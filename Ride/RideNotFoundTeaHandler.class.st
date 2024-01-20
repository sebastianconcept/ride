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

	| response feedbackMessage templateModel renderedContent origin template |
	feedbackMessage := 'Not found: {1}' format:
		                   { aZnRequest url asString }.
	[ feedbackMessage ] logWarning.
	templateModel := Ride service templates shared copy
		                 at: #status put: 404 asString;
		                 yourself.
	Ride isDevelopment ifTrue: [ 
		templateModel
			at: #error
			put: { (#messageText -> feedbackMessage) } asDictionary ].
	template := Ride service templates shared at: '404.html'.
	renderedContent := template
		                   renderOn: templateModel
		                   partials: Ride service templates shared.

	origin := aZnRequest headers at: 'origin' ifAbsent: [ '*' ].
	response := ZnResponse notFound: aZnRequest url.
	response resetEntity: (ZnEntity html: renderedContent).
	response headers
		at: 'Access-Control-Allow-Credentials' put: 'true';
		at: 'Access-Control-Allow-Origin' put: origin;
		yourself.
	^ response
]
