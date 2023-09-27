"
I help Ride to be multilingual
"
Class {
	#name : #RideMultilingual,
	#superclass : #Object,
	#classInstVars : [
		'dictionaries'
	],
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideMultilingual class >> at: sentence in: aSymbol [

	| target |
	aSymbol ifNil: [ ^ sentence ].
	target := (aSymbol includes: $-)
		          ifTrue: [ aSymbol readStream upTo: $- ]
		          ifFalse: [ aSymbol ].

	^ (self dictionaries at: target asLowercase ifAbsent: [ ^ sentence ])
		  at: sentence
		  ifAbsent: [ sentence ]
]

{ #category : #initialization }
RideMultilingual class >> brazilianPortuguese [

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
		  ('Family name' -> 'Sobrenome') } asDictionary
]

{ #category : #accessing }
RideMultilingual class >> dictionaries [

	^ dictionaries ifNil: [ self initializeDictionaries ]
]

{ #category : #initialization }
RideMultilingual class >> initializeDictionaries [

	^ dictionaries := Dictionary new
]

{ #category : #initialization }
RideMultilingual class >> loadLanguages [

	self dictionaries
		at: 'pt' put: self brazilianPortuguese;
		at: 'es' put: self spanish;
		yourself
]

{ #category : #initialization }
RideMultilingual class >> reset [

	dictionaries := nil
]

{ #category : #initialization }
RideMultilingual class >> spanish [

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
		  ('Family name' -> 'Apellido') } asDictionary
]
