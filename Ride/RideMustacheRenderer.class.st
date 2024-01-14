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
RideMustacheRenderer >> getLayoutFor: aRidePresenter [

	^ self templates layouts
		  at: aRidePresenter class mustacheLayoutName
		  ifAbsent: [ 
			  RideNotFoundError signal: ('Layout not found: {1}' format:
					   { aRidePresenter class mustacheLayoutName }) ]
]

{ #category : #actions }
RideMustacheRenderer >> newTemplateFrom: file [

	"Answer a new instance of the template that comes from the source in the given file."

	^ file contents asMustacheTemplate
]

{ #category : #rendering }
RideMustacheRenderer >> render: aRidePresenter at: anAspectVariantSelector [

	"Since it can have many, use anAspectVariantSelector 
	to decide in what aspect to render aRidePresenter."

	| templateViews mustacheTemplate partials |
	templateViews := self getTemplatesFor: aRidePresenter.
	mustacheTemplate := templateViews
		                    at: anAspectVariantSelector
		                    ifAbsent: [ 
			                    RideNotFoundError signal:
				                    ('Presenter action not found: {1}>>{2}' 
					                     format: { 
							                     aRidePresenter class name.
							                     anAspectVariantSelector }) ].
	partials := templateViews.

	^ aRidePresenter currentRequest headers
		  at: 'X-Ride-AJAX'
		  ifPresent: [ :value | 
			  self
				  render: aRidePresenter
				  with: mustacheTemplate
				  partials: partials
				  ajaxToken: value ]
		  ifAbsent: [ 
			  self
				  renderOnPage: aRidePresenter
				  with: mustacheTemplate
				  partials: partials ]
]

{ #category : #rendering }
RideMustacheRenderer >> renderOnPage: aRidePresenter with: mustacheTemplate partials: pagePartials [

	"Render the given presenter as a full web page using the given mustache template and partials."

	"Prepare all the partials needed in a full page render."

	pagePartials addAll: self templates shared.

	"Since this is a full page render, use a layout wrapping the presenter content.
	The rest of the inner rendering hppens in a partial named 'yield'"
	^ (self getLayoutFor: aRidePresenter)
		  value: aRidePresenter mustachePageTemplateModel
		  partials: (aRidePresenter
				   mustachePagePartialsOn: pagePartials
				   with: mustacheTemplate)
]
