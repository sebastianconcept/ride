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
			group: 'Builder' with: #( 'Ride-Builder' );
			group: 'Tests' with: #( 'Ride-Tests' );
			group: 'Examples' with: #( 'Ride-Examples' );
			group: 'default' with: #( 'Core' 'Builder' ) ]
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
BaselineOfRide >> mapless: spec [

	spec baseline: 'Mapless' with: [ 
		spec
			repository:
				'github://sebastianconcept/Mapless:v0.7.0/src';
			loads: #( 'Core' 'Memory' 'SQLite' ) ]
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

	self sst: spec.
	self mapless: spec.	
	self zinc: spec.
	self mustache: spec.
	self teapot: spec.
	self singularizePluralize: spec.
	
	"In Ride-Pharo we install some general extensions 
	needed for Pharo, plus extensions for Zinc and Teapot."
	spec package: 'Ride-Pharo'.
	spec postLoadDoIt: #loadTaskIt.
]

{ #category : #actions }
BaselineOfRide >> setUpPackages: spec [

	spec package: 'Ride' with: [ 
		spec requires:
			#( 'Mustache' 'ZincHTTPComponents' 'Teapot' 'Ride-Pharo'
			   'Mapless' 'SingularizePluralize' 'STTemplate' ) ].

	spec package: 'Ride-Builder' with: [ spec requires: #( 'Ride' ) ].
	spec
		package: 'Ride-Tests'
		with: [ spec requires: #( 'Ride' ) ].
	spec package: 'Ride-Examples' with: [ spec requires: #( 'Ride' ) ].
	spec package: 'Ride-Tests' with: [ spec requires: #( 'Ride' ) ]
]

{ #category : #dependencies }
BaselineOfRide >> singularizePluralize: spec [

	spec baseline: 'SingularizePluralize' with: [ 
		spec
			loads: #( 'SingularizePluralize' );
			repository: 'github://pharo-contributions/SingularizePluralize:v1.1/src' ]
]

{ #category : #dependencies }
BaselineOfRide >> sst: spec [

	spec baseline: 'STTemplate' with: [ 
		spec
			repository: 'github://sebastianconcept/STTemplate:v0.2.0';
			loads: #( 'Core' ) ]
]

{ #category : #dependencies }
BaselineOfRide >> teapot: spec [

	spec baseline: 'Teapot' with: [ 
		spec
			repository: 'github://zeroflag/Teapot:v2.7.0/source';
			loads: #( 'Deployment' ) ]
]

{ #category : #dependencies }
BaselineOfRide >> zinc: spec [

	spec baseline: 'ZincHTTPComponents' with: [ 
		spec
			repository: 'github://svenvc/zinc:v5/repository';
			loads: #( 'default' 'WebSocket' ) ]
]
