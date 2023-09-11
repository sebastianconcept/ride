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
	#name : #RideRESTfulController,
	#superclass : #RideController,
	#category : #'Ride-Controllers'
}

{ #category : #accessing }
RideRESTfulController class >> getModelFrom: aRequest [

	aRequest uri segments first = self basePath ifFalse: [ 
		self error: 'Wrong route' ].
	aRequest uri segments size < 2 ifTrue: [ 
		RideMissingModelPathError signal: 'Missing model ID' ].

	^ self getModelId: aRequest uri segments second
]

{ #category : #accessing }
RideRESTfulController class >> getModelId: anId [

	^ self getModelClass findId: anId
]

{ #category : #testing }
RideRESTfulController class >> hasModelIdIn: aRequest [

	"Improve this to support more that the first level"
	^ aRequest uri segments size > 2
]

{ #category : #accessing }
RideRESTfulController class >> newModelFrom: aRequest [

	^ self getModelClass new
]

{ #category : #crud }
RideRESTfulController >> create: someMustacheTemplates [

	self halt
]

{ #category : #crud }
RideRESTfulController >> destroy: someMustacheTemplates [

	self halt
]

{ #category : #crud }
RideRESTfulController >> show: someMustacheTemplates [

	self halt
]

{ #category : #crud }
RideRESTfulController >> update: someMustacheTemplates [

	self halt
]
