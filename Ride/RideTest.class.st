Class {
	#name : #RideTest,
	#superclass : #TestCase,
	#category : #'Ride-Tests'
}

{ #category : #tests }
RideTest >> testCamelCaseToSnakeCase [

	self assert: 'Some' asSnakeCase equals: 'some'.
	self assert: 'SomeName' asSnakeCase equals: 'some_name'.
	self assert: 'SomeLongerName' asSnakeCase equals: 'some_longer_name'
]

{ #category : #tests }
RideTest >> testSnakeCaseRouteToCamelCaseControllerName [

	self
		assert: (RideViewPresenterLocator new presenterNameFor: 'some')
		equals: 'SomeController'.
	self
		assert:
		(RideViewPresenterLocator new presenterNameFor: 'some_thing')
		equals: 'SomeThingController'.
	self
		assert:
		(RideViewPresenterLocator new presenterNameFor:
			 'some_thing_modeled')
		equals: 'SomeThingModeledController'
]
