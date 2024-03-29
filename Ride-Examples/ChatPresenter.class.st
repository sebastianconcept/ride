"
I'm the presenter of the chat demo application
"
Class {
	#name : #ChatPresenter,
	#superclass : #RidePresenter,
	#category : #'Ride-Examples-Presenters'
}

{ #category : #private }
ChatPresenter class >> defaultModel [

	^ Chat new
]

{ #category : #accessing }
ChatPresenter >> messagesChanged [

	self halt
]

{ #category : #'as yet unclassified' }
ChatPresenter >> messagesHTML [
self halt.
	^ (views at: #result) value: self messagesTemplateModel
]

{ #category : #accessing }
ChatPresenter >> mustacheTemplateModel [

	"Answers the model that is meant for the receiver rendering in a full page of HTML."

	| templateModel |
	templateModel := JsonObject new.
	model userFirstName ifNotNil: [ 
		templateModel
			hasFirstName: true;
			userFirstName: model userFirstName ].
	^ templateModel
]

{ #category : #accessing }
ChatPresenter >> sendMessage [

	self halt
]
