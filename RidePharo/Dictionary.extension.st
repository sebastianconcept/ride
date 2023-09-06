Extension { #name : #Dictionary }

{ #category : #'*RidePharo' }
Dictionary >> asJsonObject [

	^ JsonObject fromAssociations: self associations
]
