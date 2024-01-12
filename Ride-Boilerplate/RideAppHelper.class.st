"
I'm a Ride helper dedicated to boilerplate a new Ride application
"
Class {
	#name : #RideAppHelper,
	#superclass : #RideCompositeHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideAppHelper >> abstractModelClass [

	^ RideAbstractModelClassHelper new
]

{ #category : #accessing }
RideAppHelper >> abstractPresenterClass [

	^ RideAbstractPresenterClassHelper new
]

{ #category : #accessing }
RideAppHelper >> appClass [

	^ RideAppClassHelper new
]

{ #category : #accessing }
RideAppHelper >> appErrorClass [

	^ RideAppErrorClassHelper new
]

{ #category : #actions }
RideAppHelper >> for: aSymbol [

	self setPackageNameTo: aSymbol.

	self sessionClass for: aSymbol.
	self maitreClass for: aSymbol.
	self appClass for: aSymbol.
	self serverClass for: aSymbol.
	self appErrorClass for: aSymbol.
	self abstractModelClass for: aSymbol.
	self abstractPresenterClass for: aSymbol
]

{ #category : #testing }
RideAppHelper >> hasValidPackageName: aSymbol [

	^ aSymbol notNil and: [ aSymbol notEmpty ]
]

{ #category : #accessing }
RideAppHelper >> maitreClass [

	^ RideMaitreClassHelper new
]

{ #category : #accessing }
RideAppHelper >> serverClass [

	^ RideServerClassHelper new
]

{ #category : #accessing }
RideAppHelper >> sessionClass [

	^ RideSessionClassHelper new
]

{ #category : #actions }
RideAppHelper >> setPackageNameTo: aSymbol [

	(self hasValidPackageName: aSymbol) ifFalse: [ 
		RideBoilerplateError signal:
			'The application name needs to be defined' ].

	Ride draft defaultPackageName: aSymbol asString
]
