Extension { #name : #ZnHeaders }

{ #category : #'*Ride-Pharo' }
ZnHeaders >> at: key ifPresent: aPresentBlock ifAbsent: anAbsentBlock [

	self at: key ifPresent: [ :v | ^ aPresentBlock cull: v ].
	^ anAbsentBlock value
]
