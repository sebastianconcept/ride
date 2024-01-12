Class {
	#name : #RideAppErrorClassHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Boilerplate'
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
RideAppErrorClassHelper >> targetedSuperclass [

	^ RideError
]
