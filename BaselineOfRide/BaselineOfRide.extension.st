Extension { #name : #BaselineOfRide }

{ #category : #'*BaselineOfFlox' }
BaselineOfRide >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		self setUpDependencies: spec.
		self setUpPackages: spec.
		spec
			group: 'Core' with: #( 'Ride' );
			group: 'Tests' with: #( 'Ride-Tests' );
			group: 'Tools' with: #( 'Ride-Tools' );
			group: 'default' with: #( 'Core' ) ]
]

{ #category : #'*BaselineOfFlox' }
BaselineOfRide >> loadTaskIt [

	Metacello new
		baseline: 'TaskIt';
		repository: 'github://pharo-contributions/taskit:v1.2.0';
		onConflictUseIncoming;
		load
]

{ #category : #'*BaselineOfFlox' }
BaselineOfRide >> mustache: spec [

	spec baseline: 'Mustache' with: [ 
		spec
			repository: 'github://noha/mustache:v1.2/repository';
			loads: #( 'Core' ) ]
]

{ #category : #'*BaselineOfFlox' }
BaselineOfRide >> setUpDependencies: spec [

	self mustache: spec.
	self teapot: spec.
	spec postLoadDoIt: #loadTaskIt
]

{ #category : #'*BaselineOfFlox' }
BaselineOfRide >> setUpPackages: spec [

	spec
		package: 'Ride'
		with: [ spec requires: #( 'Mustache' 'Teapot' ) ].

	spec package: 'Ride-Tests' with: [ spec requires: #( 'Ride' ) ].

	spec package: 'Ride-Tools' with: [ spec requires: #( 'Ride-Tests' ) ]
]

{ #category : #'*BaselineOfFlox' }
BaselineOfRide >> teapot: spec [

	spec baseline: 'Teapot' with: [ 
		spec
			repository: 'github://zeroflag/Teapot/source';
			loads: #( 'Deployment' ) ]
]
