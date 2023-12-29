"
I represent a Ride user session.
I can help with reaching the models that are needed for that user during my lifetime.
"
Class {
	#name : #RideSession,
	#superclass : #Object,
	#instVars : [
		'id',
		'initialUrl',
		'webSocket',
		'auth',
		'cache'
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
RideSession >> auth [

	^ auth
]

{ #category : #accessing }
RideSession >> auth: anObject [

	auth := anObject
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

	^ auth notNil
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

	^ initialUrl
]

{ #category : #accessing }
RideSession >> initialUrl: anUrl [

	| excluded |
	excluded := #( 'sign-in' 'sign-out' ).

	(anUrl segments size > 0 and: [ 
		 Ride log: 'initial URL ' , anUrl asString.
		 (excluded includes: anUrl segments first) not ]) ifTrue: [ 
		Ride log:
			'Setting initial URL: ' , anUrl asString , ' in ' , self id.
		initialUrl := anUrl ]
]

{ #category : #initialization }
RideSession >> initializeCache [

	^ cache := TTLCache new
]

{ #category : #initialization }
RideSession >> initializeWith: anId url: anUrl [

	super initialize.

	id := anId.
	self initialUrl: anUrl
]

{ #category : #accessing }
RideSession >> locate [

	^ Ride service locate
]

{ #category : #handlers }
RideSession >> onWebSocketMessage: aJsonObject [

	
]

{ #category : #actions }
RideSession >> remove: routeKey [

	^ self presenters removeKey: routeKey ifAbsent: [ nil ]
]

{ #category : #accessing }
RideSession >> rootPresenter [

	^ self presenters at: #/ ifAbsent: [ nil ]
]

{ #category : #actions }
RideSession >> signOut [

	auth := nil
]

{ #category : #actions }
RideSession >> signOutAndRedirectTo: url [

	auth := nil.
	Ride service invalidateSession: self.
	(TeaAbort response: (TeaResponse redirect location: url)) signal
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
