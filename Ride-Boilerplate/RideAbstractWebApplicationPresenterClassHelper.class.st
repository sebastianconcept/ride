"
I help creating the app Presenters superclass for all the concrete presenters of the app.
"
Class {
	#name : #RideAbstractWebApplicationPresenterClassHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideAbstractWebApplicationPresenterClassHelper >> classNameFor: aSymbol [

	^ '{1}WebApplicationPresenter' format: { aSymbol }
]

{ #category : #actions }
RideAbstractWebApplicationPresenterClassHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the abstract parent for the {1} Ride-based web application presenters.' 
		  format: { aSymbol asString }
]

{ #category : #accessing }
RideAbstractWebApplicationPresenterClassHelper >> targetPackageNameTag [

	^ 'Presenters'
]

{ #category : #accessing }
RideAbstractWebApplicationPresenterClassHelper >> targetedSuperclassFor: aSymbol [

	^ RideWebApplicationPresenter
]
