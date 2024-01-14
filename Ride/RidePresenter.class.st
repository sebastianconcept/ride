"
I am the abstract RidePresenter.
I provide the commonalities of all types of presenters.
See my child classes for concrete examples.

## Responsabilities:
1. Be rendereable on a layout after performing some action.
2. Have a model and use it as my source of application domain state.
3. Define the action methods.
4. Define which paramenters are acceptable in a received request.
5. Define pagePartials and pageTemplateModel to have the receiver rendereable.
6. Be capable of using different renderers (HTML, JSON, XML, RSS, etc).

"
Class {
	#name : #RidePresenter,
	#superclass : #Object,
	#instVars : [
		'model',
		'subpresenters'
	],
	#category : #'Ride-Presenters'
}

{ #category : #accessing }
RidePresenter class >> basePath [

	"Answers the view name of this controller as snake case."

	^ self getModelName asSnakeCase
]

{ #category : #accessing }
RidePresenter class >> defaultModel [

	^ nil
]

{ #category : #accessing }
RidePresenter class >> defaultRendererSelector [

	"Answers the selector of the default renderer for this class of presenters."

	^ #stt
]

{ #category : #accessing }
RidePresenter class >> getKebabizedModelName [

	^ '-' join: (self getModelName asSnakeCase substrings: '_')
]

{ #category : #accessing }
RidePresenter class >> getModelClass [

	"Answers the model class for this presenter."

	^ Smalltalk
		  at: self getModelName asSymbol
		  ifAbsent: [ 
		  RideMissingModelError signal: self getModelName , ' not found' ]
]

{ #category : #accessing }
RidePresenter class >> getModelName [

	"Answers the conventional model name for this presenter."

	^ self name copyFrom: 1 to: self name size - 'Presener' size - 1
]

{ #category : #accessing }
RidePresenter class >> getNormalizedModelName [

	^ self getKebabizedModelName
]

{ #category : #accessing }
RidePresenter class >> layoutName [

	"Answer the layout name to be used when rendering instances of the receiver."

	^ #application
]

{ #category : #'instance creation' }
RidePresenter class >> new [

	^ self on: self defaultModel
]

{ #category : #'instance creation' }
RidePresenter class >> on: aModel [

	^ self basicNew
		  initialize;
		  model: aModel
]

{ #category : #accessing }
RidePresenter class >> partialYieldTargetName [

	"This is the name used when rendering the contents of the receiver a layout."

	^ #yield
]

{ #category : #accessing }
RidePresenter >> children [

	^ subpresenters
]

{ #category : #accessing }
RidePresenter >> currentRequest [

	^ RideCurrentRequest value
]

{ #category : #accessing }
RidePresenter >> currentSession [

	^ RideCurrentSession value
]

{ #category : #accessing }
RidePresenter >> getRenderer [

	"Returns the renderer that this presenter has to use."

	"In this version we're setting this by presenter class."
	^ Ride service renderers at: self class defaultRendererSelector
]

{ #category : #actions }
RidePresenter >> index [

	self subclassResponsibility
]

{ #category : #initialization }
RidePresenter >> initialize [

	super initialize.
	subpresenters := JsonObject new
]

{ #category : #accessing }
RidePresenter >> maitre [

	"Answers the maitre of the service"

	^ Ride service maitre
]

{ #category : #accessing }
RidePresenter >> model [

	^ model
]

{ #category : #initialization }
RidePresenter >> model: aModel [

	model := aModel.
	self setObservers	
]

{ #category : #accessing }
RidePresenter >> mustacheTemplateModel [

	"Answers the model used for the template that 
	will render only the HTML of this component (not the full page)."

	| template presenterJsAssets |

	template := model asMustacheTemplateModel.
	presenterJsAssets := Ride resource assetsMap js
		                     at: self class getNormalizedModelName
		                     ifAbsent: [ nil ].

	^ (presenterJsAssets notNil and: [ presenterJsAssets notEmpty ])
		  ifFalse: [ template ]
		  ifTrue: [ 
			  presenterJsAssets keysAndValuesDo: [ :key :value | 
				  template
					  at: ('{1}Js' format: { key })
					  put: ('/assets/js/{1}' format: { value }) ].
			  template ]
]

{ #category : #actions }
RidePresenter >> onAboutToRespond [

	"no-op is the default"
]

{ #category : #actions }
RidePresenter >> onAfterAction [

	"no-op is the default"

	
]

{ #category : #actions }
RidePresenter >> onBeforeAction [

	"no-op is the default"
]

{ #category : #actions }
RidePresenter >> resetSession [

	Ride service invalidateSession: self currentSession
]

{ #category : #accessing }
RidePresenter >> serviceCache [

	^ Ride service cache
]

{ #category : #accessing }
RidePresenter >> sessionCache [

	^ self currentSession cache
]

{ #category : #initialization }
RidePresenter >> setObservers [
]

{ #category : #accessing }
RidePresenter >> subpresenters [

	^ subpresenters
]

{ #category : #accessing }
RidePresenter >> subpresenters: anObject [

	subpresenters := anObject
]
