"
I am the abstract Ride router strategy, my subclasses have the details.
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

{ #category : #accessing }
RideRouterStrategy >> getShowPathFor: aRideModel [

	^ aRideModel class name asPlural asSnakeCase
]

{ #category : #accessing }
RideRouterStrategy >> getShowUrlFor: aRideModel [

	"Answers the conventional URL for the given RideModel"

	^ '/{1}/{2}' format: { 
			  (self getShowPathFor: aRideModel).
			  aRideModel id asString }
]
