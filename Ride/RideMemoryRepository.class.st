"
I help keeping models in memony.

"
Class {
	#name : #RideMemoryRepository,
	#superclass : #Object,
	#instVars : [
		'storage'
	],
	#category : #'Ride-Models'
}

{ #category : #accessing }
RideMemoryRepository >> find: aRideModel atId: anId [

	^ (storage at: aRideModel ifAbsentPut: [ Dictionary new ]) at: anId
]

{ #category : #initialization }
RideMemoryRepository >> initialize [

	super initialize.
	storage := Dictionary new
]

{ #category : #initialization }
RideMemoryRepository >> reset [

	storage := Dictionary new
]

{ #category : #accessing }
RideMemoryRepository >> storage [

	^ storage
]

{ #category : #accessing }
RideMemoryRepository >> storage: anObject [

	storage := anObject
]
