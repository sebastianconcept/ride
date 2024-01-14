"
I am the abstract RidePresenter.
I provide the commonalities of all types of presenters.
See my child classes for concrete examples.

## Responsabilities:
1. Be stateful, maintaining state related to presentation and GUI.
2. Have a model, which I use to perform actions and use as my source of application domain state.
3. Handle HTTP verbs.
4. Define action methods that the frontend can provoke.
5. Define which paramenters are acceptable in a received request.
6. Define pagePartials and pageTemplateModel to have the receiver rendereable as a web page.
7. Set observations on the models and their respective reaction methods.
8. Define any other method that will return a rendered ouput to use in responses (HTML, JSON, XML, RSS, etc).
9. I have a factory that allows me to create subpresenters lazily i.e.: when I try a `presenterForRoute:`.
10. I can change my `focusedView` and with that render the model in different aspects.
11. I might use a child as my delegate and it will respond in my place.

"
Class {
	#name : #RidePresenter,
	#superclass : #Object,
	#instVars : [
		'model',
		'subpresenters',
		'renderer'
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
RidePresenter class >> defaultRendererSelector [

	"Answers the selector of the default renderer"

	^ #mustache
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

{ #category : #accessing }
RidePresenter class >> mustacheLayoutName [

	"Answer the layout name to be used when rendering instances of the receiver."

	^ #application
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
self deprecated: 'No more default actions like this from AJAX calls. The presenter invoked in the right route defines the action selector always and each method knows what to do'.
	^ RideCurrentRequest value headers
		  at: 'X-Ride-AJAX'
		  ifAbsent: [ #default ]
]

{ #category : #'rest-html' }
RidePresenter >> ajaxReactionAndRender [

	"If the current request is part of a Ride AJAX request, 
	use the value sent and perform it as action in this presenter."
	self deprecated: 'the concrete renderer knows about this'.
	^ RideCurrentRequest value headers
		  at: 'X-Ride-AJAX'
		  ifPresent: [ self perform: self ajaxAction asSymbol ]
		  ifAbsent: [ self html ]
]

{ #category : #accessing }
RidePresenter >> applicationTemplate [
self deprecated: 'the concrete renderer knows about this'.
	^ Ride resource templates layouts application
]

{ #category : #rendering }
RidePresenter >> basicHTML [

	"Answers the HTML for this presenter rendered using its template, 
	its templateModel and its partials."
	self deprecated: 'the renderer is responsible for this'.
	^ self focusedView value: self mustacheTemplateModel partials: self partials
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
self deprecated: 'Ride will not mix routing strategy with presenter graph.'.
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
	self deprecated: 'Ride presenters create sub-presenters lazily'.
"	views := Ride resource templatesFor: self.
	views ifNil: [ 
		RideMissingTemplateError signal:
			('{1} template not found' format: { self class name }) ].
	focusedView := views at: #index"
]

{ #category : #accessing }
RidePresenter >> currentAction [

	"Returns the selector corresponding to the action interpreted by the receiver. 
	In Ride, this behavior can be overridden, but by default, URIs are interpreted 
	such that their first segment determines the targeted presenter, 
	and the second segment determines the corresponding selector to execute."

	^ self currentRequest uri segments second asSymbol
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
	self deprecated: 'No more default action?'.
]

{ #category : #accessing }
RidePresenter >> getRenderer [

	"Returns the renderer that this presenter shuold use."

	^ Ride service renderers at: self class defaultRendererSelector
]

{ #category : #rendering }
RidePresenter >> html [

	"Answers the HTML renderering of the model regarding to this presenter.
	It will return the class name if for any reason there is no template found at #index"
self deprecated: 'the concrete renderer knows about this'.
	"^ delegate ifNotNil: [ delegate html ] ifNil: [ self basicHTML ]"
]

{ #category : #rendering }
RidePresenter >> htmlFor: nameOfAPartial [

	"Answers the HTML rendered using the receiver's 
	templateModel on the partial named nameOfAPartial"
self deprecated: 'the concrete renderer knows about this'.
	^ self htmlFor: nameOfAPartial on: self mustacheTemplateModel
]

{ #category : #rendering }
RidePresenter >> htmlFor: nameOfAPartial on: aTemplateModel [

	"Answers the HTML rendered using the given aTemplateModel 
	on the partial named nameOfAPartial"
self deprecated: 'the concrete renderer knows about this'.
	"^ (views at: nameOfAPartial) value: aTemplateModel"
]

{ #category : #'rest-html' }
RidePresenter >> htmlOnDELETE [

	"Answers the HTML exclusive of this presenter.
	See the GET comment. This is the same concept applied to DELETE."
self deprecated: 'the concrete renderer knows about this'.
	^ self ajaxReactionAndRender
]

{ #category : #'rest-html' }
RidePresenter >> htmlOnGET [

	"Answers the HTML exclusive of this presenter.
	If the current GET is part of an AJAX request, 
	then use it as a presenter action to be performed with an HTML answer.
	If a delegate was assigned, then the action is still for this 
	presenter but the answered HTML is for the delegate to render instead."
self deprecated: 'the concrete renderer knows about this'.
	^ self ajaxReactionAndRender
]

{ #category : #'rest-html' }
RidePresenter >> htmlOnPATCH [

	"Answers the HTML exclusive of this presenter.
	See the GET comment. This is the same concept applied to PATCH."

self deprecated: 'the concrete renderer knows about this'.
	^ self ajaxReactionAndRender
]

{ #category : #'rest-html' }
RidePresenter >> htmlOnPOST [

	"If the current POST is part of an AJAX request, 
	See the GET comment. This is the same concept applied to POST."
self deprecated: 'the concrete renderer knows about this'.
	^ self ajaxReactionAndRender
]

{ #category : #'rest-html' }
RidePresenter >> htmlOnPUT [

	"If the current PUT is part of an AJAX request, 
	See the GET comment. This is the same concept applied to PUT."
self deprecated: 'the concrete renderer knows about this'.
	^ self ajaxReactionAndRender
]

{ #category : #rendering }
RidePresenter >> htmlPage [

	"Answers the HTML content generated by this presenter, 
	enclosed within the application layout template."
self deprecated: 'the concrete renderer knows about this'.
	^ self applicationTemplate
		  value: self mustachePageTemplateModel
		  partials: self pagePartials
]

{ #category : #rendering }
RidePresenter >> htmlPageOnGET [

	"Answers the HTML content generated by this presenter, 
	enclosed within the application layout template."
self deprecated: 'the concrete renderer knows about this'.
	^ self htmlPage 
]

{ #category : #actions }
RidePresenter >> index [

	"Returns the rendered representation of the receiver in its main entry point.
	For example, for an HTML representation what would be in it as index.html"

	^ renderer render: self at: #index
]

{ #category : #initialization }
RidePresenter >> initialize [

	super initialize.
	subpresenters := JsonObject new.
	renderer := self getRenderer
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

{ #category : #rendering }
RidePresenter >> mustachePagePartialsOn: pagePartials with: mustacheTemplate [

	"Answers the partials to use to render a page including the
	contents of the receiver as would be rendered by the mustacheTemplate."

	^ pagePartials
		  at: #yield put: mustacheTemplate;
		  yourself
]

{ #category : #accessing }
RidePresenter >> mustachePageTemplateModel [

	"Answers the model that is meant for the receiver rendering in a full page of HTML
	by the Mustache template renderer."

	"We just get it wrapped by the application template in layouts/ 
	which uses it as the partial named 'presenterContent'."

	^ self mustacheTemplateModel
		  at: #presenterContent put: self mustacheTemplateModel;
		  yourself
]

{ #category : #accessing }
RidePresenter >> mustacheTemplateModel [

	"Answers the model used for the template that 
	will render only the HTML of this component (not the full page)."

	| template presenterJsAssets |
	template := model asMustacheTemplateModel.
	presenterJsAssets := Ride resource assetsMap js
		                     at: self class getNormalizedModelName
		                     ifAbsent: [ nil ].
	^ (presenterJsAssets notNil and: [ presenterJsAssets notEmpty ])
		  ifFalse: [ template ]
		  ifTrue: [ 
			  presenterJsAssets keysAndValuesDo: [ :key :value | 
				  template
					  at: ('{1}Js' format: { key })
					  put: ('/assets/js/{1}' format: { value }) ].
			  template ]
]

{ #category : #actions }
RidePresenter >> onAboutToRespond [

	"no-op is the default"
]

{ #category : #actions }
RidePresenter >> onAfterAction [

	"no-op is the default"

	
]

{ #category : #actions }
RidePresenter >> onBeforeAction [

	"no-op is the default"
]

{ #category : #accessing }
RidePresenter >> pagePartials [

	"Answers the partials that are meant for the receiver rendering in a full page of HTML."
self deprecated: 'the renderer is in charge of locating partials of a presenter'.
"	^ self partials
		  ifNil: [ { (#main -> (views at: #index)) } asDictionary ]
		  ifNotNil: [ :partials | 
			  partials at: #main put: (views at: #index) ];
		  yourself"
]

{ #category : #accessing }
RidePresenter >> partialOf: aSymbol [

	"Answers the template of the subpresenter found at aSymbol 
	ready to be sent as one of the partials for them to render."
	self deprecated: 'the rendered is involved in how to find presenter partials'.
	^ aSymbol -> (self children at: aSymbol) focusedView
]

{ #category : #accessing }
RidePresenter >> partials [

	"Answers the partial templates used from the template of this presenter."

	"By default a a presenter will consider as partial to all the receiver views
	except the main one. All mustache files that were found in the corresponding 
	presenter directory except index.mustache is going to be a partial."

	| partials |
	self deprecated: 'the renderer is in charge of locating partials of a presenter'.
"	partials := views associationsSelect: [ :assoc | 
		            assoc key ~= 'index' ]."

	"In addition to that, all shared partials are made available to the presenter"
	^ partials
		  addAll: Ride resource sharedTemplates;
		  yourself
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
	It tries first in its singular version, then in its plural version.
	If still none found, return nil."

	| presenterClass presenterSingularName presenterPluralName |
	self deprecated: 'Ride will not mix routing strategy with presenter graph.'.
	presenterSingularName := RideNameNormalizer 
		                         presenterNameFromURISegment: aSymbol.
	presenterPluralName := RideNameNormalizer 
		                       presenterPluralNameFromURISegment: aSymbol.
	presenterClass := Smalltalk
		                  at: presenterPluralName asSymbol
		                  ifAbsent: [ 
		                  Smalltalk
			                  at: presenterSingularName asSymbol
			                  ifAbsent: [ nil ] ].
	^ presenterClass
		  ifNotNil: [ subpresenters at: aSymbol put: presenterClass new ]
		  ifNil: [ nil ]
]

{ #category : #accessing }
RidePresenter >> router [

	^ Ride service router
]

{ #category : #accessing }
RidePresenter >> serviceCache [

	^ Ride service cache
]

{ #category : #accessing }
RidePresenter >> sessionCache [

	^ self currentSession cache
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
self deprecated: 'the renderer is in charge of locating partials of a presenter'.
"	^ views at: #index ifAbsent: [ 
		  RideMissingTemplateError signal:
			  ('{1} has no main template' format: { self class name }) ]"
]
