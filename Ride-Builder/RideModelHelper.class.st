"
I'm a Ride helper dedicated to boilerplate a model
"
Class {
	#name : #RideModelHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RideModelHelper >> classNameFor: aSymbol [

	^ aSymbol
]

{ #category : #actions }
RideModelHelper >> defaultCommentsFor: aSymbol [

	^ 'I am {1} model' format: { aSymbol asString }
]

{ #category : #accessing }
RideModelHelper >> targetPackageNameTag [

	^ 'Models'
]

{ #category : #accessing }
RideModelHelper >> targetedSuperclassFor: aSymbol [

	| className |
	className := '{1}Model' format: { RideBuilder defaultPackageName }.
	^ Smalltalk at: className asSymbol ifAbsent: [ 
		  RideBoilerplateError signal:
			  ('{1} class is missing in this image' format: { className }) ]
]
