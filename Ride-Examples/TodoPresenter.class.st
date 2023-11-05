"
I'm the presenter of the To-Do example
"
Class {
	#name : #TodoPresenter,
	#superclass : #RidePresenter,
	#category : #'Ride-Examples-Presenters'
}

{ #category : #private }
TodoPresenter class >> defaultModel [

	^ Todo new
]

{ #category : #actions }
TodoPresenter >> addToDoItem [

	| description |
	description := self currentRequest entity at: #description.
	description ifNotEmpty: [ self model addItemDescribed: description ].
	^ self itemsHTML
]

{ #category : #rendering }
TodoPresenter >> itemHTMLFor: taskId [

	| item templateModel |
	item := model items detect: [ :e | e id = taskId ] ifNone: [ 
		        RideNotFoundError signal:
			        ('{1} is not a valid taskId' format: { taskId }) ].
	templateModel := JsonObject new
		                 taskId: taskId;
		                 description: item description;
		                 done: item done;
		                 yourself.
	^ (views at: #item) value: templateModel
]

{ #category : #rendering }
TodoPresenter >> itemsHTML [

	^ (views at: #items)
		  value: self templateModel
		  partials: self partials
]

{ #category : #accessing }
TodoPresenter >> partials [

	^ { 
		  (#todoList -> (views at: #todoList)).
		  (#items -> (views at: #items)).
		  (#item -> (views at: #item)) } asDictionary
]

{ #category : #accessing }
TodoPresenter >> templateModel [

	"Answer the model needed by the receiver's template."

	| templateModel |
	templateModel := JsonObject new.
	templateModel
		userFirstName: model userFirstName;
		items: (model items collect: [ :e | e asTemplateModel ]).
	^ templateModel
]

{ #category : #actions }
TodoPresenter >> toggleItem [

	| taskId |
	taskId := self currentRequest mergedFields at: #id.
	taskId ifNotEmpty: [ model toggleItemId: taskId ].
	^ self itemHTMLFor: taskId
]
