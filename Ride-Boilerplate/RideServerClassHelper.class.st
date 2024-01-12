"
I help with the creation of the server class of the Ride-based application
"
Class {
	#name : #RideServerClassHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideServerClassHelper >> classNameFor: aSymbol [

	^ '{1}Server' format: { aSymbol }
]

{ #category : #actions }
RideServerClassHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the server class of the {1} Ride-based application' format:
		  { aSymbol asString }
]

{ #category : #accessing }
RideServerClassHelper >> targetPackageNameTag [

	^ 'Core'
]

{ #category : #accessing }
RideServerClassHelper >> targetedSuperclass [

	^ RideServer 
]
