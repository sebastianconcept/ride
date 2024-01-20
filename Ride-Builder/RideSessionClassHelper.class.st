"
I help with the creation of the session class of the Ride-based application
"
Class {
	#name : #RideSessionClassHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RideSessionClassHelper >> classNameFor: aSymbol [

	^ '{1}Session' format: { aSymbol }
]

{ #category : #actions }
RideSessionClassHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the session of the {1} Ride-based application' format:
		  { aSymbol asString }
]

{ #category : #accessing }
RideSessionClassHelper >> targetPackageNameTag [

	^ 'Core'
]

{ #category : #accessing }
RideSessionClassHelper >> targetedSuperclassFor: aSymbol [

	^ RideSession
]
