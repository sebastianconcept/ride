"
I define how the requests are routed in Ride.

I have a strategy with the details on how that happens.
"
Class {
	#name : #RideRouter,
	#superclass : #Object,
	#instVars : [
		'rootComponentGetter',
		'strategy'
	],
	#category : #'Ride-HTTP'
}

{ #category : #initialization }
RideRouter >> beDeclarative [

	strategy := RideDeclarativeRouting new
]

{ #category : #initialization }
RideRouter >> beSubcomponent [

	strategy := RideSubcomponentRouting new
]

{ #category : #accessing }
RideRouter >> domain [

	^ [ Smalltalk os environment at: #DOMAIN ifAbsent: [ 'localhost' ] ] 
		  systemValueAt: #domain
]

{ #category : #initialization }
RideRouter >> setRoutesOn: aRideServer [

	Ride log: 'Routes definition:'.
	self strategy setRoutesOn: aRideServer
]

{ #category : #initialization }
RideRouter >> strategy [

	^ strategy ifNil: [ 
		  RideError signal: 'Router strategy was not defined' ]
]
