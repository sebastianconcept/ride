"
I help with the creating the boilerplate of a Model its and its Controllers to implement an API for a given model root name
"
Class {
	#name : #RideAPIHelper,
	#superclass : #RideCompositeHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideAPIHelper >> crud [

	^ RideAPICRUDHelper new
		  doer: doer;
		  yourself
]

{ #category : #actions }
RideAPIHelper >> for: aSymbol [

	self crud for: aSymbol
]
