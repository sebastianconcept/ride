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

{ #category : #accessing }
RideCompositeHelper >> doer [

	^ doer
]

{ #category : #accessing }
RideCompositeHelper >> doer: anObject [

	doer := anObject
]

{ #category : #initialization }
RideCompositeHelper >> initialize [

	super initialize.

	js := false
]

{ #category : #actions }
RideCompositeHelper >> withJs [

	js := true
]

{ #category : #actions }
RideCompositeHelper >> withoutJs [

	js := false
]
