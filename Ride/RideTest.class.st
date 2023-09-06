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
		assert: (RideRouter controllerNameFor: 'some')
		equals: 'SomeController'.
	self
		assert: (RideRouter controllerNameFor: 'some_thing')
		equals: 'SomeThingController'.
	self
		assert: (RideRouter controllerNameFor: 'some_thing_modeled')
		equals: 'SomeThingModeledController'
]
