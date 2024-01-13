"
I help creating the app model superclass
"
Class {
	#name : #RideAbstractModelClassHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideAbstractModelClassHelper >> classNameFor: aSymbol [

	^ '{1}Model' format: { aSymbol }
]

{ #category : #actions }
RideAbstractModelClassHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the abstract parent for the {1} Ride-based application models.' 
		  format: { aSymbol asString }
]

{ #category : #accessing }
RideAbstractModelClassHelper >> targetPackageNameTag [

	^ 'Models'
]

{ #category : #accessing }
RideAbstractModelClassHelper >> targetedSuperclassFor: aSymbol [

	^ RideModel
]
