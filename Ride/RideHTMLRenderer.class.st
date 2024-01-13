"
I can generate HTML programmaticaly for a Ride presenter 
"
Class {
	#name : #RideHTMLRenderer,
	#superclass : #RideProgrammaticRenderer,
	#category : #'Ride-Renderers'
}

{ #category : #rendering }
RideHTMLRenderer >> render: aRidePresenter at: anAspectVariantSelector [

	"Since it can have many, use anAspectVariantSelector 
	to decide in what aspect to render aRidePresenter."
	self halt.
]
