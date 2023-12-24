"
I'm a Ride helper dedicated to boilerplate a presenter
"
Class {
	#name : #RidePresenterHelper,
	#superclass : #RideBoilerplateHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RidePresenterHelper class >> newClassNamed: className [

	^ self
		  newClassNamed: ('{1}Presenter' format: { className })
		  withSuperclass: RidePresenter
]
