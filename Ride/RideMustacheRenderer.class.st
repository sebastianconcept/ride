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
