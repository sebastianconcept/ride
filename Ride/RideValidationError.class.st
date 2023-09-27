Class {
	#name : #RideValidationError,
	#superclass : #RideError,
	#instVars : [
		'fieldName'
	],
	#category : #'Ride-Exceptions'
}

{ #category : #'instance creation' }
RideValidationError class >> for: aSymbol signal: aString [

	^ self new
		  fieldName: aSymbol;
		  signal: aString
]

{ #category : #'as yet unclassified' }
RideValidationError >> describeOn: aJsonObjectToRespond [

	^ aJsonObjectToRespond
		  at: fieldName put: self messageText;
		  yourself
]

{ #category : #accessing }
RideValidationError >> fieldName [

	^ fieldName
]

{ #category : #accessing }
RideValidationError >> fieldName: anObject [

	fieldName := anObject
]
