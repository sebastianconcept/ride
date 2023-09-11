Class {
	#name : #IntroController,
	#superclass : #RideController,
	#category : #'Ride-Controllers'
}

{ #category : #rest }
IntroController >> htmlOnPUT [

	| req |
	req := RideCurrentRequest value.
	self model userFirstName: (req entity at: #firstName).
	^ (views at: #index) value:
		  { (#firstName -> model userFirstName) } asDictionary
]
