"
I'm a Ride helper dedicated to boilerplate a new Ride application
"
Class {
	#name : #RideAppHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideAppHelper >> classNameFor: aSymbol [

	^ '{1}App' format: { aSymbol }
]

{ #category : #actions }
RideAppHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the main helper to start/stop the  {1} Ride application' 
		  format: { aSymbol asString }
]

{ #category : #accessing }
RideAppHelper >> targetPackageNameTag [

	^ 'Core'
]

{ #category : #private }
RideAppHelper >> targetedSuperclass [

	^ RideService
]
