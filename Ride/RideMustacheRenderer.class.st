"
I can render a Ride presenter based in a Mustache template
"
Class {
	#name : #RideMustacheRenderer,
	#superclass : #RideTemplateBasedRenderer,
	#category : #'Ride-Renderers'
}

{ #category : #accessing }
RideMustacheRenderer class >> templateTypeExtentions [

	"Answers the filename extentions for template types accepted by the receiver."

	^ #( mustache mst ms tmpl )
]

{ #category : #accessing }
RideMustacheRenderer class >> templatesValueSelector [

	"Answer the selector to find the templates that Ride has as system has for this receiver."

	^ #mustacheTemplates
]

{ #category : #rendering }
RideMustacheRenderer >> getLayoutAt: aLayoutName [

	^ self templates layouts at: aLayoutName ifAbsent: [ 
		  RideNotFoundError signal:
			  ('Layout not found: {1}' format: { aLayoutName }) ]
]

{ #category : #rendering }
RideMustacheRenderer >> getLayoutFor: aRidePresenter [

	^ self getLayoutAt: aRidePresenter class layoutName
]

{ #category : #actions }
RideMustacheRenderer >> newTemplateFrom: file [

	"Answer a new instance of the template that comes from the source in the given file."

	^ file contents asMustacheTemplate
]

{ #category : #rendering }
RideMustacheRenderer >> render: aTemplateName as: aPartialName inLayout: aLayoutNameOrNil with: aMustacheContext for: aRidePresenter [

	| templateViews yieldTarget templateToRender |
	templateViews := (self getTemplatesFor: aRidePresenter) copy.
	yieldTarget := templateViews at: aTemplateName ifAbsent: [ 
		               RideNotFoundError signal:
			               ('Partial not found: {1} >> {2}' format: { 
					                aRidePresenter class name.
					                aTemplateName }) ].

	"1. Make the template found at aTemplateName 
	available to be rendered as a partial aPartialName in the layout template.
	
	2. Make the shared partials, always available."
	templateViews
		at: aPartialName put: yieldTarget;
		addAll: (self templates at: #shared).

	"Full page renders always want to render in a layout.
	But AJAX calls don't."
	templateToRender := aLayoutNameOrNil
		                    ifNil: [ yieldTarget ]
		                    ifNotNil: [ self getLayoutAt: aLayoutNameOrNil ].
	^ templateToRender value: aMustacheContext partials: templateViews
]

{ #category : #rendering }
RideMustacheRenderer >> render: aPartialName for: aRidePresenter [

	^ self
		  render: aPartialName
		  with: aRidePresenter mustacheTemplateModel
		  for: aRidePresenter
]

{ #category : #rendering }
RideMustacheRenderer >> render: aPartialName inLayout: aLayoutNameOrNil for: aRidePresenter [

	^ self
		  render: aPartialName
		  inLayout: aLayoutNameOrNil
		  with: aRidePresenter mustacheTemplateModel
		  for: aRidePresenter
]

{ #category : #rendering }
RideMustacheRenderer >> render: aPartialName inLayout: aLayoutNameOrNil with: aMustacheContext for: aRidePresenter [

	| templateViews yieldTarget templateToRender |
	templateViews := (self getTemplatesFor: aRidePresenter) copy.
	yieldTarget := templateViews at: aPartialName ifAbsent: [ 
		               RideNotFoundError signal:
			               ('Partial not found: {1} >> {2}' format: { 
					                aRidePresenter class name.
					                aPartialName }) ].

	"1. Make the template found at aPartialName 
	available to be yield from the layout template.
	
	2. Make the shared partials, always available."
	templateViews
		at: #yield put: yieldTarget;
		addAll: (self templates at: #shared).

	"Full page renders always want to render in a layout.
	But AJAX calls don't."
	templateToRender := aLayoutNameOrNil
		                    ifNil: [ yieldTarget ]
		                    ifNotNil: [ self getLayoutAt: aLayoutNameOrNil ].
	^ templateToRender value: aMustacheContext partials: templateViews
]

{ #category : #rendering }
RideMustacheRenderer >> render: aPartialName with: aMustacheContext for: aRidePresenter [

	| layoutNameOrNil |
	layoutNameOrNil := isLayoutWrapper ifTrue: [ 
		                   aRidePresenter class layoutName ].

	^ self
		  render: aPartialName
		  as: aRidePresenter class partialYieldTargetName
		  inLayout: layoutNameOrNil
		  with: aMustacheContext
		  for: aRidePresenter
]

{ #category : #'as yet unclassified' }
RideMustacheRenderer >> renderOnPage: aRidePresenter with: mustacheTemplate partials: pagePartials [

	"Render the given presenter as a full web page using the given mustache template and partials."

	"Prepare all the partials needed in a full page render."
self deprecated: 'should use render:on:layout:for:'.
	pagePartials addAll: self templates shared.

	"Since this is a full page render, use a layout wrapping the presenter content.
	The rest of the inner rendering hppens in a partial named 'yield'"
	^ (self getLayoutFor: aRidePresenter)
		  value: aRidePresenter mustachePageTemplateModel
		  partials: (aRidePresenter
				   mustachePagePartialsOn: pagePartials
				   with: mustacheTemplate)
]

{ #category : #'as yet unclassified' }
RideMustacheRenderer >> showDisintegrateFor: aProductPresenter [

	| partials |
	self deprecated: 'should use render:inLayout:with:for:'.
	partials := self getTemplatesFor: aProductPresenter.

	^ partials disintegrateEffect
		  value: aProductPresenter disintegrateEffectTemplateModel
		  partials: partials
]

{ #category : #'as yet unclassified' }
RideMustacheRenderer >> showEffectsFor: aProductPresenter [

	| partials |
		self deprecated: 'should use render:inLayout:with:for:'.

	partials := self getTemplatesFor: aProductPresenter.
	^ partials effectSelection
		  value: {  } asDictionary
		  partials: partials
]

{ #category : #'as yet unclassified' }
RideMustacheRenderer >> showFireFor: aProductPresenter [

	| partials |
		self deprecated: 'should use render:inLayout:with:for:'.

	partials := self getTemplatesFor: aProductPresenter.

	^ partials fireEffect
		  value: aProductPresenter fireEffectTemplateModel
		  partials: partials
]

{ #category : #'as yet unclassified' }
RideMustacheRenderer >> showJob: job for: aJobsPresenter [

	| partials templateModel |
		self deprecated: 'should use render:inLayout:with:for:'.

	partials := self getTemplatesFor: aJobsPresenter.
	partials := partials
		            at: #mainPanel put: partials show;
		            yourself.
	templateModel := aJobsPresenter templateModelFor: job.
	^ self templates layouts admin
		  value: templateModel
		  partials: partials
]

{ #category : #'as yet unclassified' }
RideMustacheRenderer >> showSubmitFormFor: aProductPresenter [

	| partials |
		self deprecated: 'should use render:inLayout:with:for:'.

	partials := self getTemplatesFor: aProductPresenter.
	^ partials submitForm value: {  } asDictionary
]
