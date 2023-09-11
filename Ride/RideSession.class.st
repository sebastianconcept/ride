"
I represent a Ride user session.
I can help with reaching the models that are needed for that user during my lifetime.
"
Class {
	#name : #RideSession,
	#superclass : #Object,
	#instVars : [
		'id',
		'rootModel',
		'rootController'
	],
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideSession class >> defaultModel [

	^ nil
]

{ #category : #'instance creation' }
RideSession class >> newWith: anId [

	^ self newWith: anId on: self defaultModel
]

{ #category : #'instance creation' }
RideSession class >> newWith: anId on: aModel [

	^ self new initializeWith: anId on: aModel
]

{ #category : #accessing }
RideSession >> getModelFor: aController [

	"Answers the model meant to be used with the given controller."

	^ rootModel
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
RideSession >> initializeRootController [

	^ rootController := Ride service router rootControllerGetter value: self
]

{ #category : #initialization }
RideSession >> initializeWith: anId on: aModel [

	super initialize.

	id := anId.
	rootModel := aModel
]

{ #category : #accessing }
RideSession >> rootController [

	^ rootController ifNil: [ self initializeRootController ]
]

{ #category : #accessing }
RideSession >> rootModel [

	^ rootModel
]

{ #category : #accessing }
RideSession >> rootModel: anObject [

	rootModel := anObject
]
