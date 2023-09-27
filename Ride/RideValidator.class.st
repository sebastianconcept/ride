"
I help validating data in models
"
Class {
	#name : #RideValidator,
	#superclass : #Object,
	#category : #'Ride-Core'
}

{ #category : #validating }
RideValidator >> checkIsNumber: aSymbol in: aJsonObject [

	| probe |
	probe := aJsonObject at: aSymbol.
	probe isNumber ifFalse: [ 
		RideValidationError signal: 'A number was expected' asRideTranslated ]
]

{ #category : #validating }
RideValidator >> checkMinimumSize: anInteger for: aSymbol as: aLabelString in: aJsonObject [

	| probe |
	probe := aJsonObject at: aSymbol.
	probe ifNil: [ 
		RideValidationError
			for: aSymbol
			signal: ('{1} should not be nil' asRideTranslated format:
					 { aLabelString asRideTranslated }) ].
	probe ifEmpty: [ 
		RideValidationError
			for: aSymbol
			signal: ('{1} should not be empty.' asRideTranslated format:
					 { aLabelString asRideTranslated }) ].
	probe size < anInteger ifTrue: [ 
		RideValidationError
			for: aSymbol
			signal:
				('{1} content should not be shorter than {2}.' asRideTranslated 
					 format: { 
							 aLabelString asRideTranslated.
							 anInteger asString }) ]
]

{ #category : #validating }
RideValidator >> checkMinimumSize: anInteger for: aSymbol in: aJsonObject [

	| probe |
	probe := aJsonObject at: aSymbol.
	probe ifNil: [ 
		RideValidationError
			for: aSymbol
			signal: ('{1} should not be nil' asRideTranslated format:
					 { aSymbol asRideTranslated }) ].
	probe ifEmpty: [ 
		RideValidationError
			for: aSymbol
			signal:
			('{1} .' asRideTranslated format: { aSymbol asRideTranslated }) ].
	probe size < anInteger ifTrue: [ 
		RideValidationError
			for: aSymbol
			signal:
				('{1} content should not be shorter than {2}.' asRideTranslated 
					 format: { 
							 aSymbol asRideTranslated.
							 anInteger asString }) ]
]

{ #category : #validating }
RideValidator >> checkNotNil: aSymbol as: aLabelString in: aJsonObject [

	| probe |
	probe := aJsonObject at: aSymbol.
	probe ifNil: [ 
		RideValidationError
			for: aSymbol
			signal: ('{1} should not be nil' asRideTranslated format:
					 { aLabelString asRideTranslated }) ]
]

{ #category : #validating }
RideValidator >> checkNotNil: aSymbol in: aJsonObject [

	| probe |
	probe := aJsonObject at: aSymbol.
	probe ifNil: [ 
		RideValidationError
			for: aSymbol
			signal: ('{1} should not be nil' asRideTranslated format:
					 { aSymbol asRideTranslated }) ]
]

{ #category : #validating }
RideValidator >> checkNotNilNotEmpty: aSymbol as: aLabelString in: aJsonObject [

	| probe |
	probe := aJsonObject at: aSymbol.
	probe ifNil: [ 
		RideValidationError
			for: aSymbol
			signal: ('{1} should not be nil.' asRideTranslated format:
					 { aLabelString asRideTranslated }) ].
	probe ifEmpty: [ 
		RideValidationError
			for: aSymbol
			signal: ('{1} should not be empty.' asRideTranslated format:
					 { aLabelString asRideTranslated }) ]
]

{ #category : #validating }
RideValidator >> checkNotNilNotEmpty: aSymbol in: aJsonObject [

	| probe |
	probe := aJsonObject at: aSymbol.
	probe ifNil: [ 
		RideValidationError
			for: aSymbol
			signal: ('{1} should not be nil.' asRideTranslated format:
					 { aSymbol asRideTranslated }) ].
	probe ifEmpty: [ 
		RideValidationError
			for: aSymbol
			signal: ('{1} should not be empty.' asRideTranslated format:
					 { aSymbol asRideTranslated }) ]
]

{ #category : #validating }
RideValidator >> checkValidEmailAddress: aSymbol as: aLabelString in: aJsonObject [

	| probe |
	probe := aJsonObject at: aSymbol.
	probe ifNil: [ 
		RideValidationError
			for: aSymbol
			signal: ('{1} should not be nil.' asRideTranslated format:
					 { aLabelString asRideTranslated }) ].
	probe ifEmpty: [ 
		RideValidationError
			for: aSymbol
			signal: ('{1} should not be empty.' asRideTranslated format:
					 { aLabelString asRideTranslated }) ].

	(probe matchesRegex: '^[^\s@]+@[^\s@]+\.[^\s@]+$') ifFalse: [ 
		RideValidationError
			for: aSymbol
			signal:
				('"{1}" should have valid E-Mail form.' asRideTranslated format:
					 { probe }) ]
]

{ #category : #validating }
RideValidator >> checkValidEmailAddress: aSymbol in: aJsonObject [

	| probe |
	probe := aJsonObject at: aSymbol.
	probe ifNil: [ 
		RideValidationError
			for: aSymbol
			signal: ('{1} should not be nil' asRideTranslated format:
					 { aSymbol asRideTranslated }) ].
	probe ifEmpty: [ 
		RideValidationError
			for: aSymbol
			signal: ('{1} should not be empty.' asRideTranslated format:
					 { aSymbol asRideTranslated }) ].

	(probe matchesRegex: '^[^\s@]+@[^\s@]+\.[^\s@]+$') ifFalse: [ 
		RideValidationError
			for: aSymbol
			signal:
				('"{1}" should have valid E-Mail form.' asRideTranslated format:
					 { probe }) ]
]
