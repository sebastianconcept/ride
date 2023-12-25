"
I'm a Ride helper dedicated to boilerplate a model
"
Class {
	#name : #RideModelHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #private }
RideModelHelper >> classNameFor: aSymbol [

	^ aSymbol
]

{ #category : #actions }
RideModelHelper >> defaultCommentsFor: aSymbol [

	^ 'I am {1} model' format: { aSymbol asString }
]

{ #category : #private }
RideModelHelper >> targetedSuperclass [

	^ RideModel
]
