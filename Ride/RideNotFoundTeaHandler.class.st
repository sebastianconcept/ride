"
I'm a Teapot handler for its composite router to do the 404 in Ride style
"
Class {
	#name : #RideNotFoundTeaHandler,
	#superclass : #TeaNotFoundHandler,
	#category : #'Ride-HTTP'
}

{ #category : #'not found handler' }
RideNotFoundTeaHandler >> requestNotFound: aZnRequest [

	| response feedbackMessage templateModel mustacheTemplate renderedContent origin |
	feedbackMessage := 'Not found: {1}' format:
		                   { aZnRequest url asString }.
	[ feedbackMessage ] logWarning.
	templateModel := Ride resource sharedTemplates copy
		                 at: #status put: 404 asString;
		                 yourself.
	Ride isDevelopment ifTrue: [ 
		templateModel
			at: #error
			put: { (#messageText -> feedbackMessage) } asDictionary ].
	mustacheTemplate := Ride resource sharedTemplates at: 404 asString.
	renderedContent := mustacheTemplate
		                   value: templateModel
		                   partials: Ride resource sharedTemplates.

	origin := aZnRequest headers at: 'origin' ifAbsent: [ '*' ].
	response := ZnResponse notFound: aZnRequest url.
	response resetEntity: (ZnEntity html: renderedContent).
	response headers
		at: 'Access-Control-Allow-Credentials' put: 'true';
		at: 'Access-Control-Allow-Origin' put: origin;
		yourself.
	^ response
]
