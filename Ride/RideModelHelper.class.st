"
I'm a Ride helper dedicated to boilerplate a model
"
Class {
	#name : #RideModelHelper,
	#superclass : #RideBoilerplateHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideModelHelper class >> newClassNamed: className [

	^ self newClassNamed: className withSuperclass: RideModel
]
