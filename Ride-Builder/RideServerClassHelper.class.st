"
I help with the creation of the server class of the Ride-based application
"
Class {
	#name : #RideServerClassHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Builder'
}

{ #category : #initialization }
RideServerClassHelper class >> initializeMethodFor: aSymbol [

	^ 'initialize

	super initialize.
	self router beDeclarative'
]

{ #category : #actions }
RideServerClassHelper >> addInitializeMethodTo: aClass for: aSymbol [

	aClass compile: (self class initializeMethodFor: aSymbol).
	aClass organization classify: #initialize under: 'initialization'
]

{ #category : #accessing }
RideServerClassHelper >> classNameFor: aSymbol [

	^ '{1}Server' format: { aSymbol }
]

{ #category : #actions }
RideServerClassHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the server class of the {1} Ride-based application' format:
		  { aSymbol asString }
]

{ #category : #actions }
RideServerClassHelper >> for: aSymbol [

	| appClass |
	appClass := super for: aSymbol.

	self addInitializeMethodTo: appClass for: aSymbol
]

{ #category : #accessing }
RideServerClassHelper >> targetPackageNameTag [

	^ 'Core'
]

{ #category : #accessing }
RideServerClassHelper >> targetedSuperclassFor: aSymbol [

	^ RideServer 
]
