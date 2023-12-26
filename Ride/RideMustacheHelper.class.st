"
I help with the boilerplate of views made with mustache templates
"
Class {
	#name : #RideMustacheHelper,
	#superclass : #RideBoilerplateHelper,
	#instVars : [
		'js'
	],
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideMustacheHelper class >> defaultJavaScriptFor: aSymbol [

	^ 'window.addEventListener("load", (event) => \{
  console.log("{1} initialized");
\});
' format: { aSymbol }
]

{ #category : #accessing }
RideMustacheHelper class >> defaultViewTemplate [

	^ '<h1>{{title}}</h1>'
]

{ #category : #accessing }
RideMustacheHelper class >> defaultViewTemplateWithJs [

	^ '<h1>{{title}}</h1>
<script type="text/javascript" src="{{ indexJs }}"></script>'
]

{ #category : #accessing }
RideMustacheHelper class >> getPathFor: aSymbol [

	^ Ride service locator viewsPath / aSymbol asPlural asSnakeCase
]

{ #category : #actions }
RideMustacheHelper >> for: aSymbol [

	| targetPath rendered |
	"Find the right path for the view template"
	targetPath := (self class getPathFor: aSymbol) asFileReference.

	"Verify lack of preexistence to protect possible existing work."
	self
		assert: targetPath exists not
		description:
			('The template for {1} already exists in {2}' format: { 
					 aSymbol.
					 targetPath pathString }).

	"Create the template file using the default template for a model"
	rendered := js
		            ifTrue: [ self class defaultViewTemplateWithJs ]
		            ifFalse: [ self class defaultViewTemplate ].

	(targetPath / 'index.mustache') ensureCreateFile writeStreamDo: [ 
		:stream | stream nextPutAll: rendered ].

	js ifTrue: [ 
		(targetPath / 'index.js') ensureCreateFile writeStreamDo: [ :stream | 
			stream nextPutAll: (self class defaultJavaScriptFor: aSymbol) ] ]
]

{ #category : #initialization }
RideMustacheHelper >> initialize [

	js := false
]

{ #category : #accessing }
RideMustacheHelper >> js [

	^ js
]

{ #category : #accessing }
RideMustacheHelper >> js: anObject [

	js := anObject
]

{ #category : #actions }
RideMustacheHelper >> withJs [

	js := true
]

{ #category : #actions }
RideMustacheHelper >> withoutJs [

	js := false
]
