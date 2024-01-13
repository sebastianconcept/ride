"
I help creating the home app presenter
"
Class {
	#name : #RideAppHomePresenterClassHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideAppHomePresenterClassHelper >> classNameFor: aSymbol [

	^ '{1}HomePresenter' format: { aSymbol }
]

{ #category : #actions }
RideAppHomePresenterClassHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the Home presenter for the {1} Ride-based application.' 
		  format: { aSymbol asString }
]

{ #category : #actions }
RideAppHomePresenterClassHelper >> newClassNamed: aSymbol [

	| className targetedSuperclass |
	className := self classNameFor: aSymbol.
	targetedSuperclass := self targetedSuperclassFor: aSymbol.
	self
		assert: (Smalltalk includesKey: className asSymbol) not
		description:
		('{1} already exists in this image.' format: { className }).
	[ 
	'Adding new class {1} as subclass of {2} in {3} package' format: { 
			className.
			targetedSuperclass name.
			self targetPackageName } ] logInfo.
	^ self newClassNamed: className withSuperclass: targetedSuperclass
]

{ #category : #accessing }
RideAppHomePresenterClassHelper >> targetPackageNameTag [

	^ 'Presenters'
]

{ #category : #accessing }
RideAppHomePresenterClassHelper >> targetedSuperclassFor: aSymbol [

	| targetClassName |
	targetClassName := '{1}AbstractPresenter' format: { aSymbol }.
	^ Smalltalk at: targetClassName asSymbol ifAbsent: [ 
		  RideBoilerplateError signal:
			  ('{1} was not found in the image' format: { targetClassName }) ]
]
