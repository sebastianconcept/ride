"
I have delarations on how to treat routes.

For example, I can make

GET /admin/dashboard

To be processed as sending the message to DashboardController>>index

and 

POST /admin/jobs/1/beCompleted

To be processed as sending the message JobController>>beCompleted after settig its model to be the Job with ID 1.

"
Class {
	#name : #RideDeclarativeRouting,
	#superclass : #RideRouterStrategy,
	#instVars : [
		'actions'
	],
	#classInstVars : [
		'supportedHttpMethods'
	],
	#category : #'Ride-HTTP'
}

{ #category : #validation }
RideDeclarativeRouting class >> checkHttpMethodValidity: aSymbol [

	(self supportedHttpMethods includes: aSymbol) ifFalse: [ 
		RideError signal:
			('{1} is not a supported HTTP method' format: { aSymbol asString }) ]
]

{ #category : #handlers }
RideDeclarativeRouting class >> handlerOfHttpMethod [

	"Answers the handler that can set a route in teapot 
	based on the given parameters expected to follow 
	the route declaration convention."

	| currentRequest |
	^ [ :methodAndPath :presenterClassAndMessage :outputOrNil :rideServer | 
	  | method path association outputType |
	  self checkHttpMethodValidity: methodAndPath key.
	  method := methodAndPath key.
	  path := methodAndPath value.
	  association := path -> [ :req | 
	                 | session presenter response renderedContent |
	                 [ req uri asString ] logDebug.
	                 currentRequest := RideCurrentRequest value.
	                 session := Ride service getSessionFrom: req.
	                 response := TeaResponse ok.
	                 RideCurrentResponse value: response during: [ 
		                 RideCurrentSession value: session during: [ 
			                 RideCurrentRequest value: req during: [ 
				                 presenter := presenterClassAndMessage key new.
				                 presenter onBeforeAction.
				                 renderedContent := presenter perform:
					                                    presenterClassAndMessage
						                                    value.
				                 presenter onAfterAction.
				                 response body: renderedContent.
				                 presenter onAboutToRespond ] ].
		                 response ] ].

	  outputType := outputOrNil ifNil: [ #html ].

	  rideServer teapot
		  perform: ('{1}:' format: { method }) asSymbol with: association;
		  output: outputType.

	  [ 
	  'Route {1} {2} -> {3}>>{4} -> {5}' format: { 
			  method.
			  path.
			  presenterClassAndMessage key.
			  presenterClassAndMessage value.
			  outputType } ] logInfo ]
]

{ #category : #handlers }
RideDeclarativeRouting class >> handlerOfResourceRoutes [

	"Definition example of a model in a custom presenter and path
	{ 
		(#resource -> {
			CoffeeJob -> (CoffeeJobPresenter -> '/coffee_jobs').
			#json } ) ) 
	}"

	| arrayOrAssociation |
	^ [ :resourceRouteDefinition :rideServer | 
	  resourceRouteDefinition isClass
		  ifTrue: [ 
		  self setResourceRouteFor: resourceRouteDefinition on: rideServer ]
		  ifFalse: [ 
			  arrayOrAssociation := resourceRouteDefinition.
			  arrayOrAssociation isArray
				  ifTrue: [ 
					  self
						  setResourceRouteFor: arrayOrAssociation first
						  output: arrayOrAssociation second
						  on: rideServer ]
				  ifFalse: [ 
					  self
						  setResourceRouteFor: arrayOrAssociation key
						  handledBy: arrayOrAssociation value
						  on: rideServer ] ] ]
]

{ #category : #initialization }
RideDeclarativeRouting class >> initializeSupportedHttpMethods [

	^ supportedHttpMethods := { #GET. #POST. #PUT. #PATCH. #DELETE }
]

{ #category : #actions }
RideDeclarativeRouting class >> newActions [

	| allowedHandler |
	allowedHandler := self handlerOfHttpMethod.
	^ { 
		  (#GET -> allowedHandler).
		  (#POST -> allowedHandler).
		  (#PUT -> allowedHandler).
		  (#PATCH -> allowedHandler).
		  (#DELETE -> allowedHandler).
		  (#resource -> self handlerOfResourceRoutes) } asDictionary
]

{ #category : #handlers }
RideDeclarativeRouting class >> pathFromPresenterClass: presenterClass [

	| targetName suffix |
	targetName := presenterClass name.
	suffix := 'Presenter'.
	^ (targetName endsWith: suffix)
		  ifTrue: [ 
			  '/{1}' format:
				  { (targetName copyFrom: 1 to: targetName size - suffix size)
					  asSnakeCase } ]
		  ifFalse: [ 
			  RideError signal:
				  ('{1} is not a presenter class' format: { targetName }) ]
]

{ #category : #actions }
RideDeclarativeRouting class >> reset [

	supportedHttpMethods := nil
]

{ #category : #handlers }
RideDeclarativeRouting class >> setResourceRouteFor: modelClass handledBy: presenterOrPathOrPresenterAndPath on: rideServer [

	presenterOrPathOrPresenterAndPath isAssociation
		ifFalse: [ 
			presenterOrPathOrPresenterAndPath isClass
				ifTrue: [ 
					self
						setResourceRouteFor: modelClass
						handledBy: presenterOrPathOrPresenterAndPath
						path:
						(self pathFromPresenterClass: presenterOrPathOrPresenterAndPath)
						on: rideServer ]
				ifFalse: [ 
					self
						setResourceRouteFor: modelClass
						handledBy: (self presenterClassFor: modelClass)
						path: presenterOrPathOrPresenterAndPath
						on: rideServer ] ]
		ifTrue: [ 
			self
				setResourceRouteFor: modelClass
				handledBy: presenterOrPathOrPresenterAndPath key
				path: presenterOrPathOrPresenterAndPath value
				output: #html
				on: rideServer ]
]

{ #category : #handlers }
RideDeclarativeRouting class >> setResourceRouteFor: modelClass handledBy: presenterAndPath output: aSymbol on: rideServer [

	self
		setResourceRouteFor: modelClass
		handledBy: presenterAndPath key
		path: presenterAndPath value
		output: aSymbol
		on: rideServer
]

{ #category : #handlers }
RideDeclarativeRouting class >> setResourceRouteFor: modelClass handledBy: presenterClass path: pathOrPresenterAndPath on: rideServer [

	self
		setResourceRouteFor: modelClass
		handledBy: presenterClass
		path: pathOrPresenterAndPath
		output: #html
		on: rideServer
]

{ #category : #handlers }
RideDeclarativeRouting class >> setResourceRouteFor: modelClass handledBy: presenterClass path: path output: aSymbol on: rideServer [

	| index withId newModel edit delete update presenter answer handler |
	index := path.
	withId := '{1}/<jobId>' format: { path }.
	newModel := '{1}/new' format: { path }.
	edit := '{1}/<jobId>/edit' format: { path }.
	delete := '{1}/<jobId>' format: { path }.

	handler := [ :actionSelector :req | 
	           | session |
	           [ req uri asString ] logDebug.
	           RideCurrentRequest value: req during: [ 
		           session := Ride service getSessionFrom: req.
		           RideCurrentSession value: session during: [ 
			           presenter := presenterClass new.
			           presenter onBeforeAction.
			           answer := presenter perform: actionSelector.
			           presenter onAfterAction.
			           answer ] ] ].
	rideServer teapot
		GET: index -> [ :req | handler value: #index value: req ];
		output: aSymbol.
	[ 
	'Route {1} {2} -> {3}>>{4} -> {5}' format: { 
			#GET.
			index.
			presenterClass name.
			#index.
			aSymbol } ] logInfo.


	rideServer teapot
		GET: withId -> [ :req | handler value: #show value: req ];
		output: aSymbol.
	[ 
	'Route {1} {2} -> {3}>>{4} -> {5}' format: { 
			#GET.
			withId.
			presenterClass name.
			#show.
			aSymbol } ] logInfo.

	rideServer teapot
		GET: newModel -> [ :req | handler value: #newModel value: req ];
		output: aSymbol.

	[ 
	'Route {1} {2} -> {3}>>{4} -> {5}' format: { 
			#GET.
			newModel.
			presenterClass name.
			#newModel.
			aSymbol } ] logInfo.

	rideServer teapot
		GET: edit -> [ :req | handler value: #edit value: req ];
		output: aSymbol.
	[ 
	'Route {1} {2} -> {3}>>{4} -> {5}' format: { 
			#GET.
			edit.
			presenterClass name.
			#edit.
			aSymbol } ] logInfo.

	rideServer teapot
		POST: path -> [ :req | handler value: #create value: req ];
		output: aSymbol.
	[ 
	'Route {1} {2} -> {3}>>{4} -> {5}' format: { 
			#POST.
			path.
			presenterClass name.
			#create.
			aSymbol } ] logInfo.

	update := path -> [ :req | handler value: #update value: req ].

	rideServer teapot
		PATCH: update;
		output: aSymbol.
	[ 
	'Route {1} {2} -> {3}>>{4} -> {5}' format: { 
			#PATCH.
			path.
			presenterClass name.
			#update.
			aSymbol } ] logInfo.

	rideServer teapot
		PUT: update;
		output: aSymbol.
	[ 
	'Route {1} {2} -> {3}>>{4} -> {5}' format: { 
			#PUT.
			path.
			presenterClass name.
			#update.
			aSymbol } ] logInfo.

	rideServer teapot
		DELETE: delete -> [ :req | handler value: #destroy value: req ];
		output: aSymbol.
	[ 
	'Route {1} {2} -> {3}>>{4} -> {5}' format: { 
			#DELETE.
			delete.
			presenterClass name.
			#destroy.
			aSymbol } ] logInfo
]

{ #category : #handlers }
RideDeclarativeRouting class >> setResourceRouteFor: aModelClass on: rideServer [

	self
		setResourceRouteFor: aModelClass
		handledBy: (self presenterClassFor: aModelClass)
		path: aModelClass name asSnakeCase asLowercase
		on: rideServer
]

{ #category : #handlers }
RideDeclarativeRouting class >> setResourceRouteFor: association output: aSymbol on: rideServer [

	| pathOrPresenterAndPath modelClass |
	modelClass := association key.
	pathOrPresenterAndPath := association value.

	pathOrPresenterAndPath isAssociation
		ifTrue: [ 
			self
				setResourceRouteFor: modelClass
				handledBy: pathOrPresenterAndPath
				output: aSymbol
				on: rideServer ]
		ifFalse: [ 
			self
				setResourceRouteFor: association key
				handledBy: (self presenterClassFor: modelClass)
				path: pathOrPresenterAndPath
				output: aSymbol
				on: rideServer ]
]

{ #category : #accessing }
RideDeclarativeRouting class >> supportedHttpMethods [

	^ supportedHttpMethods ifNil: [ self initializeSupportedHttpMethods ]
]

{ #category : #initialization }
RideDeclarativeRouting >> initialize [

	super initialize.

	actions := self class newActions
]

{ #category : #initialization }
RideDeclarativeRouting >> setRouteFromArrayDefinition: routeDeclaration on: aRideServer [

	| methodAndPath presenterClassAndMessage outputType |
	methodAndPath := routeDeclaration first.
	presenterClassAndMessage := routeDeclaration second.
	routeDeclaration size = 3 ifTrue: [ 
		outputType := routeDeclaration third ].

	(actions at: methodAndPath key ifAbsent: [ 
		 RideError signal:
			 ('Unsupported route declaration keyword {1}' format:
				  { methodAndPath key asString }) ]) valueWithArguments: { 
			methodAndPath.
			presenterClassAndMessage.
			outputType.
			aRideServer }
]

{ #category : #initialization }
RideDeclarativeRouting >> setRouteFromAssociationDefinition: routeDeclaration on: aRideServer [

	(actions at: routeDeclaration key ifAbsent: [ 
		 RideError signal:
			 ('Unsupported route declaration keyword {1}' format:
				  { routeDeclaration key asString }) ])
		value: routeDeclaration value
		value: aRideServer
]

{ #category : #initialization }
RideDeclarativeRouting >> setRoutesOn: aRideServer [

	aRideServer routesDeclaration do: [ :routeDeclaration | 
		routeDeclaration isAssociation
			ifTrue: [ 
				self
					setRouteFromAssociationDefinition: routeDeclaration
					on: aRideServer ]
			ifFalse: [ 
			self setRouteFromArrayDefinition: routeDeclaration on: aRideServer ] ]
]
