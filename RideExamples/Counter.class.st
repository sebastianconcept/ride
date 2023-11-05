"
I'm the model of the Counter example
"
Class {
	#name : #Counter,
	#superclass : #RideModel,
	#instVars : [
		'count',
		'userFirstName'
	],
	#category : #'RideExamples-Models'
}

{ #category : #accessing }
Counter >> count [

	^ count
]

{ #category : #accessing }
Counter >> count: anObject [

	count := anObject
]

{ #category : #actions }
Counter >> decrement [

	count := count - 1
]

{ #category : #actions }
Counter >> increment [

	count := count + 1
]

{ #category : #accessing }
Counter >> initialize [

	super initialize.
	count := 0
]

{ #category : #accessing }
Counter >> userFirstName [

	^ userFirstName
]

{ #category : #accessing }
Counter >> userFirstName: anObject [

	userFirstName := anObject.
	self changed
]
