Extension { #name : #Error }

{ #category : #'*Ride-Pharo' }
Error >> describeOn: aJsonObjectToRespond [

	RideServer debugMode ifTrue: [ 
		| walkback lines |
		walkback := (String streamContents: [ :stream | 
			             self signalerContext debugStack: 40 on: stream ])
			            readStream.
		lines := OrderedCollection new.
		[ walkback atEnd ] whileFalse: [ lines add: walkback nextLine ].
		lines reverse.
		aJsonObjectToRespond at: #walkback put: lines ].

	^ aJsonObjectToRespond
		  at: #message put: self messageText;
		  yourself
]

{ #category : #'*Ride-Pharo' }
Error >> htmlDescribeOn: aJsonObjectToRespond [

	RideServer debugMode ifTrue: [ 
		| walkback lines |
		walkback := (String streamContents: [ :stream | 
			             self signalerContext debugStack: 40 on: stream ])
			            readStream.
		lines := OrderedCollection new.
		[ walkback atEnd ] whileFalse: [ lines add: walkback nextLine ].
		lines reverse.
		aJsonObjectToRespond at: #walkback put: lines ].

	^ aJsonObjectToRespond
		  at: #message put: self messageText;
		  yourself
]

{ #category : #'*Ride-Pharo' }
Error >> renderHtmlWith: aJsonObject on: aMustacheTemplate [

	"Answers the rendered template using the given aJsonObject as model and
	loading it with the properties of the walkback and error message."

	| sharedTemplates |
	sharedTemplates := (Ride service renderers at: #mustache) templates
		                   shared.

	Ride service server debugMode ifTrue: [ 
		| walkback lines |
		aJsonObject title: self printString.
		walkback := (String streamContents: [ :stream | 
			             self signalerContext debugStack: 40 on: stream ])
			            readStream.
		lines := OrderedCollection new.
		[ walkback atEnd ] whileFalse: [ lines add: walkback nextLine ].
		Ride isDevelopment ifTrue: [ 
			aJsonObject
				at: #isDevelopment put: true;
				at: #walkback
				put: (lines collect: [ :line | { (#step -> line) } asDictionary ]) ].
		^ aMustacheTemplate value: aJsonObject partials: sharedTemplates ].

	^ aMustacheTemplate
		  value: (aJsonObject
				   at: #message put: self messageText;
				   yourself)
		  partials: sharedTemplates
]
