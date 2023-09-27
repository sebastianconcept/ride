Extension { #name : #String }

{ #category : #'*Ride' }
String >> asLang: aSymbol [

	^ RideMultilingual at: self in: aSymbol
]

{ #category : #'*Ride' }
String >> asRideTranslated [

	^ self asLang: RideLanguage value
]
