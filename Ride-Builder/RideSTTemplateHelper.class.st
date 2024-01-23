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
	  , '<script type="text/javascript" src="<st= self >"></script>'
]

{ #category : #accessing }
RideSTTemplateHelper class >> editContentFor: aSymbol [

	^ '<st STT yield: ''shared/feedback.html'' on: self >
<div class="container">
	<h1>Editing {3}</h1>
	<div>
		<st= self render: ''form.html'' on: model>	
	</div>
	<a href="/{4}/<st= model id>">Show this {3}</a>
	<a href="/{4}">Back to {2}</a>
</div>	
' format: { 
			  aSymbol asPlural.
			  aSymbol asPlural uncapitalized.
			  aSymbol uncapitalized.
			  aSymbol asPlural asSnakeCase }
]

{ #category : #accessing }
RideSTTemplateHelper class >> formContentFor: aSymbol [

	^ '<form action="/{4}/">
	<label for="title">{3}</label>
	<input type="text" name="{3}" id="{3}" autocomplete="{3}" placeholder="{5}">
	<button type="submit">Submit</button>
</form>
' format: { 
			  aSymbol asPlural.
			  aSymbol asPlural uncapitalized.
			  aSymbol uncapitalized.
			  aSymbol asPlural asSnakeCase.
			  aSymbol }
]

{ #category : #accessing }
RideSTTemplateHelper class >> indexContentFor: aSymbol [

	^ '<st STT yield: ''shared/feedback.html'' on: self >
<div class="container">
	<h1>{1}</h1>
	<div>
		<a href="/{2}/new">New {3}</a>
		<ul>
			<st self {2} do: [ :{3} | >
				<li>
					<st= self render: {3}>
					<ul>
						<li>
							<a href="/{4}/<st= {3} id>/show">Show this {3}</a>
						</li>
						<li>
							<a href="/{4}/<st= {3} id>/edit">Edit this {3}</a>
						</li>
						<li>
							<a href="/{4}/<st= {3} id>/delete">Delete this {3}</a>
						</li>
					</ul>
				</li>
			<st ] >
		</ul>
	</div>
</div>
' format: { 
			  aSymbol asPlural.
			  aSymbol asPlural uncapitalized.
			  aSymbol uncapitalized.
			  aSymbol asPlural asSnakeCase }
]

{ #category : #accessing }
RideSTTemplateHelper class >> newContentFor: aSymbol [

	^ '<st STT yield: ''shared/feedback.html'' on: self >
<div class="container">
	<h1>New {3}</h1>
	<div>
		<st= self render: ''form.html'' on: model>	
	</div>
	<a href="/{4}">Back to {2}</a>
</div>	
' format: { 
			  aSymbol asPlural.
			  aSymbol asPlural uncapitalized.
			  aSymbol uncapitalized.
			  aSymbol asPlural asSnakeCase }
]

{ #category : #accessing }
RideSTTemplateHelper class >> showContentFor: aSymbol [

	^ '<st STT yield: ''shared/feedback.html'' on: self >
<div class="container">
	<h1>{1}</h1>
	<st= self render: model>
	<div>
		<ul>
			<li>
				<a href="/{4}/<st= model id>/edit">Edit this {3}</a>
			</li>
			<li>
				<a href="/{4}/<st= model id>/delete">Delete this {3}</a>
			</li>
		</ul>
	</div>
	<a href="/{4}">Back to {2}</a>
</div>
' format: { 
			  aSymbol.
			  aSymbol asPlural uncapitalized.
			  aSymbol uncapitalized.
			  aSymbol asPlural asSnakeCase.
			  aSymbol asPlural }
]

{ #category : #actions }
RideSTTemplateHelper >> crudEditFor: aSymbol [

	"Creates the template file for editing a model named aSymbol.
	Find it as edit.html.stt"

	self
		template: #edit
		for: aSymbol
		contents: (self class editContentFor: aSymbol)
]

{ #category : #actions }
RideSTTemplateHelper >> crudFormFor: aSymbol [

	"Creates the template file for the view showing the form on a model named aSymbol.
	Find it as form.html.stt"

	self
		template: #form
		for: aSymbol
		contents: (self class formContentFor: aSymbol)
]

{ #category : #actions }
RideSTTemplateHelper >> crudIndexFor: aSymbol [

	"Creates the template file for the default view of the model named aSymbol.
	Find it as index.html.stt"

	self
		template: #index
		for: aSymbol
		contents: (self class indexContentFor: aSymbol)
]

{ #category : #actions }
RideSTTemplateHelper >> crudNewFor: aSymbol [

	"Creates the template file for the view showing many models named aSymbol.
	Find it as show.html.stt"

	self
		template: #new
		for: aSymbol
		contents: (self class newContentFor: aSymbol)
]

{ #category : #actions }
RideSTTemplateHelper >> crudShowFor: aSymbol [

	"Creates the template file for the view showing many models named aSymbol.
	Find it as show.html.stt"

	self
		template: #show
		for: aSymbol
		contents: (self class showContentFor: aSymbol)
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

{ #category : #actions }
RideSTTemplateHelper >> template: aTemplateSelectorName for: aSymbol contents: aString [

	| targetPath templateContentString |
	"Find the right path for the view template"
	targetPath := (self class getPathFor: aSymbol) asFileReference
	              / ('{1}.html.stt' format: { aTemplateSelectorName }).

	"Verify lack of preexistence to protect possible existing work."
	targetPath exists ifTrue: [ 
		RideBoilerplateError signal:
			('The template {1} for {2} already exists in {3}' format: { 
					 aTemplateSelectorName.
					 aSymbol.
					 targetPath pathString }) ].

	"Create the template file adding js if it has a related one and asked for it."
	templateContentString := aString.
	js ifTrue: [ 
		templateContentString := String streamContents: [ :s | 
			                         s
				                         nextPutAll: templateContentString;
				                         cr;
				                         nextPutAll:
					                         self class loadCustomJsScriptElement ] ].

	targetPath ensureCreateFile writeStreamDo: [ :stream | 
		stream nextPutAll: templateContentString ].

	js ifTrue: [ 
		(targetPath / ('{1}.js' format: { aTemplateSelectorName }))
			ensureCreateFile writeStreamDo: [ :stream | 
			stream nextPutAll:
				(self class defaultJavaScriptFor: aTemplateSelectorName) ] ]
]
