"
I have models that are expected to be saved and read from a repository based on a RESTful convention.

My subclasses will handle the custom reactions following the REST style of URLs mapping Controllers/Models. 

They provide CRUD for their corresponding models based on HTTP verbs and you can add behavior on top of that:
- GET #show:
- PUT/POST #create:
- PATCH #update:
- DELETE #destroy:

"
Class {
	#name : #RideRESTfulPresenter,
	#superclass : #RidePresenter,
	#category : #'Ride-Presenters'
}

{ #category : #crud }
RideRESTfulPresenter class >> createWith: someMustacheTemplates [

	^ [ :req | 
	  (someMustacheTemplates
		   at: #new
		   ifAbsent: [ RideMissingTemplateError signal: 'new not found' ]) 
		  value: (self newModelFrom: req) ]
]

{ #category : #crud }
RideRESTfulPresenter class >> destroy [

	^ [ :req | (self getModelFrom: req) destroy ]
]

{ #category : #accessing }
RideRESTfulPresenter class >> getModelFrom: aRequest [

	aRequest uri segments first = self basePath ifFalse: [ 
		self error: 'Wrong route' ].
	aRequest uri segments size < 2 ifTrue: [ 
		RideMissingModelPathError signal: 'Missing model ID' ].

	^ self getModelId: aRequest uri segments second
]

{ #category : #accessing }
RideRESTfulPresenter class >> getModelId: anId [

	^ self getModelClass findId: anId
]

{ #category : #testing }
RideRESTfulPresenter class >> hasModelIdIn: aRequest [

	"Improve this to support more that the first level"
	^ aRequest uri segments size > 2
]

{ #category : #accessing }
RideRESTfulPresenter class >> newModelFrom: aRequest [

	^ self getModelClass new
]

{ #category : #crud }
RideRESTfulPresenter class >> postHtmlWith: someMustacheTemplates [

	^ [ :req | 
	  (someMustacheTemplates
		   at: #edit
		   ifAbsent: [ RideMissingTemplateError signal: 'edit not found' ]) 
		  value: (self getModelFrom: req) ]
]

{ #category : #crud }
RideRESTfulPresenter class >> showHtml: someMustacheTemplate [
self halt.
	^ [ :req | someMustacheTemplate value: (self getModelFrom: req) ]
]

{ #category : #crud }
RideRESTfulPresenter class >> showManyHtml: someMustacheTemplates [

	^ [ :req | 
	  (someMustacheTemplates
		   at: #index
		   ifAbsent: [ RideMissingTemplateError signal: 'index not found' ]) 
		  value: (self getModelFrom: req) ]
]

{ #category : #crud }
RideRESTfulPresenter class >> updateWith: someMustacheTemplates [

	^ [ :req | 
	  (someMustacheTemplates
		   at: #edit
		   ifAbsent: [ RideMissingTemplateError signal: 'edit not found' ]) 
		  value: (self getModelFrom: req) ]
]

{ #category : #crud }
RideRESTfulPresenter >> create: someMustacheTemplates [

	self halt
]

{ #category : #crud }
RideRESTfulPresenter >> destroy: someMustacheTemplates [

	self halt
]

{ #category : #crud }
RideRESTfulPresenter >> show: someMustacheTemplates [

	self halt
]

{ #category : #crud }
RideRESTfulPresenter >> update: someMustacheTemplates [

	self halt
]
