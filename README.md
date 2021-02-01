# Zeotap ID+ GTM Template

## Integration Detail
The tags created with this template will have two sections: Initialisation Section and Login and Identities Setting Section

### Initialisation Section
- ***Partner Id:*** This is the ID+ partner ID which you will receive from Zeotap POM.
- ***Consent Method:*** The Collect SDK has 2 options that can be used to determine consent actions.
	- **Option ‘Default Opt-in’:** This will set the corresponding options `useConsent` and `tcfConsent` to `false`.
	- **Option ‘Check TCF CMP’:** This will set the corresponding options `useConsent` and `tcfConsent` to `true`.

### Login and Identities Setting Section
- ***Event Key:*** Name of the event key, i.e. the name of the key in the `dataLayer` which corresponds to the login event.
- ***Login Event:*** Name of the event, i.e. the value of the event in the `dataLayer` which corresponds to the login event.
- ***Capture Email*** If set to `true`, provide the email id variable.
- ***Capture Cellphone number:*** If set to `true`, provide the cellphone number variable.
- ***Identities Hashed:*** Represents whether hashing of identities are required or not. If set to `true` then hashing will not be done.
