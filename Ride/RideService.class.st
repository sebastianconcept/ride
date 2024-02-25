"
I'm the abstract parent class of Ride applications. 
Ride serves one application at the time.
My subclasses are those applications main class.
They are responsible for setting up their configuration and setup. 
"
Class {
	#name : #RideService,
	#superclass : #Object,
	#instVars : [
		'server',
		'sessions',
		'maitre',
		'repository',
		'locator',
		'cache',
		'sessionGetter',
		'renderers'
	],
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideService class >> applicationResourceClass [

	self subclassResponsibility
]

{ #category : #accessing }
RideService class >> getSessionGetter [

	^ [ :request |
	  | sessionId |
	  sessionId := self sessionIdFromCookieOrNewFrom: request.
	  Ride service sessions
		  at: sessionId
		  ifAbsentPut: [ self newSessionWith: sessionId request: request ] ]
]

{ #category : #accessing }
RideService class >> install [

	Ride
		service: self new;
		resource: self applicationResourceClass
]

{ #category : #actions }
RideService class >> log: aString [

	Ride log: aString
]

{ #category : #actions }
RideService class >> log: aString level: aSymbol [

	Ride log: aString level: aSymbol
]

{ #category : #actions }
RideService class >> newSessionId [

	^ UUID new asString36
]

{ #category : #actions }
RideService class >> newSessionWith: sessionId request: aRequest [

	^ self sessionClass newWith: sessionId request: aRequest
]

{ #category : #actions }
RideService class >> reset [

	Ride reset
]

{ #category : #actions }
RideService class >> restart [

	Ride stop.
	Smalltalk garbageCollect.
	self install.
	Ride start
]

{ #category : #accessing }
RideService class >> sessionClass [

	^ self subclassResponsibility
]

{ #category : #accessing }
RideService class >> sessionIdFromCookieOrNewFrom: aRequest [
	"Answers the session ID taken from the cookie of the given aRequest.
	Answers a new one if the cookie is absent "

	| cookieName |
	cookieName := Ride service sessionClass cookieName.

	^ (aRequest cookies
		   detect: [ :each | each name = cookieName ]
		   ifNone: [ ^ self newSessionId ]) value
]

{ #category : #actions }
RideService class >> setUp [

	"Customizations before starting the service."

	Ride service
		sessionGetter: self getSessionGetter;
		yourself.

	self log: 'Router setup...'
]

{ #category : #actions }
RideService class >> start [

	Ride start
]

{ #category : #actions }
RideService class >> stop [

	Ride stop
]

{ #category : #accessing }
RideService class >> templatesSelector [

	^ #stt
]

{ #category : #accessing }
RideService >> cache [

	^ cache ifNil: [ self initializeCache ]
]

{ #category : #accessing }
RideService >> cache: aCache [

	cache := aCache
]

{ #category : #actions }
RideService >> databaseStart [

	Ride log: 'Database starting...'.
	self repository databaseStartOn: self
]

{ #category : #actions }
RideService >> databaseStop [

	repository ifNotNil: [ 
		Ride log: 'Database shutting down...'.
		self repository shutDown ]
]

{ #category : #accessing }
RideService >> getSessionFrom: request [

	^ self sessionGetter value: request
]

{ #category : #initialization }
RideService >> initializeCache [

	^ cache := TTLCache new beThreadSafe
]

{ #category : #initialization }
RideService >> initializeMaitre [

	^ maitre := RideMaitre new
]

{ #category : #initialization }
RideService >> initializeRenderers [

	| createRenderers layoutWrappers |
	createRenderers := [ 
	                   SmallDictionary new
		                   at: #html put: self newHTMLRenderer;
		                   at: #json put: self newJSONRenderer;
		                   at: #stt put: self newSTTRenderer;
		                   at: #mustache put: self newMustacheRenderer;
		                   at: #xml put: self newXMLRenderer;
		                   at: #rss put: self newRSSRenderer;
		                   yourself ].
	layoutWrappers := createRenderers value do: [ :e | e beLayoutWrapper ].
	^ renderers := SmallDictionary new
		               addAll: createRenderers value;
		               at: #layoutWrappers put: layoutWrappers;
		               yourself
]

{ #category : #initialization }
RideService >> initializeRepository [

	^ repository := RideMemoryRepository new
]

{ #category : #initialization }
RideService >> initializeServer [

	^ server := RideServer new
]

{ #category : #initialization }
RideService >> initializeSessions [

	^ sessions := TTLCache new beThreadSafe
]

{ #category : #actions }
RideService >> invalidateSessionId: aRideSessionId [
	"Remove the given session from the cache"

	sessions removeKey: aRideSessionId ifAbsent: [  ]
]

{ #category : #accessing }
RideService >> locator: anObject [

	locator := anObject
]

{ #category : #accessing }
RideService >> maitre [

	^ maitre ifNil: [ self initializeMaitre ]
]

{ #category : #accessing }
RideService >> maitre: anObject [

	maitre := anObject
]

{ #category : #actions }
RideService >> newHTMLRenderer [

	^ RideHTMLRenderer new
]

{ #category : #actions }
RideService >> newJSONRenderer [

	^ RideJSONRenderer new
]

{ #category : #actions }
RideService >> newMustacheRenderer [

	^ RideMustacheRenderer new
]

{ #category : #actions }
RideService >> newRSSRenderer [

	^ RideRSSRenderer new
]

{ #category : #actions }
RideService >> newSTTRenderer [

	^ RideSTTemplateRenderer new
]

{ #category : #accessing }
RideService >> newSessionId [

	^ self class newSessionId
]

{ #category : #actions }
RideService >> newXMLRenderer [

	^ RideXMLRenderer new
]

{ #category : #accessing }
RideService >> renderers [

	^ renderers ifNil: [ self initializeRenderers ]
]

{ #category : #accessing }
RideService >> repository [

	^ repository ifNil: [ self initializeRepository ]
]

{ #category : #accessing }
RideService >> repository: anObject [

	repository := anObject
]

{ #category : #actions }
RideService >> reset [

	server ifNotNil: [ 
		| released |
		released := server.
		server := nil ].
	locator ifNotNil: [ 
		| released |
		released := locator.
		locator := nil ].
	sessions ifNotNil: [ 
		| released |
		released := sessions.
		sessions := nil ]
]

{ #category : #actions }
RideService >> resetRenderers [

	self renderers do: [ :renderer | renderer reset ]
]

{ #category : #actions }
RideService >> restart [

	Ride stop.
	Smalltalk garbageCollect.
	self ~= RideService ifFalse: [ 
		RideError signal:
			'The Ride service should be the one for a concrete Ride-based application' ].
	self install.
	Ride start
]

{ #category : #accessing }
RideService >> server [

	^ server ifNil: [ self initializeServer ]
]

{ #category : #accessing }
RideService >> server: anObject [

	server := anObject
]

{ #category : #accessing }
RideService >> sessionClass [

	^ self class sessionClass
]

{ #category : #accessing }
RideService >> sessionGetter [

	^ sessionGetter ifNil: [ 
		  RideError signal:
			  'This service has not definedd its required session getter' ]
]

{ #category : #accessing }
RideService >> sessionGetter: anObject [

	sessionGetter := anObject
]

{ #category : #accessing }
RideService >> sessions [

	^ sessions ifNil: [ self initializeSessions ]
]

{ #category : #accessing }
RideService >> sessions: anObject [

	sessions := anObject
]

{ #category : #actions }
RideService >> setUp [

	[ '{1} setup...' format: { self class name } ] logInfo.
	self class setUp.

	[ 'Assets setup...' ] logInfo.
	Ride resource assetsSetUp
]

{ #category : #actions }
RideService >> sqlLiteDatabaseStart [

	Ride resource databaseDirectory exists ifFalse: [ 
		RideError signal: ('Database directory not found: {1}' format:
				 { Ride resource databaseDirectory pathString }) ].

	(RideModel allSubclasses reject: #isAbstract) do: [ :each | 
		(self repository hasTableFor: each) ifFalse: [ 
			self repository ensureTableFor: each ] ]
]

{ #category : #actions }
RideService >> start [

	self setUp.

	Ride log: 'Database start...'.
	self databaseStart.	
	Ride log: ('{1} starting...' format: { self class name }).
	self maitre start.
	self server start.
	Ride log: ('{1} {2} started' format: { 
				 self class name.
				 self version })
]

{ #category : #actions }
RideService >> stop [

	Ride log: ('{1} stopping...' format: { self class name }).
	self maitre stop.
	self server stop.
	self databaseStop.
	Ride log: ('{1} stopped' format: { self class name }).
	self reset
]

{ #category : #accessing }
RideService >> templates [

	^ (Ride service renderers at: self class templatesSelector) templates
]

{ #category : #accessing }
RideService >> version [

	^ Smalltalk os environment at: 'VERSION' ifAbsent: [ 'v?.?.?' ]
]
