"
I'm the main presenter of the Counter example
"
Class {
	#name : #CounterPresenter,
	#superclass : #RidePresenter,
	#category : #'Ride-Examples-Presenters'
}

{ #category : #private }
CounterPresenter class >> defaultModel [

	^ Counter new
]

{ #category : #actions }
CounterPresenter >> decrement [

	model decrement.

	^ self resultHTML
]

{ #category : #actions }
CounterPresenter >> increment [

	model increment.

	^ self resultHTML
]

{ #category : #'as yet unclassified' }
CounterPresenter >> pageTemplateModel [

	^ self templateModel
]

{ #category : #'as yet unclassified' }
CounterPresenter >> partials [

	^ { (#result -> (views at: #result)) } asDictionary
]

{ #category : #actions }
CounterPresenter >> resultHTML [

	^ (views at: #result) value: self resultTemplateModel
]

{ #category : #'as yet unclassified' }
CounterPresenter >> resultTemplateModel [

	"Answer the model needed by the receiver's result partial."

	^ { (#count -> model count asString) } asDictionary
]

{ #category : #'as yet unclassified' }
CounterPresenter >> templateModel [

	"Answer the model needed by the receiver's template."

	^ { 
		  (#userFirstName -> model userFirstName).
		  (#count -> model count asString) } asDictionary
]
