"
I am the abstract class with the commonalities among the boilerplate helpers
"
Class {
	#name : #RideBoilerplateHelper,
	#superclass : #Object,
	#category : #'Ride-Boilerplate'
}

{ #category : #actions }
RideBoilerplateHelper class >> for: aSymbol [

	| snippet |
	snippet := self newClassNamed: aSymbol.
	^snippet 
]

{ #category : #'instance creation' }
RideBoilerplateHelper class >> newClassNamed: className [

	^ self
		  newClassNamed: className
		  instVars: ''
		  classVars: ''
		  packageNamed: Ride boilerplate packageName
]

{ #category : #'instance creation' }
RideBoilerplateHelper class >> newClassNamed: className instVars: instVars classVars: classVars packageNamed: packageName [

	^ self
		  newClassNamed: className
		  instVars: instVars
		  classVars: classVars
		  packageNamed: packageName
		  withSuperclass: Object
]

{ #category : #'instance creation' }
RideBoilerplateHelper class >> newClassNamed: className instVars: instVars classVars: classVars packageNamed: packageName withSuperclass: aClass [

	| template |
	template := '{5} subclass: #{1}
	instanceVariableNames: ''{2}''
	classVariableNames: ''{3}''
	package: ''{4}''' format: { 
			            className.
			            instVars.
			            classVars.
			            packageName.
			            aClass name }.
	^ template
]

{ #category : #'instance creation' }
RideBoilerplateHelper class >> newClassNamed: className withSuperclass: aClass [

	^ self
		  newClassNamed: className
		  instVars: ''
		  classVars: ''
		  packageNamed: Ride boilerplate packageName
		  withSuperclass: aClass
]
