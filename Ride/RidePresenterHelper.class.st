"
I'm a Ride helper dedicated to boilerplate a presenter
"
Class {
	#name : #RidePresenterHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RidePresenterHelper >> classNameFor: aSymbol [

	^ '{1}Presenter' format: { aSymbol }
]

{ #category : #actions }
RidePresenterHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the presenter for {1} models' format: { aSymbol asString }
]

{ #category : #private }
RidePresenterHelper >> targetedSuperclass [

	^ RidePresenter
]
