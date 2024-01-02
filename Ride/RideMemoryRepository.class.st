"
I help keeping models in memony.

"
Class {
	#name : #RideMemoryRepository,
	#superclass : #Object,
	#instVars : [
		'storage'
	],
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideMemoryRepository >> find: aRideModel atId: anId [

	^ (storage at: aRideModel ifAbsentPut: [ SmallDictionary new ]) at: anId
]

{ #category : #initialization }
RideMemoryRepository >> initialize [

	super initialize.
	storage := SmallDictionary new
]

{ #category : #initialization }
RideMemoryRepository >> reset [

	storage := SmallDictionary new
]

{ #category : #accessing }
RideMemoryRepository >> storage [

	^ storage
]

{ #category : #accessing }
RideMemoryRepository >> storage: anObject [

	storage := anObject
]
