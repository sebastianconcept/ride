"
I help creating the home app presenter
"
Class {
	#name : #RideAppHomePresenterClassHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RideAppHomePresenterClassHelper class >> classNameFor: aSymbol [

	^ '{1}HomePresenter' format: { aSymbol }
]

{ #category : #initialization }
RideAppHomePresenterClassHelper class >> indexMethodFor: aSymbol [

	^ 'index

	^ self render
	' format: { aSymbol }
]

{ #category : #initialization }
RideAppHomePresenterClassHelper class >> showHomeMethodFor: aSymbol [

	^ 'showHome

	<rideRoute>
	^ {
		  (#GET -> ''/'').
		  (self -> #index) }
	'
]

{ #category : #initialization }
RideAppHomePresenterClassHelper class >> templatePathMethodFor: aSymbol [

	| viewName |
	"The convention is to find the view at the normalized model name."
	viewName := (Smalltalk at: (self classNameFor: aSymbol) asSymbol ifAbsent: [ 
		             RideBoilerplateError signal:
			             ('A presenter class for {1} was expected but not found' 
				              format: { aSymbol asString }) ])
		            getNormalizedModelName.

	^ 'templatePath

	^ ''{1}''
	' format: { (RideResource viewsDirectory / viewName) pathString }
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
RideAppHomePresenterClassHelper >> addShowHomeMethodTo: aClass for: aSymbol [

	aClass class compile: (self class showHomeMethodFor: aSymbol).
	aClass class organization classify: #showHome under: 'accessing'
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

	^ self class classNameFor: aSymbol
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

	self addShowHomeMethodTo: appClass for: aSymbol.

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
	targetClassName := '{1}Presenter' format: { aSymbol }.
	^ Smalltalk at: targetClassName asSymbol ifAbsent: [ 
		  RideBoilerplateError signal:
			  ('{1} was not found in the image' format: { targetClassName }) ]
]
