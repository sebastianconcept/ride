"
Helper to start/stop Ride applications.
"
Class {
	#name : #Ride,
	#superclass : #Object,
	#classInstVars : [
		'logLevelSymbols',
		'service',
		'isMaintenance',
		'resource'
	],
	#category : #'Ride-Core'
}

{ #category : #testing }
Ride class >> allowsLoglevel: aSymbol [

	aSymbol == #ERROR ifTrue: [ ^ true ].
	^ (self logLevelSymbols keyAtValue: aSymbol)
	  <= (self logLevelSymbols keyAtValue: self logLevel)
]

{ #category : #actions }
Ride class >> beDevEnvironment [
	"Sets the OS environment to be in #DEVELOPMENT mode"

	<script>
	Smalltalk os environment at: 'MODE' put: #DEVELOPMENT
]

{ #category : #accessing }
Ride class >> defaultLogLevel [

	^ #INFO
]

{ #category : #actions }
Ride class >> ensure [

	"Goes to the file system and checks the src/config/ directory for settings that are needed to keep this image properly set for the app."

	self notYetImplemented
]

{ #category : #initialization }
Ride class >> initializeIsMaintenance [

	^ isMaintenance := (Smalltalk os environment at: #MW ifAbsent: [ 0 ])
		                   asInteger = 1
]

{ #category : #initialization }
Ride class >> initializeLogLevelSymbols [

	^ logLevelSymbols := { 
		                     (1 -> #ERROR).
		                     (2 -> #WARNING).
		                     (3 -> #INFO).
		                     (4 -> #DEBUG) } asDictionary
]

{ #category : #testing }
Ride class >> isDebugMode [

	^ RideServer debugMode
]

{ #category : #testing }
Ride class >> isDevelopment [

	^ self mode asLowercase = 'development'
]

{ #category : #testing }
Ride class >> isMaintenance [

	^ isMaintenance ifNil: [ self initializeIsMaintenance ]
]

{ #category : #testing }
Ride class >> isProduction [

	^ self mode asLowercase = 'production'
]

{ #category : #actions }
Ride class >> log: aString [

	self log: aString level: self defaultLogLevel
]

{ #category : #actions }
Ride class >> log: aString level: aSymbol [

	(self allowsLoglevel: aSymbol) ifFalse: [ ^ self ].
	Stdio stdout
		<<
			('[' , DateAndTime now asString , '] ['
			 , Processor activeProcess name , '] [' , aSymbol , '] ');
		<< aString;
		lf;
		cr;
		flush
]

{ #category : #accessing }
Ride class >> logLevel [

	^ Smalltalk os environment
		  at: 'LOGLEVEL'
		  ifAbsent: [ self defaultLogLevel ]
]

{ #category : #accessing }
Ride class >> logLevelSymbols [

	^ logLevelSymbols ifNil: [ self initializeLogLevelSymbols ]
]

{ #category : #accessing }
Ride class >> logLevelSymbols: anObject [

	logLevelSymbols := anObject
]

{ #category : #accessing }
Ride class >> mode [

	^ Smalltalk os environment at: #MODE ifAbsent: [ 
		  RideError signal:
			  'The environment needs to have defined the MODE env var as production, development or debug' ]
]

{ #category : #actions }
Ride class >> purgeUploadsDirectory [
	"Removes all files from the uploads directory"

	<script>
	self resource uploadsDirectory asFileReference files do: [ :each |
		each delete ]
]

{ #category : #actions }
Ride class >> reset [

	<script>
	| released |
	service ifNotNil: [
		released := service.
		service := nil ].
	logLevelSymbols := nil.
	isMaintenance := nil.
	RideDeclarativeRouting reset.
	resource ifNotNil: [
		Ride isDevelopment ifTrue: [ resource resetAssetsMapFile ].
		resource reset ]
]

{ #category : #accessing }
Ride class >> resource [

	^ resource ifNil: [ 
		  RideError signal:
			  'The application needs a specialized resource resolver and it was not set' ]
]

{ #category : #accessing }
Ride class >> resource: aRideResourceClass [

	resource := aRideResourceClass
]

{ #category : #actions }
Ride class >> restart [

	self
		stop;
		start
]

{ #category : #accessing }
Ride class >> service [

	^ service
]

{ #category : #accessing }
Ride class >> service: anObject [

	^ service := anObject
]

{ #category : #actions }
Ride class >> shutDown [

	super shutDown.
	[ 'Shutting down...' ] logInfo.
	self stop.
	self reset
]

{ #category : #actions }
Ride class >> start [

	<script>
	service start
]

{ #category : #actions }
Ride class >> startUp [

	super startUp.
	[ 'Pharo starting up...' ] logInfo.
	Smalltalk vm maxExternalSemaphoresSilently: 32 * 1000.
	ZnOptions globalDefault
		at: #maximumNumberOfConcurrentConnections
		put: 1000.
	self isDebugMode ifTrue: [ 
		[ 'Starting up service in debug mode.' ] logWarning ].
	self start
]

{ #category : #actions }
Ride class >> stop [

	<script>
	service ifNotNil: [ service stop ]
]
