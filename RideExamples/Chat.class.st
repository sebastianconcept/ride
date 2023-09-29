"
I model the Chat of the chat demo app
"
Class {
	#name : #Chat,
	#superclass : #RideModel,
	#instVars : [
		'chatMessages',
		'userFirstName'
	],
	#category : #'RideExamples-WelcomeApp-Models'
}

{ #category : #accessing }
Chat >> chatMessages [

	^ chatMessages
]

{ #category : #accessing }
Chat >> chatMessages: anObject [

	chatMessages := anObject
]

{ #category : #accessing }
Chat >> userFirstName [

	^ userFirstName
]

{ #category : #accessing }
Chat >> userFirstName: anObject [

	userFirstName := anObject
]
