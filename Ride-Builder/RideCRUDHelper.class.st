"
I am an abstract class with the commonalities of CRUD boilerplate generators
"
Class {
	#name : #RideCRUDHelper,
	#superclass : #RideCompositeHelper,
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RideCRUDHelper class >> createMethodFor: aSymbol [

	^ 'create

	"POST /{2}"

	| request |
	request := self currentRequest.

	model := {1} new.

	request entity fields keysAndValuesDo: [ :k :v | model at: k put: v ].

	model saveOrSignal.

	self addNoticeSuccess: ''{1} was successfully created.''.

	self redirectFor: model	
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #accessing }
RideCRUDHelper class >> destroyMethodFor: aSymbol [

	^ 'destroy

	"DELETE /{2}/<id>"
	
	| id notFound |

	notFound := [ :v | 
	            RideNotFoundError signal:
		            (''No \{1\} found at \{2\}'' format: \{ v asString. id asString \}) ].

	id := self currentRequest at: #id ifAbsent: notFound.
		
	model 
		ifNotNil: [ model destroyOrSignal ] 
		ifNil:[ notFound value: {1} name ].

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

	| id notFound |

	notFound := [ :v | 
	            RideNotFoundError signal:
		            (''No \{1\} found at \{2\}'' format: \{ v asString. id asString \}) ].

	id := self currentRequest at: #id ifAbsent: notFound.

	model := {1} findId: id.

	model ifNil:[ 
		notFound value: {1} name ].
	
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
RideCRUDHelper class >> showMethodFor: aSymbol [

	^ 'show

	"GET /{2}/<id>"

	| id notFound |

	notFound := [ :v | 
	            RideNotFoundError signal:
		            (''No \{1\} found at \{2\}'' format: \{ v asString. id asString \}) ].

	id := self currentRequest at: #id ifAbsent: notFound.

	model := {1} findId: id.

	model ifNil:[ 
		notFound value: {1} name ].	
	
	^ self renderUsing: ''show.html''	
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #accessing }
RideCRUDHelper class >> updateMethodFor: aSymbol [

	^ 'update

	"PATCH/PUT /{2}/<id>"

	model updateFromRequest: self currentRequest.

	model saveOrSignal.
	
	self addNoticeSuccess: ''{1} was successfully updated.''.

	self redirectFor: model
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #actions }
RideCRUDHelper >> addCRUDMethodsTo: aClass for: aSymbol [

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
RideCRUDHelper >> addShowMethodTo: aClass for: aSymbol [

	aClass compile: (self class showMethodFor: aSymbol).
	aClass organization classify: #show under: 'actions'	
]

{ #category : #actions }
RideCRUDHelper >> addShowTemplateFor: aSymbol [

	self subclassResponsibility
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
	self addCRUDMethodsTo: (self presenterForModel: aSymbol) for: aSymbol.
	self addCRUDTemplatesTo: (self presenterForModel: aSymbol) for: aSymbol
	
]
