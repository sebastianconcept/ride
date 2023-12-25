"
I help with the creating the boilerplate of a Model its View and its Presenter for a given model root name
"
Class {
	#name : #RideMVPHelper,
	#superclass : #RideCompositeHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideMVPHelper >> doer [

	^ doer
]

{ #category : #accessing }
RideMVPHelper >> doer: anObject [

	doer := anObject
]

{ #category : #actions }
RideMVPHelper >> for: aSymbol [

	| v |
	doer model for: aSymbol.
	doer presenter for: aSymbol.
	v := doer view mustache.
	v js: js.
	v for: aSymbol
]

{ #category : #initialization }
RideMVPHelper >> initialize [

	super initialize.

	js := false
]

{ #category : #actions }
RideMVPHelper >> withJs [

	js := true
]

{ #category : #actions }
RideMVPHelper >> withoutJs [

	js := false
]
