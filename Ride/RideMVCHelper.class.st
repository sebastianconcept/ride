"
I help with the creating the boilerplate of a Model its View and its Controller for a given model root name
"
Class {
	#name : #RideMVCHelper,
	#superclass : #RideCompositeHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideMVCHelper >> crud [

	^ RideMVCCRUDHelper new
		  doer: doer;
		  yourself
]

{ #category : #actions }
RideMVCHelper >> for: aSymbol [

	self notYetImplemented
]
