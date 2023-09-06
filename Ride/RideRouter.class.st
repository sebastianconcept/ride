"
I set the routes of a RideServer.

This is my convention for setting routes:

1. Define the list of directories under templates/views/ as the supported routes.
2. Every dirname is a route that will be rendered when hit with a GET or 404 otherwise.
3. Every other http method, is a method in a corresponding 'controller' named like this:
3.1 Take the view name and convert it from snake case to camel case and 
3.2 Suffix it with 'Controller'.
3.3 That controller should understand create for POST, destroy for DELETE, update for PATCH/PUT, show, edit. 
	
"
Class {
	#name : #RideRouter,
	#superclass : #Object,
	#classInstVars : [
		'templates',
		'controllers'
	],
	#category : #'Ride-REST'
}

{ #category : #accessing }
RideRouter class >> baseUrl [

	^ OSEnvironment current
		  at: #RIDE_BASE_URL
		  ifAbsent: [ self defaultBaseUrl ]
]

{ #category : #actions }
RideRouter class >> basicSetRoute: routeName with: someMustacheTemplates on: aRideServer [

	"Set the endpoints accepted for routeName in aRideServer based the
	given templates found and interpreted with the Ride convention:
	1. Templates under file names starting with underscore are partials.
	2. The '_form' partial is the default used for editing a model.
	3. The 'new' view also uses the _form partial (on a new model).
	4. The 'show' view will use _show partial to render the model.
	5. The 'edit' view will also use the _form partial to render a form for the model.
	"

	aRideServer teapot
		GET: self baseUrl , '/' , routeName , '/*'
			-> (self getHtmlHandlerFor: routeName with: someMustacheTemplates);
		output: #html.
	aRideServer teapot
		POST: self baseUrl , '/' , routeName , '/*'
			-> (self postHtmlHandlerFor: routeName with: someMustacheTemplates);
		output: #html.
	aRideServer teapot
		PUT: self baseUrl , '/' , routeName , '/*'
			-> (self putHtmlHandlerFor: routeName with: someMustacheTemplates);
		output: #html.
	aRideServer teapot
		PATCH: self baseUrl , '/' , routeName , '/*'
			->
				(self patchHtmlHandlerFor: routeName with: someMustacheTemplates);
		output: #html.
	aRideServer teapot
		DELETE: self baseUrl , '/' , routeName , '/*'
			-> (self deleteHtmlHandlerFor: routeName);
		output: #html
]

{ #category : #accessing }
RideRouter class >> controllerNameFor: routeName [

	^ '{1}Controller' format: { ('' join:
			   ((routeName substrings: '_') collect: [ :e | e capitalized ])) }
]

{ #category : #accessing }
RideRouter class >> controllers [

	^ controllers ifNil: [ self initializeControllers ]
]

{ #category : #accessing }
RideRouter class >> defaultBaseUrl [

	^ ''
]

{ #category : #handler }
RideRouter class >> deleteHtmlHandlerFor: routeName [

	^ (self controllers at: routeName ifAbsent: [ 
		   RideMissingControllerError signal:
			   ('{1} not found' format: { (self controllerNameFor: routeName) }) ])
		  destroy
]

{ #category : #accessing }
RideRouter class >> getControllers [

	"Returns a dictionary with keys being view names (view/ subdirectory names) 
	and as value, the corresponding controller classes expected to be found in the image."

	| newControllers |
	newControllers := Dictionary new.
	self templates keys do: [ :routeName | 
		newControllers at: routeName put: (Smalltalk
				 at: (self controllerNameFor: routeName) asSymbol
				 ifAbsent: [ 
					 RideMissingControllerError signal:
						 ('{1} not found' format:
							  { (self controllerNameFor: routeName) }) ]) ].
	^ newControllers
]

{ #category : #handler }
RideRouter class >> getHtmlHandlerFor: routeName with: someMustacheTemplates [

	^ (self controllers at: routeName ifAbsent: [ 
		   RideMissingControllerError signal:
			   ('{1} not found' format: { (self controllerNameFor: routeName) }) ]) 
		  showHtml: someMustacheTemplates
]

{ #category : #accessing }
RideRouter class >> getTemplates [

	"Returns a dictionary with keys being view names (view/ dsubirectory names) 
	and as value, a dictionary with mustache templates for every file found."

	| newTemplates |
	newTemplates := Dictionary new.
	RideDirectoryResolver getViewsDir directories do: [ :path | 
		(newTemplates
			 at: path basenameWithoutExtension
			 ifAbsentPut: Dictionary new)
			at: path basenameWithoutExtension
			put: (self getTemplatesFrom: path) ].

	^ newTemplates
]

{ #category : #accessing }
RideRouter class >> getTemplatesFrom: aPath [

	"Returns a dictionary with keys being the filenames (without extension) of aPath
	and as value, the mustache template based on its content."

	| newTemplates |
	newTemplates := Dictionary new.
	aPath files do: [ :file | 
		newTemplates
			at: file basenameWithoutExtension
			put: file contents asMustacheTemplate ].

	^ newTemplates
]

{ #category : #initialization }
RideRouter class >> initializeControllers [

	^ controllers := self getControllers
]

{ #category : #initialization }
RideRouter class >> initializeTemplates [

	^ templates := self getTemplates
]

{ #category : #handler }
RideRouter class >> patchHtmlHandlerFor: routeName with: someMustacheTemplates [

	^ (self controllers at: routeName ifAbsent: [ 
		   RideMissingControllerError signal:
			   ('{1} not found' format: { (self controllerNameFor: routeName) }) ]) 
		  updateWith: someMustacheTemplates
]

{ #category : #handler }
RideRouter class >> postHtmlHandlerFor: routeName with: someMustacheTemplates [

	^ (self controllers at: routeName ifAbsent: [ 
		   RideMissingControllerError signal:
			   ('{1} not found' format: { (self controllerNameFor: routeName) }) ]) 
		  createWith: someMustacheTemplates
]

{ #category : #handler }
RideRouter class >> putHtmlHandlerFor: routeName with: someMustacheTemplates [

	^ (self controllers at: routeName ifAbsent: [ 
		   RideMissingControllerError signal:
			   ('{1} not found' format: { (self controllerNameFor: routeName) }) ]) 
		  updateWith: someMustacheTemplates
]

{ #category : #actions }
RideRouter class >> reset [

	templates := nil
]

{ #category : #actions }
RideRouter class >> setRoute: routeName with: someMustacheTemplates on: aRideServer [

	someMustacheTemplates keysAndValuesDo: [ :route :mustacheTemplates | 
		self basicSetRoute: route with: mustacheTemplates on: aRideServer ]
]

{ #category : #actions }
RideRouter class >> setRoutesOn: aRideServer [

	self templates keysAndValuesDo: [ :key :value | 
		self setRoute: key with: value on: aRideServer ]
]

{ #category : #accessing }
RideRouter class >> templates [

	^ templates ifNil: [ self initializeTemplates ]
]
