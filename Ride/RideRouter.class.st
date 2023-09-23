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
		'domain',
		'rootPresenterGetter'
	],
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideRouter class >> baseFilePath [

	^ Path from: (OSEnvironment current
			   at: #RIDE_BASE_FILE_PATH
			   ifAbsent: [ self defaultBaseFilePathString ])
]

{ #category : #accessing }
RideRouter class >> baseUrl [

	^ OSEnvironment current
		  at: #RIDE_BASE_URL
		  ifAbsent: [ self defaultBaseUrl ]
]

{ #category : #accessing }
RideRouter class >> defaultBaseFilePathString [

	^ (Smalltalk imageDirectory / 'app' / 'templates') pathString
]

{ #category : #accessing }
RideRouter class >> defaultBaseUrl [

	^ ''
]

{ #category : #accessing }
RideRouter class >> defaultPublicBasePath [

	^ (Smalltalk imageDirectory / 'public') pathString
]

{ #category : #accessing }
RideRouter class >> defaultPublicBaseUrl [

	^ '/'
]

{ #category : #accessing }
RideRouter class >> defaultUploadsBasePath [

	^ (Smalltalk imageDirectory / 'uploads') pathString
]

{ #category : #actions }
RideRouter class >> newSessionId [

	^ UUID new asString36
]

{ #category : #accessing }
RideRouter class >> publicDirectory [

	^ Path from: self publicDirectoryString
]

{ #category : #accessing }
RideRouter class >> publicDirectoryString [

	^ OSEnvironment current
		  at: #RIDE_PUBLIC_BASE_PATH
		  ifAbsent: [ self defaultPublicBasePath ]
]

{ #category : #accessing }
RideRouter class >> publicPathString [

	^ OSEnvironment current
		  at: #RIDE_PUBLIC_BASE_URL
		  ifAbsent: [ self defaultPublicBaseUrl ]
]

{ #category : #handler }
RideRouter class >> sessionHeaderKey [

	^ 'X-Ride-SessionId'
]

{ #category : #accessing }
RideRouter class >> uploadsBaseDirectory [

	^ Path from: self uploadsBaseDirectoryString
]

{ #category : #accessing }
RideRouter class >> uploadsBaseDirectoryString [

	^ OSEnvironment current
		  at: #RIDE_UPLOAD_BASE_PATH
		  ifAbsent: [ self defaultUploadsBasePath ]
]

{ #category : #accessing }
RideRouter class >> views [

	^ self templates
		  at: #views
		  ifAbsent: [ RideMissingTemplateError signal: 'No view templates' ]
]

{ #category : #accessing }
RideRouter >> baseFilePath [

	^ self class baseFilePath
]

{ #category : #accessing }
RideRouter >> baseUrl [

	^ self class baseUrl
]

{ #category : #actions }
RideRouter >> basicSetRoute: routeName with: someMustacheTemplate on: aRideServer [

	"Set the endpoints accepted for routeName in aRideServer based the
	given templates found and interpreted with the Ride convention:
	1. Templates under file names starting with underscore are partials.
	2. The '_form' partial is the default used for editing a model.
	3. The 'new' view also uses the _form partial (on a new model).
	4. The 'show' view will use _show partial to render the model.
	5. The 'edit' view will also use the _form partial to render a form for the model."

	aRideServer teapot
		GET: self baseUrl , '/<routeName>/*'
			-> [ :req | self fileServeOrRenderPresenterFor: req ];
		output: #html.
	aRideServer teapot
		GET: self baseUrl , '/' , routeName , '/*'
			-> (self handleHTMLOnGETFor: routeName);
		output: #html.
	aRideServer teapot
		POST: self baseUrl , '/' , routeName , '/*'
			-> (self handleHTMLOnPOSTFor: routeName);
		output: #html.
	aRideServer teapot
		PUT: self baseUrl , '/' , routeName , '/*'
			-> (self handleHTMLOnPUTFor: routeName);
		output: #html.
	aRideServer teapot
		PATCH: self baseUrl , '/' , routeName , '/*'
			-> (self handleHTMLOnPATCHFor: routeName);
		output: #html.
	aRideServer teapot
		DELETE: self baseUrl , '/' , routeName , '/*'
			-> (self handleHTMLOnDELETEFor: routeName);
		output: #html
]

{ #category : #actions }
RideRouter >> fileServe: request [

	| route targetedPath |
	route := request at: #routeName.
	targetedPath := self baseFilePath / 'views'.
	('*.js' match: request uri segments last) ifFalse: [ 
		request abort: TeaResponse notFound ].
	request uri segments do: [ :path | 
		targetedPath := targetedPath / path ].
	targetedPath asFileReference exists ifFalse: [ 
		RideNotFoundError signal:
			('{1} not found' format: { request uri asString }) ].
	"We should at least be caching this.
	Not for dev tho."
	^ targetedPath asFileReference contents
	"^ '<script>{1}</script>' format:
		  { targetedPath asFileReference contents }"
]

{ #category : #actions }
RideRouter >> fileServeOrRenderPresenterFor: request [

	| route targetedPath |
	route := request at: #routeName.

	"1. Try to serve it as a presenter's main view (directory)"
	(route = request uri segments last and: [ 
		 self hasPresenterForRoute: route ]) ifTrue: [ 
		^ (self handleHTMLOnGETFor: route) value: request ].

	"2. Try to serve it as a resource local to the view directory"
	targetedPath := self baseFilePath / 'views'.
	request uri segments do: [ :path | 
		targetedPath := targetedPath / path.
		(targetedPath asFileReference exists and: [ 
			 targetedPath asFileReference isFile ]) ifTrue: [ 
			^ targetedPath asFileReference contents ] ].

	"3. Try to serve it as a resource found in the public directory and 404 otherwise."
	targetedPath := self class publicDirectory asFileReference
	                / request uri segments last.
	^ targetedPath exists
		  ifTrue: [ targetedPath asFileReference contents ]
		  ifFalse: [ 
			  RideNotFoundError signal:
				  ('{1} not found' format: { request uri asString }) ]
]

{ #category : #accessing }
RideRouter >> getBasicHandlerDo: aBlock [

	| session |
	^ [ :req | 
	  RideCurrentRequest value: req during: [ 
		  session := self getSessionFrom: req.
		  [ RideCurrentSession value: session during: aBlock ]
			  on: RideMissingPresenterError
			  do: [ :x | "404" self halt ] ] ]
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

	"Answers the html produced with the presenter that is set as root."

	| response session request sessionCookie presenter content |

	^ self getBasicHandlerDo: [ 
		  request := RideCurrentRequest value.
		  session := RideCurrentSession value.
		  response := TeaResponse ok.
		  sessionCookie := self newSessionCookieFor: session id.
		  response headers at: 'Set-Cookie' put: sessionCookie fullString.
		  presenter := RideCurrentSession value rootPresenter.
		  content := (RideCurrentRequest value headers includesKey:
			              'X-Ride-AJAX')
			             ifTrue: [ presenter htmlOnGET ]
			             ifFalse: [ presenter htmlPageOnGET ].
		  response body: content.
		  response ]
]

{ #category : #handler }
RideRouter >> handleHTMLHomePagePOST [

	"Answers the html produced with the controller that is set as root."

	| response session request sessionCookie |
	^ self getBasicHandlerDo: [ 
		  request := RideCurrentRequest value.
		  session := RideCurrentSession value.
		  response := TeaResponse ok.
		  sessionCookie := self newSessionCookieFor: session id.
		  response headers at: 'Set-Cookie' put: sessionCookie fullString.
		  response body: RideCurrentSession value rootPresenter htmlOnPOST.
		  response ]
]

{ #category : #handler }
RideRouter >> handleHTMLOnDELETEFor: routeName [

	^ self getBasicHandlerDo: [ 
		  (RideCurrentSession value presenterForRoute: routeName)
			  htmlOnDELETE ]
]

{ #category : #handler }
RideRouter >> handleHTMLOnGETFor: routeName [

	| response presenter content |
	^ self getBasicHandlerDo: [ 
		  response := TeaResponse ok.
		  presenter := RideCurrentSession value presenterForRoute: routeName.
		  content := (RideCurrentRequest value headers includesKey:
			              'X-Ride-AJAX')
			             ifTrue: [ presenter htmlOnGET ]
			             ifFalse: [ presenter htmlPageOnGET ].
		  response body: content.
		  response ]
]

{ #category : #handler }
RideRouter >> handleHTMLOnGETFor: routeName with: someMustacheTemplates [

	| response presenter content |
	^ self getBasicHandlerDo: [ 
		  response := TeaResponse ok.
		  presenter := RideCurrentSession value presenterForRoute:
			                routeName.
		  content := (RideCurrentRequest value headers includesKey:
			              'X-Ride-AJAX')
			             ifTrue: [ presenter htmlOnGET ]
			             ifFalse: [ presenter htmlPageOnGET ].
		  response body: content.
		  response ]
]

{ #category : #handler }
RideRouter >> handleHTMLOnPATCHFor: routeName [

	^ self getBasicHandlerDo: [ 
		  (RideCurrentSession value presenterForRoute: routeName)
			  htmlOnPATCH ]
]

{ #category : #handler }
RideRouter >> handleHTMLOnPATCHFor: routeName with: someMustacheTemplates [

	^ self getBasicHandlerDo: [ 
		  (RideCurrentSession value presenterForRoute: routeName)
			  htmlOnPATCH ]
]

{ #category : #handler }
RideRouter >> handleHTMLOnPOSTFor: routeName [

	^ self getBasicHandlerDo: [ 
		  (RideCurrentSession value presenterForRoute: routeName) htmlOnPOST ]
]

{ #category : #handler }
RideRouter >> handleHTMLOnPOSTFor: routeName with: someMustacheTemplates [

	^ self getBasicHandlerDo: [ 
		  (RideCurrentSession value presenterForRoute: routeName)
			  htmlOnPOST ]
]

{ #category : #handler }
RideRouter >> handleHTMLOnPUTFor: routeName [

	^ self getBasicHandlerDo: [ 
		  (RideCurrentSession value presenterForRoute: routeName) htmlOnPUT ]
]

{ #category : #handler }
RideRouter >> handleHTMLOnPUTFor: routeName with: someMustacheTemplates [

	^ self getBasicHandlerDo: [ 
		  (RideCurrentSession value presenterForRoute: routeName) htmlOnPUT ]
]

{ #category : #testing }
RideRouter >> hasPresenterForRoute: aString [

	"Answers true if Ride finds a presenter defined for the given route.
	The convention in Ride is that views/ subdirectories are:
	1. routes and
	2. their name defines the main view and other views of its presenter."

	^ Ride service locator templates views keys includes: aString
]

{ #category : #initialization }
RideRouter >> initializeRootPresenterGetter [

	^ rootPresenterGetter := [ :session | 
	                          | presenter |
	                          presenter := session rootPresenter.
	                          presenter
		                          ifNil: [ 
		                          WelcomePresenter on: Welcome new ]
		                          ifNotNil: [ presenter ] ]
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
		                   RideSession
			                   newWith: sessionId
			                   on: WelcomePresenter new ] ]
]

{ #category : #actions }
RideRouter >> newSessionCookieFor: sessionId [

	^ ZnCookie
		  fromString: (self sessionCookiePathFor: sessionId)
		  for: ('http://' , self getDomain) asZnUrl
]

{ #category : #accessing }
RideRouter >> rootPresenterGetter [

	^ rootPresenterGetter ifNil: [ self initializeRootPresenterGetter ]
]

{ #category : #accessing }
RideRouter >> rootPresenterGetter: anObject [

	rootPresenterGetter := anObject
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
RideRouter >> setPublicRouteOn: aRideServer [

	"Sets the default handler for the home route."

	aRideServer teapot staticRouter delegate:
		RideStaticFileServerDelegate new.
	aRideServer teapot staticRouter
		urlPrefix: self class publicPathString
		path: self class publicDirectory
]

{ #category : #actions }
RideRouter >> setRoute: routeName with: someMustacheTemplates on: aRideServer [

	someMustacheTemplates keysAndValuesDo: [ :route :mustacheTemplate | 
		self basicSetRoute: routeName with: mustacheTemplate on: aRideServer ]
]

{ #category : #actions }
RideRouter >> setRoutesOn: aRideServer [

	"RideRouter policy will be like this:	
	1. Use the views/ directory and use each subdirectory 
	name as snake_case and those are the default routes.
	2. Set one route that is going to define who's 
	the presenter and template. 
	Usually this would happen with the rootPresenter showHtml method."

	self setPublicRouteOn: aRideServer.
	
	Ride service locate viewTemplates keysAndValuesDo: [ :key :value | 
		self setRoute: key with: value on: aRideServer ].

	self setHomeRouteOn: aRideServer.
]

{ #category : #accessing }
RideRouter >> uploadsBaseDirectory [

	^ self class uploadsBaseDirectory
]
