"
I'm the default Home presenter for the default new Ride web application.

"
Class {
	#name : #WelcomePresenter,
	#superclass : #RidePresenter,
	#category : #'Ride-Examples-Presenters'
}

{ #category : #private }
WelcomePresenter class >> defaultModel [

	^ Welcome new
]

{ #category : #actions }
WelcomePresenter >> edit [
	self resetDelegate.

	self focusedView: (views at: #promptUsername).
	^ self html
]

{ #category : #reactions }
WelcomePresenter >> onUserFirstNameChanged [

	self subpresenters do: [ :each | 
		each model userFirstName: self model userFirstName ]
]

{ #category : #actions }
WelcomePresenter >> openChat [

	delegate := self subpresenters at: #chat ifAbsentPut: [ 
		            ChatPresenter on: (Chat new
				             userFirstName: model userFirstName;
				             yourself) ].

	^ self html
]

{ #category : #actions }
WelcomePresenter >> openCounter [

	delegate := self subpresenters at: #counter ifAbsentPut: [ 
		            CounterPresenter on: (Counter new
				             userFirstName: model userFirstName;
				             yourself) ].
	^ self html
]

{ #category : #actions }
WelcomePresenter >> openTodo [

	delegate := self subpresenters at: #todo ifAbsentPut: [ 
		            TodoPresenter on: (Todo new
				             userFirstName: model userFirstName;
				             yourself) ].

	^ self html
]

{ #category : #accessing }
WelcomePresenter >> partials [

	^ { 
		  (#promptUsername -> (views at: #promptUsername)).
		  (#intro -> (views at: #intro)) } asDictionary
]

{ #category : #initialization }
WelcomePresenter >> setObservers [

	super setObservers.

	model when: #userFirstNameChanged send: #onUserFirstNameChanged to: self
]

{ #category : #actions }
WelcomePresenter >> setUserFirstName [

	self model userFirstName: (self currentRequest entity at: #firstName).

	self focusedView: (views at: #intro).
	^ self html
]

{ #category : #'rest-html' }
WelcomePresenter >> templateModel [

	"Answers the model that is meant for the receiver rendering in a full page of HTML."

	| templateModel |
	templateModel := JsonObject new.
	model userFirstName ifNotNil: [ 
		templateModel
			hasFirstName: true;
			userFirstName: model userFirstName ].
	^ templateModel
]
