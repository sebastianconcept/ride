"
I represent a Ride user session.
I can help with reaching the models that are needed for that user during my lifetime.
"
Class {
	#name : #RideSession,
	#superclass : #Object,
	#instVars : [
		'id',
		'controllers'
	],
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideSession class >> defaultController [

	^ nil
]

{ #category : #'instance creation' }
RideSession class >> newWith: anId [

	^ self newWith: anId on: self defaultController
]

{ #category : #'instance creation' }
RideSession class >> newWith: anId on: aController [

	^ self new initializeWith: anId on: aController
]

{ #category : #actions }
RideSession >> add: routeKey controller: aRideController [

	^ self controllers at: routeKey put: aRideController
]

{ #category : #accessing }
RideSession >> controllerForRoute: routeName [

	^ self controllers at: routeName ifAbsentPut: [ 
		  | controller |
		  controller := self rootController children at: routeName.
		  controller ifNil: [ 
			  RideMissingControllerError signal:
				  ('{1} not found' format: { routeName }) ].
		  controller ]
]

{ #category : #accessing }
RideSession >> controllers [

	^ controllers ifNil: [ self initializeControllers ]
]

{ #category : #initialization }
RideSession >> htmlPageOnGET [

self halt.
]

{ #category : #accessing }
RideSession >> id [

	^ id
]

{ #category : #accessing }
RideSession >> id: anObject [

	id := anObject
]

{ #category : #initialization }
RideSession >> initialize [

	super initialize.

	"The minimal thing to do for the session of the app: add the root controller"
	"self
		add: #/
		controller: (Ride service router rootControllerGetter value: self)"
]

{ #category : #initialization }
RideSession >> initializeControllers [

	^ controllers := Dictionary new
]

{ #category : #initialization }
RideSession >> initializeWith: anId on: aController [

	super initialize.

	id := anId.
	self add: #/ controller: aController
]

{ #category : #accessing }
RideSession >> locate [

	^ Ride service locate
]

{ #category : #actions }
RideSession >> remove: routeKey [

	^ self controllers removeKey: routeKey ifAbsent: [ nil ]
]

{ #category : #accessing }
RideSession >> rootController [

	^ self controllers at: #/ ifAbsent: [ nil ]
]
