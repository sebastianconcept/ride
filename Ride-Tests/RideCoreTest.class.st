Class {
	#name : #RideCoreTest,
	#superclass : #RideTest,
	#category : #'Ride-Tests'
}

{ #category : #tests }
RideCoreTest >> setUp [

	super setUp.

	Ride resource: RideResource
]

{ #category : #tests }
RideCoreTest >> testCamelCaseToSnakeCase [

	self assert: 'Some' asSnakeCase equals: 'some'.
	self assert: 'SomeName' asSnakeCase equals: 'some_name'.
	self assert: 'SomeLongerName' asSnakeCase equals: 'some_longer_name'
]

{ #category : #tests }
RideCoreTest >> testDebugMode [

	self deny: Ride isDebugMode.
	self assert: RideServer defaultDebugMode equals: 0
]

{ #category : #tests }
RideCoreTest >> testDefaultHttpBind [


	self assert: RideServer defaultHttpBind equals: '0.0.0.0'
]

{ #category : #tests }
RideCoreTest >> testDefaultHttpPort [

	self assert: RideServer defaultHttpPort equals: 3004
]

{ #category : #tests }
RideCoreTest >> testDefaultMAXAGE [

	self assert: RideServer defaultMAXAGE equals: 60 * 60
]

{ #category : #tests }
RideCoreTest >> testDefaultSMAXAGE [

	self assert: RideServer defaultSMAXAGE equals: 120 * 60
]

{ #category : #tests }
RideCoreTest >> testDefaultWebSocketPort [

	self assert: RideServer defaultWebSocketPort equals: 3008
]

{ #category : #tests }
RideCoreTest >> testHasWebSocket [

	self deny: RideServer hasWebSocket
]

{ #category : #tests }
RideCoreTest >> testHttpBind [

	self assert: RideServer httpBind equals: '0.0.0.0'
]

{ #category : #tests }
RideCoreTest >> testHttpPort [

	self assert: RideServer httpPort equals: 3004
]

{ #category : #tests }
RideCoreTest >> testSettings [

	self
		assert: RideServer new settings asDictionary
		equals: {  } asDictionary
]

{ #category : #tests }
RideCoreTest >> testSnakeCaseRouteToCamelCasePresenterName [

	self
		assert: (RideNameNormalizer presenterNameFromURISegment: 'some')
		equals: 'SomePresenter'.
	self
		assert:
		(RideNameNormalizer presenterNameFromURISegment: 'some_thing')
		equals: 'SomeThingPresenter'.
	self
		assert:
		(RideNameNormalizer presenterNameFromURISegment:
			 'some_thing_modeled')
		equals: 'SomeThingModeledPresenter'
]

{ #category : #tests }
RideCoreTest >> testStartStop [

	| server |

	server := RideServer new.
	server router beDeclarative.
	server start.
	server stop.
]
