Class {
	#name : #RideValidationError,
	#superclass : #RideError,
	#instVars : [
		'fieldName'
	],
	#category : #'Ride-Exceptions'
}

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
