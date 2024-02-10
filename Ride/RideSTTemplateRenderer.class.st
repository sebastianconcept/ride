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
RideSTTemplateRenderer >> render: aTemplateName inLayout: aLayoutNameOrNil on: aTemplateContext for: aRidePresenter [

	"Render the template found with aTemplateName embedded 
	in the layout at aLayoutNameOrNil for aRidePresenter."

	| layoutWrapper wrappedTemplate missingTemplate |
	missingTemplate := [ :templateName | 
	                   RideMissingTemplateError signal: templateName ].
	layoutWrapper := (self templates at: #layouts)
		                 at: aLayoutNameOrNil
		                 ifAbsent: [ 
		                 missingTemplate value: aLayoutNameOrNil ].
	wrappedTemplate := ((self templates at: #views)
		                    at: aRidePresenter class getNormalizedModelName
		                    ifAbsent: [ 
		                    missingTemplate value:
			                    aRidePresenter class getNormalizedModelName ])
		                   at: aTemplateName
		                   ifAbsent: [ missingTemplate value: aTemplateName ].

	^ layoutWrapper renderOn: aTemplateContext partial: wrappedTemplate
]