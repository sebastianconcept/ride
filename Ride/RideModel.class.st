"
I'm the abstract class of the models in Ride applications
"
Class {
	#name : #RideModel,
	#superclass : #Mapless,
	#category : #'Ride-Models'
}

{ #category : #querying }
RideModel class >> findId: anId [

	^ self getRepository find: self atId: anId
]

{ #category : #querying }
RideModel class >> getRepository [

	^ Ride service repository
]

{ #category : #converting }
RideModel >> asTemplateModel [

	^ { (#name -> self class name) } asDictionary
]
