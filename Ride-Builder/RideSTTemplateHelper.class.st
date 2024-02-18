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
  <p>Find the source of the <%= self class name%> template in</p><p><code><%= (Ride resource viewsDirectory / self class getModelName asSnakeCase) pathString %></code></p>
</div>'
]

{ #category : #accessing }
RideSTTemplateHelper class >> defaultViewTemplateWithJs [

	^ self defaultViewTemplate
	  , '<script type="text/javascript" src="<%= self%>"></script>'
]

{ #category : #accessing }
RideSTTemplateHelper class >> editContentFor: aSymbol [

	^ '<% STT yield: self using: ''shared/feedback.html'' %>
<div class="container">
	<h1>Editing {3}</h1>
	<div>
		<%= self render: self using: ''formEdit.html''%>	
	</div>
	<a href="/{4}/<%= model id%>">Show this {3}</a>
	<a href="/{4}">Back to {2}</a>
</div>	
' format: { 
			  aSymbol asPlural.
			  aSymbol asPlural uncapitalized.
			  aSymbol uncapitalized.
			  aSymbol asPlural asSnakeCase }
]

{ #category : #accessing }
RideSTTemplateHelper class >> formEditContentFor: aSymbol [

	^ '<form action="/{4}/<%= model id%>" accept-charset="UTF-8" method="POST">
	<input type="hidden" name="_method" value="PATCH" autocomplete="off">
	<input type="hidden" name="authenticity_token" value="<%= self newAuthToken%>" autocomplete="off">
	<%= self render: model using: ''formFields.html''%>
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
RideSTTemplateHelper class >> formFieldsContentFor: aSymbol [

	^ '
	<label for="title">{3}</label>
	<input type="text" name="title" id="title" autocomplete="title" placeholder="{5}" value="<%= self title%>">
' format: { 
			  aSymbol asPlural.
			  aSymbol asPlural uncapitalized.
			  aSymbol uncapitalized.
			  aSymbol asPlural asSnakeCase.
			  aSymbol }
]

{ #category : #accessing }
RideSTTemplateHelper class >> formNewContentFor: aSymbol [

	^ '<form action="/{4}/" accept-charset="UTF-8" method="POST">
	<input type="hidden" name="_method" value="POST" autocomplete="off">
	<input type="hidden" name="authenticity_token" value="<%= self newAuthToken %>" autocomplete="off">

	<%= self render: model using: ''formFields.html''%>
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

	^ '<% STT yield: self using: ''shared/feedback.html'' %>
<div class="container">
	<h1>{1}</h1>
	<div>
		<a href="/{2}/new">New {3}</a>
		<ul>
			<% self {2} do: [ :{3} | %>
				<li>
					<%= self render: {3}%>
					<ul>
						<li>
							<a href="/{4}/<%= {3} id%>">Show this {3}</a>
						</li>
						<li>
							<a href="/{4}/<%= {3} id%>/edit">Edit this {3}</a>
						</li>
						<li>
							<a href="/{4}/<%= {3} id%>/delete">Delete this {3}</a>
						</li>
					</ul>
				</li>
			<% ] %>
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
RideSTTemplateHelper class >> modelDisplayContentFor: aSymbol [

	^ '
	<h2><div>Title:</div><div><%= self title%></div></h2>
' format: { 
			  aSymbol asPlural.
			  aSymbol asPlural uncapitalized.
			  aSymbol uncapitalized.
			  aSymbol asPlural asSnakeCase.
			  aSymbol }
]

{ #category : #accessing }
RideSTTemplateHelper class >> newContentFor: aSymbol [

	^ '<% STT yield: self using: ''shared/feedback.html'' %>
<div class="container">
	<h1>New {3}</h1>
	<div>
		<%= self renderUsing: ''formNew.html'' %>	
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

	^ '<%= self render: self using: ''shared/feedback.html'' %>
<div class="container">
	<h1>{1}</h1>
	<%= self render: model %>
	<div>
		<ul>
			<li>
				<a href="/{4}/<%= model id %>/edit">Edit this {3}</a>
			</li>
			<li>
				<form action="/{4}/<%= model id%>" method="POST">
					<input type="hidden" name="_method" value="delete" autocomplete="off">
					<input type="hidden" name="authenticity_token" value="<%= self newAuthToken %>" autocomplete="off">
					<button type="submit">Delete this {3}</button>
				</form>
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
RideSTTemplateHelper >> crudFormEditFor: aSymbol [

	"Creates the template file for the view showing the form that updates an existing model named aSymbol.
	Find it as formEdit.html.stt"

	self
		template: #formEdit
		for: aSymbol
		contents: (self class formEditContentFor: aSymbol)
]

{ #category : #actions }
RideSTTemplateHelper >> crudFormFieldsFor: aSymbol [

	"Creates the template file for the view showing the common fields in the forms
	typically used in creating and editing aSymbol models.
	Find it as formFields.html.stt"

	self
		template: #formFields
		for: aSymbol
		contents: (self class formFieldsContentFor: aSymbol)
]

{ #category : #actions }
RideSTTemplateHelper >> crudFormNewFor: aSymbol [

	"Creates the template file for the view showing the form that creates a new model named aSymbol.
	Find it as formNew.html.stt"

	self
		template: #formNew
		for: aSymbol
		contents: (self class formNewContentFor: aSymbol)
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
RideSTTemplateHelper >> crudModelDisplayContentFor: aSymbol [

	"Creates the template file for the view showing one model named aSymbol.
	Find it as <aSymbol asSnakeCase>.html.stt"

	self
		template: aSymbol uncapitalized asSnakeCase
		for: aSymbol
		contents: (self class modelDisplayContentFor: aSymbol)
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
