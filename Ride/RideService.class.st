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
		'router',
		'sessions',
		'maitre',
		'repository',
		'locator'
	],
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideService class >> getSessionGetter [

	^ [ :request | 
	  | sessionId |
	  sessionId := self sessionIdFromCookieOrNewFrom: request.
	  Ride service sessions
		  at: sessionId
		  ifAbsentPut: [ self newSessionWith: sessionId ] ]
]

{ #category : #accessing }
RideService class >> install [

	Ride service: self new
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

{ #category : #accessing }
RideService class >> rootPresenterClass [

	self subclassResponsibility
]

{ #category : #accessing }
RideService class >> sessionIdFromCookieOrNewFrom: aRequest [

	"Answers the session ID taken from the cookie of the given aRequest.
	Answers a new one if the cookie is absent "

	^ (aRequest cookies
		   detect: [ :each | each name = 'id' ]
		   ifNone: [ ^ self newSessionId ]) value
]

{ #category : #actions }
RideService class >> setUp [

	"Customizations before starting the service."

	self log: 'Router setup...'.
	Ride service router
		sessionGetter: self getSessionGetter;
		yourself
]

{ #category : #initialization }
RideService >> initializeLocator [

	^ locator := RideViewPresenterLocator new
]

{ #category : #initialization }
RideService >> initializeMaitre [

	^ maitre := RideMaitre new
]

{ #category : #initialization }
RideService >> initializeRepository [

	^ repository := RideMemoryRepository new
]

{ #category : #initialization }
RideService >> initializeRouter [

	^ router := RideRouter new
]

{ #category : #initialization }
RideService >> initializeServer [

	^ server := RideServer new
]

{ #category : #initialization }
RideService >> initializeSessions [

	^ sessions := TTLCache new
]

{ #category : #accessing }
RideService >> locate [

	"Syntax sugar for delegating to the views and templates locator"

	^ self locator
]

{ #category : #accessing }
RideService >> locator [

	^ locator ifNil: [ self initializeLocator ]
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

{ #category : #accessing }
RideService >> newSessionId [

	^ self class newSessionId
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
	router ifNotNil: [ 
		| released |
		released := router.
		router := nil ].
	locator ifNotNil: [ 
		| released |
		released := locator.
		locator := nil ].
	sessions ifNotNil: [ 
		| released |
		released := sessions.
		sessions := nil ]
]

{ #category : #accessing }
RideService >> router [

	^ router ifNil: [ self initializeRouter ]
]

{ #category : #accessing }
RideService >> router: anObject [

	router := anObject
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
RideService >> sessions [

	^ sessions ifNil: [ self initializeSessions ]
]

{ #category : #accessing }
RideService >> sessions: anObject [

	sessions := anObject
]

{ #category : #actions }
RideService >> setUp [

	Ride log: ('{1} setup...' format: { self class name }).
	self class setUp
]

{ #category : #actions }
RideService >> start [
	self setUp.
	Ride log: ('{1} starting...' format: { self class name }).
	self maitre start.
	self server start.
	Ride log: ('{1} started' format: { self class name }).
]

{ #category : #actions }
RideService >> stop [

	Ride log: ('{1} stopping...' format: { self class name }).
	self maitre stop.
	self server stop.
	Ride log: ('{1} stopped' format: { self class name }).
	self reset
]
