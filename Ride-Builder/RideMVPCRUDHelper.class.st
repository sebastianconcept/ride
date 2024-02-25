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
RideMVPCRUDHelper >> addFormEditTemplateFor: aSymbol [

	builder view stt
		js: js;
		crudFormEditFor: aSymbol
]

{ #category : #adding }
RideMVPCRUDHelper >> addFormFieldsTemplateFor: aSymbol [

	builder view stt
		js: js;
		crudFormFieldsFor: aSymbol
]

{ #category : #adding }
RideMVPCRUDHelper >> addFormNewTemplateFor: aSymbol [

	builder view stt
		js: js;
		crudFormNewFor: aSymbol
]

{ #category : #adding }
RideMVPCRUDHelper >> addModelDisplayContentFor: aSymbol [

	builder view stt
		js: js;
		crudModelDisplayContentFor: aSymbol
]

{ #category : #adding }
RideMVPCRUDHelper >> addNewTemplateFor: aSymbol [

	builder view stt
		js: js;
		crudNewFor: aSymbol
]

{ #category : #adding }
RideMVPCRUDHelper >> addPluralIndexTemplateFor: aSymbol [

	builder view stt
		js: js;
		crudPluralIndexFor: aSymbol asPlural 
]

{ #category : #adding }
RideMVPCRUDHelper >> addPluralModelDisplayContentFor: aSymbol [

	builder view stt
		js: js;
		crudPluralModelDisplayContentFor: aSymbol 
]

{ #category : #adding }
RideMVPCRUDHelper >> addSingularIndexTemplateFor: aSymbol [

	builder view stt
		js: js;
		crudIndexFor: aSymbol
]
