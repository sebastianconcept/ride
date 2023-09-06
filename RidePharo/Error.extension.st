Extension { #name : #Error }

{ #category : #'*RidePharo' }
Error >> describeOn: aJsonObjectToRespond [

	RideServer debugMode ifTrue: [ 
		| walkback lines |
		walkback := (String streamContents: [ :stream | 
			             self signalerContext debugStack: 10 on: stream ])
			            readStream.
		lines := OrderedCollection new.
		[ walkback atEnd ] whileFalse: [ lines add: walkback nextLine ].
		lines reverse.
		aJsonObjectToRespond at: #walkback put: lines ].

	^ aJsonObjectToRespond
		  at: #message put: self messageText;
		  yourself
]
