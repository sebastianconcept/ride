"
I'm signaled when there is a need to respond with a HTTP 302 redirect

"
Class {
	#name : #RideRedirect,
	#superclass : #RideException,
	#instVars : [
		'location'
	],
	#category : #'Ride-Exceptions'
}

{ #category : #signalling }
RideRedirect class >> signalFor: location [

	^ (self new initializeOn: location) signal
]

{ #category : #initialization }
RideRedirect >> initializeOn: aString [

	location := aString
]

{ #category : #initialization }
RideRedirect >> location [

	^ location asString
]

{ #category : #initialization }
RideRedirect >> messageText [

	^ self location
]
