"
I model the To Do list
"
Class {
	#name : #Todo,
	#superclass : #RideModel,
	#instVars : [
		'items',
		'userFirstName'
	],
	#category : #'Ride-Examples-Models'
}

{ #category : #actions }
Todo >> addItem: aTodoItem [

	^ items add: aTodoItem
]

{ #category : #actions }
Todo >> addItemDescribed: aString [

	^ self addItem: (TodoItem new description: aString)
]

{ #category : #initialization }
Todo >> initialize [

	super initialize.
	items := OrderedCollection new
]

{ #category : #accessing }
Todo >> items [

	^ items
]

{ #category : #accessing }
Todo >> items: anObject [

	items := anObject
]

{ #category : #actions }
Todo >> removeItem: aTodoItem [

	^ items remove: aTodoItem ifAbsent: [ nil ]
]

{ #category : #actions }
Todo >> toggleItemId: taskId [

	items
		detect: [ :item | item id = taskId ]
		ifFound: [ :item | item toggle ]
]

{ #category : #accessing }
Todo >> userFirstName [

	^ userFirstName
]

{ #category : #accessing }
Todo >> userFirstName: anObject [

	userFirstName := anObject
]
