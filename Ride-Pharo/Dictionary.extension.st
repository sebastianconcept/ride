Extension { #name : #Dictionary }

{ #category : #'*Ride-Pharo' }
Dictionary >> asJsonObject [

	^ JsonObject fromAssociations: self associations
]
