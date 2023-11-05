"
I am the welcoming web app of the Rider framework
"
Class {
	#name : #RideWelcomeApp,
	#superclass : #RideService,
	#category : #'RideExamples-WelcomeApp-Core'
}

{ #category : #'instance creation' }
RideWelcomeApp class >> newSessionWith: sessionId [

	^ RideSession newWith: sessionId on: WelcomePresenter new
]

{ #category : #initialization }
RideWelcomeApp >> initializeServer [

	^ server := RideWelcomeAppServer new
]
