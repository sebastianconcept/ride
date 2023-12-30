"
I help to locate and answer resources
"
Class {
	#name : #RideResource,
	#superclass : #Object,
	#classInstVars : [
		'values'
	],
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideResource class >> appDirectory [

	^ self projectRootDirectory/ 'app'
]

{ #category : #accessing }
RideResource class >> assetsDirectory [

	^ (self values at: #assetsDirectory ifAbsentPut: [ 
		   Smalltalk os environment
			   at: 'ASSETS_PATH'
			   ifAbsent: [ Smalltalk imageDirectory / 'app' / 'assets' ] ])
		  asFileReference
]

{ #category : #accessing }
RideResource class >> assetsDirectoryString [

	^ self values at: #assetsDirectoryString ifAbsentPut: [ 
		  Smalltalk os environment
			  at: #RIDE_ASSETS_PATH
			  ifAbsent: [ self defaultAssetsDirectoryString ] ]
]

{ #category : #accessing }
RideResource class >> assetsFileDirectory [

	^ Path from: self assetsDirectoryString
]

{ #category : #accessing }
RideResource class >> assetsMap [

	^ self values at: #assetsMap ifAbsentPut: [ self readAssetsMap ]
]

{ #category : #accessing }
RideResource class >> assetsMapDirectory [

	^ (self appDirectory / 'maps') asFileReference ensureCreateDirectory
]

{ #category : #accessing }
RideResource class >> assetsMapFile [

	^ self assetsMapDirectory / 'assets.json'
]

{ #category : #accessing }
RideResource class >> baseUrl [

	^ self values at: #baseUrl ifAbsentPut: [ 
		  Smalltalk os environment
			  at: #RIDE_BASE_URL
			  ifAbsent: [ self defaultBaseUrl ] ]
]

{ #category : #accessing }
RideResource class >> defaultAssetsDirectoryString [

	^ (self appDirectory / 'assets') pathString
]

{ #category : #accessing }
RideResource class >> defaultBaseUrl [

	^ ''
]

{ #category : #accessing }
RideResource class >> defaultUploadsBaseDirectoryString [

	^ (Smalltalk imageDirectory / 'uploads') pathString
]

{ #category : #accessing }
RideResource class >> emailTemplatesDirectory [

	^ self templatesDirectory / 'emails'
]

{ #category : #accessing }
RideResource class >> getJavaScriptAssets [

	"Returns a dictionary with keys being view names (views/ dsubirectory names) 
	and as value, a dictionary with the .js file names as keys and their content as value"

	| assets jsFiles presenterJavaScript |
	assets := SmallDictionary new.
	Ride resource viewTemplatesDirectory asFileReference directories do: [ 
		:path | 
		jsFiles := path files select: [ :e | e extension = 'js' ].
		presenterJavaScript := SmallDictionary new.
		jsFiles do: [ :jsFile | 
			presenterJavaScript at: jsFile basenameWithoutExtension put: jsFile ].
		assets at: path basename put: presenterJavaScript ].
	^ assets asJsonObject
]

{ #category : #accessing }
RideResource class >> getMustacheTemplagesIn: aPath [

	"Returns only the .mustache template files in aPath"

	| accepted |
	accepted := #( mustache mst ms tmpl ).
	^ aPath files select: [ :file | accepted includes: file extension ]
]

{ #category : #accessing }
RideResource class >> getTemplates [

	"Returns a dictionary with keys being view names (views/ dsubirectory names) 
	and as value, a dictionary with mustache templates for every file found."

	| newTemplates newViewTemplates newEmailTemplates |
	newTemplates := JsonObject new.
	newViewTemplates := JsonObject new.
	self viewTemplatesDirectory asFileReference directories do: [ :path | 
		newViewTemplates
			at: path basenameWithoutExtension
			put: (self getTemplatesFrom: path) ].
	newTemplates
		at: self viewTemplatesDirectory basenameWithoutExtension
		put: newViewTemplates.
	self layoutTemplatesDirectory asFileReference files do: [ :file | 
		(newTemplates
			 at:
			 Ride resource layoutTemplatesDirectory basenameWithoutExtension
			 ifAbsentPut: [ JsonObject new ])
			at: file basenameWithoutExtension
			put: file contents asMustacheTemplate ].
	Ride resource sharedTemplatesDirectory asFileReference files do: [ 
		:file | 
		(newTemplates
			 at:
			 Ride resource sharedTemplatesDirectory basenameWithoutExtension
			 ifAbsentPut: [ JsonObject new ])
			at: file basenameWithoutExtension
			put: file contents asMustacheTemplate ].
	newEmailTemplates := JsonObject new.
	Ride resource emailTemplatesDirectory asFileReference directories 
		do: [ :path | 
			newEmailTemplates
				at: path basenameWithoutExtension
				put: (self getTemplatesFrom: path) ].
	newTemplates
		at: Ride resource emailTemplatesDirectory basenameWithoutExtension
		put: newEmailTemplates.
	^ newTemplates
]

{ #category : #accessing }
RideResource class >> getTemplatesFrom: aPath [

	"Returns a dictionary with keys being the filenames (without extension) of aPath
	and as value, the mustache template based on its content."

	| newTemplates |
	newTemplates := JsonObject new.
	(self getMustacheTemplagesIn: aPath) do: [ :file | 
		newTemplates
			at: file basenameWithoutExtension
			put: file contents asMustacheTemplate ].

	^ newTemplates
]

{ #category : #initialization }
RideResource class >> initializeValues [

	^ values := SmallDictionary new
]

{ #category : #accessing }
RideResource class >> javaScriptAssets [

	^ self values
		  at: #javaScriptAssets
		  ifAbsentPut: [ self getJavaScriptAssets ]
]

{ #category : #accessing }
RideResource class >> layoutTemplatesDirectory [

	^ self templatesDirectory / 'layouts'
]

{ #category : #accessing }
RideResource class >> outboxDirectory [

	^ (self values at: #outboxDirectory ifAbsentPut: [ 
		   Smalltalk os environment
			   at: 'OUTBOX_PATH'
			   ifAbsent: [ Smalltalk imageDirectory / 'outbox' ] ])
		  asFileReference
]

{ #category : #accessing }
RideResource class >> projectRootDirectory [

	^ Path from: self projectRootDirectoryString
]

{ #category : #accessing }
RideResource class >> projectRootDirectoryString [

	^ self values at: #projectRootDirectoryString ifAbsentPut: [ 
		  Smalltalk os environment
			  at: #PROJECT_ROOT_PATH
			  ifAbsent: [ Smalltalk imageDirectory pathString ] ]
]

{ #category : #actions }
RideResource class >> readAssetsMap [

	"Answers the assets cache as read from cache/assets.json"

	| file |
	file := self assetsMapFile.
	^ file exists
		  ifTrue: [ file readStreamDo: [ :stream | Json readFrom: stream ] ]
		  ifFalse: [ SmallDictionary new asJsonObject ]
]

{ #category : #actions }
RideResource class >> reset [

	values := nil
]

{ #category : #actions }
RideResource class >> resetAssetsMapFile [

	self assetsMapFile deleteIfAbsent: [ 
		^ Ride log: 'Assets map file not found' level: #WARNING ].

	Ride log: 'Assets map file deleted' level: #INFO
]

{ #category : #accessing }
RideResource class >> sharedTemplates [

	^ self templates
		  at: #shared
		  ifAbsent: [ 
		  RideMissingTemplateError signal: 'No shared templates were found' ]
]

{ #category : #accessing }
RideResource class >> sharedTemplatesDirectory [

	^ self templatesDirectory / 'shared'
]

{ #category : #accessing }
RideResource class >> templates [

	^ self values at: #templates ifAbsentPut: [ self getTemplates ]
]

{ #category : #accessing }
RideResource class >> templatesDirectory [

	^ self appDirectory / 'templates'
]

{ #category : #accessing }
RideResource class >> templatesFor: aPresenter [

	"Answers the mustache templates that correspond to aPresenter.
	The convention that followed by this resource helper is to find 
	the presenter's model name in snake_case or kebab-case on disk."

	| views modelName kebabized found |
	views := self templates at: #views.
	modelName := aPresenter class getModelName.
	kebabized := '-' join: (modelName asSnakeCase substrings: '_').
	found := views at: kebabized.
	^ found
		  ifNil: [ views at: modelName asSnakeCase ]
		  ifNotNil: [ found ]
]

{ #category : #accessing }
RideResource class >> uploadsBaseDirectory [

	^ Path from: self uploadsBaseDirectoryString
]

{ #category : #accessing }
RideResource class >> uploadsBaseDirectoryString [

	^ self values at: #uploadsBaseDirectoryString ifAbsentPut: [ 
		  Smalltalk os environment
			  at: #RIDE_UPLOAD_BASE_PATH
			  ifAbsent: [ self defaultUploadsBaseDirectoryString ] ]
]

{ #category : #accessing }
RideResource class >> values [

	^ values ifNil: [ self initializeValues ]
]

{ #category : #accessing }
RideResource class >> viewTemplatesDirectory [

	^ self templatesDirectory / 'views'
]

{ #category : #accessing }
RideResource class >> viewsDirectory [

	^ self templatesDirectory / 'views'
]

{ #category : #actions }
RideResource class >> writeAssetsMap [

	"Writes the assets map in maps/assets.json"

	| file |
	file := self assetsMapFile.

	file exists ifTrue: [ 
		file writeStreamDo: [ :stream | stream truncate ] ].

	file writeStreamDo: [ :stream | 
		stream nextPutAll: self assetsMap asJsonString ]
]
