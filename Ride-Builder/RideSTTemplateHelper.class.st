"
I help with the boilerplate of views made out of STTemplate
"
Class {
	#name : #RideSTTemplateHelper,
	#superclass : #RideAbstractTemplateHelper,
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RideSTTemplateHelper class >> defaultViewTemplate [

	^ '<div>
  <p>Find the source of the <st= self class name> template in</p><p><code><st= (Ride resource viewsDirectory / self class getModelName asSnakeCase) pathString ></code></p>
</div>'
]

{ #category : #accessing }
RideSTTemplateHelper class >> defaultViewTemplateWithJs [

	^ self defaultViewTemplate
	  , '<script type="text/javascript" src="{{ indexJs }}"></script>'
]

{ #category : #'instance creation' }
RideSTTemplateHelper >> for: aSymbol [

	| targetPath rendered |
	"Find the right path for the view template"
	targetPath := (self class getPathFor: aSymbol) asFileReference.

	"Verify lack of preexistence to protect possible existing work."
	targetPath exists ifTrue: [ 
		RideBoilerplateError signal:
			('The template for {1} already exists in {2}' format: { 
					 aSymbol.
					 targetPath pathString }) ].

	"Create the template file using the default template for a model"
	rendered := js
		            ifTrue: [ self class defaultViewTemplateWithJs ]
		            ifFalse: [ self class defaultViewTemplate ].

	(targetPath / 'index.html.stt') ensureCreateFile writeStreamDo: [ 
		:stream | stream nextPutAll: rendered ].

	js ifTrue: [ 
		(targetPath / 'index.js') ensureCreateFile writeStreamDo: [ :stream | 
			stream nextPutAll: (self class defaultJavaScriptFor: aSymbol) ] ]
]
