"
Helper to start/stop Ride applications.
"
Class {
	#name : #Ride,
	#superclass : #Object,
	#classInstVars : [
		'server',
		'logLevelSymbols',
		'maitre'
	],
	#category : #'Ride-Core'
}

{ #category : #testing }
Ride class >> allowsLoglevel: aSymbol [

	aSymbol == #ERROR ifTrue: [ ^ true ].
	^ (self logLevelSymbols keyAtValue: aSymbol)
	  <= (self logLevelSymbols keyAtValue: self logLevel)
]

{ #category : #accessing }
Ride class >> defaultLogLevel [

	^ #INFO
]

{ #category : #actions }
Ride class >> ensure [

	"Goes to the file system and checks the src/config/ directory for settings that are needed to keep this image properly set for the app."

	
]

{ #category : #initialization }
Ride class >> initializeLogLevelSymbols [

	^ logLevelSymbols := { 
		                     (1 -> #ERROR).
		                     (2 -> #WARNING).
		                     (3 -> #INFO).
		                     (4 -> #DEBUG) } asDictionary
]

{ #category : #initialization }
Ride class >> initializeMaitre [

	^ maitre := RideMaitre new
]

{ #category : #initialization }
Ride class >> initializeServer [

	^ server := RideServer new
]

{ #category : #testing }
Ride class >> isDebugMode [

	^ RideServer debugMode
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

	^ OSEnvironment current
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
Ride class >> maitre [

	^ maitre ifNil: [ self initializeMaitre ]
]

{ #category : #accessing }
Ride class >> maitre: anObject [

	maitre := anObject
]

{ #category : #accessing }
Ride class >> mode [

	^ OSEnvironment current at: 'RIDE_MODE'
]

{ #category : #actions }
Ride class >> reportedError: aString [

	self log: aString level: #ERROR
]

{ #category : #actions }
Ride class >> reset [

	| released |
	maitre ifNotNil: [ 
		released := maitre.
		maitre := nil.
		released reset ].

	server ifNotNil: [ 
		released := server.
		server := nil.
		released reset ].

	logLevelSymbols := nil
]

{ #category : #actions }
Ride class >> restart [

	self
		stop;
		reset;
		start
]

{ #category : #actions }
Ride class >> scaffold [

	^ RideScaffold 
]

{ #category : #accessing }
Ride class >> server [

	^ server ifNil: [ self initializeServer ]
]

{ #category : #accessing }
Ride class >> server: anObject [

	server := anObject
]

{ #category : #actions }
Ride class >> shutDown [

	super shutDown.
	self log: 'Shutting down...' level: #INFO.
	self stop.
	self reset
]

{ #category : #actions }
Ride class >> start [

	"self log: 'Warming up database pool...'.
	self initializeRepository."

	"[ 
	self repository accessor start.
	self log: 'Ensuring database indexes...'.
	self ensureDatabaseIndexes ]
		on: NetworkError
		do: [ :x | 
			self
				log:
				('Failed to reach the database {1}' format: { x printString })
				level: #ERROR ]."

	self log: 'Starting Raid REST service...'.
	self server start.
	self maitre start
]

{ #category : #actions }
Ride class >> startUp [

	| message |
	super startUp.
	self log: 'Pharo starting up...' level: #INFO.
	Smalltalk vm maxExternalSemaphoresSilently: 32 *1000.
	ZnOptions globalDefault at: #maximumNumberOfConcurrentConnections put: 1000.
	self isDebugMode ifTrue: [ 
		message := 'Starting up service in debug mode.'.
		self log: message level: #WARNING ].
	self start
]

{ #category : #actions }
Ride class >> stop [
]
