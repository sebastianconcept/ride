"
I'm the abstract class of renderers and a renderer is a strategy to get a formated representation of a presenter with a model. My subclasses will have details and concrete examples.

"
Class {
	#name : #RideRenderer,
	#superclass : #Object,
	#instVars : [
		'isLayoutWrapper'
	],
	#category : #'Ride-Renderers'
}

{ #category : #actions }
RideRenderer >> beLayoutWrapper [

	isLayoutWrapper := true
]

{ #category : #initialization }
RideRenderer >> initialize [

	super initialize.
	isLayoutWrapper := false
]

{ #category : #testing }
RideRenderer >> isLayoutWrapper [

	^ isLayoutWrapper
]

{ #category : #rendering }
RideRenderer >> render: anAspectVariantSelector for: aRidePresenter [

	"Since it can have many, use anAspectVariantSelector 
	to decide in what aspect to render aRidePresenter."

	self subclassResponsibility
]

{ #category : #actions }
RideRenderer >> reset [

	"No-op, compatibility"

	[ '{1} reset' format: { self class name } ] logDebug
]
