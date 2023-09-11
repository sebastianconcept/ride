"
I am the welcoming web app of the Rider framework
"
Class {
	#name : #RideWelcomeApp,
	#superclass : #RideService,
	#category : #'Ride-Core'
}

{ #category : #initialization }
RideWelcomeApp >> initializeServer [

	^ server := RideWelcomeAppServer new
]
