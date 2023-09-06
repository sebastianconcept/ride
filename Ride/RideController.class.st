"
I am the abstract RideController.
My subclasses will handle the custom reactions following the REST Ride convention that provides CRUD for models as the starting point of their behavior.
"
Class {
	#name : #RideController,
	#superclass : #Object,
	#category : #'Ride-Controllers'
}

{ #category : #accessing }
RideController class >> basePath [

	"Answers the view name of this controller as snake case."

	^ self getModelName asSnakeCase
]

{ #category : #crud }
RideController class >> createWith: someMustacheTemplates [

	^ [ :req | 
	  (someMustacheTemplates
		   at: #new
		   ifAbsent: [ RideMissingTemplateError signal: 'new not found' ]) 
		  value: (self newModelFrom: req) ]
]

{ #category : #crud }
RideController class >> destroy [

	^ [ :req | (self getModelFrom: req) destroy ]
]

{ #category : #accessing }
RideController class >> getModelClass [

	"Answers the model class for this controller."

	^ Smalltalk
		  at: self getModelName asSymbol
		  ifAbsent: [ 
		  RideMissingModelError signal: self getModelName , ' not found' ]
]

{ #category : #accessing }
RideController class >> getModelFrom: aRequest [

	aRequest uri segments first = self basePath ifFalse: [ 
		self error: 'Wrong route' ].
	aRequest uri segments size < 2 ifTrue: [ 
		RideMissingModelPathError signal: 'Missing model ID' ].

	^ self getModelId: aRequest uri segments second
]

{ #category : #accessing }
RideController class >> getModelId: anId [

	^ self getModelClass findId: anId
]

{ #category : #accessing }
RideController class >> getModelName [

	"Answers the conventional model name for this controller."

	^ self name copyFrom: 1 to: self name size - 'Controller' size
]

{ #category : #accessing }
RideController class >> newModelFrom: aRequest [

	^ self getModelClass new
]

{ #category : #crud }
RideController class >> showHtml: someMustacheTemplate [

	^ [ :req | someMustacheTemplate value: (self getModelFrom: req) ]
]

{ #category : #crud }
RideController class >> showManyHtml: someMustacheTemplates [

	^ [ :req | 
	  (someMustacheTemplates
		   at: #index
		   ifAbsent: [ RideMissingTemplateError signal: 'index not found' ]) 
		  value: (self getModelFrom: req) ]
]

{ #category : #crud }
RideController class >> updateWith: someMustacheTemplates [

	^ [ :req | 
	  (someMustacheTemplates
		   at: #edit
		   ifAbsent: [ RideMissingTemplateError signal: 'edit not found' ]) 
		  value: (self getModelFrom: req) ]
]
