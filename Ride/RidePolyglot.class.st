"
I am the object that can help to make a Ride app multilingual
"
Class {
	#name : #RidePolyglot,
	#superclass : #Object,
	#classInstVars : [
		'dictionaries'
	],
	#category : #'Ride-Core'
}

{ #category : #actions }
RidePolyglot class >> at: sentence in: aSymbol [

	| target |
	target := (aSymbol includes: $-)
		          ifTrue: [ aSymbol readStream upTo: $- ]
		          ifFalse: [ aSymbol ].

	^ (self dictionaries at: target asLowercase ifAbsent: [ ^ sentence ])
		  at: sentence
		  ifAbsent: [ sentence ]
]

{ #category : #accessing }
RidePolyglot class >> brazilianPortuguese [

	^ { 
		  ('{1} should not be nil.' -> '{1} não deve ser nulo.').
		  ('{1} should not be empty.' -> '{1} não deve estar vazio.').
		  ('"{1}" should have valid E-Mail form.'
		   -> '"{1}" deveria ter forma de E-Mail válida.').
		  ('{1} content should not be shorter than {2}.'
		   -> 'O conteúdo "{1}" não deve ser menor do que {2}.').
		  ('name' -> 'nome').
		  ('I' -> 'Eu').
		  ('You' -> 'Você').
		  ('User already exists: {1}' -> 'O usuário já existe: {1}').
		  ('First name' -> 'Nome').
		  ('Family name' -> 'Sobrenome').
		  ('Hello from Proposto!' -> 'Olá da Proposto!') } asDictionary
]

{ #category : #accessing }
RidePolyglot class >> dictionaries [

	^ dictionaries ifNil: [ self initializeDictionaries ]
]

{ #category : #initialization }
RidePolyglot class >> initializeDictionaries [

	^ dictionaries := Dictionary new
]

{ #category : #actions }
RidePolyglot class >> loadLanguages [

	self dictionaries
		at: 'pt' put: self brazilianPortuguese;
		at: 'es' put: self spanish;
		yourself
]

{ #category : #actions }
RidePolyglot class >> reset [

	dictionaries := nil
]

{ #category : #accessing }
RidePolyglot class >> spanish [

	^ { 
		  ('{1} should not be nil.' -> '{1} no debe ser nulo.').
		  ('{1} should not be empty.' -> '{1} no debe estar vacío.').
		  ('"{1}" should have valid E-Mail form.'
		   -> '"{1}" debería tener forma de E-Mail valida.').
		  ('{1} content should not be shorter than {2}.'
		   -> 'El contenido "{1}" no debe ser menor que {2}.').
		  ('name' -> 'nombre').
		  ('I' -> 'Yo').
		  ('You' -> 'Usted').
		  ('User already exists: {1}' -> 'El usuario ye existe: {1}').
		  ('First name' -> 'Nombre').
		  ('Family name' -> 'Apellido').
		  ('Hello from Proposto!' -> '¡Hola desde Proposto!') } asDictionary
]
