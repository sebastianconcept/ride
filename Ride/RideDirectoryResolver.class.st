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

	^ OSEnvironment current
		  at: 'RIDE_WORKING_DIR'
		  ifAbsent: [ FileSystem workingDirectory ]
]

{ #category : #accessing }
RideDirectoryResolver class >> getViewsDir [

	^ self baseDirectory / 'templates' / 'views'
]
