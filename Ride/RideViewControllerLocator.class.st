"
I help locating the templates that are meant to be views.
"
Class {
	#name : #RideViewControllerLocator,
	#superclass : #Object,
	#instVars : [
		'templates',
		'controllers'
	],
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideViewControllerLocator >> controllerNameFor: routeName [

	^ '{1}Controller' format: { ('' join:
			   ((routeName substrings: '_') collect: [ :e | e capitalized ])) }
]

{ #category : #accessing }
RideViewControllerLocator >> controllers [

	^ controllers ifNil: [ self initializeControllers ]
]

{ #category : #accessing }
RideViewControllerLocator >> getControllers [

	"Returns a dictionary with keys being view names (views/ subdirectory names) 
	and as value, the corresponding controller classes expected to be found in the image."

	| newPresenters |
	newPresenters := Dictionary new.
	self viewTemplates keys do: [ :routeName | 
		newPresenters at: routeName put: (Smalltalk
				 at: (self controllerNameFor: routeName) asSymbol
				 ifAbsent: [ 
					 RideMissingControllerError signal:
						 ('{1} not found' format:
							  { (self controllerNameFor: routeName) }) ]) ].
	^ newPresenters
]

{ #category : #accessing }
RideViewControllerLocator >> getTemplates [

	"Returns a dictionary with keys being view names (views/ dsubirectory names) 
	and as value, a dictionary with mustache templates for every file found."

	| newTemplates newViewTemplates |
	newTemplates := JsonObject new.
	newViewTemplates := JsonObject new.
	RideDirectoryResolver getViewTemplatesDir directories do: [ :path | 
		newViewTemplates
			at: path basenameWithoutExtension
			put: (self getTemplatesFrom: path) ].
	newTemplates
		at:
		RideDirectoryResolver getViewTemplatesDir basenameWithoutExtension
		put: newViewTemplates.
	RideDirectoryResolver getLayoutTemplatesDir files do: [ :file | 
		(newTemplates
			 at:
			 RideDirectoryResolver getLayoutTemplatesDir
				 basenameWithoutExtension
			 ifAbsentPut: [ JsonObject new ])
			at: file basenameWithoutExtension
			put: file contents asMustacheTemplate ].
	RideDirectoryResolver getSharedTemplatesDir files do: [ :file | 
		(newTemplates
			 at:
			 RideDirectoryResolver getSharedTemplatesDir
				 basenameWithoutExtension
			 ifAbsentPut: [ JsonObject new ])
			at: file basenameWithoutExtension
			put: file contents asMustacheTemplate ].
	^ newTemplates
]

{ #category : #accessing }
RideViewControllerLocator >> getTemplatesFrom: aPath [

	"Returns a dictionary with keys being the filenames (without extension) of aPath
	and as value, the mustache template based on its content."

	| newTemplates |
	newTemplates := JsonObject new.
	aPath files do: [ :file | 
		newTemplates
			at: file basenameWithoutExtension
			put: file contents asMustacheTemplate ].

	^ newTemplates
]

{ #category : #initialization }
RideViewControllerLocator >> initializeControllers [

	^ controllers := self getControllers
]

{ #category : #initialization }
RideViewControllerLocator >> initializeTemplates [

	^ templates := self getTemplates
]

{ #category : #accessing }
RideViewControllerLocator >> layoutTemplates [

	^ self templates
		  at: #layouts
		  ifAbsent: [ 
		  RideMissingTemplateError signal: 'No layout templates' ]
]

{ #category : #accessing }
RideViewControllerLocator >> sharedTemplates [

	^ self templates
		  at: #shared
		  ifAbsent: [ 
		  RideMissingTemplateError signal: 'No shared templates' ]
]

{ #category : #accessing }
RideViewControllerLocator >> templates [

	^ templates ifNil: [ self initializeTemplates ]
]

{ #category : #accessing }
RideViewControllerLocator >> templatesFor: aController [

	^ (self templates at: #views) at: aController class basePath
]

{ #category : #accessing }
RideViewControllerLocator >> viewTemplates [

	^ self templates
		  at: #views
		  ifAbsent: [ RideMissingTemplateError signal: 'No templates for the views?' ]
]
