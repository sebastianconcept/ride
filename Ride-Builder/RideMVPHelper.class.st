"
I help with the creating the boilerplate of a Model its View and its Presenter for a given model root name
"
Class {
	#name : #RideMVPHelper,
	#superclass : #RideCompositeHelper,
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RideMVPHelper >> crud [

	^ RideMVPCRUDHelper new
		  doer: builder;
		  yourself
]

{ #category : #actions }
RideMVPHelper >> for: aSymbol [

	| view |
	builder model for: aSymbol.
	builder presenter for: aSymbol.
	view := builder view stt.
	view js: js.
	view for: aSymbol
]
