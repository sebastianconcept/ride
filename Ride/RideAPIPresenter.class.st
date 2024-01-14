"
I am the a presenter for API endpoints.


"
Class {
	#name : #RideAPIPresenter,
	#superclass : #RidePresenter,
	#instVars : [
		'api'
	],
	#category : #'Ride-Presenters'
}

{ #category : #accessing }
RideAPIPresenter >> index [

	"Returns the rendered representation of the receiver in its main entry point.
	For example, for an HTML representation what would be in it as index.html"

	^ api render: #index for: self
]

{ #category : #initialization }
RideAPIPresenter >> initialize [

	super initialize.
	api := self getRenderer
]
