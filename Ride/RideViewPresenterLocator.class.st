"
I help locating the templates that are meant to be views.
"
Class {
	#name : #RideViewPresenterLocator,
	#superclass : #Object,
	#instVars : [
		'templates',
		'presenters',
		'javaScriptAssets',
		'assetsMap'
	],
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideViewPresenterLocator >> appPath [
	self deprecated: 'using resources'.
	self halt.
	^ self projectRootDirectory / 'app'
]

{ #category : #accessing }
RideViewPresenterLocator >> assetsFilePath [
	self deprecated: 'using resources'.
	self halt.
	^ Path from: (Smalltalk os environment
			   at: #RIDE_ASSETS_FILE_PATH
			   ifAbsent: [ self defaultAssetsFilePathString ])
]

{ #category : #accessing }
RideViewPresenterLocator >> assetsMap [
self flag: #deprecated.
self halt.
	^ assetsMap ifNil: [ self initializeAssetsMap ]
]

{ #category : #accessing }
RideViewPresenterLocator >> assetsMapFile [
self deprecated: 'use locator'.
self halt.
	^ self assetsMapPath / 'assets.json'
]

{ #category : #accessing }
RideViewPresenterLocator >> assetsMapPath [
	self deprecated: 'using resources'.
	self halt.
	^ (self appPath / 'maps') asFileReference ensureCreateDirectory
]

{ #category : #accessing }
RideViewPresenterLocator >> defaultAssetsFilePathString [
	self deprecated: 'using resources'.
	self halt.
	^ (self appPath / 'assets') pathString
]

{ #category : #accessing }
RideViewPresenterLocator >> getJavaScriptAssets [

	"Returns a dictionary with keys being view names (views/ dsubirectory names) 
	and as value, a dictionary with the .js file names as keys and their content as value"

	| assets jsFiles presenterJavaScript |
	self deprecated: 'using resources'.
	self halt.
	assets := Dictionary new.
	RideDirectoryResolver viewTemplatesDirectory directories do: [ :path | 
		jsFiles := path files select: [ :e | e extension = 'js' ].
		presenterJavaScript := Dictionary new.
		jsFiles do: [ :jsFile | 
			presenterJavaScript at: jsFile basenameWithoutExtension put: jsFile ].
		assets at: path basename put: presenterJavaScript ].
	^ assets
]

{ #category : #accessing }
RideViewPresenterLocator >> getMustacheTemplatesIn: aPath [

	"Returns only the .mustache template files in aPath"

	| accepted |
		self deprecated: 'use resources'.
self halt.
	accepted := #( mustache mst ms tmpl ).
	^ aPath files select: [ :file | accepted includes: file extension ]
]

{ #category : #accessing }
RideViewPresenterLocator >> getPresenters [

	"Returns a dictionary with keys being view names (views/ subdirectory names) 
	and as value, the corresponding presenter classes expected to be found in the image."

	| newPresenters |
		self deprecated: 'using resources'.
	self halt.
	newPresenters := Dictionary new.
	self viewTemplates keys do: [ :routeName | 
		newPresenters at: routeName put: (Smalltalk
				 at:
				 (RideNameNormalizer presenterNameFromURISegment: routeName)
					 asSymbol
				 ifAbsent: [ 
					 RideMissingPresenterError signal: ('{1} not found' format:
							  { (RideNameNormalizer presenterNameFromURISegment: routeName) }) ]) ].
	^ newPresenters
]

{ #category : #accessing }
RideViewPresenterLocator >> getTemplates [

	"Returns a dictionary with keys being view names (views/ dsubirectory names) 
	and as value, a dictionary with mustache templates for every file found."

	| newTemplates newViewTemplates newEmailTemplates |
	self deprecated: 'use resources'.
self halt.
	newTemplates := JsonObject new.
	newViewTemplates := JsonObject new.
	RideDirectoryResolver viewTemplatesDirectory directories do: [ :path | 
		newViewTemplates
			at: path basenameWithoutExtension
			put: (self getTemplatesFrom: path) ].
	newTemplates
		at:
		RideDirectoryResolver viewTemplatesDirectory
			basenameWithoutExtension
		put: newViewTemplates.
	RideDirectoryResolver layoutTemplatesDirectory files do: [ :file | 
		(newTemplates
			 at: RideDirectoryResolver layoutTemplatesDirectory
					 basenameWithoutExtension
			 ifAbsentPut: [ JsonObject new ])
			at: file basenameWithoutExtension
			put: file contents asMustacheTemplate ].
	RideDirectoryResolver sharedTemplatesDirectory files do: [ :file | 
		(newTemplates
			 at: RideDirectoryResolver sharedTemplatesDirectory
					 basenameWithoutExtension
			 ifAbsentPut: [ JsonObject new ])
			at: file basenameWithoutExtension
			put: file contents asMustacheTemplate ].
	newEmailTemplates := JsonObject new.
	RideDirectoryResolver emailTemplatesDirectory directories do: [ :path | 
		newEmailTemplates
			at: path basenameWithoutExtension
			put: (self getTemplatesFrom: path) ].
	newTemplates
		at:
		RideDirectoryResolver emailTemplatesDirectory
			basenameWithoutExtension
		put: newEmailTemplates.
	^ newTemplates
]

{ #category : #accessing }
RideViewPresenterLocator >> getTemplatesFrom: aPath [

	"Returns a dictionary with keys being the filenames (without extension) of aPath
	and as value, the mustache template based on its content."

	| newTemplates |
		self deprecated: 'using resources'.
	self halt.
	newTemplates := JsonObject new.
	(self getMustacheTemplatesIn: aPath) do: [ :file | 
		newTemplates
			at: file basenameWithoutExtension
			put: file contents asMustacheTemplate ].

	^ newTemplates
]

{ #category : #initialization }
RideViewPresenterLocator >> initializeAssetsMap [
	self deprecated: 'using resources'.
	self halt.
	^ assetsMap := self readAssetsMap
]

{ #category : #initialization }
RideViewPresenterLocator >> initializeJavaScriptAssets [
	self deprecated: 'using resources'.
	self halt.
	^ javaScriptAssets := self getJavaScriptAssets
]

{ #category : #initialization }
RideViewPresenterLocator >> initializePresenters [
	self deprecated: 'using resources'.
	self halt.
	^ presenters := self getPresenters
]

{ #category : #initialization }
RideViewPresenterLocator >> initializeTemplates [
	self deprecated: 'using resources'.
	self halt.
	^ templates := self getTemplates
]

{ #category : #accessing }
RideViewPresenterLocator >> javaScriptAssets [
self deprecated: 'use resources'.
self halt.
	^ javaScriptAssets ifNil: [ self initializeJavaScriptAssets ]
]

{ #category : #accessing }
RideViewPresenterLocator >> layoutTemplates [
	self deprecated: 'using resources'.
	self halt.

	^ self templates
		  at: #layouts
		  ifAbsent: [ 
		  RideMissingTemplateError signal: 'No layout templates' ]
]

{ #category : #accessing }
RideViewPresenterLocator >> presenterNameFor: routeName [
	self deprecated: 'using resources'.
	self halt.
	^ '{1}Presenter' format: { ('' join:
			   ((routeName substrings: '_') collect: [ :e | e capitalized ])) }
]

{ #category : #accessing }
RideViewPresenterLocator >> presenters [
	self deprecated: 'using resources'.
	self halt.
	^ presenters ifNil: [ self initializePresenters ]
]

{ #category : #accessing }
RideViewPresenterLocator >> projectRootDirectory [
	self deprecated: 'using resources'.
	self halt.

	^ Path from: (Smalltalk os environment
			   at: #PROJECT_ROOT_PATH
			   ifAbsent: [ Smalltalk imageDirectory pathString ])
]

{ #category : #actions }
RideViewPresenterLocator >> readAssetsMap [

	"Answers the assets cache as read from cache/assets.json"

	| file |
	self deprecated: 'use locator'.
	self halt.
	file := self assetsMapFile.
	^ file exists
		  ifTrue: [ file readStreamDo: [ :stream | Json readFrom: stream ] ]
		  ifFalse: [ Dictionary new ]
]

{ #category : #accessing }
RideViewPresenterLocator >> sharedTemplates [
	self deprecated: 'using resources'.
	^ self templates
		  at: #shared
		  ifAbsent: [ 
		  RideMissingTemplateError signal: 'No shared templates' ]
]

{ #category : #accessing }
RideViewPresenterLocator >> templates [
	self deprecated: 'use Ride resource'.
	self halt.
	^ templates ifNil: [ self initializeTemplates ]
]

{ #category : #accessing }
RideViewPresenterLocator >> templatesFor: aPresenter [

	"Answers the mustache templates that correspond to aPresenter.
	The convention that is followed is to find the presenter's 
	model name in snake_case or kebab-case on disk."

	| views modelName kebabized found |
		self deprecated: 'using resources'.
	self halt.
	views := self templates at: #views.
	modelName := aPresenter class getModelName.
	kebabized := '-' join: (modelName asSnakeCase substrings: '_').
	found := views at: kebabized.
	^ found
		  ifNil: [ views at: modelName asSnakeCase ]
		  ifNotNil: [ found ]
]

{ #category : #accessing }
RideViewPresenterLocator >> templatesPath [
	self deprecated: 'using resources'.
	self halt.
	^ self appPath / 'templates'
]

{ #category : #accessing }
RideViewPresenterLocator >> viewTemplates [
	self deprecated: 'use Ride resource'.
	self halt.


	^ self templates
		  at: #views
		  ifAbsent: [ RideMissingTemplateError signal: 'No templates for the views?' ]
]

{ #category : #accessing }
RideViewPresenterLocator >> viewsPath [
	self deprecated: 'use Ride resource'.
	self halt.

	^ self templatesPath / 'views'
]

{ #category : #actions }
RideViewPresenterLocator >> writeAssetsMap [

	"Writes the assets map in maps/assets.json"

	| file |
	self deprecated: 'use Ride resource'.
	self halt.
	file := self assetsMapFile.

	file exists ifTrue: [ 
		file writeStreamDo: [ :stream | stream truncate ] ].

	file writeStreamDo: [ :stream | 
		stream nextPutAll: self assetsMap asJsonString ]
]
