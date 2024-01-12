"
I help creating the class that helps resolving resources for the Ride-based app
"
Class {
	#name : #RideResourceClassHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideResourceClassHelper class >> databaseDirectoryMethodFor: aSymbol [

	^ 'databaseDirectory

	^ (Smalltalk os environment
		   at: ''DATABASE_DIR''
		   ifAbsent: [ FileSystem workingDirectory / ''db'' ]) asFileReference'
]

{ #category : #accessing }
RideResourceClassHelper class >> databaseFileMethodFor: aSymbol [

	^ 'databaseFile

	^ self databaseDirectory / self databaseName'
]

{ #category : #accessing }
RideResourceClassHelper class >> databaseNameMethodFor: aSymbol [

	^ 'databaseName

	^ Smalltalk os environment
		  at: ''DATABASE_NAME''
		  ifAbsent: [ ''{1}.dev.db'' ]' format:
		  { aSymbol asString uncapitalized }
]

{ #category : #actions }
RideResourceClassHelper >> addDatabaseDirectoryMethodTo: appClass for: aSymbol [

	appClass class compile:
		(self class databaseDirectoryMethodFor: aSymbol).
	appClass class organization
		classify: #databaseDirectory
		under: 'accessing'
]

{ #category : #actions }
RideResourceClassHelper >> addDatabaseFileMethodTo: appClass for: aSymbol [

	appClass class compile: (self class databaseFileMethodFor: aSymbol).
	appClass class organization
		classify: #databaseFile
		under: 'accessing'
]

{ #category : #actions }
RideResourceClassHelper >> addDatabaseNameMethodTo: appClass for: aSymbol [

	appClass class compile: (self class databaseNameMethodFor: aSymbol).
	appClass class organization
		classify: #databaseName
		under: 'accessing'
]

{ #category : #accessing }
RideResourceClassHelper >> classNameFor: aSymbol [

	^ '{1}Resource' format: { aSymbol }
]

{ #category : #actions }
RideResourceClassHelper >> defaultCommentsFor: aSymbol [

	^ 'I help resolving how to find resources for the {1} Ride-based application.' 
		  format: { aSymbol asString }
]

{ #category : #actions }
RideResourceClassHelper >> for: aSymbol [

	| appClass |
	appClass := super for: aSymbol.

	self addDatabaseDirectoryMethodTo: appClass for: aSymbol.
	self addDatabaseNameMethodTo: appClass for: aSymbol.
	self addDatabaseFileMethodTo: appClass for: aSymbol
]

{ #category : #accessing }
RideResourceClassHelper >> targetPackageNameTag [

	^ 'Core'
]

{ #category : #accessing }
RideResourceClassHelper >> targetedSuperclass [

	^ RideResource
]
