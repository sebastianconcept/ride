"
I can render a Ride presenter based in a template
"
Class {
	#name : #RideTemplateBasedRenderer,
	#superclass : #RideRenderer,
	#category : #'Ride-Renderers'
}

{ #category : #accessing }
RideTemplateBasedRenderer class >> templateTypeExtentions [

	"Answers the filename extentions for template types accepted by the receiver."

	self subclassResponsibility
]

{ #category : #accessing }
RideTemplateBasedRenderer class >> templatesValueSelector [

	"Answer the selector to find the templates that Ride has as system has for this receiver."

	self subclassResponsibility
]

{ #category : #accessing }
RideTemplateBasedRenderer >> getTemplates [

	"Returns a dictionary with keys being view names (views/ subirectory names) 
	and as value, a dictionary with the receiver template instantiated 
	from the source in every file found."

	| newTemplates newViewTemplates newEmailTemplates resourceLocator |
	resourceLocator := Ride resource.
	newTemplates := JsonObject new.
	newViewTemplates := JsonObject new.
	resourceLocator viewTemplatesDirectory asFileReference directories 
		do: [ :path | 
			newViewTemplates
				at: path basenameWithoutExtension
				put: (self getTemplatesFrom: path) ].
	newTemplates
		at: resourceLocator viewTemplatesDirectory basenameWithoutExtension
		put: newViewTemplates.
	resourceLocator layoutTemplatesDirectory asFileReference files do: [ 
		:file | 
		(newTemplates
			 at:
			 resourceLocator layoutTemplatesDirectory basenameWithoutExtension
			 ifAbsentPut: [ JsonObject new ])
			at: file basenameWithoutExtension
			put: (self newTemplateFrom: file) ].
	resourceLocator sharedTemplatesDirectory asFileReference files do: [ 
		:file | 
		(newTemplates
			 at:
			 resourceLocator sharedTemplatesDirectory basenameWithoutExtension
			 ifAbsentPut: [ JsonObject new ])
			at: file basenameWithoutExtension
			put: (self newTemplateFrom: file) ].
	newEmailTemplates := JsonObject new.
	resourceLocator emailTemplatesDirectory asFileReference directories 
		do: [ :path | 
			newEmailTemplates
				at: path basenameWithoutExtension
				put: (self getTemplatesFrom: path) ].
	newTemplates
		at: resourceLocator emailTemplatesDirectory basenameWithoutExtension
		put: newEmailTemplates.
	^ newTemplates
]

{ #category : #accessing }
RideTemplateBasedRenderer >> getTemplatesFrom: aPath [

	"Returns a dictionary with keys being the filenames (without extension) of aPath
	and as value, the receiver type of template based on its content."

	| newTemplates |
	newTemplates := JsonObject new.
	(self getTemplatesIn: aPath) do: [ :file | 
		newTemplates
			at: file basenameWithoutExtension
			put: (self newTemplateFrom: file) ].

	^ newTemplates
]

{ #category : #accessing }
RideTemplateBasedRenderer >> getTemplatesIn: aPath [

	"Returns only the template for the receiver type of files in aPath"

	| accepted |
	accepted := self class templateTypeExtentions.
	^ aPath files select: [ :file | accepted includes: file extension ]
]

{ #category : #accessing }
RideTemplateBasedRenderer >> newTemplateFrom: file [

	"Answer a new instance of the template that comes from the source in the given file."

	self subclassResponsibility
]

{ #category : #accessing }
RideTemplateBasedRenderer >> templates [

	^ [ self getTemplates ] systemValueAt:
		  self class templatesValueSelector
]
