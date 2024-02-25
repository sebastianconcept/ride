"
I represent a Ride user session.
I can help with reaching the models that are needed for that user during my lifetime.
"
Class {
	#name : #RideSession,
	#superclass : #Object,
	#instVars : [
		'id',
		'webSocket',
		'cache',
		'values',
		'authenticityTokens',
		'cookie'
	],
	#classInstVars : [
		'authenticityTokenGenerator'
	],
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideSession class >> authenticityTokenGenerator [

	^ authenticityTokenGenerator := UUIDGenerator new
]

{ #category : #actions }
RideSession class >> cookieName [
	"Answers the session cookie name."

	^ self name asString
]

{ #category : #actions }
RideSession class >> newSessionCookieExpiring: aDateAndTime [

	| domain expires cookieString |
	domain := Ride service server router domain.
	expires := ZnUtils httpDate: aDateAndTime.
	cookieString := '{1}=invalid; expires={2}; path=/; domain={3}' format: {
			                Ride service sessionClass cookieName.
			                expires.
			                domain }.

	^ ZnCookie fromString: cookieString for: ('http://' , domain) asZnUrl
]

{ #category : #actions }
RideSession class >> newSessionCookieId: anId expiring: aDateAndTime [

	| domain expires cookieString |
	domain := Ride service server router domain.
	expires := ZnUtils httpDate: aDateAndTime.
	cookieString := '{1}={2}; expires={3}; path=/; domain={4}' format: {
			                Ride service sessionClass cookieName.
			                anId.
			                expires.
			                domain }.

	^ ZnCookie fromString: cookieString for: ('http://' , domain) asZnUrl
]

{ #category : #'instance creation' }
RideSession class >> newWith: anId request: aRequest [

	^ self new initializeWith: anId request: aRequest
]

{ #category : #actions }
RideSession class >> nextAuthenticityTokenValue [

	^ self authenticityTokenGenerator next asString36
]

{ #category : #actions }
RideSession class >> reset [

	authenticityTokenGenerator := nil
]

{ #category : #accessing }
RideSession class >> sessionDuration [

	^ (Smalltalk os environment
		   at: #SESSION_DURATION
		   ifAbsent: [ 20 years asSeconds ]) asInteger seconds
]

{ #category : #accessing }
RideSession >> authenticityTokens [

	^ authenticityTokens ifNil: [ self initializeAuthenticityTokens ]
]

{ #category : #accessing }
RideSession >> cache [

	^ cache ifNil: [ self initializeCache ]
]

{ #category : #accessing }
RideSession >> cache: anObject [

	cache := anObject
]

{ #category : #testing }
RideSession >> hasAuth [

	^ self values includesKey: #auth
]

{ #category : #testing }
RideSession >> hasWebSocket [

	^ webSocket notNil
]

{ #category : #accessing }
RideSession >> id [

	^ id
]

{ #category : #accessing }
RideSession >> id: anObject [

	id := anObject
]

{ #category : #accessing }
RideSession >> initialUrl [

	^ self values at: #initialUrl ifAbsent: [ nil ]
]

{ #category : #accessing }
RideSession >> initialUrl: anUrl [

	| excluded |
	excluded := #( 'sign-in' 'sign-out' ).

	(anUrl segments notNil and: [ 
		 anUrl segments size > 0 and: [ 
			 [ 'initial URL ' , anUrl asString ] logDebug.
			 (excluded includes: anUrl segments first) not ] ]) ifTrue: [ 
		[ 'Setting initial URL: ' , anUrl asString , ' in ' , self id ]
			logDebug.
		self values at: #initialUrl put: anUrl ]
]

{ #category : #initialization }
RideSession >> initializeAuthenticityTokens [

	^ authenticityTokens := TTLCache new beThreadSafe
]

{ #category : #initialization }
RideSession >> initializeCache [

	^ cache := TTLCache new beThreadSafe
]

{ #category : #initialization }
RideSession >> initializeCookieUsing: aRequest [

	| newCookie |

	newCookie := [
	             self class
		             newSessionCookieId:
		             self class nextAuthenticityTokenValue
		             expiring: DateAndTime now + self class sessionDuration ].

	^ cookie := aRequest cookies
		            detect: [ :e | e name = self class cookieName ]
		            ifNone: [ newCookie value ]
]

{ #category : #initialization }
RideSession >> initializeValues [

	^ values := SmallDictionary new
]

{ #category : #initialization }
RideSession >> initializeWith: anId request: aRequest [

	super initialize.

	id := anId.
	self initializeCookieUsing: aRequest.
	self initializeCache.
	self initializeAuthenticityTokens.
	self initialUrl: aRequest url
]

{ #category : #actions }
RideSession >> invalidate [

	self invalidateAndRedirectTo: '/'
]

{ #category : #actions }
RideSession >> invalidateAndRedirectTo: url [

	| response |
	Ride service invalidateSessionId: self id.
	response := RideCurrentResponse value.

	"Reset the session cookie"
	response headers
		at: 'Set-Cookie'
		put:
			(self class newSessionCookieExpiring: DateAndTime now - 10 years)
				fullString.

	"and redirect"
	response
		code: 302;
		location: url.
	(TeaAbort response: response) signal
]

{ #category : #actions }
RideSession >> newAuthToken [
	"Adds a new auth token.
	The authenticity tokens are stored by value with its own TTL
	so request can be considered unauthorized when a request doesn't
	include an existing one for this session."

	| value |
	value := self class nextAuthenticityTokenValue.
	^ authenticityTokens at: value ifAbsentPut: [ value ]
]

{ #category : #actions }
RideSession >> newUUIDAsString36 [

	^ UUID new asString36
]

{ #category : #handlers }
RideSession >> onWebSocketMessage: aJsonObject [

	
]

{ #category : #actions }
RideSession >> remove: routeKey [

	^ self presenters removeKey: routeKey ifAbsent: [ nil ]
]

{ #category : #accessing }
RideSession >> sessionCookie [

	^ cookie 
]

{ #category : #accessing }
RideSession >> values [

	^ values ifNil: [ self initializeValues ]
]

{ #category : #accessing }
RideSession >> webSocket [

	^ webSocket
]

{ #category : #accessing }
RideSession >> webSocket: aWebSocket [

	webSocket ifNotNil: [ 
		webSocket isConnected ifTrue: [ webSocket close ] ].
	webSocket := aWebSocket
]
