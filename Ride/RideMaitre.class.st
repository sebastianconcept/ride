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
RideMaitre class >> poolMaxSize [

	^ (OSEnvironment current at: 'RIDE_WORKER_POOL_SIZE' ifAbsent: [ 2 ])
		  asInteger
]

{ #category : #initialization }
RideMaitre >> initialize [

	super initialize.

	userActions := TKTWorkerPool new
		               poolMaxSize: self class poolMaxSize;
		               yourself.
	Ride
		log:
		('Using {1} workers...' format: { self class poolMaxSize asString })
		level: #INFO
]

{ #category : #actions }
RideMaitre >> reset [

	self initialize
]

{ #category : #actions }
RideMaitre >> scheduleAction: aBlock [

	| locale |
	locale := self auth normalizedLocale: RideLanguage value.
	userActions schedule: [ RideLanguage value: locale during: aBlock ]
]

{ #category : #actions }
RideMaitre >> scheduleAction: aBlock for: aUser [

	userActions schedule: [ 
		RideLanguage
			value: (self auth normalizedLocale: aUser locale)
			during: aBlock ]
]

{ #category : #actions }
RideMaitre >> start [

	userActions start
]

{ #category : #actions }
RideMaitre >> stop [

	userActions stop
]
