"
I help to use more than one boilerplate helper
"
Class {
	#name : #RideCompositeHelper,
	#superclass : #Object,
	#instVars : [
		'js',
		'doer'
	],
	#category : #'Ride-Boilerplate'
}

{ #category : #'as yet unclassified' }
RideCompositeHelper class >> getPluralOf: aSymbol [

	self flag: #todo.
	^ aSymbol asSnakeCase
]

{ #category : #accessing }
RideCompositeHelper >> controllerForModel: aSymbol [

	^ Smalltalk at: (doer controller classNameFor: aSymbol) asSymbol
]

{ #category : #accessing }
RideCompositeHelper >> doer [

	^ doer
]

{ #category : #accessing }
RideCompositeHelper >> doer: anObject [

	doer := anObject
]

{ #category : #actions }
RideCompositeHelper >> for: aSymbol [

	self subclassResponsibility
]

{ #category : #initialization }
RideCompositeHelper >> initialize [

	super initialize.

	js := false
]

{ #category : #accessing }
RideCompositeHelper >> presenterForModel: aSymbol [

	^ Smalltalk at: (doer presenter classNameFor: aSymbol) asSymbol
]

{ #category : #actions }
RideCompositeHelper >> withJs [

	js := true
]

{ #category : #actions }
RideCompositeHelper >> withoutJs [

	js := false
]
