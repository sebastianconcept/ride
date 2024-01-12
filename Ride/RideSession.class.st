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
		'values'
	],
	#category : #'Ride-Core'
}

{ #category : #'instance creation' }
RideSession class >> newWith: anId url: anUrl [

	^ self new initializeWith: anId url: anUrl
]

{ #category : #actions }
RideSession >> add: routeKey presenter: aRidePresenter [

	^ self presenters at: routeKey put: aRidePresenter
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
RideSession >> initializeCache [

	^ cache := TTLCache new
]

{ #category : #initialization }
RideSession >> initializeValues [

	^ values := SmallDictionary new
]

{ #category : #initialization }
RideSession >> initializeWith: anId url: anUrl [

	super initialize.

	id := anId.
	self initialUrl: anUrl
]

{ #category : #actions }
RideSession >> invalidateAndRedirectTo: url [

	| response |
	Ride service invalidateSession: self.
	response := RideCurrentResponse value.

	"Redirect"
	response
		code: 302;
		location: url.
	(TeaAbort response: response) signal
]

{ #category : #handlers }
RideSession >> onWebSocketMessage: aJsonObject [

	
]

{ #category : #actions }
RideSession >> remove: routeKey [

	^ self presenters removeKey: routeKey ifAbsent: [ nil ]
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
