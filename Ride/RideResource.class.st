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

	^ self projectRootDirectory / 'app'
]

{ #category : #accessing }
RideResource class >> assetsDirectory [

	^ ([ 
	   Smalltalk os environment
		   at: 'ASSETS_PATH'
		   ifAbsent: [ Smalltalk imageDirectory / 'app' / 'assets' ] ] 
		   systemValueAt: #assetsDirectory) asFileReference
]

{ #category : #accessing }
RideResource class >> assetsDirectoryString [

	^ [ 
	  Smalltalk os environment
		  at: #RIDE_ASSETS_PATH
		  ifAbsent: [ self defaultAssetsDirectoryString ] ] systemValueAt:
		  #assetsDirectoryString
]

{ #category : #accessing }
RideResource class >> assetsFileDirectory [

	^ Path from: self assetsDirectoryString
]

{ #category : #accessing }
RideResource class >> assetsMap [

	^ [ self readAssetsMap ] systemValueAt: #assetsMap
]

{ #category : #accessing }
RideResource class >> assetsMapDirectory [

	^ (self appDirectory / 'maps') asFileReference ensureCreateDirectory
]

{ #category : #accessing }
RideResource class >> assetsMapFile [

	^ self assetsMapDirectory / 'assets.json'
]

{ #category : #actions }
RideResource class >> assetsSetUp [

	| map jsPath |
	map := self assetsMap.
	map ifEmpty: [ 
		[ 'Assets map not found.' ] logWarning.
		^ self rebuildJavaScriptAssets ].

	[ 'JavaScript assets map found.' ] logInfo.

	jsPath := (self assetsFileDirectory / 'js') asFileReference
		          ensureCreateDirectory.
	jsPath entries isEmpty ifTrue: [ 
		[ 'No JavaScript assets found.' ] logWarning.
		self buildJavaScriptAssetsFor: map ]
]

{ #category : #accessing }
RideResource class >> baseUrl [

	^ [ 
	  Smalltalk os environment
		  at: #RIDE_BASE_URL
		  ifAbsent: [ self defaultBaseUrl ] ] systemValueAt: #baseUrl
]

{ #category : #actions }
RideResource class >> buildJavaScriptAssets [

	| destinationHash destinationFile |
	[ 'Building JavaScript assets and new map...' ] logInfo.
	self javaScriptAssets keysAndValuesDo: [ 
		:presenterSelector 
		:assets | 
		assets copy keysAndValuesDo: [ :jsSelector :jsFile | 
			destinationHash := UUID new asString36.
			destinationFile := (self assetsDirectory / 'js'
			                    / (destinationHash , '.js')) asFileReference.
			self makeJavaScriptAsset: jsFile to: destinationFile.
			((self assetsMap
				  at: 'js'
				  ifAbsentPut: [ Dictionary new ])
				 at: presenterSelector
				 ifAbsentPut: [ Dictionary new ])
				at: jsSelector
				put: destinationFile basename ] ].

	[ 'JavaScript assets ready.' ] logInfo.

	self writeAssetsMap.
	[ 'JavaScript assets map updated.' ] logInfo
]

{ #category : #actions }
RideResource class >> buildJavaScriptAssetsFor: assetsMap [

	| destinationHash destinationFile mappedJsFilename |
	[ 'Building JavaScript assets as mapped...' ] logInfo.
	self javaScriptAssets keysAndValuesDo: [ :presenterSelector :assets | 
		assets copy keysAndValuesDo: [ :jsSelector :jsFile | 
			mappedJsFilename := (assetsMap js at: presenterSelector) at:
				                    jsSelector.
			destinationHash := (mappedJsFilename substrings: '.') first.
			destinationFile := (self assetsFileDirectory / 'js'
			                    / (destinationHash , '.js')) asFileReference.
			self makeJavaScriptAsset: jsFile to: destinationFile ] ].

	[ 'JavaScript assets ready.' ] logInfo
]

{ #category : #defaults }
RideResource class >> defaultAssetsDirectoryString [

	^ (self appDirectory / 'assets') pathString
]

{ #category : #defaults }
RideResource class >> defaultBaseUrl [

	^ ''
]

{ #category : #defaults }
RideResource class >> defaultUploadsBaseDirectoryString [

	^ (Smalltalk imageDirectory / 'uploads') pathString
]

{ #category : #actions }
RideResource class >> deleteJavaScriptAssets [

	(self assetsDirectory / 'js') asFileReference ensureDeleteAllChildren.
	[ 'JavaScript assets deleted.' ] logInfo
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
	self viewTemplatesDirectory asFileReference directories do: [ 
		:path | 
		jsFiles := path files select: [ :e | e extension = 'js' ].
		presenterJavaScript := SmallDictionary new.
		jsFiles do: [ :jsFile | 
			presenterJavaScript at: jsFile basenameWithoutExtension put: jsFile ].
		assets at: path basename put: presenterJavaScript ].
	^ assets asJsonObject
]

{ #category : #initialization }
RideResource class >> initializeValues [

	^ values := SmallDictionary new
]

{ #category : #accessing }
RideResource class >> javaScriptAssets [

	^ [ self getJavaScriptAssets ] systemValueAt: #javaScriptAssets
]

{ #category : #accessing }
RideResource class >> layoutTemplatesDirectory [

	^ self templatesDirectory / 'layouts'
]

{ #category : #actions }
RideResource class >> makeJavaScriptAsset: jsSourceFile to: destinationFile [

	"We can improve this by minifying it in the destination."
	self flag: #minifyJs.
	destinationFile parent ensureCreateDirectory.
	jsSourceFile copyTo: destinationFile
]

{ #category : #accessing }
RideResource class >> projectRootDirectory [

	^ Path from: self projectRootDirectoryString
]

{ #category : #accessing }
RideResource class >> projectRootDirectoryString [

	^ [ 
	  Smalltalk os environment
		  at: #PROJECT_ROOT_PATH
		  ifAbsent: [ Smalltalk imageDirectory pathString ] ] 
		  systemValueAt: #projectRootDirectoryString
]

{ #category : #actions }
RideResource class >> readAssetsMap [

	"Answers the assets cache as read from cache/assets.json"

	| file |
	file := self assetsMapFile.
	^ file exists
		  ifTrue: [ file readStreamDo: [ :stream | Json readFrom: stream ] ]
		  ifFalse: [ Dictionary new asJsonObject ]
]

{ #category : #actions }
RideResource class >> rebuildJavaScriptAssets [

	[ 'Rebuilding JavaScript assets...' ] logWarning.

	self
		deleteJavaScriptAssets;
		buildJavaScriptAssets
]

{ #category : #actions }
RideResource class >> reset [

	[ '{1} values reset' format: { self name } ] logDebug.
	values := nil
]

{ #category : #actions }
RideResource class >> resetAssetsMapFile [

	self assetsMapFile deleteIfAbsent: [ 
		^ [ 'Assets map file not found' ] logWarning ].

	[ 'Assets map file deleted' ] logInfo
]

{ #category : #accessing }
RideResource class >> sharedTemplatesDirectory [

	^ self templatesDirectory / 'shared'
]

{ #category : #accessing }
RideResource class >> tempDirectory [

	^ FileLocator temp resolve
]

{ #category : #accessing }
RideResource class >> templatesDirectory [

	^ self appDirectory / 'templates'
]

{ #category : #accessing }
RideResource class >> uploadsBaseDirectory [

	^ Path from: self uploadsBaseDirectoryString
]

{ #category : #accessing }
RideResource class >> uploadsBaseDirectoryString [

	^ [ 
	  Smalltalk os environment
		  at: #RIDE_UPLOAD_BASE_PATH
		  ifAbsent: [ self defaultUploadsBaseDirectoryString ] ] 
		  systemValueAt: #uploadsBaseDirectoryString
]

{ #category : #accessing }
RideResource class >> uploadsDirectory [

	^ self projectRootDirectory / 'uploads'
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
