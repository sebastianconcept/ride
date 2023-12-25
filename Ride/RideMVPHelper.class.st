"
I help with the creating the boilerplate of a Model its View and its Presenter for a given model root name
"
Class {
	#name : #RideMVPHelper,
	#superclass : #RideCompositeHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideMVPHelper >> crud [

	^ RideMVPCRUDHelper new
		  doer: doer;
		  yourself
]

{ #category : #actions }
RideMVPHelper >> for: aSymbol [

	| view |
	doer model for: aSymbol.
	doer presenter for: aSymbol.
	view := doer view mustache.
	view js: js.
	view for: aSymbol
]
