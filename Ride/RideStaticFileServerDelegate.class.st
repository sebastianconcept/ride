Class {
	#name : #RideStaticFileServerDelegate,
	#superclass : #ZnStaticFileServerDelegate,
	#category : #Ride
}

{ #category : #public }
RideStaticFileServerDelegate >> actualFilenameFor: uri [

	^ ('js' match: uri segments last asFileReference extension)
		  ifTrue: [ uri segments last ]
		  ifFalse: [ super actualFilenameFor: uri ]
]

{ #category : #public }
RideStaticFileServerDelegate >> handleRequest: request [

	"Server delegate entry point"

	| actualFilename |

	(#( #GET #HEAD ) includes: request method) ifFalse: [ 
		^ ZnResponse methodNotAllowed: request ].
	actualFilename := self actualFilenameFor: request uri.
	^ (self isJavaScript: request)
		  ifTrue: [ 
		  self
			  responseForJavaScriptFile: actualFilename
			  fromRequest: request ]
		  ifFalse: [ super handleRequest: request ]
]

{ #category : #testing }
RideStaticFileServerDelegate >> isJavaScript: request [

	^ 'js' match: request uri segments last asFileReference extension
]

{ #category : #public }
RideStaticFileServerDelegate >> responseForJavaScriptFile: filename fromRequest: aRequest [

	"Serves the JavaScript file from the directory (sourceDir) corresponding to the presenter matching the URI path."

	| sourceDir file entry size time mimeType fileStream entity response modified |
	aRequest uri segments size > 2 ifTrue: [ 
		self error: 'Not supporting more than 1 level yet.' ].
	sourceDir := aRequest uri segments size = 1
		             ifFalse: [ 
			             self flag: #todo.
			             self notYetImplemented.
			             "need to implement when the js is for a presenter other than root."
			             RideDirectoryResolver viewTemplatesDirectory ]
		             ifTrue: [ 
			             RideDirectoryResolver viewTemplatesDirectory
			             / Ride service class rootPresenterClass basePath ].

	file := sourceDir / filename.
	entry := file entry.
	size := entry size.
	time := entry modificationTime.
	modified := true.
	aRequest headers at: 'If-Modified-Since' ifPresent: [ 
		modified := time
		            >
		            (ZnUtils parseHttpDate:
			             (aRequest headers at: 'If-Modified-Since')) ].
	modified
		ifTrue: [ 
			mimeType := ZnMimeType forFilenameExtension: file extension.

			fileStream := file readStream.
			(entity := ZnStreamingEntity type: mimeType length: size) stream:
				fileStream.
			(response := ZnResponse ok: entity) headers
				at: 'Modification-Date'
				put: (ZnUtils httpDate: time).
			(self maxAgeFor: mimeType) ifNotNil: [ :maxAge | 
				response headers at: 'Cache-Control' put: maxAge ].
			(self expirationDateFor: mimeType) ifNotNil: [ :expirationDate | 
				response headers at: 'Expires' put: expirationDate ] ]
		ifFalse: [ response := ZnResponse notModified ].
	^ response
]
