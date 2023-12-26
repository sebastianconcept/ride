"
I'm the abstract class of the models in Ride applications
"
Class {
	#name : #RideModel,
	#superclass : #Mapless,
	#category : #'Ride-Models'
}

{ #category : #querying }
RideModel class >> getRepository [

	^ Ride service repository
]

{ #category : #converting }
RideModel >> asTemplateModel [

	^ { (#name -> self class name) } asDictionary
]
