"
Project loader
"
Class {
	#name : #BaselineOfRide,
	#superclass : #BaselineOf,
	#category : #BaselineOfRide
}

{ #category : #actions }
BaselineOfRide >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		self setUpDependencies: spec.
		self setUpPackages: spec.
		spec
			group: 'Core' with: #( 'Ride' );
			group: 'Tests' with: #( 'Ride-Tests' );
			group: 'Examples' with: #( 'RideExamples' );
			group: 'Tools' with: #( 'Ride-Tools' );
			group: 'default' with: #( 'Core' ) ]
]

{ #category : #actions }
BaselineOfRide >> loadTaskIt [

	Metacello new
		baseline: 'TaskIt';
		repository: 'github://pharo-contributions/taskit:v1.2.0';
		onConflictUseIncoming;
		load
]

{ #category : #dependencies }
BaselineOfRide >> mustache: spec [

	spec baseline: 'Mustache' with: [ 
		spec
			repository: 'github://noha/mustache:v1.2/repository';
			loads: #( 'Core' ) ]
]

{ #category : #actions }
BaselineOfRide >> setUpDependencies: spec [

	self zinc: spec.
	self mustache: spec.
	self teapot: spec.
	
	"In RidePharo we install some general extensions 
	needed and the ones in Zinc and Teapot."
	spec package: 'RidePharo'.
	spec postLoadDoIt: #loadTaskIt.
]

{ #category : #actions }
BaselineOfRide >> setUpPackages: spec [

	spec package: 'Ride' with: [ 
		spec requires:
			#( 'Mustache' 'ZincHTTPComponents' 'Teapot' 'RidePharo' ) ].

	spec package: 'Ride-Tests' with: [ spec requires: #( 'Ride' ) ].
	spec package: 'Ride-Examples' with: [ spec requires: #( 'Ride' ) ].
	spec package: 'Ride-Tools' with: [ spec requires: #( 'Ride' ) ]
]

{ #category : #dependencies }
BaselineOfRide >> teapot: spec [

	spec baseline: 'Teapot' with: [ 
		spec
			repository: 'github://zeroflag/Teapot/source';
			loads: #( 'Deployment' ) ]
]

{ #category : #dependencies }
BaselineOfRide >> zinc: spec [

	spec baseline: 'ZincHTTPComponents' with: [ 
		spec
			repository: 'github://svenvc/zinc/repository';
			loads: #( 'default' 'WebSocket' ) ]
]
