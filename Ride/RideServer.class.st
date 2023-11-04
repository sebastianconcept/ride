"
I'm orchestrating the HTTP server for this Ride web application.

See setRoutes comments to understand my default convention.

Applications might be interested in subclassing me and implement their own custom:
- setFilters
- setRoutes

"
Class {
	#name : #RideServer,
	#superclass : #Object,
	#instVars : [
		'teapot',
		'validator',
		'maitre',
		'webSocket',
		'webSocketReferences'
	],
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideServer class >> databaseName [

	^ OSEnvironment current
		  at: #DB_NAME
		  ifAbsent: [ self defaultDatabaseName ]
]

{ #category : #accessing }
RideServer class >> debugMode [

	^ (OSEnvironment current
		  at: #HTTP_DEBUG
		  ifAbsent: [ self defaultDebugMode ]) asInteger > 0
]

{ #category : #accessing }
RideServer class >> defaultDatabaseName [

	^ self subclassResponsibility
]

{ #category : #accessing }
RideServer class >> defaultDebugMode [

	^ 0
]

{ #category : #accessing }
RideServer class >> defaultHttpBind [
	^ '0.0.0.0'
]

{ #category : #accessing }
RideServer class >> defaultHttpPort [
	^ 3004
]

{ #category : #accessing }
RideServer class >> defaultWebSocketPort [
	^ 3008
]

{ #category : #testing }
RideServer class >> hasWebSocket [

	^ (OSEnvironment current at: #WEB_SOCKET_PORT ifAbsent: [ 0 ])
		  asInteger > 0
]

{ #category : #accessing }
RideServer class >> httpBind [

	^ OSEnvironment current
		  at: #HTTP_BIND
		  ifAbsent: [ self defaultHttpBind ]
]

{ #category : #accessing }
RideServer class >> httpPort [

	^ (OSEnvironment current
		  at: #HTTP_PORT
		  ifAbsent: [ self defaultHttpPort ]) asInteger
]

{ #category : #accessing }
RideServer class >> version [

	^ '1.0.1'
]

{ #category : #accessing }
RideServer class >> webSockerPort [

	^ (OSEnvironment current
		  at: #WEB_SOCKET_PORT
		  ifAbsent: [ self defaultWebSocketPort ]) asInteger
]

{ #category : #accessing }
RideServer >> debugMode [

	^ self class debugMode
]

{ #category : #initialization }
RideServer >> initialize [

	super initialize.
	RidePolyglot
		reset;
		loadLanguages.
	validator := RideValidator new
]

{ #category : #initialization }
RideServer >> initializeTeapot [

	^ teapot := self newHttpServer
]

{ #category : #initialization }
RideServer >> initializeWebSocket [

	^ webSocket := self newWebSocketServer
]

{ #category : #initialization }
RideServer >> isProtectedUrl: req [

	^ self unprotectedPaths noneSatisfy: [ :path | 
		  ('*{1}' format: { path }) match: req url path ]
]

{ #category : #initialization }
RideServer >> languageCodeFrom: request [

	"Answers the first ISO 639-1 standard code or 'en' if none was set."

	| acceptLanguage code |
	acceptLanguage := request headers
		                  at: 'Accept-Language'
		                  ifAbsent: [ 'en' ].
	code := acceptLanguage readStream upTo: $,.
	^ code
]

{ #category : #actions }
RideServer >> newHttpServer [

	| newServer |
	newServer := Teapot configure: { 
			             (#defaultOutput -> #json).
			             (#port -> self class httpPort).
			             (#debugMode -> self class debugMode).
			             (#bindAddress
			              -> (NetNameResolver addressForName: self class httpBind)) }.
	((newServer instVarNamed: 'compositeRouter') instVarNamed:
		 'errorhandlers') removeLast.
	^ newServer
]

{ #category : #actions }
RideServer >> newWebSocketServer [

	| newServer |
	newServer := (ZnServer startOn: self class webSockerPort)
		             delegate:
			             (RideWebSocketDelegate handler: [ :ws | 
					              self onWebSocketConnected: ws ]);
		             yourself.

	^ newServer
]

{ #category : #reactions }
RideServer >> onWebSocketClosed: aWebSocket [

	"Clean any related references."

	"webSocketReferences removeKey: aWebSocket ifAbsent: [ nil ]"
]

{ #category : #reactions }
RideServer >> onWebSocketConnected: aWebSocket [

	| session |
	session := Ride service router getSessionFrom:
		           RideCurrentRequest value.
	Ride log: 'onWebSocketConnected id: ' , session id.
	session webSocket: aWebSocket.
	^ self
		  run: aWebSocket
		  with: [ :message | self onWebSocketMessage: message for: session ]
]

{ #category : #reactions }
RideServer >> onWebSocketMessage: message for: aRideSession [

	Ride log: 'onMessage' , message asString level: #DEBUG.
	aRideSession onWebSocketMessage: (Json readFrom: message readStream)
]

{ #category : #actions }
RideServer >> renderHtml404On: aRideNotFoundError [

	self halt
]

{ #category : #actions }
RideServer >> renderHtml500On: anError [

	^ anError descriptionModel
]

{ #category : #actions }
RideServer >> reset [

	webSocket ifNotNil: [ 
		| released |
		released := webSocket.
		webSocket := nil.
		released stop ].

	teapot ifNotNil: [ 
		| released |
		released := teapot.
		teapot := nil.
		released stop ]
]

{ #category : #actions }
RideServer >> run: aWebSocket with: aBlock [
	^ [ [ | message |
	message := nil.
	[ aWebSocket isConnected
		ifTrue: [ message := aWebSocket readMessage ]
		ifFalse: [ ConnectionClosed signal ] ]
		on: ConnectionTimedOut
		do: [ "Ignore & continue" aWebSocket ping ].
	message ifNotNil: [ aBlock value: message ] ] repeat ]
		on: ConnectionClosed
		do: [ :x | self onWebSocketClosed: aWebSocket ]
]

{ #category : #actions }
RideServer >> setAccessControlAllowOriginFilter [

	| origin |
	self teapot after: '/*' -> [ :req :resp | 
		origin := req headers at: 'origin' ifAbsent: [ '*' ].
		resp headers at: 'Access-Control-Allow-Origin' put: origin ]
]

{ #category : #actions }
RideServer >> setCacheControlFilter [

	| maxage smaxage |
	maxage := OSEnvironment current at: 'MAXAGE' ifAbsent: [ 60 * 60 ]. "for the browser"
	smaxage := OSEnvironment current at: 'SMAXAGE' ifAbsent: [ 120 * 60 ]. "for the CDN"
	self teapot
		after: '/*' -> [ :req :resp | 
				resp headers
					at: 'Cache-Control'
					put:
						'max-age=' , maxage asString , 's-maxage=' , smaxage asString;
					yourself ];
		yourself
]

{ #category : #actions }
RideServer >> setExceptionHandlers [

	| origin response |
	self teapot exception: TeaAbort -> [ :abort :req | 
		origin := req headers at: 'origin' ifAbsent: [ '*' ].

		abort response headers
			at: 'Access-Control-Allow-Credentials' put: 'true';
			at: 'Access-Control-Allow-Origin' put: origin;
			yourself.
		abort response teaTransform: [ :same | same ] request: req ].

	self teapot exception: RideValidationError -> [ :ex :req | 
		response := TeaResponse badRequest.
		origin := req headers at: 'origin' ifAbsent: [ '*' ].
		response body: (ex describeOn:
				 { (#status -> response code) } asDictionary asJsonObject).
		response headers
			at: 'Access-Control-Allow-Credentials' put: 'true';
			at: 'Access-Control-Allow-Origin' put: origin;
			yourself.
		response ].

	self teapot
		exception: RideNotFoundError -> [ :ex :req | 
				response := TeaResponse notFound.
				Ride log: ex printString level: #ERROR.
				origin := req headers at: 'origin' ifAbsent: [ '*' ].
				response body: (ex
							 renderHtmlWith:
								 { (#status -> response code) } asDictionary asJsonObject
							 on:
								 (Ride service locate sharedTemplates at:
										  response code asString)).
				response headers
					at: 'Access-Control-Allow-Credentials' put: 'true';
					at: 'Access-Control-Allow-Origin' put: origin;
					yourself.
				response ];
		output: #html.

	self teapot
		exception: Error -> [ :ex :req | 
				response := TeaResponse serverError.
				Ride log: ex printString level: #ERROR.
				origin := req headers at: 'origin' ifAbsent: [ '*' ].

				response body: (ex
							 renderHtmlWith:
								 { (#status -> response code) } asDictionary asJsonObject
							 on:
								 (Ride service locate sharedTemplates at:
										  response code asString)).
				response headers
					at: 'Access-Control-Allow-Credentials' put: 'true';
					at: 'Access-Control-Allow-Origin' put: origin;
					yourself.
				response ];
		output: #html
]

{ #category : #actions }
RideServer >> setFilters [

	"Nothing to add"
]

{ #category : #actions }
RideServer >> setRoutes [

	Ride service router setRoutesOn: self
]

{ #category : #actions }
RideServer >> start [

	self setRoutes.
	self setFilters.
	self setExceptionHandlers.
	self class hasWebSocket ifTrue: [ 
		self webSocket start.
		Ride log: ('WebSocket started at {1}:{2}' format: { 
					 self class httpBind printString.
					 self class webSockerPort asString }) ].
	self teapot start.
	Ride log: ('Teapot started with http server at {1}:{2}' format: { 
				 self class httpBind printString.
				 self class httpPort asString })
]

{ #category : #actions }
RideServer >> stop [

	webSocket ifNotNil: [ 
		Ride log: 'Stoping WebSocket...'.
		webSocket stop ].
	Ride log: 'Stoping Teapot...'.
	teapot ifNotNil: [ teapot stop ].

	self reset
]

{ #category : #accessing }
RideServer >> teapot [

	^ teapot ifNil: [ self initializeTeapot ]
]

{ #category : #accessing }
RideServer >> webSocket [

	^ webSocket ifNil: [ self initializeWebSocket ]
]
