"
I help locating the templates that are meant to be views.
"
Class {
	#name : #RideViewPresenterLocator,
	#superclass : #Object,
	#instVars : [
		'templates',
		'presenters'
	],
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideViewPresenterLocator >> getMustacheTemplagesIn: aPath [

	"Returns only the .mustache template files in aPath"

	| accepted |
	accepted := #( mustache mst ms tmpl ).
	^ aPath files select: [ :file | accepted includes: file extension ]
]

{ #category : #accessing }
RideViewPresenterLocator >> getPresenters [

	"Returns a dictionary with keys being view names (views/ subdirectory names) 
	and as value, the corresponding presenter classes expected to be found in the image."

	| newPresenters |
	newPresenters := Dictionary new.
	self viewTemplates keys do: [ :routeName | 
		newPresenters at: routeName put: (Smalltalk
				 at: (self presenterNameFor: routeName) asSymbol
				 ifAbsent: [ 
					 RideMissingPresenterError signal:
						 ('{1} not found' format:
							  { (self presenterNameFor: routeName) }) ]) ].
	^ newPresenters
]

{ #category : #accessing }
RideViewPresenterLocator >> getTemplates [

	"Returns a dictionary with keys being view names (views/ dsubirectory names) 
	and as value, a dictionary with mustache templates for every file found."

	| newTemplates newViewTemplates |

	newTemplates := JsonObject new.
	newViewTemplates := JsonObject new.
	RideDirectoryResolver viewTemplatesDirectory directories do: [ :path | 
		newViewTemplates
			at: path basenameWithoutExtension
			put: (self getTemplatesFrom: path) ].
	newTemplates
		at:
		RideDirectoryResolver viewTemplatesDirectory basenameWithoutExtension
		put: newViewTemplates.
	RideDirectoryResolver layoutTemplatesDirectory files do: [ :file | 
		(newTemplates
			 at:
			 RideDirectoryResolver layoutTemplatesDirectory
				 basenameWithoutExtension
			 ifAbsentPut: [ JsonObject new ])
			at: file basenameWithoutExtension
			put: file contents asMustacheTemplate ].
	RideDirectoryResolver sharedTemplatesDirectory files do: [ :file | 
		(newTemplates
			 at:
			 RideDirectoryResolver sharedTemplatesDirectory
				 basenameWithoutExtension
			 ifAbsentPut: [ JsonObject new ])
			at: file basenameWithoutExtension
			put: file contents asMustacheTemplate ].
	^ newTemplates
]

{ #category : #accessing }
RideViewPresenterLocator >> getTemplatesFrom: aPath [

	"Returns a dictionary with keys being the filenames (without extension) of aPath
	and as value, the mustache template based on its content."

	| newTemplates |
	newTemplates := JsonObject new.
	(self getMustacheTemplagesIn: aPath) do: [ :file | 
		newTemplates
			at: file basenameWithoutExtension
			put: file contents asMustacheTemplate ].

	^ newTemplates
]

{ #category : #initialization }
RideViewPresenterLocator >> initializePresenters [

	^ presenters := self getPresenters
]

{ #category : #initialization }
RideViewPresenterLocator >> initializeTemplates [

	^ templates := self getTemplates
]

{ #category : #accessing }
RideViewPresenterLocator >> layoutTemplates [

	^ self templates
		  at: #layouts
		  ifAbsent: [ 
		  RideMissingTemplateError signal: 'No layout templates' ]
]

{ #category : #accessing }
RideViewPresenterLocator >> presenterNameFor: routeName [

	^ '{1}Presenter' format: { ('' join:
			   ((routeName substrings: '_') collect: [ :e | e capitalized ])) }
]

{ #category : #accessing }
RideViewPresenterLocator >> presenters [

	^ presenters ifNil: [ self initializePresenters ]
]

{ #category : #accessing }
RideViewPresenterLocator >> sharedTemplates [

	^ self templates
		  at: #shared
		  ifAbsent: [ 
		  RideMissingTemplateError signal: 'No shared templates' ]
]

{ #category : #accessing }
RideViewPresenterLocator >> templates [

	^ templates ifNil: [ self initializeTemplates ]
]

{ #category : #accessing }
RideViewPresenterLocator >> templatesFor: aPresenter [

	| views modelName kebabized found |
	views := self templates at: #views.
	modelName := aPresenter class getModelName.
	kebabized := '-' join: (modelName asSnakeCase substrings: '_').
	found := views at: kebabized.
	^ found
		  ifNil: [ views at: modelName asSnakeCase ]
		  ifNotNil: [ found ]
]

{ #category : #accessing }
RideViewPresenterLocator >> viewTemplates [

	^ self templates
		  at: #views
		  ifAbsent: [ RideMissingTemplateError signal: 'No templates for the views?' ]
]
