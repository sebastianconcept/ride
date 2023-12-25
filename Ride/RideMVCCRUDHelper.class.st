"
I help to draft the model, views and controllers needed for a basic CRUD around the given model root name
"
Class {
	#name : #RideMVCCRUDHelper,
	#superclass : #RideCRUDHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #actions }
RideMVCCRUDHelper >> for: aSymbol [

	super for: aSymbol.
	self addCRUDMethodsTo: (self controllerForModel: aSymbol)
]
