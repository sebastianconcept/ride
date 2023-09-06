"
I help with transactional emails via ZeptoMail from Zoho
"
Class {
	#name : #ZeptoMail,
	#superclass : #Object,
	#instVars : [
		'token'
	],
	#category : #'Ride-EMail'
}

{ #category : #actions }
ZeptoMail >> newHTTPClient [

	^ ZnClient new
		  beOneShot;
		  url: 'https://api.zeptomail.com/v1.1/email';
		  method: 'POST';
		  yourself
]

{ #category : #actions }
ZeptoMail >> send: anEmail [

	| client jsonString response |
	client := self newHTTPClient.
	client request headers
		at: 'Accept' put: 'application/json';
		at: 'Content-Type' put: 'application/json';
		at: 'Authorization' put: token;
		yourself.

	jsonString := JsonObject new
		              bounce_address: 'bounced@admin.proposto.co';
		              from:
			              { (#address -> anEmail sender) } asDictionary
				              asJsonObject;
		              to: { { (#email_address -> { 
					               (#address -> anEmail recipient).
					               (#name -> anEmail recipientName) } asDictionary
					               asJsonObject) } asDictionary asJsonObject };
		              subject: anEmail subject;
		              htmlBody: anEmail html;
		              asJsonString.

	client entity: (ZnEntity json: jsonString).
	response := client post.
	client response status = 201
		ifTrue: [ 
		Ride log: ('ZeptoMail: {1}' format: { response }) level: #INFO ]
		ifFalse: [ 
			Ride
				log: ('ZeptoMail send error: {1}' format: { response })
				level: #ERROR ]
]

{ #category : #accessing }
ZeptoMail >> token [

	^ token
]

{ #category : #accessing }
ZeptoMail >> token: anObject [

	token := anObject
]
