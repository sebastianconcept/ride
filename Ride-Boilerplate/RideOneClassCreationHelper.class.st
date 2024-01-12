"
I help with the boilerplate of things that end up creating one class
"
Class {
	#name : #RideOneClassCreationHelper,
	#superclass : #RideBoilerplateHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideOneClassCreationHelper >> classNameFor: className [

	self subclassResponsibility
]

{ #category : #actions }
RideOneClassCreationHelper >> defaultCommentsFor: aSymbol [

	^ self subclassResponsibility
]

{ #category : #actions }
RideOneClassCreationHelper >> for: aSymbol [

	| snippet newClass |
	snippet := self newClassNamed: aSymbol.
	[ newClass := OpalCompiler new evaluate: snippet ]
		on: Error
		do: [ :x | RideBoilerplateError signal: x messageText ].
	newClass comment: (self defaultCommentsFor: aSymbol).
	^ newClass
]

{ #category : #actions }
RideOneClassCreationHelper >> newClassNamed: aSymbol [

	| className targetedSuperclass |
	className := self classNameFor: aSymbol.
	targetedSuperclass := self targetedSuperclass.
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

{ #category : #actions }
RideOneClassCreationHelper >> newClassNamed: className instVars: instVars classVars: classVars packageNamed: packageName [

	^ self
		  newClassNamed: className
		  instVars: instVars
		  classVars: classVars
		  packageNamed: packageName
		  withSuperclass: Object
]

{ #category : #actions }
RideOneClassCreationHelper >> newClassNamed: className instVars: instVars classVars: classVars packageNamed: packageName withSuperclass: aClass [

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

{ #category : #accessing }
RideOneClassCreationHelper >> newClassNamed: className on: aSuperclass [

	| subclassName |
	subclassName := self classNameFor: className.
	self
		assert: (Smalltalk includesKey: subclassName asSymbol) not
		description:
		('{1} already exists in this image.' format: { subclassName }).
	[ 
	'Adding subclass {1} to {2}' format: { 
			subclassName.
			aSuperclass name } ] logInfo.
	^ self
		  newClassNamed: subclassName
		  instVars: ''
		  classVars: ''
		  packageNamed: self targetPackageName
		  withSuperclass: aSuperclass
]

{ #category : #actions }
RideOneClassCreationHelper >> newClassNamed: className withSuperclass: aClass [

	^ self
		  newClassNamed: className
		  instVars: ''
		  classVars: ''
		  packageNamed: self targetPackageName
		  withSuperclass: aClass
]

{ #category : #accessing }
RideOneClassCreationHelper >> targetPackageName [

	^ '{1}-{2}' format: { 
			  self targetPackageNameRoot.
			  self targetPackageNameTag }
]

{ #category : #accessing }
RideOneClassCreationHelper >> targetPackageNameRoot [

	^ Ride draft packageName
]

{ #category : #accessing }
RideOneClassCreationHelper >> targetPackageNameTag [

	^ self subclassResponsibility
]
