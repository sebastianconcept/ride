Extension { #name : #UndefinedObject }

{ #category : #'*Ride' }
UndefinedObject >> asMustacheTemplateModel [
	self deprecated: 'use asTemplateModel'.
	^ Dictionary new
]
