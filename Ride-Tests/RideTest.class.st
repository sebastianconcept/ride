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
