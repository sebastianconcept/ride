"
I help with the boilerplate of views made out of STTemplate
"
Class {
	#name : #RideSTTemplateHelperReview,
	#superclass : #RideAbstractTemplateHelper,
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RideSTTemplateHelperReview class >> defaultJavaScriptFor: aSymbol [

	^ 'window.addEventListener("load", (event) => \{
  console.log("{1} initialized");
\});
' format: { aSymbol }
]

{ #category : #accessing }
RideSTTemplateHelperReview class >> defaultViewTemplate [

	^ '<h1>{{title}}</h1>'
]

{ #category : #accessing }
RideSTTemplateHelperReview class >> defaultViewTemplateWithJs [

	^ '<h1>{{title}}</h1>
<script type="text/javascript" src="{{ indexJs }}"></script>'
]

{ #category : #accessing }
RideSTTemplateHelperReview class >> editMustacheTemplateContent: aSymbol [

	^ '<h1>Editing {1}</h1>
\{\{>form{1}\}\}
<br>
<div>
  <a href="/{2}/\{\{modelId\}\}">Show this {3}</a>
  <a href="/{2}">Back to {4}</a>
</div>
' format: { 
			  aSymbol.
			  aSymbol asPlural asSnakeCase.
			  aSymbol uncapitalized.
			  aSymbol asPlural uncapitalized }
]

{ #category : #accessing }
RideSTTemplateHelperReview class >> formMustacheTemplateContent: aSymbol [

	^ '<form action="/{1}/\{\{modelId\}\}" method="POST" accept-charset="UTF-8">
  \{\{>userFeedback\}\}
  <div>
    <label name="\{\{name\}\}" style="display: block">
    <input type="text" placeholder="Type name here" value="\{\{name\}\}">
  </div>
  <div>
    <label name="\{\{notes\}\}" style="display: block">
    <input type="text" placeholder="Type notes here" value="\{\{notes\}\}">
  </div>
  <button type="submit">Submit</a>
</form>
' format: { aSymbol asPlural asSnakeCase }
]

{ #category : #accessing }
RideSTTemplateHelperReview class >> getPathFor: aSymbol [

	^ Ride resource viewsDirectory / aSymbol asPlural asSnakeCase
]

{ #category : #accessing }
RideSTTemplateHelperReview class >> indexMustacheTemplateContent: aSymbol [

	^ '\{\{#notice\}\}
  <p style="color: green">\{\{notice\}\}</p>
\{\{/notice\}\}

<h1>{1}</h1>

<div>
  \{\{#{2}\}\}
    \{\{>{3}\}\}
    <p>
      <a href="/{4}/\{\{id\}\}">Show this {3}</a>
    </p>
  \{\{/{2}\}\}
</div>

<a href="/{4}">New {3}</a>
' format: { 
			  aSymbol asPlural.
			  aSymbol asPlural uncapitalized.
			  aSymbol uncapitalized.
			  aSymbol asPlural asSnakeCase }
]

{ #category : #accessing }
RideSTTemplateHelperReview class >> loadCustomJsScriptElement [

	^ '<script type="text/javascript" src="{{ indexJs }}"></script>'
]

{ #category : #accessing }
RideSTTemplateHelperReview class >> modelMustacheTemplateContent: aSymbol [

	^ '<div data-id="\{\{modelId\}\}">
  <p>
    <strong>{1}: </strong>
    \{\{modelId\}\}
  </p>
</div>
' format: { aSymbol }
]

{ #category : #accessing }
RideSTTemplateHelperReview class >> newModelMustacheTemplateContent: aSymbol [

	^ '<h1>New {1}</h1>
\{\{>form{1}\}\}
<br>
<div>
  <a href="/{2}">Back to {3}</a>
</div>
' format: { 
			  aSymbol.
			  aSymbol asPlural asSnakeCase.
			  aSymbol asPlural uncapitalized }
]

{ #category : #accessing }
RideSTTemplateHelperReview class >> showMustacheTemplateContent: aSymbol [

	^ '\{\{#notice\}\}
  <p style="color: green">\{\{notice\}\}</p>
\{\{/notice\}\}

\{\{>{3}\}\}

<div>
  <a href="/{2}/\{\{modelId\}\}/edit">Edit this {3}</a>
  <a href="/{2}">Back to {4}</a>
  <form action="/{2}/\{\{modelId\}\}" method="DELETE">
    <button type="submit">Destroy this {3}</a>
  </form>
</div>
' format: { 
			  aSymbol.
			  aSymbol asPlural asSnakeCase.
			  aSymbol uncapitalized.
			  aSymbol asPlural uncapitalized }
]

{ #category : #actions }
RideSTTemplateHelperReview >> crudEditFor: aSymbol [

	| targetPath rendered templateFilename |
	self halt.
	"Find the right path for the view template"
	targetPath := (self class getPathFor: aSymbol) asFileReference.

	"Verify lack of preexistence to protect possible existing work."
	templateFilename := 'edit{1}.mustache' format: { aSymbol }.

	self
		assert: (targetPath / templateFilename) exists not
		description:
			('The template for {1} already exists in {2}' format: { 
					 aSymbol.
					 targetPath pathString }).

	"Get the template content"
	rendered := self class editMustacheTemplateContent: aSymbol.

	(targetPath / templateFilename) ensureCreateFile writeStreamDo: [ 
		:stream | stream nextPutAll: rendered ]
]

{ #category : #actions }
RideSTTemplateHelperReview >> crudFormFor: aSymbol [

	| targetPath rendered templateFilename |
	self halt.
	"Find the right path for the view template"
	targetPath := (self class getPathFor: aSymbol) asFileReference.

	"Verify lack of preexistence to protect possible existing work."
	templateFilename := 'form{1}.mustache' format: { aSymbol }.

	self
		assert: (targetPath / templateFilename) exists not
		description:
			('The template for {1} already exists in {2}' format: { 
					 aSymbol.
					 targetPath pathString }).

	"Get the template content"
	rendered := self class formMustacheTemplateContent: aSymbol.

	(targetPath / templateFilename) ensureCreateFile writeStreamDo: [ 
		:stream | stream nextPutAll: rendered ]
]

{ #category : #actions }
RideSTTemplateHelperReview >> crudIndexFor: aSymbol [

	| targetPath rendered |
	self halt.
	"Find the right path for the view template"
	targetPath := (self class getPathFor: aSymbol) asFileReference.

	"Verify lack of preexistence to protect possible existing work."
	targetPath exists ifTrue: [ 
		RideBoilerplateError signal:
			('The template for {1} already exists in {2}' format: { 
					 aSymbol.
					 targetPath pathString }) ].

	"Create the template file using the default template for a model"
	rendered := self class indexMustacheTemplateContent: aSymbol.
	js ifTrue: [ 
		rendered := String streamContents: [ :s | 
			            s
				            nextPutAll: rendered;
				            cr;
				            nextPutAll: self class loadCustomJsScriptElement ] ].

	(targetPath / 'index.mustache') ensureCreateFile writeStreamDo: [ 
		:stream | stream nextPutAll: rendered ].

	js ifTrue: [ 
		(targetPath / 'index.js') ensureCreateFile writeStreamDo: [ :stream | 
			stream nextPutAll: (self class defaultJavaScriptFor: aSymbol) ] ]
]

{ #category : #actions }
RideSTTemplateHelperReview >> crudModelFor: aSymbol [

	| targetPath rendered templateFilename |
	self halt.
	"Find the right path for the view template"
	targetPath := (self class getPathFor: aSymbol) asFileReference.

	"Verify lack of preexistence to protect possible existing work."
	templateFilename := '{1}.mustache' format: { aSymbol uncapitalized }.

	(targetPath / templateFilename) exists ifTrue: [ 
		RideBoilerplateError signal:
			('The template for {1} already exists in {2}' format: { 
					 aSymbol.
					 targetPath pathString }) ].

	"Get the template content"
	rendered := self class modelMustacheTemplateContent: aSymbol.

	(targetPath / templateFilename) ensureCreateFile writeStreamDo: [ 
		:stream | stream nextPutAll: rendered ]
]

{ #category : #actions }
RideSTTemplateHelperReview >> crudNewModelFor: aSymbol [

	| targetPath rendered templateFilename |
	self halt.
	"Find the right path for the view template"
	targetPath := (self class getPathFor: aSymbol) asFileReference.

	"Verify lack of preexistence to protect possible existing work."
	templateFilename := 'new{1}.mustache' format: { aSymbol }.

	(targetPath / templateFilename) exists ifTrue: [ 
		RideBoilerplateError signal:
			('The template for {1} already exists in {2}' format: { 
					 aSymbol.
					 targetPath pathString }) ].

	"Get the template content"
	rendered := self class newModelMustacheTemplateContent: aSymbol.

	(targetPath / templateFilename) ensureCreateFile writeStreamDo: [ 
		:stream | stream nextPutAll: rendered ]
]

{ #category : #actions }
RideSTTemplateHelperReview >> crudShowFor: aSymbol [

	| targetPath rendered templateFilename |
	self halt.
	"Find the right path for the view template"
	targetPath := (self class getPathFor: aSymbol) asFileReference.

	"Verify lack of preexistence to protect possible existing work."
	templateFilename := 'show{1}.mustache' format: { aSymbol }.

	(targetPath / templateFilename) exists ifTrue: [ 
		RideBoilerplateError signal:
			('The template for {1} already exists in {2}' format: { 
					 aSymbol.
					 targetPath pathString }) ].

	"Get the template content"
	rendered := self class showMustacheTemplateContent: aSymbol.

	(targetPath / templateFilename) ensureCreateFile writeStreamDo: [ 
		:stream | stream nextPutAll: rendered ]
]

{ #category : #actions }
RideSTTemplateHelperReview >> for: aSymbol [

	| targetPath rendered |
	self halt.
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
