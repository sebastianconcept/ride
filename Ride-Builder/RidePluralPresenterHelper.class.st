Class {
	#name : #RidePluralPresenterHelper,
	#superclass : #RidePresenterHelper,
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RidePluralPresenterHelper >> classNameFor: aSymbol [

	^ '{1}Presenter' format: { aSymbol asPlural }
]

{ #category : #actions }
RidePluralPresenterHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the presenter for lists of {1} models' format: { aSymbol asString }
]
