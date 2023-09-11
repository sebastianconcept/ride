"
I'm orchestrating the HTTP server for this Ride web application.
"
Class {
	#name : #RideServer,
	#superclass : #Object,
	#instVars : [
		'teapot',
		'validator',
		'maitre'
	],
	#category : #'Ride-REST'
}

{ #category : #versions }
RideServer class >> bind [

	^ OSEnvironment current
		  at: #BIND
		  ifAbsent: [ self defaultBind ]
]

{ #category : #versions }
RideServer class >> databaseName [

	^ OSEnvironment current
		  at: #DB_NAME
		  ifAbsent: [ self defaultDatabaseName ]
]

{ #category : #versions }
RideServer class >> debugMode [

	^ (OSEnvironment current
		  at: #HTTP_DEBUG
		  ifAbsent: [ self defaultDebugMode ]) asInteger > 0
]

{ #category : #versions }
RideServer class >> defaultBind [
	^ '0.0.0.0'
]

{ #category : #versions }
RideServer class >> defaultDatabaseName [

	^ self subclassResponsibility
]

{ #category : #versions }
RideServer class >> defaultDebugMode [

	^ 0
]

{ #category : #versions }
RideServer class >> defaultPort [
	^ 3004
]

{ #category : #versions }
RideServer class >> port [

	^ (OSEnvironment current
		  at: #PORT
		  ifAbsent: [ self defaultPort ]) asInteger
]

{ #category : #versions }
RideServer class >> version [

	^ '1.0.1'
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

{ #category : #accessing }
RideServer >> maitre [

	^ maitre
]

{ #category : #accessing }
RideServer >> maitre: aMaitre [

	maitre := aMaitre
]

{ #category : #actions }
RideServer >> newHttpServer [

	| newServer |
	newServer := Teapot configure: { 
			             (#defaultOutput -> #json).
			             (#port -> self class port).
			             (#debugMode -> self class debugMode).
			             (#bindAddress
			              -> (NetNameResolver addressForName: self class bind)) }.
	((newServer instVarNamed: 'compositeRouter') instVarNamed:
		 'errorhandlers') removeLast.
	^ newServer
]

{ #category : #actions }
RideServer >> renderHtml404On: aRideNotFoundError [

	self halt
]

{ #category : #actions }
RideServer >> renderHtml500On: anError [

	^ anError descriptionModel
]

{ #category : #accessing }
RideServer >> reset [

	teapot ifNotNil: [ 
		| released |
		released := teapot.
		teapot := nil.
		released stop ].

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
RideServer >> setRoutes [

	Ride service router setRoutesOn: self
]

{ #category : #accessing }
RideServer >> start [

	self setRoutes.
	self setFilters.
	self setExceptionHandlers.
	self teapot start.
	Ride log: ('Teapot started at http server at {1}:{2}' format: { 
				 self class bind printString.
				 self class port asString })
]

{ #category : #accessing }
RideServer >> stop [

	Ride log: 'Stoping Teapot...'.
	teapot ifNotNil: [ teapot stop ].
	self reset
]

{ #category : #accessing }
RideServer >> teapot [

	^ teapot ifNil: [ self initializeTeapot ]
]
