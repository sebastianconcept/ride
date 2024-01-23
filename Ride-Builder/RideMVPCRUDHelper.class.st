"
I help to draft the model, views and presenters needed for a basic CRUD around the given model root name
"
Class {
	#name : #RideMVPCRUDHelper,
	#superclass : #RideCRUDHelper,
	#category : #'Ride-Builder'
}

{ #category : #adding }
RideMVPCRUDHelper >> addEditTemplateFor: aSymbol [

	builder view stt
		js: js;
		crudEditFor: aSymbol
]

{ #category : #adding }
RideMVPCRUDHelper >> addFormTemplateFor: aSymbol [

	builder view stt
		js: js;
		crudFormFor: aSymbol
]

{ #category : #adding }
RideMVPCRUDHelper >> addIndexTemplateFor: aSymbol [

	builder view stt
		js: js;
		crudIndexFor: aSymbol
]

{ #category : #adding }
RideMVPCRUDHelper >> addNewTemplateFor: aSymbol [

	builder view stt
		js: js;
		crudNewFor: aSymbol
]

{ #category : #adding }
RideMVPCRUDHelper >> addShowTemplateFor: aSymbol [

	builder view stt
		js: js;
		crudShowFor: aSymbol
]
