"
I set the routes of a RideServer.

This is my convention for setting routes:

1. Define the list of directories under templates/views/ as the supported routes.
2. Every dirname is a route that will be rendered when hit with a GET or 404 otherwise.
3. Every other http method, is a method in a corresponding 'controller' named like this:
3.1 Take the view name and convert it from snake case to camel case and 
3.2 Suffix it with 'Controller'.
3.3 That controller should understand create for POST, destroy for DELETE, update for PATCH/PUT, show, edit. 
	
"
Class {
	#name : #RideRouter,
	#superclass : #Object,
	#instVars : [
		'sessionGetter',
		'rootControllerGetter',
		'domain'
	],
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideRouter class >> baseUrl [

	^ OSEnvironment current
		  at: #RIDE_BASE_URL
		  ifAbsent: [ self defaultBaseUrl ]
]

{ #category : #accessing }
RideRouter class >> defaultBaseUrl [

	^ ''
]

{ #category : #actions }
RideRouter class >> newSessionId [

	^ UUID new asString36
]

{ #category : #handler }
RideRouter class >> sessionHeaderKey [

	^ 'X-Ride-SessionId'
]

{ #category : #accessing }
RideRouter class >> views [

	^ self templates
		  at: #views
		  ifAbsent: [ RideMissingTemplateError signal: 'No view templates' ]
]

{ #category : #accessing }
RideRouter >> baseUrl [

	^ self class baseUrl
]

{ #category : #actions }
RideRouter >> basicSetRoute: routeName with: someMustacheTemplates on: aRideServer [

	"Set the endpoints accepted for routeName in aRideServer based the
	given templates found and interpreted with the Ride convention:
	1. Templates under file names starting with underscore are partials.
	2. The '_form' partial is the default used for editing a model.
	3. The 'new' view also uses the _form partial (on a new model).
	4. The 'show' view will use _show partial to render the model.
	5. The 'edit' view will also use the _form partial to render a form for the model."

	aRideServer teapot
		GET: self baseUrl , '/' , routeName , '/*'
			-> (self handleHTMLOnGETFor: routeName with: someMustacheTemplates);
		output: #html.
	aRideServer teapot
		POST: self baseUrl , '/' , routeName , '/*'
			-> (self handleHTMLOnPOSTFor: routeName with: someMustacheTemplates);
		output: #html.
	aRideServer teapot
		PUT: self baseUrl , '/' , routeName , '/*'
			-> (self handleHTMLOnPUTFor: routeName with: someMustacheTemplates);
		output: #html.
	aRideServer teapot
		PATCH: self baseUrl , '/' , routeName , '/*'
			->
				(self handleHTMLOnPATCHFor: routeName with: someMustacheTemplates);
		output: #html.
	aRideServer teapot
		DELETE: self baseUrl , '/' , routeName , '/*'
			-> (self handleHTMLOnDELETEFor: routeName);
		output: #html
]

{ #category : #accessing }
RideRouter >> getBasicHandlerDo: aBlock [

	| session |
	^ [ :req | 
	  RideCurrentRequest value: req during: [ 
		  session := self getSessionFrom: req.
		  RideCurrentSession value: session during: aBlock ] ]
]

{ #category : #accessing }
RideRouter >> getDomain [

	^ domain ifNil: [ 
		  domain := OSEnvironment current
			            at: 'RIDE_DOMAIN'
			            ifAbsent: [ 'localhost' ] ]
]

{ #category : #accessing }
RideRouter >> getSessionFrom: aRequest [

	^ self sessionGetter value: aRequest
]

{ #category : #handler }
RideRouter >> handleHTMLHomePageGET [

	"Answers the html produced with the controller that is set as root."

	| response session request sessionCookie |
	^ self getBasicHandlerDo: [ 
		  request := RideCurrentRequest value.
		  session := RideCurrentSession value.
		  response := TeaResponse ok.
		  sessionCookie := self newSessionCookieFor: session id.
		  response headers at: 'Set-Cookie' put: sessionCookie fullString.
		  response body: RideCurrentSession value rootController htmlPageOnGET.
		  response ]
]

{ #category : #handler }
RideRouter >> handleHTMLOnDELETEFor: routeName [

	^ self getBasicHandlerDo: [ 
		  (RideCurrentSession value rootController controllerForRoute:
			   routeName) htmlOnDELETE ]

"	^ (self locate controllers at: routeName ifAbsent: [ 
		   RideMissingControllerError signal: ('{1} not found' format:
				    { (self locate controllerNameFor: routeName) }) ]) deleteHtml"
]

{ #category : #handler }
RideRouter >> handleHTMLOnGETFor: routeName with: someMustacheTemplates [

	| response controller content |
	^ self getBasicHandlerDo: [ "	^ self getBasicHandlerDo: [ 
		  RideCurrentSession value rootController showHtml ]"
		  response := TeaResponse ok.
		  "Set a custom header in the response"
		  response headers at: 'Custom-Header' put: 'Hello from Teapot!'.
		  controller := RideCurrentSession value rootController 
			                controllerForRoute: routeName.
		  content := (RideCurrentRequest value headers includesKey:
			              'X-Ride-AJAX')
			             ifTrue: [ controller htmlOnGET ]
			             ifFalse: [ controller htmlPageOnGET ].
		  response body: content.
		  response ]
]

{ #category : #handler }
RideRouter >> handleHTMLOnPATCHFor: routeName with: someMustacheTemplates [

	^ self getBasicHandlerDo: [ 
		  (RideCurrentSession value rootController controllerForRoute:
			   routeName) htmlOnPATCH ]

"	^ (self locate controllers at: routeName ifAbsent: [ 
		   RideMissingControllerError signal: ('{1} not found' format:
				    { (self locate controllerNameFor: routeName) }) ]) 
		  patchHtmlWith: someMustacheTemplates"
]

{ #category : #handler }
RideRouter >> handleHTMLOnPOSTFor: routeName with: someMustacheTemplates [

	^ self getBasicHandlerDo: [ 
		  (RideCurrentSession value rootController controllerForRoute:
			   routeName) htmlOnPOST ]
]

{ #category : #handler }
RideRouter >> handleHTMLOnPUTFor: routeName with: someMustacheTemplates [

	^ self getBasicHandlerDo: [ 
		  (RideCurrentSession value rootController controllerForRoute:
			   routeName) htmlOnPUT ]
		
		
"	^ (self locate controllers at: routeName ifAbsent: [ 
		   RideMissingControllerError signal: ('{1} not found' format:
				    { (self locate controllerNameFor: routeName) }) ]) 
		  putHtmlWith: someMustacheTemplates"
]

{ #category : #initialization }
RideRouter >> initializeRootControllerGetter [

	^ rootControllerGetter := [ :session | 
	                          session
		                          ifNil: [ 
		                          WelcomeController on: Welcome new ]
		                          ifNotNil: [ 
		                          WelcomeController on:
			                          session rootModel ] ]
]

{ #category : #initialization }
RideRouter >> initializeSessionGetter [

	^ sessionGetter := [ :request | 
	                   | sessionCookie sessionId |
	                   sessionCookie := request cookies
		                                    detect: [ :each | 
		                                    each name = 'id' ]
		                                    ifNone: [ nil ].
	                   sessionId := sessionCookie
		                                ifNil: [ self class newSessionId ]
		                                ifNotNil: [ sessionCookie value ].

	                   Ride service sessions
		                   at: sessionId
		                   ifAbsentPut: [ 
		                   RideSession newWith: sessionId on: Welcome new ] ]
]

{ #category : #actions }
RideRouter >> newSessionCookieFor: sessionId [

	^ ZnCookie
		  fromString: (self sessionCookiePathFor: sessionId)
		  for: ('http://' , self getDomain) asZnUrl
]

{ #category : #accessing }
RideRouter >> rootControllerGetter [

	^ rootControllerGetter ifNil: [ self initializeRootControllerGetter ]
]

{ #category : #accessing }
RideRouter >> rootControllerGetter: anObject [

	rootControllerGetter := anObject
]

{ #category : #handler }
RideRouter >> sessionCookiePathFor: anId [

	| expires |
	expires := ZnUtils httpDate: DateAndTime now + 5 minutes.
	^ 'id={1}; expires={2}; path=/; domain={3}' format: { 
			  anId.
			  expires.
			  self getDomain }
]

{ #category : #accessing }
RideRouter >> sessionGetter [

	^ sessionGetter ifNil: [ self initializeSessionGetter ]
]

{ #category : #accessing }
RideRouter >> sessionGetter: anObject [

	sessionGetter := anObject
]

{ #category : #accessing }
RideRouter >> sessionHeaderKey [

	^ self class sessionHeaderKey
]

{ #category : #actions }
RideRouter >> setHomeRouteOn: aRideServer [
	"Sets the default handler for the home route."
	aRideServer teapot
		GET: self baseUrl , '/' -> self handleHTMLHomePageGET;
		output: #html
]

{ #category : #actions }
RideRouter >> setRoute: routeName with: someMustacheTemplates on: aRideServer [

	someMustacheTemplates keysAndValuesDo: [ :route :mustacheTemplates | 
		self
			basicSetRoute: routeName
			with: mustacheTemplates
			on: aRideServer ]
]

{ #category : #actions }
RideRouter >> setRoutesOn: aRideServer [

	"RideRouter policy will be like this:	
	1. Use the views/ directory and use each subdirectory 
	name as snake_case and those are the default routes.
	2. Set one route that is going to define who's 
	the controller and template. 
	Usually this would happen with the rootController showHtml method."

	Ride service locate viewTemplates keysAndValuesDo: [ :key :value | 
		self setRoute: key with: value on: aRideServer ].

	self setHomeRouteOn: aRideServer
]
