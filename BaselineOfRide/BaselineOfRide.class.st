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
			group: 'Examples' with: #( 'Ride-Examples' );
			group: 'Tools' with: #( 'Ride-Tools' );
			group: 'default' with: #( 'Core' ) ]
]

{ #category : #dependencies }
BaselineOfRide >> json: spec [

	spec baseline: 'JSON' with: [ 
		spec
			loads: #( 'JSON' );
			repository: 'github://sebastianconcept/JSON/src' ]
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
				'github://sebastianconcept/Mapless:93-Support-for-SQLite/src';
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

	self json: spec.
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
			#( 'Mustache' 'ZincHTTPComponents' 'Teapot' 'JSON' 'Ride-Pharo'
			   'Mapless' 'SingularizePluralize' ) ].

	spec package: 'Ride-Tests' with: [ spec requires: #( 'Ride' ) ].
	spec package: 'Ride-Examples' with: [ spec requires: #( 'Ride' ) ].
	spec package: 'Ride-Tools' with: [ spec requires: #( 'Ride' ) ]
]

{ #category : #dependencies }
BaselineOfRide >> singularizePluralize: spec [

	spec baseline: 'SingularizePluralize' with: [ 
		spec
			loads: #( 'SingularizePluralize' );
			repository: 'github://pharo-contributions/SingularizePluralize:v1.1/src' ]
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
