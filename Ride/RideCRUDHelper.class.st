"
I am an abstract class with the commonalities of CRUD boilerplate generators
"
Class {
	#name : #RideCRUDHelper,
	#superclass : #RideCompositeHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #actions }
RideCRUDHelper >> addCRUDMethodsTo: aClass [

	self halt.
]

{ #category : #actions }
RideCRUDHelper >> for: aSymbol [

	doer model for: aSymbol.
	doer presenter for: aSymbol.
	self addCRUDMethodsTo: (self presenterForModel: aSymbol)
]
