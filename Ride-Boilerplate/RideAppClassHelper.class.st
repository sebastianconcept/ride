"
I help with the creation of the main application helper class
"
Class {
	#name : #RideAppClassHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideAppClassHelper class >> applicationResourceClassMethodFor: aSymbol [

	^ 'applicationResourceClass
	
	^ {1}Resource' format: { aSymbol }
]

{ #category : #accessing }
RideAppClassHelper class >> initializeRepositoryMethodFor: aSymbol [

	^ 'initializeRepository

	^ repository := MaplessSQLiteRepository
		                for: ''{1}''
		                with:
		                (MaplessSQLitePool on:
			                 Ride resource databaseFile pathString)' format:
		  { aSymbol uncapitalized }
]

{ #category : #accessing }
RideAppClassHelper class >> initializeServerMethodFor: aSymbol [

	^ 'initializeServer

	^ server := {1}Server new' format: { aSymbol }
]

{ #category : #accessing }
RideAppClassHelper class >> installMethodFor: aSymbol [

	^ 'install

	super install.

	Ride service maitre: {1}Maitre new' format: { aSymbol }
]

{ #category : #accessing }
RideAppClassHelper class >> newSessionWith_UrlMethodFor: aSymbol [

	^ 'newSessionWith: sessionId url: anUrl
	
	"Answer a new {1}App session with the given sessionId and url."

	^ {1}Session newWith: sessionId url: anUrl
' format: { aSymbol }
]

{ #category : #actions }
RideAppClassHelper >> addApplicationResourceClassMethodTo: aClass for: aSymbol [

	aClass class compile:
		(self class applicationResourceClassMethodFor: aSymbol).
	aClass class organization
		classify: #applicationResourceClass
		under: 'accessing'
]

{ #category : #actions }
RideAppClassHelper >> addInitializeRepositoryMethodTo: aClass for: aSymbol [

	aClass compile: (self class initializeRepositoryMethodFor: aSymbol).
	aClass organization classify: #initializeRepository under: 'initialization'
]

{ #category : #actions }
RideAppClassHelper >> addInitializeServerMethodTo: aClass for: aSymbol [

	aClass compile: (self class initializeServerMethodFor: aSymbol).
	aClass organization classify: #initializeServer under: 'initialization'
]

{ #category : #actions }
RideAppClassHelper >> addInstallMethodTo: aClass for: aSymbol [

	aClass class compile: (self class installMethodFor: aSymbol).
	aClass class organization classify: #install under: 'actions'
]

{ #category : #actions }
RideAppClassHelper >> addNewSessionWith_UrlMethodTo: aClass for: aSymbol [

	aClass class compile: (self class newSessionWith_UrlMethodFor: aSymbol).
	aClass class organization classify: #'newSessionWith:url:' under: 'actions'
]

{ #category : #accessing }
RideAppClassHelper >> classNameFor: aSymbol [

	^ '{1}App' format: { aSymbol }
]

{ #category : #actions }
RideAppClassHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the main helper to start/stop the {1} Ride-based application' 
		  format: { aSymbol asString }
]

{ #category : #actions }
RideAppClassHelper >> for: aSymbol [

	| appClass |
	appClass := super for: aSymbol.

	self addNewSessionWith_UrlMethodTo: appClass for: aSymbol.
	self addInstallMethodTo: appClass for: aSymbol.
	self addApplicationResourceClassMethodTo: appClass for: aSymbol.
	self addInitializeServerMethodTo: appClass for: aSymbol.
	self addInitializeRepositoryMethodTo: appClass for: aSymbol
]

{ #category : #accessing }
RideAppClassHelper >> targetPackageNameTag [

	^ 'Core'
]

{ #category : #accessing }
RideAppClassHelper >> targetedSuperclass [

	^ RideService
]
