const getEventData = require('getEventData');
const parseUrl = require('parseUrl');
const createRegex = require('createRegex');
const makeString = require('makeString');

const targetUtm = data.target_utm;
let finalValue;

const urlKey = data.url_key || 'page_location';
const referrerKey = data.referrer_key || 'page_referrer';

const pageLocation = getEventData(urlKey) || '';
const pageReferrer = getEventData(referrerKey) || '';

const parsedUrl = pageLocation ? parseUrl(pageLocation) : {};
const queryParams = parsedUrl.searchParams || {};

let currentUtm = queryParams[targetUtm];

if (currentUtm && data.behavior !== 'override') {
  finalValue = currentUtm; 
} else {
  const rules = data.rules_table || [];
  let matchFound = false;

  for (let i = 0; i < rules.length; i++) {
    const rule = rules[i];
    let evaluateValue = '';

    if (rule.source === 'referrer') {
      evaluateValue = pageReferrer;
    } else if (rule.source === 'query' && rule.query_key) {
      evaluateValue = queryParams[rule.query_key];
    }

    if (evaluateValue) {
      evaluateValue = makeString(evaluateValue); 
      
      let isMatch = false;

      // Convert both values to lowercase for case-insensitive matching
      const evalStringLower = evaluateValue.toLowerCase();
      const matchStringLower = makeString(rule.match_value).toLowerCase();

      // Apply Match Logic
      if (rule.match_type === 'equals' && evalStringLower === matchStringLower) {
        isMatch = true;
      } else if (rule.match_type === 'contains' && evalStringLower.indexOf(matchStringLower) !== -1) {
        isMatch = true;
      } else if (rule.match_type === 'regex') {
        const matchRegex = createRegex(rule.match_value);
        if (matchRegex && evaluateValue.search(matchRegex) !== -1) {
            isMatch = true;
        }
      }

      // If a match was found, check if we need to verify the referrer
      const internalDomain = data.internal_domain ? makeString(data.internal_domain).toLowerCase() : '';
      
      if (isMatch && rule.require_external && internalDomain) {
        const refLower = pageReferrer.toLowerCase();
        // If the referrer contains our own domain, this is internal navigation
        if (refLower.indexOf(internalDomain) !== -1) {
            isMatch = false;
        }
      }

      if (isMatch) {
        if (rule.output_type === 'regex_extract') {
            const extractionRegex = createRegex(rule.match_value);
            if (extractionRegex) {
                finalValue = evaluateValue.replace(extractionRegex, rule.output_value);
            } else {
                finalValue = undefined; 
            }
        } else {
            finalValue = rule.output_value;
        }
        
        matchFound = true;
        break; 
      }
    }
  }

  if (!matchFound) {
    finalValue = currentUtm || data.fallback_value || undefined;
  }
}

if (finalValue && data.force_lowercase) {
  finalValue = makeString(finalValue);
  return finalValue.toLowerCase();
}

return finalValue;