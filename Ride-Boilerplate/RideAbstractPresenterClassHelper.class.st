"
I help creating the app Presenters superclass for all the concrete presenters of the app.
"
Class {
	#name : #RideAbstractPresenterClassHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideAbstractPresenterClassHelper >> classNameFor: aSymbol [

	^ '{1}AbstractPresenter' format: { aSymbol }
]

{ #category : #actions }
RideAbstractPresenterClassHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the abstract parent for the {1} Ride-based application presenters.' 
		  format: { aSymbol asString }
]

{ #category : #accessing }
RideAbstractPresenterClassHelper >> targetPackageNameTag [

	^ 'Presenters'
]

{ #category : #accessing }
RideAbstractPresenterClassHelper >> targetedSuperclassFor: aSymbol [

	^ RidePresenter
]
