___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Dynamic UTM Resolver",
  "description": "Fix missing or incorrect UTMs based on Referrers or Query Parameters. Includes advanced rule mapping, dynamic RegEx extraction, default fallbacks, and automatic lowercase formatting.",
  "categories": ["ANALYTICS", "UTILITY"],
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "advancedSettingsGroup",
    "displayName": "Input Settings",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "TEXT",
        "name": "url_key",
        "displayName": "URL Event Data Key",
        "simpleValueType": true,
        "defaultValue": "page_location",
        "help": "The Event Data key containing the full page URL. Leave as \u003cstrong\u003epage_location\u003c/strong\u003e for standard GA4/sGTM setups."
      },
      {
        "type": "TEXT",
        "name": "referrer_key",
        "displayName": "Referrer Event Data Key",
        "simpleValueType": true,
        "defaultValue": "page_referrer",
        "help": "The Event Data key containing the referring URL. Leave as \u003cstrong\u003epage_referrer\u003c/strong\u003e for standard GA4/sGTM setups."
      }
    ]
  },
  {
    "type": "SELECT",
    "name": "target_utm",
    "displayName": "Target UTM",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "utm_source",
        "displayValue": "Campaign Source"
      },
      {
        "value": "utm_medium",
        "displayValue": "Campaign Medium"
      },
      {
        "value": "utm_campaign",
        "displayValue": "Campaign Name"
      },
      {
        "value": "utm_content",
        "displayValue": "Campaign Content"
      },
      {
        "value": "utm_term",
        "displayValue": "Campaign Term"
      },
      {
        "value": "utm_id",
        "displayValue": "Campaign ID"
      },
      {
        "value": "utm_source_platform",
        "displayValue": "Campaign Source Platform"
      },
      {
        "value": "utm_creative_format",
        "displayValue": "Campaign Creative Format"
      },
      {
        "value": "utm_marketing_tactic",
        "displayValue": "Campaign Marketing Tactic"
      }
    ],
    "simpleValueType": true,
    "help": "Select the UTM parameter this variable will output. The template will first check if this parameter is already present in the user\u0027s URL."
  },
  {
    "type": "RADIO",
    "name": "behavior",
    "displayName": "When should this trigger",
    "radioItems": [
      {
        "value": "missing",
        "displayValue": "Only if missing in URL"
      },
      {
        "value": "override",
        "displayValue": "Always override"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "missing",
    "help": "\u003cstrong\u003eOnly if missing in URL\u003c/strong\u003e: Preserves the existing UTM if the user clicked a tagged link.\u003cbr /\u003e \u003cbr /\u003e\n\u003cstrong\u003eAlways override\u003c/strong\u003e: Ignores the URL and forces the rules below (useful for fixing known bad UTMs)."
  },
  {
    "type": "PARAM_TABLE",
    "name": "rules_table",
    "displayName": "Rules Table",
    "paramTableColumns": [
      {
        "param": {
          "type": "SELECT",
          "name": "source",
          "displayName": "Source",
          "macrosInSelect": false,
          "selectItems": [
            {
              "value": "referrer",
              "displayValue": "Referrer"
            },
            {
              "value": "query",
              "displayValue": "Query Parameter"
            }
          ],
          "simpleValueType": true,
          "help": "Look at either the referring domain or a specific URL query parameter."
        },
        "isUnique": false
      },
      {
        "param": {
          "type": "TEXT",
          "name": "query_key",
          "displayName": "Query Key",
          "simpleValueType": true,
          "enablingConditions": [
            {
              "paramName": "source",
              "paramValue": "referrer",
              "type": "NOT_EQUALS"
            }
          ],
          "valueValidators": [],
          "help": "Leave blank if Source is \"Referrer\". If Source is \"Query Parameter\", enter the exact parameter name (e.g., \u003cstrong\u003eat_gd\u003c/strong\u003e)."
        },
        "isUnique": false
      },
      {
        "param": {
          "type": "SELECT",
          "name": "match_type",
          "displayName": "Match Type",
          "macrosInSelect": false,
          "selectItems": [
            {
              "value": "equals",
              "displayValue": "Equals"
            },
            {
              "value": "contains",
              "displayValue": "Contains"
            },
            {
              "value": "regex",
              "displayValue": "RegEx"
            }
          ],
          "simpleValueType": true,
          "help": "Use Contains for simple referrers (e.g., \u003cstrong\u003efacebook.com\u003c/strong\u003e). Use RegEx for complex matching."
        },
        "isUnique": false
      },
      {
        "param": {
          "type": "TEXT",
          "name": "match_value",
          "displayName": "Match Value",
          "simpleValueType": true,
          "help": "The string or RegEx to match. \u003cstrong\u003eNote\u003c/strong\u003e: \"Equals\" and \"Contains\" are automatically case-insensitive. \"RegEx\" is strictly case-sensitive unless you start your regex with \u003cstrong\u003e(?i)\u003c/strong\u003e (e.g., \u003cstrong\u003e(?i)knowit\u003c/strong\u003e). For referrers, use \"Contains\" and stick to root domains (e.g., \"facebook.com\").",
          "valueHint": "E.g., facebook\\.com",
          "valueValidators": [
            {
              "type": "NON_EMPTY"
            }
          ]
        },
        "isUnique": false
      },
      {
        "param": {
          "type": "SELECT",
          "name": "output_type",
          "displayName": "Output Type",
          "macrosInSelect": false,
          "selectItems": [
            {
              "value": "static",
              "displayValue": "Static Text"
            },
            {
              "value": "regex_extract",
              "displayValue": "Regex Extraction"
            }
          ],
          "simpleValueType": true,
          "help": "Choose \u003cstrong\u003eStatic Text\u003c/strong\u003e for a fixed value, or \u003cstrong\u003eRegex Extraction\u003c/strong\u003e to dynamically capture a value."
        },
        "isUnique": false
      },
      {
        "param": {
          "type": "TEXT",
          "name": "output_value",
          "displayName": "Output Value",
          "simpleValueType": true,
          "valueValidators": [
            {
              "type": "NON_EMPTY"
            }
          ],
          "valueHint": "affiliate",
          "help": "If using Regex Extraction, use \u003cstrong\u003e$1\u003c/strong\u003e to output your captured group."
        },
        "isUnique": false
      }
    ],
    "help": "Define your UTM creation rules here. The template evaluates rows from top to bottom and stops at the first match. If matching a Referrer, remember that only the domain portion is typically available."
  },
  {
    "type": "TEXT",
    "name": "fallback_value",
    "displayName": "Default Fallback Value (Optional)",
    "simpleValueType": true,
    "help": "Optional. If the UTM is missing from the URL and no rules match, this value is output. Leave blank to return \u003cstrong\u003eundefined\u003c/strong\u003e, allowing GA4 to naturally assign its own defaults like \u003cstrong\u003e(direct) / (none)\u003c/strong\u003e."
  },
  {
    "type": "CHECKBOX",
    "name": "force_lowercase",
    "checkboxText": "Force output to lowercase",
    "simpleValueType": true,
    "help": "Highly recommended for source, medium, and campaign to prevent GA4 report fragmentation (e.g., splitting \"Social\" and \"social\"). \u003cbr /\u003e\u003cbr /\u003e\n\u003cstrong\u003eWarning\u003c/strong\u003e: Uncheck this if mapping to case-sensitive parameters like \u003cstrong\u003eutm_id\u003c/strong\u003e."
  }
]


___SANDBOXED_JS_FOR_SERVER___

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


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 21.5.2026, 21:03:21


