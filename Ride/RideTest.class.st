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
		assert: (RideNameNormalizer controllerNameFromURISegment: 'some')
		equals: 'SomeController'.
	self
		assert:
		(RideNameNormalizer controllerNameFromURISegment: 'some_thing')
		equals: 'SomeThingController'.
	self
		assert:
		(RideNameNormalizer controllerNameFromURISegment:
			 'some_thing_modeled')
		equals: 'SomeThingModeledController'
]

{ #category : #tests }
RideTest >> testSnakeCaseRouteToCamelCasePresenterName [

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
