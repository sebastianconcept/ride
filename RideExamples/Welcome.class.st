"
I'm Ride's Welcome model
"
Class {
	#name : #Welcome,
	#superclass : #RideModel,
	#instVars : [
		'userFirstName'
	],
	#category : #'RideExamples-WelcomeApp-Models'
}

{ #category : #accessing }
Welcome >> userFirstName [

	^ userFirstName
]

{ #category : #accessing }
Welcome >> userFirstName: anObject [

	userFirstName := anObject.
	self triggerEvent: #userFirstNameChanged
]
