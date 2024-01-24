"
I can render a Ride presenter based in a STTemplate
"
Class {
	#name : #RideSTTemplateRenderer,
	#superclass : #RideTemplateBasedRenderer,
	#category : #'Ride-Renderers'
}

{ #category : #accessing }
RideSTTemplateRenderer class >> templateTypeExtentions [

	"Answers the filename extentions for template types accepted by the receiver."

	^ #( stt est )
]

{ #category : #accessing }
RideSTTemplateRenderer class >> templatesValueSelector [

	"Answer the selector to find the templates that Ride has as system has for this receiver."

	^ #sttTemplates
]

{ #category : #actions }
RideSTTemplateRenderer >> newTemplateFrom: file [

	"Answer a new instance of the template that comes from the source in the given file."

	^ file contents asSTTemplate
]

{ #category : #rendering }
RideSTTemplateRenderer >> render: aTemplateContext using: aTemplateName in: aLayoutNameOrNil for: aRidePresenter [

	"Render the template found with aTemplateName embedded 
	in the layout at aLayoutNameOrNil for aRidePresenter."

	| templateToRender layoutWrapper wrappedTemplate missingTemplate partials targetedTemplate targetedTemplates |
	"Prepare missing template handler just in case."
	missingTemplate := [ :templateName | 
	                   RideMissingTemplateError signal:
		                   ('{2} >> {1}' format: { 
				                    templateName.
				                    aRidePresenter class name }) ].

	"Keep a reference to the template that is the actual main target of a rendering."
	targetedTemplates := (self templates at: #views)
		                     at: aRidePresenter class getNormalizedModelName
		                     ifAbsent: [ 
		                     missingTemplate value:
			                     aRidePresenter class getNormalizedModelName ].
	targetedTemplate := targetedTemplates at: aTemplateName.

	"Unless changed, make the targeted template to be the one to render"
	templateToRender := targetedTemplate.

	"Initialize the partials dictionary with the shared ones 
	that are usually needed to complete a rendering."
	partials := {  } asDictionary
		            at: #shared put: self templates shared;
		            yourself.

	"If it's a case to wrap the targeted template 
	in a layout then prepare that accordingly"
	aLayoutNameOrNil ifNotNil: [ 
		layoutWrapper := (self templates at: #layouts)
			                 at: aLayoutNameOrNil
			                 ifAbsent: [ 
			                 missingTemplate value: aLayoutNameOrNil ].
		wrappedTemplate := targetedTemplate.
		partials at: #_yield put: wrappedTemplate.
		templateToRender := layoutWrapper ].

	"Complete the rendering"
	^ templateToRender renderOn: aTemplateContext partials: partials
]

{ #category : #rendering }
RideSTTemplateRenderer >> renderUsing: aTemplateName for: aRidePresenter [

	"Render the template found with aTemplateName for aRidePresenter
	using the layout and context that the presenter itself provides."

	^ self
		  render: aRidePresenter getRenderContext
		  using: aTemplateName
		  in: aRidePresenter getLayoutName
		  for: aRidePresenter
]
