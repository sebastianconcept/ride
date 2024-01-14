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
RideSTTemplateRenderer >> render: aSTTemplateName for: aRidePresenter [
	"Since it can have many, use anAspectVariantSelector 
	to decide in what aspect to render aRidePresenter."

	self halt.
	aRidePresenter getTemplatesFrom: self templates.
	^ Ride resource
]
