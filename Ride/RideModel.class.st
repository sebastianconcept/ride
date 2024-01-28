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
RideModel >> asMustacheTemplateModel [

	self deprecated: 'use asTemplateModel'.
	^ { (#name -> self class name) } asDictionary
]

{ #category : #converting }
RideModel >> asTemplateModel [

	^ { (#name -> self class name) } asDictionary
]

{ #category : #'as yet unclassified' }
RideModel >> destroyOrSignal [

	"Destroys the receiver or signals an unprocessable entity error."

	[ self destroy ]
		on: Error
		do: [ :x | RideUnprocessableEntity signal: x messageText ]
]

{ #category : #'as yet unclassified' }
RideModel >> saveOrSignal [

	"Saves the receiver or signals an unprocessable entity error."

	[ self save ]
		on: Error
		do: [ :x | RideUnprocessableEntity signal: x messageText ]
]
