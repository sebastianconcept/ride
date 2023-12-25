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

	^ RideMVPCRUDHelper new
]

{ #category : #actions }
RideMVCHelper >> for: aSymbol [

	| v |
	doer model for: aSymbol.
	doer presenter for: aSymbol.
	v := doer view mustache.
	v js: js.
	v for: aSymbol
]
