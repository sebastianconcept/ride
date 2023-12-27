"
I'm orchestrating the HTTP server for this Ride web application.

See setRoutes comments to understand my default convention.

Applications might be interested in subclassing me and implement their own custom:
- setFilters
- setRoutes

In relation to the filter for maintainance mode, it counts with the right HTTP server configuration in order to work well. See nginxExample class method for the boilerplate.


"
Class {
	#name : #RideServer,
	#superclass : #Object,
	#instVars : [
		'settings',
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
RideServer class >> defaultMAXAGE [

	^ Smalltalk os environment at: 'MAXAGE' ifAbsent: [ 60 * 60 ]
]

{ #category : #accessing }
RideServer class >> defaultSMAXAGE [

	^ Smalltalk os environment at: 'SMAXAGE' ifAbsent: [ 120 * 60 ] "for the CDN"
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
RideServer class >> nginxConfExample [

	^ '# Access to the Pharo http service with the app
upstream yourapp_backend {
    server 127.0.0.1:3004;
}

# Access to REPLEndpoint for maintainance
upstream repl {
    server 127.0.0.1:4045;
}

# Basic http configuration rewriting all requests to https
server {
    listen 80;
    server_name yourapp.local.com;
    rewrite ^(.*) https://yourapp.local.com$1 permanent;
}

# Settings for the service using https
server {
    listen               443 ssl;

    # Setup your trusted certificates
    # Ref: https://www.freecodecamp.org/news/how-to-get-https-working-on-your-local-development-environment-in-5-minutes-7af615770eec
    ssl_certificate       /path/to/your/project/ssl/yourapp.local.com.crt;
    ssl_certificate_key  /path/to/your/project/ssl/yourapp.local.com.key;

    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;

    server_name          yourapp.local.com;

    # Default public dir to search for content
    root /path/to/your/project/yourapp/public;

    # Proxy to your REPL endpoint
    location /repl {
        proxy_pass http://repl;
    }

    # Serving your app assets dir
    location /assets/ {
        alias /path/to/your/project/yourapp/app/assets;
    }

    # Setup main route to serve from the root or 
    # Default public dir to search for content or @yourapp when is not found
    location / {
        try_files $uri @yourapp;
    }

    # Setup how to proxy to your app accessible at yourapp_backend
    location @yourapp {
        add_header Strict-Transport-Security "max-age=63072000; includeSubdomains" always;
        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;
        add_header Cross-Origin-Opener-Policy same-origin-allow-popups always;

        # Preflighted requests
        if ($request_method = OPTIONS ) {
            add_header "Access-Control-Allow-Origin" "*";
            add_header "Access-Control-Allow-Methods" "GET, PUT, PATCH, POST, OPTIONS, HEAD, DELETE";
            add_header "Access-Control-Allow-Headers" "Authorization, Origin, X-Requested-With, Content-Type, Accept, Range";
            return 200;
        }
     
        # All supported requests
        if ($request_method ~* "(GET|POST|PUT|PATCH|DELETE)") {
            add_header "Access-Control-Allow-Headers" "Authorization, Origin, X-Requested-With, Content-Type, Accept, Range";
        }

        # set client body size to 10 MB #
        client_max_body_size 10M;

        proxy_pass  http://yourapp_backend;
    }
}'
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

{ #category : #actions }
RideServer >> htmlMaintenancePage [

	| templateModel maintenanceTemplate |
	templateModel := {  } asDictionary.
	maintenanceTemplate := Ride service locate sharedTemplates at:
		                       #maintenance.
	(Smalltalk os environment at: #MW_TITLE ifAbsent: [ nil ]) ifNotNil: [ 
		:string | templateModel at: #title put: string ].
	(Smalltalk os environment at: #MW_DETAILS ifAbsent: [ nil ]) 
		ifNotNil: [ :string | templateModel at: #details put: string ].
	(Smalltalk os environment at: #MW_NOTES ifAbsent: [ nil ]) ifNotNil: [ 
		:string | templateModel at: #notes put: string ].
	^ maintenanceTemplate
		  value: templateModel
		  partials: Ride service locate sharedTemplates
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
RideServer >> initializeSettings [

	^ settings := Dictionary new
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
	maxage := self settings
		          at: 'MAXAGE'
		          ifAbsentPut: [ self class defaultMAXAGE ]. "for the browser"
	smaxage := self settings
		           at: 'SMAXAGE'
		           ifAbsentPut: [ self class defaultSMAXAGE ]. "for the CDN"
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

	self teapot
		exception: RideMaintenanceException -> [ :ex :req | 
				response := TeaResponse ok.
				origin := req headers at: 'origin' ifAbsent: [ '*' ].
				response body: self htmlMaintenancePage.
				response headers
					at: 'Access-Control-Allow-Credentials' put: 'true';
					at: 'Access-Control-Allow-Origin' put: origin;
					yourself.
				response ];
		output: #html.

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
				| templateModel |
				response := TeaResponse notFound.
				Ride log: ex printString level: #ERROR.
				origin := req headers at: 'origin' ifAbsent: [ '*' ].
				templateModel := Ride service locate sharedTemplates copy
					                 at: #status put: response code asString;
					                 yourself.
				Ride isDevelopment ifTrue: [ 
					templateModel
						at: #error
						put: { (#messageText -> ex messageText) } asDictionary ].
				response body: (ex
						 renderHtmlWith: templateModel
						 on:
						 (Ride service locate sharedTemplates at: response code asString)).
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

	self teapot before: '*' -> [ :request | 
		Ride isMaintenance ifTrue: [ RideMaintenanceException signal ] ]
]

{ #category : #actions }
RideServer >> setRoutes [

	Ride service router setRoutesOn: self
]

{ #category : #accessing }
RideServer >> settings [

	^ settings ifNil: [ self initializeSettings ]
]

{ #category : #accessing }
RideServer >> settings: anObject [

	settings := anObject
]

{ #category : #actions }
RideServer >> start [

	self setFilters.
	self setRoutes.
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
