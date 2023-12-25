"
I'm a Ride helper dedicated to boilerplate a controller
"
Class {
	#name : #RideControllerHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideControllerHelper >> classNameFor: aSymbol [

	^ '{1}Controller' format: { aSymbol }
]

{ #category : #actions }
RideControllerHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the controller for {1} models' format: { aSymbol asString }
]

{ #category : #private }
RideControllerHelper >> targetedSuperclass [

	^ RideController
]
