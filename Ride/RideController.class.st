"
I am the abstract RideController.
I provide the commonalities of all types of controllers.
See my child classes for more.

"
Class {
	#name : #RideController,
	#superclass : #Object,
	#instVars : [
		'subcontrollers',
		'model',
		'views',
		'focused'
	],
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

{ #category : #accessing }
RideController class >> defaultModel [

	^ nil
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
RideController class >> getModelName [

	"Answers the conventional model name for this controller."

	^ self name copyFrom: 1 to: self name size - 'Controller' size
]

{ #category : #'instance creation' }
RideController class >> new [

	^ self on: self defaultModel
]

{ #category : #'instance creation' }
RideController class >> on: aModel [

	^ self basicNew
		  initialize;
		  model: aModel
]

{ #category : #crud }
RideController class >> postHtmlWith: someMustacheTemplates [

	^ [ :req | 
	  (someMustacheTemplates
		   at: #edit
		   ifAbsent: [ RideMissingTemplateError signal: 'edit not found' ]) 
		  value: (self getModelFrom: req) ]
]

{ #category : #crud }
RideController class >> showHtml: someMustacheTemplate [
self halt.
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

{ #category : #accessing }
RideController >> ajaxAction [

	"Answers the selector of the action specified from the AJAX request.
	The convention is to use the value in 'X-Ride-AJAX' as the selector
	that this controller would perform as a reaction. And, as #default is a no-op,
	the default is to do nothing."

	^ RideCurrentRequest value headers
		  at: 'X-Ride-AJAX'
		  ifAbsent: [ #default ]
]

{ #category : #accessing }
RideController >> applicationTemplate [

	^ Ride service locate templates layouts application
]

{ #category : #accessing }
RideController >> childAt: aSymbol [

	^ subcontrollers at: aSymbol
]

{ #category : #accessing }
RideController >> children [

	^ subcontrollers
]

{ #category : #accessing }
RideController >> controllerForRoute: routeName [

	^ subcontrollers at: routeName ifAbsent: [ 
		  RideMissingControllerError signal: ('{1} not found' format:
				   { (self locate controllerNameFor: routeName) }) ]
]

{ #category : #rendering }
RideController >> controllerPutHtml [

	"Answers the HTML exclusive of this controller."

	^ (views at: #index) value: model
]

{ #category : #initialization }
RideController >> createSubControllers [

	"Add the subcontrollers to this receiver.
	Keys typically match the route name in snake_case."

	
]

{ #category : #initialization }
RideController >> createViews [

	views := Ride service locate templatesFor: self
]

{ #category : #actions }
RideController >> default [
	"The default action is doing nothing."
]

{ #category : #'rest-html' }
RideController >> htmlOnDELETE [

	"If the current DELETE is part of an AJAX request, 
	then use its value as a controller action to be performed."

	RideCurrentRequest value headers
		at: 'X-Ride-AJAX'
		ifPresent: [ self perform: self ajaxAction asSymbol ].

	"My subclasses are expected to answer a more sensible HTML content.
	This answer is only intended as convenience for quick feedback loop to the developers."
	^ self class name
]

{ #category : #'rest-html' }
RideController >> htmlOnGET [

	"Answers the HTML exclusive of this controller.
	If the current PUT is part of an AJAX request, 
	then use its value as a controller action to be performed."

	RideCurrentRequest value headers
		at: 'X-Ride-AJAX'
		ifPresent: [ self perform: self ajaxAction asSymbol ].

	^ (views at: #index) value: model
]

{ #category : #'rest-html' }
RideController >> htmlOnPATCH [

	"If the current PATCH is part of an AJAX request, 
	then use its value as a controller action to be performed."

	RideCurrentRequest value headers
		at: 'X-Ride-AJAX'
		ifPresent: [ self perform: self ajaxAction asSymbol ].

	"My subclasses are expected to answer a more sensible HTML content.
	This answer is only intended as convenience for quick feedback loop to the developers."
	^ self class name
]

{ #category : #'rest-html' }
RideController >> htmlOnPOST [

	"If the current POST is part of an AJAX request, 
	then use its value as a controller action to be performed."

	RideCurrentRequest value headers
		at: 'X-Ride-AJAX'
		ifPresent: [ self perform: self ajaxAction asSymbol ].

	"My subclasses are expected to answer a more sensible HTML content.
	This answer is only intended as convenience for quick feedback loop to the developers."
	^ self class name
]

{ #category : #'rest-html' }
RideController >> htmlOnPUT [

	"If the current PUT is part of an AJAX request, 
	then use its value as a controller action to be performed."

	RideCurrentRequest value headers
		at: 'X-Ride-AJAX'
		ifPresent: [ self perform: self ajaxAction asSymbol ].

	"My subclasses are expected to answer a more sensible HTML content.
	This answer is only intended as convenience for quick feedback loop to the developers."
	^ self class name
]

{ #category : #rendering }
RideController >> htmlPageOnGET [

	"Answers the HTML content generated by this controller, 
	enclosed within the application layout template."

	^ self applicationTemplate
		  value: model
		  partials: { (#main -> (views at: #index)) } asDictionary
]

{ #category : #initialization }
RideController >> initialize [

	super initialize.
	subcontrollers := JsonObject new.
	self createSubControllers.
	self createViews.

]

{ #category : #accessing }
RideController >> locate [

	^ Ride service locate
]

{ #category : #accessing }
RideController >> model [

	^ model
]

{ #category : #initialization }
RideController >> model: aModel [

	model := aModel.
	self setObservers	
]

{ #category : #accessing }
RideController >> router [

	^ Ride service router
]

{ #category : #initialization }
RideController >> setObservers [
]

{ #category : #accessing }
RideController >> subcontrollers [

	^ subcontrollers
]

{ #category : #accessing }
RideController >> subcontrollers: anObject [

	subcontrollers := anObject
]
