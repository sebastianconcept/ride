"
I can compose emails and send them with a provider
"
Class {
	#name : #RideEmailComposer,
	#superclass : #Object,
	#instVars : [
		'provider'
	],
	#classInstVars : [
		'htmlTemplates',
		'textTemplates'
	],
	#category : #'Ride-EMail'
}

{ #category : #accessing }
RideEmailComposer class >> htmlTemplates [

	^ htmlTemplates ifNil: [ htmlTemplates := SmallDictionary new ]
]

{ #category : #accessing }
RideEmailComposer class >> reset [

	textTemplates := nil.
	htmlTemplates := nil
]

{ #category : #accessing }
RideEmailComposer class >> textTemplates [

	^ textTemplates ifNil: [ textTemplates := SmallDictionary new ]
]

{ #category : #accessing }
RideEmailComposer >> htmlFor: aSymbol [

	^ self class htmlTemplates
		  at: ('{1}.{2}' format: { 
					   RideLanguage value.
					   aSymbol })
		  ifAbsentPut: [ self loadHtmlFor: aSymbol ]
]

{ #category : #accessing }
RideEmailComposer >> load: type for: aSymbol [

	| baseDir locale |
	baseDir := Smalltalk image imageDirectory / 'templates' / 'email'
	           / type.
	locale := RideLanguage value.
	"If we have an issue locating the locale, fallback to english."
	((baseDir / locale) exists not or: [ locale isNil ]) ifTrue: [ 
		locale := 'en' ].
	^ (baseDir / locale / ('{1}.mustache' format: { aSymbol }))
		  readStream contents asMustacheTemplate
]

{ #category : #accessing }
RideEmailComposer >> loadHtmlFor: aSymbol [

	^ self load: 'html' for: aSymbol
]

{ #category : #accessing }
RideEmailComposer >> loadSubjectFor: aSymbol [

	| baseDir locale |
	baseDir := Smalltalk image imageDirectory / 'templates' / 'email'
	           / 'text'.
	locale := RideLanguage value.
	"If we have an issue locating the locale, fallback to english."
	((baseDir / locale) exists not or: [ locale isNil ]) ifTrue: [ 
		locale := 'en' ].
	^ (baseDir / locale / ('{1}.subject.mustache' format: { aSymbol }))
		  readStream contents asMustacheTemplate
]

{ #category : #accessing }
RideEmailComposer >> loadTextFor: aSymbol [

	^ self load: 'text' for: aSymbol
]

{ #category : #accessing }
RideEmailComposer >> provider [

	^ provider
]

{ #category : #accessing }
RideEmailComposer >> provider: anObject [

	provider := anObject
]

{ #category : #accessing }
RideEmailComposer >> subjectFor: aSymbol [

	^ self class textTemplates
		  at: ('{1}.{2}.subject' format: { 
					   RideLanguage value.
					   aSymbol })
		  ifAbsentPut: [ self loadSubjectFor: aSymbol ]
]

{ #category : #accessing }
RideEmailComposer >> textFor: aSymbol [

	^ self class textTemplates
		  at: ('{1}.{2}' format: { 
					   RideLanguage value.
					   aSymbol })
		  ifAbsentPut: [ self loadTextFor: aSymbol ]
]
