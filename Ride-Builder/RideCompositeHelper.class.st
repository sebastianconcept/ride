"
I help to use more than one boilerplate helper
"
Class {
	#name : #RideCompositeHelper,
	#superclass : #Object,
	#instVars : [
		'js',
		'builder'
	],
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RideCompositeHelper >> builder [

	^ builder
]

{ #category : #accessing }
RideCompositeHelper >> doer: anObject [

	builder := anObject
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
	view := builder view mustache.
	view js: js.
	view for: aSymbol
]

{ #category : #accessing }
RideCompositeHelper >> pluralPresenterForModel: aSymbol [

	^ Smalltalk at: (builder pluralPresenter classNameFor: aSymbol) asSymbol
]

{ #category : #accessing }
RideCompositeHelper >> presenterForModel: aSymbol [

	^ Smalltalk at: (builder presenter classNameFor: aSymbol) asSymbol
]

{ #category : #actions }
RideCompositeHelper >> sttTemplateFor: aSymbol [

	| view |
	view := builder view stt.
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
