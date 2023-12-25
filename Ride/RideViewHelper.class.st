"
I help with the boilerplate of the views
"
Class {
	#name : #RideViewHelper,
	#superclass : #RideBoilerplateHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideViewHelper >> mustache [

	^ RideMustacheHelper new
]
