"
I'm a Ride helper dedicated to boilerplate a presenter
"
Class {
	#name : #RidePresenterHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RidePresenterHelper class >> indexMethodFor: aSymbol [

	^ 'index

	^ self render: ''index.html''
	' format: { aSymbol }
]

{ #category : #accessing }
RidePresenterHelper >> addIndexMethodTo: aClass for: aSymbol [

	aClass compile: (self class indexMethodFor: aSymbol).
	aClass organization classify: #index under: 'accessing'
]

{ #category : #accessing }
RidePresenterHelper >> classNameFor: aSymbol [

	^ '{1}Presenter' format: { aSymbol asPlural }
]

{ #category : #actions }
RidePresenterHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the presenter for {1} models' format: { aSymbol asString }
]

{ #category : #actions }
RidePresenterHelper >> for: aSymbol [

	| appClass |
	appClass := super for: aSymbol.

	self addIndexMethodTo: appClass for: aSymbol
]

{ #category : #accessing }
RidePresenterHelper >> targetPackageNameTag [

	^ 'Presenters'
]

{ #category : #accessing }
RidePresenterHelper >> targetedSuperclassFor: aSymbol [

	| targetClassName |
	targetClassName := '{1}Presenter' format:
		                   { Ride builder packageName }.
	^ Smalltalk at: targetClassName asSymbol ifAbsent: [ 
		  RideBoilerplateError signal:
			  ('{1} was not found in the image' format: { targetClassName }) ]
]
