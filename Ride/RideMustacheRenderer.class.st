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
RideMustacheRenderer >> render: aTemplateName in: aLayoutNameOrNil for: aRidePresenter [

	"Render the template found with aTemplateName embedded 
	in the layout at aLayoutNameOrNil for aRidePresenter."
	self flag: #review.
	^ self
		  render: aRidePresenter mustacheTemplateModel
		  using: aTemplateName
		  in: aLayoutNameOrNil
		  for: aRidePresenter
]

{ #category : #rendering }
RideMustacheRenderer >> render: aTemplateContext using: aTemplateName as: aPartialName in: aLayoutNameOrNil for: aRidePresenter [

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
	^ templateToRender value: aTemplateContext partials: templateViews
]

{ #category : #rendering }
RideMustacheRenderer >> render: aMustacheContext using: aTemplateName for: aRidePresenter [

	| layoutNameOrNil |
	layoutNameOrNil := isLayoutWrapper ifTrue: [ 
		                   aRidePresenter class layoutName ].

	^ self
		  render: aTemplateName
		  using: aRidePresenter class partialYieldTargetName
		  as: layoutNameOrNil
		  in: aMustacheContext
		  for: aRidePresenter
]

{ #category : #rendering }
RideMustacheRenderer >> render: aTemplateContext using: aTemplateName in: aLayoutNameOrNil for: aRidePresenter [

	"Render the template found with aTemplateName embedded 
	in the layout at aLayoutNameOrNil for aRidePresenter."

	| templateViews yieldTarget templateToRender |
	templateViews := (self getTemplatesFor: aRidePresenter) copy.
	yieldTarget := templateViews at: aTemplateName ifAbsent: [ 
		               RideNotFoundError signal:
			               ('Partial not found: {1} >> {2}' format: { 
					                aRidePresenter class name.
					                aTemplateName }) ].

	"1. Make the template found at aTemplateName 
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
	^ templateToRender value: aTemplateContext partials: templateViews
]

{ #category : #rendering }
RideMustacheRenderer >> renderUsing: aTemplateName for: aRidePresenter [

	"Render the template found with aTemplateName for aRidePresenter."
	self flag: #review.
	^ self
		  render: aRidePresenter mustacheTemplateModel
		  using: aTemplateName
		  for: aRidePresenter
]
