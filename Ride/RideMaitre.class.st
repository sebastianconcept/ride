"
I'm the one in charge of orchestrating user's request.
"
Class {
	#name : #RideMaitre,
	#superclass : #Object,
	#instVars : [
		'emailComposer',
		'actionsQueue',
		'actionsPool'
	],
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideMaitre class >> assetsDirectory [

	^ (Smalltalk os environment
		   at: 'ASSETS_PATH'
		   ifAbsent: [ Smalltalk imageDirectory / 'app' / 'assets' ])
		  asFileReference
]

{ #category : #accessing }
RideMaitre class >> workersPoolSize [

	^ (OSEnvironment current at: 'WORKER_POOL_SIZE' ifAbsent: [ 2 ])
		  asInteger
]

{ #category : #acccessing }
RideMaitre >> actionsPool [

	"Answer the pool of workers that will execute the scheduled actions.
	Useful when you do not need sequential order preserved
	and you can schedule actions to eventually get done."

	^ actionsPool ifNil: [ self initializeActionsPool ]
]

{ #category : #acccessing }
RideMaitre >> actionsQueue [

	"Answer the worker that has a queue of actions.
	For example when you need sequential order preserved
	you schedule actions to this worker."

	^ actionsQueue ifNil: [ self initializeActionsQueue ]
]

{ #category : #acccessing }
RideMaitre >> emailComposer [

	^ emailComposer ifNil: [ self initializeEmailComposer ]
]

{ #category : #initialization }
RideMaitre >> initializeActionsPool [

	^ actionsPool := TKTWorkerPool new
		                 poolMaxSize: self class workersPoolSize;
		                 yourself
]

{ #category : #initialization }
RideMaitre >> initializeActionsQueue [

	^ actionsQueue := TKTWorker new
]

{ #category : #initialization }
RideMaitre >> initializeEmailComposer [

	^ emailComposer := RideEmailComposer new
]

{ #category : #actions }
RideMaitre >> reset [

	actionsQueue ifNotNil: [ 
		actionsQueue stop.
		actionsQueue := nil ].

	actionsPool ifNotNil: [ 
		actionsPool stop.
		actionsPool := nil ]
]

{ #category : #actions }
RideMaitre >> start [

	self actionsQueue start.
	Ride
		log:
		('{1} started the actions queue...' format: { self class name })
		level: #INFO.
	self actionsPool start.
	Ride
		log: ('{1} prepared {2} workers for its action pool...' format: { 
					 self class name.
					 self class workersPoolSize asString })
		level: #INFO
]

{ #category : #actions }
RideMaitre >> stop [

	self reset
]
