Class {
	#name : #IntroController,
	#superclass : #RideController,
	#category : #'Ride-Controllers'
}

{ #category : #rest }
IntroController >> htmlOnPUT [

	super htmlOnPUT.

	^ (views at: #index) value:
		  { (#userFirstName -> model userFirstName) } asDictionary
]

{ #category : #rest }
IntroController >> setUserFirstName [

	| req |
	req := RideCurrentRequest value.
	self model userFirstName: (req entity at: #firstName).

	
]
