"
I'm the abstract class of renderers and a renderer is a strategy to get a formated representation of a presenter with a model. My subclasses will have details and concrete examples.

"
Class {
	#name : #RideRenderer,
	#superclass : #Object,
	#category : #'Ride-Renderers'
}

{ #category : #rendering }
RideRenderer >> render: aRidePresenter at: anAspectVariantSelector [

	"Since it can have many, use anAspectVariantSelector 
	to decide in what aspect to render aRidePresenter."

	self subclassResponsibility
]
