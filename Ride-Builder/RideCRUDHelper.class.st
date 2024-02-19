"
I am an abstract class with the commonalities of CRUD boilerplate generators
"
Class {
	#name : #RideCRUDHelper,
	#superclass : #RideCompositeHelper,
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RideCRUDHelper class >> allowedParamsMethodFor: aSymbol [

	^ 'allowedParams

	"Answer the names of the parameters that are allowed to be read from the current request."
	
	^ #()
'
]

{ #category : #accessing }
RideCRUDHelper class >> createMethodFor: aSymbol [

	^ 'create

	"POST /{2}"

	| request |
	request := self currentRequest.

	model := {1} new.

	self allowedFields keysAndValuesDo: [ :k :v | model at: k put: v ].

	model saveOrSignal.

	self addNoticeSuccess: ''{1} was successfully created.''.

	self redirectToIndex
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #accessing }
RideCRUDHelper class >> destroyMethodFor: aSymbol [

	^ 'destroy

	"DELETE /{2}/<id>"
	
	model := {1} findId: (self currentRequestParam: #id).
	model ifNil: self modelNotFoundHandler.
		
	model destroyOrSignal.

	self addNoticeSuccess: ''{1} was successfully deleted.''.		

	self redirectToIndex
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #accessing }
RideCRUDHelper class >> editMethodFor: aSymbol [

	^ 'edit

	"GET /{2}/<id>/edit"

	model := {1} findId: (self currentRequestParam: #id).
	model ifNil: self modelNotFoundHandler.
	
	^ self renderUsing: ''edit.html''	
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #accessing }
RideCRUDHelper class >> indexMethodFor: aSymbol [

	^ 'index

	"GET /{2}"
	
	model := self {3}.
	
	^ self render
	
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase.
			  aSymbol uncapitalized asPlural }
]

{ #category : #accessing }
RideCRUDHelper class >> newModelMethodFor: aSymbol [

	^ 'newModel

	"GET /{2}/new"
	
	model := {1} new.
	
	^ self renderUsing: ''new.html''
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #accessing }
RideCRUDHelper class >> pluralIndexMethodFor: aSymbol [

	^ 'index

	"GET /{2}"
	
	model := self {3}.
	
	^ self render
	
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase.
			  aSymbol uncapitalized asPlural }
]

{ #category : #accessing }
RideCRUDHelper class >> singularIndexMethodFor: aSymbol [

	^ 'index

	"GET /{2}/<id>"

	model := {1} findId: (self currentRequestParam: #id).
	model ifNil: self modelNotFoundHandler.
	
	^ self renderUsing: ''index.html''	
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #accessing }
RideCRUDHelper class >> updateMethodFor: aSymbol [

	^ 'update

	"POST/PATCH/PUT /{2}/<id>"

	model := {1} findId: (self currentRequestParam: #id).
	model ifNil: self modelNotFoundHandler.
	
	self updateModelFromRequest: self currentRequest.

	model saveOrSignal.
	
	self addNoticeSuccess: ''{1} was successfully updated.''.

	self redirectFor: model
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #actions }
RideCRUDHelper >> addAllowedParamsMethodTo: aClass for: aSymbol [

	aClass compile: (self class allowedParamsMethodFor: aSymbol).
	aClass organization classify: #allowedParams under: 'accessing'	
]

{ #category : #actions }
RideCRUDHelper >> addCRUDMethodsTo: aClass for: aSymbol [
self deprecated: 'singular or plural'.
	self addIndexMethodTo: aClass for: aSymbol.
	self addModelsAccessorMethodTo: aClass for: aSymbol.
	self addShowMethodTo: aClass for: aSymbol.
	self addNewModelMethodTo: aClass for: aSymbol.
	self addEditMethodTo: aClass for: aSymbol.
	self addCreateMethodTo: aClass for: aSymbol.
	self addUpdateMethodTo: aClass for: aSymbol.
	self addDestroyMethodTo: aClass for: aSymbol
]

{ #category : #actions }
RideCRUDHelper >> addCRUDTemplatesTo: aClass for: aSymbol [
self deprecated: 'silgular or plural'.
	self addIndexTemplateFor: aSymbol.
	self addShowTemplateFor: aSymbol.
	self addNewTemplateFor: aSymbol.
	self addEditTemplateFor: aSymbol.
	self addFormNewTemplateFor: aSymbol.
	self addFormEditTemplateFor: aSymbol.
	self addFormFieldsTemplateFor: aSymbol.
	self addModelDisplayContentFor: aSymbol
]

{ #category : #actions }
RideCRUDHelper >> addCreateMethodTo: aClass for: aSymbol [

	aClass compile: (self class createMethodFor: aSymbol).
	aClass organization classify: #create under: 'actions'
]

{ #category : #actions }
RideCRUDHelper >> addDestroyMethodTo: aClass for: aSymbol [

	aClass compile: (self class destroyMethodFor: aSymbol).
	aClass organization classify: #destroy under: 'actions'	
]

{ #category : #actions }
RideCRUDHelper >> addEditMethodTo: aClass for: aSymbol [

	aClass compile: (self class editMethodFor: aSymbol).
	aClass organization classify: #edit under: 'actions'	
]

{ #category : #actions }
RideCRUDHelper >> addEditTemplateFor: aSymbol [

	self subclassResponsibility
]

{ #category : #actions }
RideCRUDHelper >> addFormEditTemplateFor: aSymbol [

	self subclassResponsibility
]

{ #category : #actions }
RideCRUDHelper >> addFormFieldsTemplateFor: aSymbol [

	self subclassResponsibility
]

{ #category : #actions }
RideCRUDHelper >> addFormNewTemplateFor: aSymbol [

	self subclassResponsibility
]

{ #category : #actions }
RideCRUDHelper >> addFormTemplateFor: aSymbol [

	self deprecated: 'use either formNew or formEdit'.
	self subclassResponsibility
]

{ #category : #actions }
RideCRUDHelper >> addIndexMethodTo: aClass for: aSymbol [
	self deprecated: ' plural or singular'.
	aClass compile: (self class indexMethodFor: aSymbol).
	aClass organization classify: #index under: 'actions'	
]

{ #category : #actions }
RideCRUDHelper >> addIndexTemplateFor: aSymbol [

	self subclassResponsibility
]

{ #category : #actions }
RideCRUDHelper >> addModelDisplayContentFor: aSymbol [

	self subclassResponsibility
]

{ #category : #actions }
RideCRUDHelper >> addModelsAccessorMethodTo: aClass for: aSymbol [

	| selector source |
	selector := aSymbol uncapitalized asPlural asSymbol.

	source := '{3}

	"Answers all {1} in the system."

	^ {1} findAll
' format: { 
			          aSymbol.
			          aSymbol asLowercase asPlural asSnakeCase.
			          selector }.

	aClass compile: source.
	aClass organization classify: selector under: 'accessing'
]

{ #category : #actions }
RideCRUDHelper >> addNewModelMethodTo: aClass for: aSymbol [

	aClass compile: (self class newModelMethodFor: aSymbol).
	aClass organization classify: #newModel under: 'actions'	
]

{ #category : #actions }
RideCRUDHelper >> addNewTemplateFor: aSymbol [

	self subclassResponsibility
]

{ #category : #actions }
RideCRUDHelper >> addPluralCRUDMethodsTo: aClass for: aSymbol [

	self addPluralIndexMethodTo: aClass for: aSymbol.
	"self addIndexMethodTo: aClass for: aSymbol."
	self addModelsAccessorMethodTo: aClass for: aSymbol.
	"self addShowMethodTo: aClass for: aSymbol.
	self addNewModelMethodTo: aClass for: aSymbol.
	self addEditMethodTo: aClass for: aSymbol.
	self addCreateMethodTo: aClass for: aSymbol.
	self addUpdateMethodTo: aClass for: aSymbol.
	self addDestroyMethodTo: aClass for: aSymbol"
]

{ #category : #actions }
RideCRUDHelper >> addPluralCRUDTemplatesTo: aClass for: aSymbol [

	self addPluralIndexTemplateFor: aSymbol.
	"self addShowTemplateFor: aSymbol.
	self addNewTemplateFor: aSymbol.
	self addEditTemplateFor: aSymbol.
	self addFormNewTemplateFor: aSymbol.
	self addFormEditTemplateFor: aSymbol.
	self addFormFieldsTemplateFor: aSymbol."
	self addPluralModelDisplayContentFor: aSymbol
]

{ #category : #actions }
RideCRUDHelper >> addPluralIndexMethodTo: aClass for: aSymbol [

	aClass compile: (self class pluralIndexMethodFor: aSymbol).
	aClass organization classify: #index under: 'actions'
]

{ #category : #actions }
RideCRUDHelper >> addPluralIndexTemplateFor: aClass for: aSymbol [

	aClass compile: (self class pluralIndexMethodFor: aSymbol).
	aClass organization classify: #index under: 'actions'	
]

{ #category : #actions }
RideCRUDHelper >> addPluralModelDisplayContentFor: aSymbol [

	self subclassResponsibility
]

{ #category : #actions }
RideCRUDHelper >> addShowMethodTo: aClass for: aSymbol [
self deprecated: 'no'.
	aClass compile: (self class singularIndexMethodFor: aSymbol).
	aClass organization classify: #index under: 'actions'	
]

{ #category : #actions }
RideCRUDHelper >> addShowTemplateFor: aSymbol [
self deprecated: 'no'.
	self subclassResponsibility
]

{ #category : #actions }
RideCRUDHelper >> addSingularCRUDMethodsTo: aClass for: aSymbol [

	self addAllowedParamsMethodTo: aClass for: aSymbol.
	self addSingularIndexMethodTo: aClass for: aSymbol.
	self addNewModelMethodTo: aClass for: aSymbol.
	self addEditMethodTo: aClass for: aSymbol.
	self addCreateMethodTo: aClass for: aSymbol.
	self addUpdateMethodTo: aClass for: aSymbol.
	self addDestroyMethodTo: aClass for: aSymbol
]

{ #category : #actions }
RideCRUDHelper >> addSingularCRUDTemplatesTo: aClass for: aSymbol [

	self addSingularIndexTemplateFor: aSymbol.
	"self addShowTemplateFor: aSymbol."
	self addNewTemplateFor: aSymbol.
	self addEditTemplateFor: aSymbol.
	self addFormNewTemplateFor: aSymbol.
	self addFormEditTemplateFor: aSymbol.
	self addFormFieldsTemplateFor: aSymbol.
	self addModelDisplayContentFor: aSymbol
]

{ #category : #actions }
RideCRUDHelper >> addSingularIndexMethodTo: aClass for: aSymbol [

	aClass compile: (self class singularIndexMethodFor: aSymbol).
	aClass organization classify: #index under: 'actions'	
]

{ #category : #actions }
RideCRUDHelper >> addSingularIndexTemplateFor: aClass for: aSymbol [

	aClass compile: (self class singularIndexMethodFor: aSymbol).
	aClass organization classify: #index under: 'actions'	
]

{ #category : #actions }
RideCRUDHelper >> addUpdateMethodTo: aClass for: aSymbol [

	aClass compile: (self class updateMethodFor: aSymbol).
	aClass organization classify: #update under: 'actions'	
]

{ #category : #actions }
RideCRUDHelper >> for: aSymbol [

	builder model for: aSymbol.
	builder presenter for: aSymbol.
	self addSingularCRUDMethodsTo: (self presenterForModel: aSymbol) for: aSymbol.
	self addSingularCRUDTemplatesTo: (self presenterForModel: aSymbol) for: aSymbol.

	builder pluralPresenter for: aSymbol.
	self addPluralCRUDMethodsTo: (self pluralPresenterForModel: aSymbol) for: aSymbol.
	self addPluralCRUDTemplatesTo: (self pluralPresenterForModel: aSymbol) for: aSymbol

	
]
