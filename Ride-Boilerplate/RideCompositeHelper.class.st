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
RideCompositeHelper >> builder [

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

{ #category : #actions }
RideCompositeHelper >> mustacheTemplateFor: aSymbol [

	| view |
	view := doer view mustache.
	view js: js.
	view for: aSymbol
]

{ #category : #accessing }
RideCompositeHelper >> presenterForModel: aSymbol [

	^ Smalltalk at: (doer presenter classNameFor: aSymbol) asSymbol
]

{ #category : #actions }
RideCompositeHelper >> sttTemplateFor: aSymbol [

	| view |
	view := doer view stt.
	view js: js.
	view for: aSymbol
]

{ #category : #actions }
RideCompositeHelper >> withJs [

	js := true
]

{ #category : #actions }
RideCompositeHelper >> withoutJs [

	js := false
]
