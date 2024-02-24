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
		'subpresenters',
		'renderer'
	],
	#classInstVars : [
		'restfulActions'
	],
	#category : #'Ride-Presenters'
}

{ #category : #accessing }
RidePresenter class >> basePath [

	"Answers the view name of this presenter as snake case."
	self deprecated: 'not in use'.
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

	^ self getRootWord asSingular
]

{ #category : #accessing }
RidePresenter class >> getNormalizedModelName [

	^ self getSnakeCasedModelName
]

{ #category : #accessing }
RidePresenter class >> getNormalizedModelNameForURLs [

	^ self getKebabizedModelName asSnakeCase 
]

{ #category : #accessing }
RidePresenter class >> getNormalizedRootWord [

	^ self getRootWord asSnakeCase
]

{ #category : #accessing }
RidePresenter class >> getRenderSelector [

	"Answer the selector that detemines the rendered aspect defined for the receiver."

	^ 'index.html'
]

{ #category : #accessing }
RidePresenter class >> getRootWord [
	"Answers the root word used to refer the model name for this presenter."

	^ self name copyFrom: 1 to: self name size - 'Presener' size - 1
]

{ #category : #accessing }
RidePresenter class >> getShowUrlFor: aRideModel [

	"Answers the conventional URL for the given RideModel"

	^ Ride service server router getShowUrlFor: aRideModel
]

{ #category : #accessing }
RidePresenter class >> getSnakeCasedModelName [

	^ self getModelName asSnakeCase
]

{ #category : #initializing }
RidePresenter class >> intializeResfulActions [

	^ restfulActions := SmallDictionary new
		                    at: #POST put: #create;
		                    at: #PUT put: #update;
		                    at: #PATCH put: #update;
		                    at: #DELETE put: #destroy;
		                    yourself
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

	"This is the name used when rendering the contents of the receiver in a layout."

	^ #yield
]

{ #category : #actions }
RidePresenter class >> reset [

	restfulActions := nil
]

{ #category : #accessing }
RidePresenter class >> restfulActions [

	^ restfulActions ifNil: [ self intializeResfulActions ]
]

{ #category : #adding }
RidePresenter >> addNoticeSuccess: aString [

	self flag: #todo.
	[ 'Notice Success: ' , aString ] logInfo
]

{ #category : #accessing }
RidePresenter >> allowedFields [
	"Answers the current request fields that are allowed
	to be used in this presenter."

	^ self allowedFieldsFrom: self currentRequest
]

{ #category : #accessing }
RidePresenter >> allowedFieldsFrom: aRequest [
	"Answers the given request fields that are allowed
	to be used in this presenter."

	| allowed |
	allowed := self allowedParams.
	^ aRequest entity fields associationsSelect: [ :field |
		  allowed includes: field key ]
]

{ #category : #accessing }
RidePresenter >> allowedParams [

	"Answer the names of the parameters that are allowed to be read from the current request."
	
	"None by default"
	^ #()

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
RidePresenter >> currentRequestParam: aSymbol [
	"Answers the value of the given paramenter.
	Signals the corresponding exception if that parameter is missing."

	^ self currentRequest
		  at: aSymbol
		  ifAbsent: [ self missingParameterHandler value: aSymbol ]
]

{ #category : #accessing }
RidePresenter >> currentResponse [

	^ RideCurrentResponse value
]

{ #category : #accessing }
RidePresenter >> currentSession [

	^ RideCurrentSession value
]

{ #category : #actions }
RidePresenter >> ensureSessionCookie [

	| response sessionCookie |
	response := RideCurrentResponse value.
	sessionCookie := self currentSession sessionCookie.
	response headers at: 'Set-Cookie' put: sessionCookie fullString
]

{ #category : #actions }
RidePresenter >> formAction [
	"Makes the receiver perform the action corresponding to a RESTful convention
	and defined by the expected hidden field in its _method value.
	Signals an exception if no value is found for _method 
	or when is found but it doesn't follow the REST convention."

	| req restfulAction selector unauthorized authenticityToken session |
	req := self currentRequest.
	unauthorized := self unauthorizedHandler.
	authenticityToken := req entity
		                     at: #authenticity_token
		                     ifAbsent: unauthorized.
	session := self currentSession.

	(session authenticityTokens includesKey: authenticityToken) ifFalse:
		unauthorized.

	restfulAction := req entity
		                 at: #_method
		                 ifAbsent: [
		                 RideError signal: 'Missing form action' ].
	selector := self class restfulActions at: restfulAction ifAbsent: [
		            RideError signal:
			            ('Unsupported form action: {1}' format:
				             { restfulAction asString }) ].
	^ self perform: selector
]

{ #category : #accessing }
RidePresenter >> getLayoutName [

	^ 'application.html'
]

{ #category : #rendering }
RidePresenter >> getRenderContext [

	^ self
]

{ #category : #accessing }
RidePresenter >> getRenderSelector [

	"Answer the selector that detemines the rendered aspect defined for the receiver."

	^ self class getRenderSelector
]

{ #category : #rendering }
RidePresenter >> getRenderSelectorFor: aRenderContext [

	^ aRenderContext getRenderSelector
]

{ #category : #accessing }
RidePresenter >> getRenderer [

	"Returns the renderer that this presenter has to use."

	"In this version we're setting this by presenter class."
	^ Ride service renderers at: self class defaultRendererSelector
]

{ #category : #actions }
RidePresenter >> getShowUrlFor: aRideModel [

	"Answers the conventional URL for the given RideModel"

	^ self class getShowUrlFor: aRideModel
]

{ #category : #actions }
RidePresenter >> index [

	"Returns the default rendered representation of the receiver in its main entry point.
	For example, for an HTML representation what would be this 
	presenter rendered as intended by its corresponding index.html
	and for an JSON representation what would be in it as index.json"

	^ self render
]

{ #category : #initialization }
RidePresenter >> initialize [

	super initialize.
	subpresenters := JsonObject new.
	renderer := self getRenderer
]

{ #category : #accessing }
RidePresenter >> maitre [

	"Answers the maitre of the service"

	^ Ride service maitre
]

{ #category : #accessing }
RidePresenter >> missingParameterHandler [
	" Answers a handler to react when an expected parameter was not found."

	^ [ :symbol |
	  RideNotFoundError signal:
		  ('Expected parameter not found: {1}' format: { symbol asString }) ]
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
RidePresenter >> modelNotFoundHandler [
	" Answers a handler to react when an expected model instance wasn't found."

	^ [
	  | id |
	  id := self currentRequest at: #id.
	  RideNotFoundError signal: ('No {1} found at {2}' format: {
				   self class getModelName.
				   id asString }) ]
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
RidePresenter >> newAuthToken [

	^ self currentSession newAuthToken
]

{ #category : #actions }
RidePresenter >> onAboutToRespond [

	self ensureSessionCookie
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
RidePresenter >> redirectFor: aRideModel [
	"Signal a redirect poiting to what will show the given RideModel."

	| destinationURL |
	destinationURL := self getShowUrlFor: aRideModel.

	RideRedirect signalFor: destinationURL
]

{ #category : #actions }
RidePresenter >> redirectTo: destinationURI [
	"Signal a redirect poiting to the given destinationURI."

	RideRedirect signalFor: destinationURI
]

{ #category : #actions }
RidePresenter >> redirectToIndex [
	"Signal a redirect pointing to the root word of the receiver in plural and normalized."

	| destinationURL |
	destinationURL := '/{1}' format:
		                  { self class getRootWord asLowercase asPlural asSnakeCase }.

	RideRedirect signalFor: destinationURL
]

{ #category : #rendering }
RidePresenter >> render [

	^ self render: self getRenderContext
]

{ #category : #rendering }
RidePresenter >> render: aRenderContext [

	^ self
		  render: aRenderContext
		  using: (renderer getRenderSelectorOf: aRenderContext)
]

{ #category : #rendering }
RidePresenter >> render: aSelector inLayout: aLayoutNameOrNil on: aRenderContext [

	self deprecated: 'use render:using:in:'.
	^ renderer
		  render: aSelector
		  using: aLayoutNameOrNil
		  in: aRenderContext
		  for: self
]

{ #category : #rendering }
RidePresenter >> render: aSelector model: aRideModel [

	"Render the given model using aSelector to decide how it should be rendered."

	self deprecated: 'use render:using:'.
	^ renderer render: aSelector model: aRideModel for: self
]

{ #category : #rendering }
RidePresenter >> render: aSelector on: aRenderContext [

	self deprecated: 'use render:in:'.
	^ self
		  render: aSelector
		  inLayout: self getLayoutName
		  on: aRenderContext
]

{ #category : #rendering }
RidePresenter >> render: aRenderContext using: aSelector [

	^ self render: aRenderContext using: aSelector in: nil
]

{ #category : #rendering }
RidePresenter >> render: aRenderContext using: aSelector in: aLayoutNameOrNil [

	^ renderer
		  render: aRenderContext
		  using: aSelector
		  in: aLayoutNameOrNil
		  for: self
]

{ #category : #rendering }
RidePresenter >> renderModel: aRideModel [

	"Render the given model using its own default way to do it."
	self deprecated: 'not used'.
	aRideModel ifNil: [ RideNotFoundError signal: 'Model not found ' ].
	self halt.
	^ self render: aRideModel getDefaultRenderSelector model: aRideModel
]

{ #category : #rendering }
RidePresenter >> renderUsing: aSelector [

	^ self render: self getRenderContext using: aSelector
]

{ #category : #actions }
RidePresenter >> resetSession [

	Ride service invalidateSessionId: self currentSession
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

{ #category : #accessing }
RidePresenter >> templateContext [

	"Answers the object used as context for the template that 
	will render the HTML of this presenter (its strict content
	not wrapped in a layout as in a full page render)."

	| template presenterJsAssets |
	template := model asTemplateModel.
	Ride resource assetsMap js ifNil: [ ^ template ].

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

{ #category : #accessing }
RidePresenter >> unauthorizedHandler [
	"Answers a handler to react when the auth token is missing or was not found."

	^ [ RideUnauthorizedError signal: 'Authorization not found' ]
]

{ #category : #actions }
RidePresenter >> updateModelFromRequest: aRequest [
	"Updates the model data following the convention of expecting for all its data keys,
	parameters in the given request with their corresponding new value."

	| allDataFields |
	allDataFields := self allowedFieldsFrom: aRequest.

	allDataFields keysAndValuesDo: [ :key :value |
		model at: key put: value ]
]
