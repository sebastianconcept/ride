"
I represent a Ride user session.
I can help with reaching the models that are needed for that user during my lifetime.
"
Class {
	#name : #RideSession,
	#superclass : #Object,
	#instVars : [
		'id',
		'presenters'
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
RideSession >> add: routeKey presenter: aRidePresenter [

	^ self presenters at: routeKey put: aRidePresenter
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
RideSession >> initializePresenters [

	^ presenters := Dictionary new
]

{ #category : #initialization }
RideSession >> initializeWith: anId on: aPresenter [

	super initialize.

	id := anId.
	self add: #/ presenter: aPresenter
]

{ #category : #accessing }
RideSession >> locate [

	^ Ride service locate
]

{ #category : #accessing }
RideSession >> presenterForRoute: routeName [

	^ self presenters at: routeName ifAbsentPut: [ 
		  | presenter |
		  presenter := routeName = '/'
			               ifTrue: [ self rootPresenter ]
			               ifFalse: [ self rootPresenter childAt: routeName ].

		  presenter ifNil: [ 
			  RideMissingPresenterError signal:
				  ('{1} not found' format: { routeName }) ].
		  presenter ]
]

{ #category : #accessing }
RideSession >> presenters [

	^ presenters ifNil: [ self initializePresenters ]
]

{ #category : #actions }
RideSession >> remove: routeKey [

	^ self presenters removeKey: routeKey ifAbsent: [ nil ]
]

{ #category : #accessing }
RideSession >> rootPresenter [

	^ self presenters at: #/ ifAbsent: [ nil ]
]
