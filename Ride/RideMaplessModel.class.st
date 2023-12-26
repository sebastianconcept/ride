"
I'm the abstract class for Mapless based Ride models
"
Class {
	#name : #RideMaplessModel,
	#superclass : #Mapless,
	#category : #'Ride-Models'
}

{ #category : #converting }
RideMaplessModel >> asTemplateModel [

	^ { (#name -> self class name) } asDictionary
]
