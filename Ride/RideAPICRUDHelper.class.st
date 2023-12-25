"
I help to draft the model and controllers needed for a basic CRUD actions around the given model root name
"
Class {
	#name : #RideAPICRUDHelper,
	#superclass : #RideCRUDHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #'instance creation' }
RideAPICRUDHelper >> for: aSymbol [

	super for: aSymbol.
	doer controller for: aSymbol.	
	self addCRUDMethodsTo: (self controllerForModel: aSymbol) for: aSymbol
]
