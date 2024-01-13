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

{ #category : #'instance creation' }
RideMustacheRenderer >> newTemplateFrom: file [

	"Answer a new instance of the template that comes from the source in the given file."

	^ file contents asMustacheTemplate
]

{ #category : #rendering }
RideMustacheRenderer >> render: aRidePresenter at: anAspectVariantSelector [

	"Since it can have many, use anAspectVariantSelector 
	to decide in what aspect to render aRidePresenter."

	self halt.
	^ Ride resource
]
