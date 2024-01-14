"
I help creating the home app presenter
"
Class {
	#name : #RideAppHomePresenterClassHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #initialization }
RideAppHomePresenterClassHelper class >> indexMethodFor: aSymbol [

	^ 'index

	^ page render: #index for: self
	' format: { aSymbol }
]

{ #category : #initialization }
RideAppHomePresenterClassHelper class >> templatePathMethodFor: aSymbol [

	^ 'templatePath

	^ ''{1}''
	' format:
		  { (RideResource viewsDirectory / aSymbol asSnakeCase) pathString }
]

{ #category : #initialization }
RideAppHomePresenterClassHelper class >> webAppNameMethodFor: aSymbol [

	^ 'webAppName

	^ ''{1}''
	' format: { aSymbol }
]

{ #category : #actions }
RideAppHomePresenterClassHelper >> addIndexMethodTo: aClass for: aSymbol [

	aClass compile: (self class indexMethodFor: aSymbol).
	aClass organization classify: #index under: 'accessing'
]

{ #category : #actions }
RideAppHomePresenterClassHelper >> addTemplatePathMethodTo: aClass for: aSymbol [

	aClass compile: (self class templatePathMethodFor: aSymbol).
	aClass organization classify: #templatePath under: 'accessing'
]

{ #category : #actions }
RideAppHomePresenterClassHelper >> addWebAppNameMethodTo: aClass for: aSymbol [

	aClass compile: (self class webAppNameMethodFor: aSymbol).
	aClass organization classify: #webAppName under: 'accessing'
]

{ #category : #accessing }
RideAppHomePresenterClassHelper >> classNameFor: aSymbol [

	^ '{1}HomePresenter' format: { aSymbol }
]

{ #category : #actions }
RideAppHomePresenterClassHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the Home presenter for the {1} Ride-based web application.' 
		  format: { aSymbol asString }
]

{ #category : #actions }
RideAppHomePresenterClassHelper >> for: aSymbol [

	| appClass |
	appClass := super for: aSymbol.

	self addIndexMethodTo: appClass for: aSymbol.
	self addTemplatePathMethodTo: appClass for: aSymbol.
	self addWebAppNameMethodTo: appClass for: aSymbol
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
	targetClassName := '{1}WebApplicationPresenter' format: { aSymbol }.
	^ Smalltalk at: targetClassName asSymbol ifAbsent: [ 
		  RideBoilerplateError signal:
			  ('{1} was not found in the image' format: { targetClassName }) ]
]
