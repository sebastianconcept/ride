Extension { #name : #MustacheVisitor }

{ #category : #'*Ride' }
MustacheVisitor >> visitPartial: aMustachePartial [

	| found |
	found := self partialAt: aMustachePartial name.
	found ifNil: [ 
		Error signal: ('Mustache partial named "{1}" not found' format:
				 { aMustachePartial name asString }) ].
	self visit: found
]
