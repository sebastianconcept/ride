"
I help locating expected files for applications following the Ride doctrine.
"
Class {
	#name : #RideDirectoryResolver,
	#superclass : #Object,
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideDirectoryResolver class >> baseDirectory [
self deprecated: 'use resources projectRootPathString based on PROJECT_ROOT_PATH'.
self halt.
	^ OSEnvironment current
		  at: 'RIDE_WORKING_DIR'
		  ifAbsent: [ FileSystem workingDirectory ]
]

{ #category : #accessing }
RideDirectoryResolver class >> emailTemplatesDirectory [

	^ self templatesDirectory / 'emails'
]

{ #category : #accessing }
RideDirectoryResolver class >> getLayoutTemplatesDir [

	^ self baseDirectory / 'templates' / 'layouts'
]

{ #category : #accessing }
RideDirectoryResolver class >> getSharedTemplatesDir [

	^ self baseDirectory / 'templates' / 'shared'
]

{ #category : #accessing }
RideDirectoryResolver class >> getTemplatesDir [

	^ self baseDirectory / 'templates'
]

{ #category : #accessing }
RideDirectoryResolver class >> getViewTemplatesDir [

	^ self baseDirectory / 'templates' / 'views'
]

{ #category : #accessing }
RideDirectoryResolver class >> layoutTemplatesDirectory [

	^ self templatesDirectory / 'layouts'
]

{ #category : #accessing }
RideDirectoryResolver class >> sharedTemplatesDirectory [

	^ self templatesDirectory / 'shared'
]

{ #category : #accessing }
RideDirectoryResolver class >> templatesDirectory [
self deprecated: 'use resources'.
self halt.
	^ self baseDirectory / 'app' / 'templates'
]

{ #category : #accessing }
RideDirectoryResolver class >> uploadsDirectory [

	^ self baseDirectory / 'uploads'
]

{ #category : #accessing }
RideDirectoryResolver class >> viewTemplatesDirectory [

	^ self templatesDirectory / 'views'
]
