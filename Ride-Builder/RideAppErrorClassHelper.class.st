"
I help with the creation of the Error class for the application so app specific errors can be signaled or subclassified from it.
"
Class {
	#name : #RideAppErrorClassHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RideAppErrorClassHelper >> classNameFor: aSymbol [

	^ '{1}Error' format: { aSymbol }
]

{ #category : #actions }
RideAppErrorClassHelper >> defaultCommentsFor: aSymbol [

	^ 'I represent an Error specific of the {1} Ride-based application.' 
		  format: { aSymbol asString }
]

{ #category : #accessing }
RideAppErrorClassHelper >> targetPackageNameTag [

	^ 'Errors'
]

{ #category : #accessing }
RideAppErrorClassHelper >> targetedSuperclassFor: aSymbol [

	^ RideError
]
