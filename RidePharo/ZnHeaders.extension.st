Extension { #name : #ZnHeaders }

{ #category : #'*RidePharo' }
ZnHeaders >> at: key ifPresent: aPresentBlock ifAbsent: anAbsentBlock [

	self at: key ifPresent: [ :v | ^ aPresentBlock cull: v ].
	^ anAbsentBlock value
]
