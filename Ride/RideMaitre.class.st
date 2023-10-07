"
I'm the one in charge of orchestrating user's request.
"
Class {
	#name : #RideMaitre,
	#superclass : #Object,
	#instVars : [
		'userActions'
	],
	#category : #'Ride-Core'
}

{ #category : #'as yet unclassified' }
RideMaitre class >> workersPoolSize [

	^ (OSEnvironment current at: 'WORKER_POOL_SIZE' ifAbsent: [ 2 ])
		  asInteger
]

{ #category : #initialization }
RideMaitre >> initializeUserActions [

	^ userActions := TKTWorkerPool new
		                 poolMaxSize: self class workersPoolSize;
		                 yourself
]

{ #category : #actions }
RideMaitre >> reset [

	userActions ifNotNil: [ 
		userActions stop.
		userActions := nil ]
]

{ #category : #actions }
RideMaitre >> scheduleAction: aBlock [

	self userActions schedule: aBlock
]

{ #category : #actions }
RideMaitre >> start [

	self userActions start.
	Ride
		log: ('{1} prepared {2} workers...' format: { 
					 self class name.
					 self class workersPoolSize asString })
		level: #INFO
]

{ #category : #actions }
RideMaitre >> stop [

	self reset
]

{ #category : #acccessing }
RideMaitre >> userActions [

	^ userActions ifNil: [ self initializeUserActions ]
]
