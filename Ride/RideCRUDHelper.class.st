"
I am an abstract class with the commonalities of CRUD boilerplate generators
"
Class {
	#name : #RideCRUDHelper,
	#superclass : #RideCompositeHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideCRUDHelper class >> createMethodFor: aSymbol [

	^ 'create

	"POST /{2}"

	model := {1} fromRequest: self currentRequest.

	[ model save ] on: Error do: [ :x |
		RideUnprocessableEntity signal: x messageText ].
	self redirectTo: #{2}_url notice: ''{1} was successfully created.''.
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #accessing }
RideCRUDHelper class >> destroyMethodFor: aSymbol [

	^ 'destroy

	"DELETE /{2}"
	
	model ifNil: [ 
		model := {1} findId: self currentRequest uri segments last.
		model ifNotNil: [ 
			[ model destroy ]
				on: Error
				do: [ :x | RideUnprocessableEntity signal: x messageText ].
			self
				redirectTo: #{2}_url
				notice: ''{1} was successfully destroyed.'' ] ]	
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #accessing }
RideCRUDHelper class >> editMethodFor: aSymbol [

	^ 'edit

	"GET /{2}/edit"
	
	model ifNil: [
		model := {1} findId: (self currentRequest uri segments reversed second) ]
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #accessing }
RideCRUDHelper class >> indexMethodFor: aSymbol [

	^ 'index

	"GET /{2}"
	
	model := {1} findAll
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #accessing }
RideCRUDHelper class >> newModelMethodFor: aSymbol [

	^ 'newModel

	"GET /{2}/new"
	
	model := {1} new
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #accessing }
RideCRUDHelper class >> showMethodFor: aSymbol [

	^ 'show

	"GET /{2}/<id>"

	model ifNil: [
		model := {1} findId: (self currentRequest uri segments last) ]
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #accessing }
RideCRUDHelper class >> updateMethodFor: aSymbol [

	^ 'update

	"PATCH/PUT /{2}"

	model updateFromRequest: self currentRequest.

	[ model save ] on: Error do: [ :x |
		RideUnprocessableEntity signal: x messageText ].
	self redirectTo: #{2}_url notice: ''{1} was successfully updated.''
' format: { 
			  aSymbol.
			  aSymbol asLowercase asPlural asSnakeCase }
]

{ #category : #actions }
RideCRUDHelper >> addCRUDMethodsTo: aClass for: aSymbol [

	self addIndexMethodTo: aClass for: aSymbol.
	self addShowMethodTo: aClass for: aSymbol.
	self addNewModelMethodTo: aClass for: aSymbol.
	self addEditMethodTo: aClass for: aSymbol.
	self addCreateMethodTo: aClass for: aSymbol.
	self addUpdateMethodTo: aClass for: aSymbol.
	self addDestroyMethodTo: aClass for: aSymbol
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
RideCRUDHelper >> addIndexMethodTo: aClass for: aSymbol [

	aClass compile: (self class indexMethodFor: aSymbol).
	aClass organization classify: #index under: 'actions'	
]

{ #category : #actions }
RideCRUDHelper >> addNewModelMethodTo: aClass for: aSymbol [

	aClass compile: (self class newModelMethodFor: aSymbol).
	aClass organization classify: #newModel under: 'actions'	
]

{ #category : #actions }
RideCRUDHelper >> addShowMethodTo: aClass for: aSymbol [

	aClass compile: (self class showMethodFor: aSymbol).
	aClass organization classify: #show under: 'actions'	
]

{ #category : #actions }
RideCRUDHelper >> addUpdateMethodTo: aClass for: aSymbol [

	aClass compile: (self class updateMethodFor: aSymbol).
	aClass organization classify: #update under: 'actions'	
]

{ #category : #actions }
RideCRUDHelper >> for: aSymbol [

	doer model for: aSymbol
]
