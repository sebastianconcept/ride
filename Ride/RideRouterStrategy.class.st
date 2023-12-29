"
I am the abstract Ride router strategy, my subclasses have the details
"
Class {
	#name : #RideRouterStrategy,
	#superclass : #Object,
	#category : #'Ride-HTTP'
}

{ #category : #'as yet unclassified' }
RideRouterStrategy class >> presenterClassFor: aModelClass [

	| presenterClassName |
	presenterClassName := '{1}Presenter' format: { aModelClass name }.
	^ Smalltalk
		  at: presenterClassName asSymbol
		  ifAbsent: [ 
		  RideError signal: presenterClassName , ' was not found' ]
]
