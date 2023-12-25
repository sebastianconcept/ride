"
I am the abstract RidePresenter.
I provide the commonalities of all types of presenters.
See my child classes for concrete examples.

## Responsabilities:
1. Handle HTTP verbs.
2. Define action methods that the frontend can provoke.
3. Define pagePartials and pageTemplateModel to have the receiver rendereable as a web page.
4. Set observations on the models and their respective reaction methods.
5. Define any other method that will return HTML upon the frontend action messages.
6. These additional HTML methods will get the HTML rendered by relying on their own dedicated partials and template models.
7. I have a factory that allows me to create subpresenters lazily i.e.: when I try a `presenterForRoute:`.
8. I can change my `focusedView` and with that render the model in different aspects.
9. I might use a child as my delegate and it will respond in my place.
"
Class {
	#name : #RidePresenter,
	#superclass : #Object,
	#instVars : [
		'model',
		'views',
		'focusedView',
		'delegate',
		'subpresenters',
		'factory'
	],
	#category : #'Ride-Presenters'
}

{ #category : #accessing }
RidePresenter class >> basePath [

	"Answers the view name of this controller as snake case."

	^ self getModelName asSnakeCase
]

{ #category : #accessing }
RidePresenter class >> defaultModel [

	^ nil
]

{ #category : #accessing }
RidePresenter class >> getKebabizedModelName [

	^ '-' join: (self getModelName asSnakeCase substrings: '_')
]

{ #category : #accessing }
RidePresenter class >> getModelClass [

	"Answers the model class for this presenter."

	^ Smalltalk
		  at: self getModelName asSymbol
		  ifAbsent: [ 
		  RideMissingModelError signal: self getModelName , ' not found' ]
]

{ #category : #accessing }
RidePresenter class >> getModelName [

	"Answers the conventional model name for this presenter."

	^ self name copyFrom: 1 to: self name size - 'Presener' size - 1
]

{ #category : #accessing }
RidePresenter class >> getNormalizedModelName [

	^ self getKebabizedModelName
]

{ #category : #'instance creation' }
RidePresenter class >> new [

	^ self on: self defaultModel
]

{ #category : #'instance creation' }
RidePresenter class >> on: aModel [

	^ self basicNew
		  initialize;
		  model: aModel
]

{ #category : #actions }
RidePresenter >> ajaxAction [

	"Answers the selector of the action specified from the AJAX request.
	The convention is to use the value in 'X-Ride-AJAX' as the selector
	that this controller would perform as a reaction. And, as #default is a no-op,
	the default is to do nothing."

	^ RideCurrentRequest value headers
		  at: 'X-Ride-AJAX'
		  ifAbsent: [ #default ]
]

{ #category : #'rest-html' }
RidePresenter >> ajaxReactionAndRender [

	"If the current request is part of a Ride AJAX request, 
	use the value sent and perform it as action in this presenter."

	^ RideCurrentRequest value headers
		  at: 'X-Ride-AJAX'
		  ifPresent: [ self perform: self ajaxAction asSymbol ]
		  ifAbsent: [ self html ]
]

{ #category : #accessing }
RidePresenter >> applicationTemplate [

	^ Ride service locate templates layouts application
]

{ #category : #rendering }
RidePresenter >> basicHTML [

	"Answers the HTML for this presenter rendered using its template, 
	its templateModel and its partials."

	^ self focusedView value: self templateModel partials: self partials
]

{ #category : #accessing }
RidePresenter >> childAt: aSymbol [

	"Answers the current child presenter found at aSymbol.
	If not found, try to find a factory block to lazily create it.
	If a new one was created, add it and return it.
	If that didn't work, use the convention of trying to instantiate
	a presenter that matches aSymbol route from what's found in
	the templates/views directory and store it as child of this receiver.
	If nothing of that worked, return nil."

	^ (subpresenters includesKey: aSymbol)
		  ifTrue: [ subpresenters at: aSymbol ]
		  ifFalse: [ 
			  self factory
				  at: aSymbol
				  ifPresent: [ :aBlock | 
				  subpresenters at: aSymbol put: aBlock value ]
				  ifAbsent: [ self restfulSubPresenterOrNilFor: aSymbol ] ]
]

{ #category : #accessing }
RidePresenter >> children [

	^ subpresenters
]

{ #category : #initialization }
RidePresenter >> createViews [

	views := Ride service locate templatesFor: self.
	views ifNil: [ 
		RideMissingTemplateError signal:
			('{1} template not found' format: { self class name }) ].
	focusedView := views at: #index
]

{ #category : #accessing }
RidePresenter >> currentRequest [

	^ RideCurrentRequest value
]

{ #category : #accessing }
RidePresenter >> currentSession [

	^ RideCurrentSession value
]

{ #category : #actions }
RidePresenter >> default [
	"The default action is doing nothing."
]

{ #category : #accessing }
RidePresenter >> delegate [

	^ delegate
]

{ #category : #accessing }
RidePresenter >> delegate: anObject [

	delegate := anObject
]

{ #category : #accessing }
RidePresenter >> factory [

	^ factory ifNil: [ self initializeFactory ]
]

{ #category : #accessing }
RidePresenter >> focusedView [
	"Answers the template that is the current view to be rendered for this presenter.
	It starts by being #index and after that it might be changed by ushow the presenter
	reactcs to user input."
	^ focusedView
]

{ #category : #accessing }
RidePresenter >> focusedView: anObject [

	focusedView := anObject
]

{ #category : #rendering }
RidePresenter >> html [

	"Answers the HTML renderering of the model regarding to this presenter.
	It will return the class name if for any reason there is no template found at #index"

	^ delegate ifNotNil: [ delegate html ] ifNil: [ self basicHTML ]
]

{ #category : #rendering }
RidePresenter >> htmlFor: nameOfAPartial [

	"Answers the HTML rendered using the receiver's 
	templateModel on the partial named nameOfAPartial"

	^ self htmlFor: nameOfAPartial on: self templateModel
]

{ #category : #rendering }
RidePresenter >> htmlFor: nameOfAPartial on: aTemplateModel [

	"Answers the HTML rendered using the given aTemplateModel 
	on the partial named nameOfAPartial"

	^ (views at: nameOfAPartial) value: aTemplateModel
]

{ #category : #'rest-html' }
RidePresenter >> htmlOnDELETE [

	"Answers the HTML exclusive of this presenter.
	See the GET comment. This is the same concept applied to DELETE."

	^ self ajaxReactionAndRender
]

{ #category : #'rest-html' }
RidePresenter >> htmlOnGET [

	"Answers the HTML exclusive of this presenter.
	If the current GET is part of an AJAX request, 
	then use it as a presenter action to be performed with an HTML answer.
	If a delegate was assigned, then the action is still for this 
	presenter but the answered HTML is for the delegate to render instead."

	^ self ajaxReactionAndRender
]

{ #category : #'rest-html' }
RidePresenter >> htmlOnPATCH [

	"Answers the HTML exclusive of this presenter.
	See the GET comment. This is the same concept applied to PATCH."


	^ self ajaxReactionAndRender
]

{ #category : #'rest-html' }
RidePresenter >> htmlOnPOST [

	"If the current POST is part of an AJAX request, 
	See the GET comment. This is the same concept applied to POST."

	^ self ajaxReactionAndRender
]

{ #category : #'rest-html' }
RidePresenter >> htmlOnPUT [

	"If the current PUT is part of an AJAX request, 
	See the GET comment. This is the same concept applied to PUT."

	^ self ajaxReactionAndRender
]

{ #category : #rendering }
RidePresenter >> htmlPage [

	"Answers the HTML content generated by this presenter, 
	enclosed within the application layout template."

	^ self applicationTemplate
		  value: self pageTemplateModel
		  partials: self pagePartials
]

{ #category : #rendering }
RidePresenter >> htmlPageOnGET [

	"Answers the HTML content generated by this presenter, 
	enclosed within the application layout template."

	^ self htmlPage 
]

{ #category : #initialization }
RidePresenter >> initialize [

	super initialize.
	subpresenters := JsonObject new.
	self createViews.

]

{ #category : #initialization }
RidePresenter >> initializeFactory [

	^ factory := Dictionary new
]

{ #category : #accessing }
RidePresenter >> locate [

	^ Ride service locate
]

{ #category : #accessing }
RidePresenter >> maitre [

	"Answers the maitre of the service"

	^ Ride service maitre
]

{ #category : #accessing }
RidePresenter >> model [

	^ model
]

{ #category : #initialization }
RidePresenter >> model: aModel [

	model := aModel.
	self setObservers	
]

{ #category : #accessing }
RidePresenter >> pagePartials [

	"Answers the partials that are meant for the receiver rendering in a full page of HTML."

	^ self partials
		  ifNil: [ { (#main -> (views at: #index)) } asDictionary ]
		  ifNotNil: [ :partials | 
			  partials at: #main put: (views at: #index) ];
		  yourself
]

{ #category : #accessing }
RidePresenter >> pageTemplateModel [

	"Answers the model that is meant for the receiver rendering in a full page of HTML."

	"We basically just get it wrapped by the application template used as partial named 'main'."
	^ self templateModel
		  at: #main put: self templateModel;
		  yourself
]

{ #category : #accessing }
RidePresenter >> partialOf: aSymbol [

	"Answers the template of the subpresenter found at aSymbol 
	ready to be sent as one of the partials for them to render."

	^ aSymbol -> (self children at: aSymbol) focusedView
]

{ #category : #accessing }
RidePresenter >> partials [

	"Answers the partial templates used from the template of this presenter."

	"By default a a presenter will consider as partial to all the receiver views
	except the main one. All mustache files that were found in the corresponding 
	presenter directory except index.mustache is going to be a partial."

	| partials |
	partials := views associationsSelect: [ :assoc | 
		            assoc key ~= 'index' ].

	"In addition to that, all shared partials are made available to the presenter"
	^ partials
		  addAll: self locate sharedTemplates;
		  yourself
]

{ #category : #actions }
RidePresenter >> resetDelegate [

	delegate := nil
]

{ #category : #actions }
RidePresenter >> resetSession [

	Ride service invalidateSession: self currentSession
]

{ #category : #actions }
RidePresenter >> restfulSubPresenterOrNilFor: aSymbol [

	"use the convention of trying to instantiate
	a presenter that matches aSymbol route in the templates/views directory
	(and store it as child of this receiver).
	If still none found, return nil."

	| presenterName presenterClass |
	presenterName := RideNameNormalizer presenterNameFromURISegment:
		                 aSymbol.
	presenterClass := Smalltalk
		                  at: presenterName asSymbol
		                  ifAbsent: [ nil ].
	^ presenterClass
		  ifNotNil: [ subpresenters at: aSymbol put: presenterClass new ]
		  ifNil: [ nil ]
]

{ #category : #accessing }
RidePresenter >> router [

	^ Ride service router
]

{ #category : #initialization }
RidePresenter >> setObservers [
]

{ #category : #accessing }
RidePresenter >> subpresenters [

	^ subpresenters
]

{ #category : #accessing }
RidePresenter >> subpresenters: anObject [

	subpresenters := anObject
]

{ #category : #rendering }
RidePresenter >> template [

	^ views at: #index ifAbsent: [ 
		  RideMissingTemplateError signal:
			  ('{1} has no main template' format: { self class name }) ]
]

{ #category : #accessing }
RidePresenter >> templateModel [

	"Answers the model used for the template that 
	will render only the HTML of this component (not the full page)."

	| template presenterJsAssets indexJs |
	template := model asTemplateModel.
	presenterJsAssets := self locate assetsMap js at:
		                     self class getNormalizedModelName.
	^ (presenterJsAssets notNil and: [ 
		   indexJs := presenterJsAssets at: #index.
		   indexJs notNil ])
		  ifFalse: [ template ]
		  ifTrue: [ 
			  template
				  at: #indexJs put: ('/assets/js/{1}' format: { indexJs });
				  yourself ]
]
