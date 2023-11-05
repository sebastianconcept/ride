"
I model an item of the to-do list
"
Class {
	#name : #TodoItem,
	#superclass : #RideModel,
	#instVars : [
		'id',
		'done',
		'description'
	],
	#category : #'RideExamples-Models'
}

{ #category : #converting }
TodoItem >> asTemplateModel [

	^ { 
		  (#taskId -> id).
		  (#done -> done).
		  (#description -> description) } asDictionary
]

{ #category : #accessing }
TodoItem >> description [

	^ description
]

{ #category : #accessing }
TodoItem >> description: anObject [

	description := anObject
]

{ #category : #accessing }
TodoItem >> done [

	^ done
]

{ #category : #accessing }
TodoItem >> done: anObject [

	done := anObject
]

{ #category : #accessing }
TodoItem >> id [

	^ id
]

{ #category : #initialization }
TodoItem >> initialize [

	super initialize.

	id := UUID new asString36.
	done := false
]

{ #category : #actions }
TodoItem >> toggle [

	done := done not
]
