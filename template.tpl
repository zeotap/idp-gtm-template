___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Zeotap ID+ Tag",
  "description": "Script to utilise Zeotap\u0027s universal ID+ identifiers.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "Initialisation",
    "displayName": "Initialisation",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "TEXT",
        "name": "partnerId",
        "displayName": "Partner ID",
        "simpleValueType": true,
        "help": "The ID+ partnerid, check with zeotap POM for the same",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "valueHint": "eg. xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
      },
      {
        "type": "TEXT",
        "name": "partner_dom",
        "displayName": "Page domain from which the ID+ script is invoked",
        "simpleValueType": true,
        "defaultValue": "{{Page Hostname}}",
        "help": "Default value here is the inbuilt Page HostName variable, you can choose your own Variables or plain string as the domain."
      },
      {
        "type": "SELECT",
        "name": "consentMethod",
        "displayName": "Consent method",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "default",
            "displayValue": "Default Opt-in"
          },
          {
            "value": "tcf",
            "displayValue": "Check TCF CMP"
          }
        ],
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "GROUP",
        "name": "customConsentValue",
        "displayName": "Custom Consent",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "TEXT",
            "name": "consentEventKey",
            "displayName": "Consent Event Key",
            "simpleValueType": true,
            "valueHint": "eg. zeotapEvent",
            "help": "Key for event name in dataLayer object. leave the default if you use the GTM\u0027s default key."
          },
          {
            "type": "TEXT",
            "name": "consentEventName",
            "displayName": "Consent Event Name",
            "simpleValueType": true,
            "valueHint": "eg. setConsent",
            "help": "Value of the event in the dataLayer for consent capture",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "type": "TEXT",
            "name": "truePropertyValue",
            "displayName": "Given Consent Value",
            "simpleValueType": true,
            "valueHint": "eg. yes",
            "help": "Value for \u0027Consent Property name \u0027 when consent is given",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          }
        ],
        "enablingConditions": [
          {
            "paramName": "consentMethod",
            "paramValue": "custom",
            "type": "EQUALS"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "identities",
    "displayName": "Login and Identities setting",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "GROUP",
        "name": "userLogin",
        "displayName": "User Login",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "TEXT",
            "name": "eventKey",
            "displayName": "Event Key",
            "simpleValueType": true,
            "valueHint": "eg. zeotapEvent",
            "help": "Key for event name in dataLayer object. leave the default if you use the GTM\u0027s default key.",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "defaultValue": "event"
          },
          {
            "type": "TEXT",
            "name": "loginEvent",
            "displayName": "Login Event",
            "simpleValueType": true,
            "help": "Specify the dataLayer event fired on user login",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "type": "CHECKBOX",
            "name": "emailExists",
            "checkboxText": "Capture email",
            "simpleValueType": true,
            "defaultValue": true
          },
          {
            "type": "SELECT",
            "name": "email",
            "displayName": "Email variable",
            "macrosInSelect": true,
            "selectItems": [],
            "simpleValueType": true,
            "enablingConditions": [
              {
                "paramName": "emailExists",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "type": "CHECKBOX",
            "name": "cellnoExists",
            "checkboxText": "Capture cellphone number",
            "simpleValueType": true,
            "defaultValue": true
          },
          {
            "type": "TEXT",
            "name": "cellno_cc",
            "displayName": "Cell number with country code variable",
            "simpleValueType": true,
            "enablingConditions": [
              {
                "paramName": "cellnoExists",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "help": "Cell number with country code, stripped of symbols, eg: +1 9033 or (1) 9033 should be 19033",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "type": "CHECKBOX",
            "name": "areIdentitiesHashed",
            "checkboxText": "Are your identities hashed ?",
            "simpleValueType": true,
            "defaultValue": false,
            "enablingConditions": [],
            "help": "Should be hashed in sha256"
          }
        ]
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// IDP
const log = require('logToConsole');
const injectScript = require('injectScript');
const copyFromWindow = require('copyFromWindow');
const setInWindow = require('setInWindow');
const callInWindow = require('callInWindow');
const makeTableMap = require('makeTableMap');
const getType = require("getType");

//////// constants
const url = 'https://content.zeotap.com/sdk/idp.min.js';
const dataLayer = copyFromWindow('dataLayer');
const callMethod = copyFromWindow('zeotap.callMethod');

function callSDKForEvent(eventData) {
  const eventNameKey = data.eventKey;
  log('Tag fired for Event:', eventData[eventNameKey]);

  if (eventData[eventNameKey] === data.loginEvent) {
    log('user logged in');

    const identities = {};
    if (data.emailExists) {
      identities.email = data.email;
    }
    if (data.cellnoExists) {
      identities.cellno_cc = data.cellno_cc;
    }
    log('identities .... : ', identities);
    callInWindow('zeotap.callMethod', 'setUserIdentities', identities, data.areIdentitiesHashed);
  }
}

if (callMethod === undefined) {
  const options = {
    partnerId: data.partnerId,
    useConsent: data.consentMethod === 'default' ? false : true,
    checkForCMP: data.consentMethod === 'tcf' ? true : false,
    partner_dom: data.partner_dom ? data.partner_dom : data.page_domain
  };
  log('Options', options);
  setInWindow('zeotap', { _q: [], _qcmp: [] });
  setInWindow('zeotap.callMethod', function () {
    callInWindow('zeotap._q.push', arguments);
  });
  log('zeotap.callMethod', 'init', options);
  callInWindow('zeotap.callMethod', 'init', options);
  injectScript(url, data.gtmOnSuccess, data.gtmOnFailure, 'zeotapID+');
}

if (!!dataLayer && !!dataLayer.length) {

  log('dataLayer exists on window : ', dataLayer.length, dataLayer);
  let parsedDataLayerLength = copyFromWindow('dl_parsed_length') || 0;
  for (let i = parsedDataLayerLength; i < dataLayer.length ; i++) {
    const eventData = dataLayer[i];
    callSDKForEvent(eventData);
  }
  setInWindow('dl_parsed_length', dataLayer.length, true);
  log('dl parsed length : ', copyFromWindow('dl_parsed_length'));
  
}

data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "dataLayer"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "zeotap.callMethod"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "zeotap"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "zeotap._q.push"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "dl_parsed_length"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://content.zeotap.com/sdk/*"
              }
            ]
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

Created on 28/01/2021, 12:10:45


