Extension { #name : #MustachePartial }

{ #category : #'*Ride' }
MustachePartial >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: ('({1})' format: { name asString })
]
