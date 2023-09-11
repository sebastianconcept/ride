"
I'm the abstract class of the models in Ride applications
"
Class {
	#name : #RideModel,
	#superclass : #Object,
	#category : #'Ride-Models'
}

{ #category : #querying }
RideModel class >> findId: anId [

	^ Ride repository find: self atId: anId
]
