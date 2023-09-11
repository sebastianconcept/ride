Extension { #name : #Error }

{ #category : #'*RidePharo' }
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

{ #category : #'*RidePharo' }
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

{ #category : #'*RidePharo' }
Error >> renderHtmlWith: aJsonObject on: aMustacheTemplate [

	RideServer debugMode ifTrue: [ 
		| walkback lines |
		aJsonObject title: self printString.
		walkback := (String streamContents: [ :stream | 
			             self signalerContext debugStack: 40 on: stream ])
			            readStream.
		lines := OrderedCollection new.
		[ walkback atEnd ] whileFalse: [ lines add: walkback nextLine ].
		aJsonObject
			at: #walkback
			put: (lines collect: [ :line | { (#step -> line) } asDictionary ]).
		^ aMustacheTemplate value: aJsonObject ].

	^ aMustacheTemplate value: (aJsonObject
			   at: #message put: self messageText;
			   yourself)
]
