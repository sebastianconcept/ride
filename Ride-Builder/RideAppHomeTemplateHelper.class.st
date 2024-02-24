"
I help creating the app Presenter class for the home path of a boilerplated app
"
Class {
	#name : #RideAppHomeTemplateHelper,
	#superclass : #RideBoilerplateHelper,
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RideAppHomeTemplateHelper class >> indexHTMLTemplateFor: aSymbol [

	^ '<div>
  <h1>Welcome to <%= self webAppName %></h1>
  <p>This page was rendered by a STTemplate generated for <%= self webAppName %>.</p>
  <p>Find my source in <code><%= self templatePath %></code></p>
</div>' format: { aSymbol }
]

{ #category : #'instance creation' }
RideAppHomeTemplateHelper >> for: aSymbol [

	| projectRoot file viewSelector |
	projectRoot := RideResource projectRootDirectory asFileReference.
	"Make a FileReference to where the template will be."
	viewSelector := '{1}Home' format: { aSymbol asString }.
	file := projectRoot / 'app' / 'templates' / 'views'
	        / viewSelector asSnakeCase.

	"Verify preexistence."
	file exists ifTrue: [ 
		RideBoilerplateError signal:
			('Aborting. The app directory already exist: {1}' format:
				 { file pathString }) ].
	[ 
	'Creating STTemplate for {1} in {2}' format: { 
			aSymbol.
			file pathString } ] logDebug.

	file ensureCreateDirectory.

	"Create the index template."
	file / 'index.html.stt' writeStreamDo: [ :stream | 
		stream nextPutAll: (self class indexHTMLTemplateFor: aSymbol) ]
]
