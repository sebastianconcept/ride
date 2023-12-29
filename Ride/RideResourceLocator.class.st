"
I help locate resources
"
Class {
	#name : #RideResourceLocator,
	#superclass : #Object,
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideResourceLocator class >> appPath [

	^ self projectRootPath / 'app'
]

{ #category : #accessing }
RideResourceLocator class >> assetsDirectory [

	^ (Smalltalk os environment
		   at: 'ASSETS_PATH'
		   ifAbsent: [ Smalltalk imageDirectory / 'app' / 'assets' ])
		  asFileReference
]

{ #category : #accessing }
RideResourceLocator class >> assetsFilePath [

	^ Path from: (Smalltalk os environment
			   at: #RIDE_ASSETS_FILE_PATH
			   ifAbsent: [ self defaultAssetsFilePathString ])
]

{ #category : #accessing }
RideResourceLocator class >> assetsMapFile [

	^ self assetsMapPath / 'assets.json'
]

{ #category : #accessing }
RideResourceLocator class >> assetsMapPath [

	^ (self appPath / 'maps') asFileReference ensureCreateDirectory
]

{ #category : #accessing }
RideResourceLocator class >> baseUrl [

	^ Smalltalk os environment
		  at: #RIDE_BASE_URL
		  ifAbsent: [ self defaultBaseUrl ]
]

{ #category : #accessing }
RideResourceLocator class >> defaultAssetsFilePathString [

	^ (self appPath / 'assets') pathString
]

{ #category : #accessing }
RideResourceLocator class >> defaultBaseUrl [

	^ ''
]

{ #category : #accessing }
RideResourceLocator class >> defaultUploadsBasePath [

	^ (Smalltalk imageDirectory / 'uploads') pathString
]

{ #category : #accessing }
RideResourceLocator class >> outboxDirectory [

	^ (Smalltalk os environment
		   at: 'OUTBOX_PATH'
		   ifAbsent: [ Smalltalk imageDirectory / 'outbox' ])
		  asFileReference
]

{ #category : #accessing }
RideResourceLocator class >> projectRootPath [

	^ Path from: (Smalltalk os environment
			   at: #PROJECT_ROOT_PATH
			   ifAbsent: [ Smalltalk imageDirectory pathString ])
]

{ #category : #accessing }
RideResourceLocator class >> uploadsBaseDirectory [

	^ Path from: self uploadsBaseDirectoryString
]

{ #category : #accessing }
RideResourceLocator class >> uploadsBaseDirectoryString [

	^ Smalltalk os environment
		  at: #RIDE_UPLOAD_BASE_PATH
		  ifAbsent: [ self defaultUploadsBasePath ]
]
