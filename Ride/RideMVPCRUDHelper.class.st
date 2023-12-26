"
I help to draft the model, views and presenters needed for a basic CRUD around the given model root name
"
Class {
	#name : #RideMVPCRUDHelper,
	#superclass : #RideCRUDHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #actions }
RideMVPCRUDHelper >> for: aSymbol [

	super for: aSymbol.
	doer presenter for: aSymbol.
	self addCRUDMethodsTo: (self presenterForModel: aSymbol) for: aSymbol.
	doer view mustache
		js: js;
		crudIndexFor: aSymbol;
		crudModelFor: aSymbol;
		crudShowFor: aSymbol;
		crudNewModelFor: aSymbol;
		crudEditFor: aSymbol;
		crudFormFor: aSymbol;
		yourself
]
