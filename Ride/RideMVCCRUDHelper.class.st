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
	doer controller for: aSymbol.
	self
		addCRUDMethodsTo: (self controllerForModel: aSymbol)
		for: aSymbol.

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
