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
		'focusedView',
		'delegate'
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

{ #category : #actions }
RideController >> ajaxAction [

	"Answers the selector of the action specified from the AJAX request.
	The convention is to use the value in 'X-Ride-AJAX' as the selector
	that this controller would perform as a reaction. And, as #default is a no-op,
	the default is to do nothing."

	^ RideCurrentRequest value headers
		  at: 'X-Ride-AJAX'
		  ifAbsent: [ #default ]
]

{ #category : #'rest-html' }
RideController >> ajaxReactionAndRender [

	"If the current request is part of a Ride AJAX request, 
	use the value sent and perform it as reaction in this controller."

	^ RideCurrentRequest value headers
		  at: 'X-Ride-AJAX'
		  ifPresent: [ self perform: self ajaxAction asSymbol ]
		  ifAbsent: [ self html ]
]

{ #category : #accessing }
RideController >> applicationTemplate [

	^ Ride service locate templates layouts application
]

{ #category : #rendering }
RideController >> basicHTML [

	(views at: #index ifAbsent: [ ^ self class name ]) value: model
]

{ #category : #accessing }
RideController >> childAt: aSymbol [

	^ subcontrollers at: aSymbol
]

{ #category : #accessing }
RideController >> children [

	^ subcontrollers
]

{ #category : #initialization }
RideController >> createSubcontrollers [

	"Add the subcontrollers to this receiver.
	Keys typically match the route name in snake_case."

	
]

{ #category : #initialization }
RideController >> createViews [

	views := Ride service locate templatesFor: self.
	focusedView := views at: #index
]

{ #category : #accessing }
RideController >> currentRequest [

	^ RideCurrentRequest value
]

{ #category : #actions }
RideController >> default [
	"The default action is doing nothing."
]

{ #category : #accessing }
RideController >> delegate [

	^ delegate
]

{ #category : #accessing }
RideController >> delegate: anObject [

	delegate := anObject
]

{ #category : #accessing }
RideController >> focusedView [
	"Answers the template that is the current view to be rendered for this controller.
	It starts by being #index and after that it might be changed by ushow the controller
	reactcs to user input."
	^ focusedView
]

{ #category : #accessing }
RideController >> focusedView: anObject [

	focusedView := anObject
]

{ #category : #rendering }
RideController >> html [

	"Answers the HTML renderering of the model regarding to this controller.
	It will return the class name if for any reason there is no template found at #index"

	^ delegate ifNotNil: [ delegate html ] ifNil: [ self basicHTML ]
]

{ #category : #'rest-html' }
RideController >> htmlOnDELETE [

	"If the current DELETE is part of an AJAX request, 
	then use its value as a controller action to be performed and 
	answer whatever that action decided is the html to be send as response."

	^ self ajaxReactionAndRender
]

{ #category : #'rest-html' }
RideController >> htmlOnGET [

	"Answers the HTML exclusive of this controller.
	If the current GET is part of an AJAX request, 
	then use its value as a controller action to be performed.
	If a delegate was assigned, then the reaction is still for this 
	controller but the html is for the delegate to render instead."

	"If the current GET is part of an AJAX request, 
	then use its value as a controller action to be performed and 
	answer whatever that action decided is the html to be send as response."

	^ self ajaxReactionAndRender
]

{ #category : #'rest-html' }
RideController >> htmlOnPATCH [

	"If the current PATCH is part of an AJAX request, 
	then use its value as a controller action to be performed and 
	answer whatever that action decided is the html to be send as response."

	^ self ajaxReactionAndRender
]

{ #category : #'rest-html' }
RideController >> htmlOnPOST [

	"If the current POST is part of an AJAX request, 
	then use its value as a controller action to be performed and 
	answer whatever that action decided is the html to be send as response."

	^ self ajaxReactionAndRender
]

{ #category : #'rest-html' }
RideController >> htmlOnPUT [

	"If the current PUT is part of an AJAX request, 
	then use its value as a controller action to be performed and 
	answer whatever that action decided is the html to be send as response."

	^ self ajaxReactionAndRender
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
	self createSubcontrollers.
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
RideController >> partialOf: aSymbol [

	"Answers the template of the subcontroller found at aSymbol 
	ready to be sent as one of the partials for them to render."

	^ aSymbol -> (self children at: aSymbol) focusedView
]

{ #category : #actions }
RideController >> resetDelegate [

	delegate := nil
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
