"
I'm a Ride helper dedicated to boilerplate a presenter
"
Class {
	#name : #RidePresenterHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RidePresenterHelper >> classNameFor: aSymbol [

	^ '{1}Presenter' format: { aSymbol asPlural }
]

{ #category : #actions }
RidePresenterHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the presenter for {1} models' format: { aSymbol asString }
]

{ #category : #accessing }
RidePresenterHelper >> targetPackageNameTag [

	^ 'Presenters'
]

{ #category : #accessing }
RidePresenterHelper >> targetedSuperclassFor: aSymbol [

	| className |
	className := '{1}Presenter' format: { RideBuilder defaultPackageName }.
	^ Smalltalk
		  at: className asSymbol
		  ifAbsent: [ 
		  RideBoilerplateError signal: '{1} class is missing in this image' ]
]
