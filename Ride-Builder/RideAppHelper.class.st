"
I'm a Ride helper dedicated to boilerplate a new Ride application
"
Class {
	#name : #RideAppHelper,
	#superclass : #RideCompositeHelper,
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RideAppHelper class >> applicationLayoutContentFor: aSymbol [

	^ '<!DOCTYPE html>
<html>
  <head>
    <title>{1}</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
    <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png" />
    <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png" />
    <link rel="manifest" href="/site.webmanifest" />
    <meta name="msapplication-TileColor" content="#da532c" />
    <meta name="theme-color" content="#ffffff" />
  </head>
  <body>
    <main>
      <st STT yield >
    </main>
  </body>
  <script
    src="https://unpkg.com/htmx.org@1.9.5"
    integrity="sha384-xcuj3WpfgjlKF+FXhSQFQ0ZNr39ln+hwjN3npfM9VBnUskLolQAcN80McRIVOPuO"
    crossorigin="anonymous"
  ></script>
</html>
' format: { aSymbol }
]

{ #category : #accessing }
RideAppHelper class >> changesContentFor: aSymbol [

	^ '{1}
===================================
- Initial entry in `CHANGES.md` for the `{2}` project.
- Started the work with generated boilerplate code for `{3}`.
' format: { 
			  DateAndTime now asDate yyyymmdd.
			  ('{1}App' format: { aSymbol }).
			  aSymbol }
]

{ #category : #accessing }
RideAppHelper class >> devEnvSampleContentFor: aSymbol [

	^ '## Environment variables used during the setup and operation of the Ride-based application
#
UID=`id -u`
GID=`id -g`
APP_NAME={1}
DOMAIN=example.com
VERSION=v0.0.1
MODE=development
LOGLEVEL=DEBUG
HTTP_DEBUG=1
HTTP_PORT=3004
HTTP_BIND=0.0.0.0
WEB_SOCKET_PORT=3008
REPL_PORT=4045
WORKER_POOL_SIZE=2
DATABASE_DIR=db
DATABASE_NAME={2}.dev.db
ASSETS_PATH=/opt/pharo/app/assets

SENDER_EMAIL_ADDRESS=team@example.com
BOUNCE_EMAIL_ADDRESS=team@bounce.example.com

# Secrets
STRIPE_SECRET_KEY=sk_test_1234432112344321

# Paths
PROJECT_ROOT_PATH=/opt/pharo/
ASSETS_PATH=/opt/pharo/app/assets

# Maintenance
MW=0
MW_TITLE="Leveling up in progress!"
MW_DETAILS="Our engineers are doing some behind-the-scenes work with the service."
MW_NOTES="This is a maintenance window that we had programmed to keep all working well, nothing to worry about. Get ready for an even smoother website experience soon!"
' format: { 
			  aSymbol.
			  aSymbol asSnakeCase }
]

{ #category : #accessing }
RideAppHelper class >> fiveHundredContentFor: aSymbol [

	^ '<!DOCTYPE html>
<html>
  <head>
    <title>We''re sorry, but something went wrong (500)</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
  </head>

  <body class="ride-default-error-page">
    <div class="dialog">
      <div>
        <h1>We''re sorry, but something went wrong.</h1>
      </div>
      <p>
        If you are the {1} application owner check the logs for more information.
      </p>
    </div>
  </body>
</html>
' format: { aSymbol }
]

{ #category : #accessing }
RideAppHelper class >> fourTwentyTwoContentFor: aSymbol [

	^ '<!DOCTYPE html>
<html>
  <head>
    <title>The change you wanted was rejected (422)</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
  </head>

 <body class="ride-default-error-page">
    <div class="dialog">
      <div>
        <h1>The change you wanted was rejected.</h1>
        <p>Maybe you tried to change something you didn''t have access to.</p>
      </div>
      <p>
        If you are the {1} application owner check the logs for more information.
      </p>
    </div>
  </body>
</html>
' format: { aSymbol }
]

{ #category : #accessing }
RideAppHelper class >> fourZeroFourContentFor: aSymbol [

	^ '<!DOCTYPE html>
<html>
  <head>
    <title>The page you were looking for doesn''t exist (404)</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
  </head>

  <body class="ride-default-error-page">
    <div class="dialog">
      <div>
        <h1>The page you were looking for doesn''t exist.</h1>
        <p>You may have mistyped the address or the page may have moved.</p>
      </div>
      <p>
        If you are the {1} application owner check the logs for more information.
      </p>
    </div>
  </body>
</html>
' format: { aSymbol }
]

{ #category : #accessing }
RideAppHelper class >> gitignoreContent [

	^ 'pharo*
Pharo*
*.image
*.changes

*.dylib
*.so

*.zip
*.log

.env
.dmp

docker/cache/
uploads/*
db/*

# Project specific
app/assets/*/**'
]

{ #category : #accessing }
RideAppHelper class >> maintenanceContentFor: aSymbol [

	^ '<!DOCTYPE html>
<html>
  <head>
    <title>The page you were looking for doesn''t exist (404)</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
  </head>

  <body class="ride-default-error-page">
    <div class="dialog">
      <div>
        <h1>The service is currently under maintenance.</h1>
        <p>This service is not in normal operations at the moment.</p>
      </div>
      <p>
        You can try using the {1} application at a later time.
      </p>
    </div>
  </body>
</html>
' format: { aSymbol }
]

{ #category : #accessing }
RideAppHelper class >> prodEnvSampleContentFor: aSymbol [

	^ '## Environment variables used during the setup and operation of the Ride-based application
#
UID=`id -u`
GID=`id -g`
APP_NAME={1}
DOMAIN=example.com
VERSION=v0.0.1
MODE=development
LOGLEVEL=DEBUG
HTTP_DEBUG=1
HTTP_PORT=3004
HTTP_BIND=0.0.0.0
WEB_SOCKET_PORT=3008
REPL_PORT=4045
WORKER_POOL_SIZE=2
DATABASE_DIR=db
DATABASE_NAME={2}.prod.db
ASSETS_PATH=/opt/pharo/app/assets

SENDER_EMAIL_ADDRESS=team@example.com
BOUNCE_EMAIL_ADDRESS=team@bounce.example.com

# Secrets
STRIPE_SECRET_KEY=sk_test_1234432112344321

# Paths
PROJECT_ROOT_PATH=/opt/pharo/
ASSETS_PATH=/opt/pharo/app/assets

# Maintenance
MW=0
MW_TITLE="Leveling up in progress!"
MW_DETAILS="Our engineers are doing some behind-the-scenes work with the service."
MW_NOTES="This is a maintenance window that we had programmed to keep all working well, nothing to worry about. Get ready for an even smoother website experience soon!"
' format: { 
			  aSymbol.
			  aSymbol asSnakeCase }
]

{ #category : #accessing }
RideAppHelper class >> readmeContentFor: aSymbol [

	^ '# {1}

A Ride-based application.

### Install in a Pharo image

Essential core:

```Smalltalk
Metacello new
  baseline: ''{1}'';
  repository: ''github://{2}/{1}'';
  load.
```

### Snippets
Handy to start stop the {1} Ride-based application:
```Smalltalk
"Stop and reset what any previously running Ride-based service:"
Ride stop; reset.

"Install the Ride-based application in the image:"
{1}App install.

"Start and stop this service:"
{1}App stop.
{1}App start.

{1}App restart.

"One-liner clean and restart:"
{1}App stop; reset. 100 milliSeconds asDelay wait. {1}App install; restart.
```

### Enhancing developer productivity
Ride offers you a convenient way to quickly draft the basic elements needed for implementing a feature based in a new model for {1}. For example, if the {1} web application needs to implement a feature regarding to invoiced coffee, you will think in a `CoffeeInvoice` model. And you have available these boilerplate commands:

```Smalltalk
"Set the default package that will be the destination of the generated code:"
Ride draft defaultPackageName: ''{1}''.

"Create a {1}Model subclass CoffeeInvoice to use as app domain state:"
Ride draft model for: #CoffeeInvoice.

"Create a {1}Presenter subclass CoffeeInvoicePresenter"
Ride draft presenter for: #CoffeeInvoice.

"Create the STTemplate-based template in: templates/views/coffee_invoices/index.stt"
Ride draft view stt for: #CoffeeInvoice.

"Create the Mustache-based template in: templates/views/coffee_invoices/index.mustache"
Ride draft view mustache for: #CoffeeInvoice.
```

## MVP

Using these basic code generators, Ride also can create the elemental Model-View-Presenter triad for a given model in one shot:

```Smalltalk
"Create the model and presenter classes and stt template file for `CoffeeInvoice`:"
Ride draft mvp for: #CoffeeInvoice.

"Same as before but `CoffeeInvoicePresenter` loads custom JavaScript:"
Ride draft mvp withJs for: #CoffeeInvoice.

"Have an unstyled but functioning CRUD for the `CoffeeInvoice` models based on MVP:"
Ride draft mvp crud for: #CoffeeInvoice.
```

## API
If you don''t need HTML for an UI and an API is enough, Ride helps you to keep concerns organized with MVP too.

For example, say you need to make a system to invoices coffee, this is how to boilerplate an endpoint doing a CRUD for `CoffeeInvoice`:
```Smalltalk
Ride draft api crud for: #CoffeeInvoice.
```

And you can adjust in the `CoffeeInvoicesPresenter` the methods so it renders in JSON for example.
' format: { 
			  aSymbol.
			  'yourgithubusername' }
]

{ #category : #accessing }
RideAppHelper >> abstractModelClass [

	^ RideAbstractModelClassHelper new
]

{ #category : #accessing }
RideAppHelper >> abstractWebApplicationPresenterClass [

	^ RideAbstractWebApplicationPresenterClassHelper new
]

{ #category : #accessing }
RideAppHelper >> appClass [

	^ RideAppClassHelper new
]

{ #category : #accessing }
RideAppHelper >> appErrorClass [

	^ RideAppErrorClassHelper new
]

{ #category : #actions }
RideAppHelper >> ensureAppDirectoryOn: projectRoot for: aSymbol [

	| file |
	file := projectRoot / 'app'.
	file exists ifTrue: [ 
		RideBoilerplateError signal:
			('Aborting. The app directory already exist: {1}' format:
				 { file pathString }) ].

	file ensureCreateDirectory.

	(file / 'assets') ensureCreateDirectory.
	(file / 'assets' / 'js') ensureCreateDirectory.
	(file / 'assets' / 'images') ensureCreateDirectory.
	(file / 'assets' / 'media') ensureCreateDirectory.
	(file / 'assets' / 'files') ensureCreateDirectory.

	(file / 'maps') ensureCreateDirectory.

	(file / 'templates') ensureCreateDirectory.

	(file / 'templates' / 'emails') ensureCreateDirectory.

	(file / 'templates' / 'views') ensureCreateDirectory.

	self
		ensureTemplatesSharedOn: file / 'templates' / 'shared'
		for: aSymbol.

	self
		ensureTemplatesLayoutsOn: file / 'templates' / 'layouts'
		for: aSymbol
]

{ #category : #actions }
RideAppHelper >> ensureAppFilesFor: aSymbol [

	"Ride-based applications have the convention to
	use the Smalltalk image directory as its root."

	| projectRoot |
	[ 'Boilerplate ensuring Ride application file structure' ] logDebug.
	projectRoot := RideResource projectRootDirectory asFileReference.
	projectRoot exists ifFalse: [ 
		RideBoilerplateError signal:
			'The base project directory was expected to exist' ].
	self
		ensureAppDirectoryOn: projectRoot for: aSymbol;
		ensureDbDirectoryOn: projectRoot for: aSymbol;
		ensureDockerDirectoryOn: projectRoot for: aSymbol;
		ensurePublicDirectoryOn: projectRoot;
		ensureUploadsDirectoryOn: projectRoot;
		ensureRootFilesOn: projectRoot for: aSymbol;
		yourself
]

{ #category : #actions }
RideAppHelper >> ensureChangesOn: projectRoot for: aSymbol [

	| file |
	file := projectRoot / 'CHANGES.md'.
	file exists ifTrue: [ 
		RideBoilerplateError signal: 'The CHANGES.md file already exist.' ].

	file writeStreamDo: [ :stream | 
		stream nextPutAll: (self class changesContentFor: aSymbol) ]
]

{ #category : #actions }
RideAppHelper >> ensureDbDirectoryOn: projectRoot for: aSymbol [

	| file |
	file := projectRoot / 'db'.
	file exists ifTrue: [ 
		RideBoilerplateError signal: 'The db directory already exist.' ].

	file ensureCreateDirectory
]

{ #category : #actions }
RideAppHelper >> ensureDockerDevOn: projectRoot for: aSymbol [

	| file |
	file := projectRoot / '.env.sample'.

	projectRoot ensureCreateDirectory.

	file writeStreamDo: [ :stream | 
		stream nextPutAll: (self class devEnvSampleContentFor: aSymbol) ]
]

{ #category : #actions }
RideAppHelper >> ensureDockerDirectoryOn: projectRoot for: aSymbol [

	| file |
	file := projectRoot / 'docker'.
	file exists ifTrue: [ 
		RideBoilerplateError signal: 'The docker directory already exist.' ].

	file ensureCreateDirectory.

	self ensureDockerDevOn: file / 'dev' for: aSymbol.
	self ensureDockerProdOn: file / 'prod' for: aSymbol.
	
	'build.st'.
	'startup.st'.
	
]

{ #category : #actions }
RideAppHelper >> ensureDockerProdOn: projectRoot for: aSymbol [

	| file |
	file := projectRoot / '.env.sample'.

	projectRoot ensureCreateDirectory.

	file writeStreamDo: [ :stream | 
		stream nextPutAll: (self class prodEnvSampleContentFor: aSymbol) ].

	'docker-compose.yml'.
	'Dockerfile'
]

{ #category : #actions }
RideAppHelper >> ensureGitignoreOn: projectRoot [

	| file |
	file := projectRoot / '.gitignore'.
	file exists ifTrue: [ 
		RideBoilerplateError signal: 'The .gitignore file already exist.' ].

	file writeStreamDo: [ :stream | 
		stream nextPutAll: self class gitignoreContent ]
]

{ #category : #actions }
RideAppHelper >> ensurePublicDirectoryOn: projectRoot [

	| file |
	file := projectRoot / 'public/'.
	file exists ifTrue: [ 
		RideBoilerplateError signal: 'The public/ directory already exist.' ].

	file ensureCreateDirectory.
	
	self flag: #todo.
	"Add:
	- site.webmanifest
	- favicon.ico
	- robots.txt
	"
]

{ #category : #actions }
RideAppHelper >> ensureReadmeOn: projectRoot for: aSymbol [

	| file |
	file := projectRoot / 'README.md'.
	file exists ifTrue: [ 
		RideBoilerplateError signal: 'The README.md file already exist.' ].

	file writeStreamDo: [ :stream | 
		stream nextPutAll: (self class readmeContentFor: aSymbol) ]
]

{ #category : #actions }
RideAppHelper >> ensureRootFilesOn: projectRoot for: aSymbol [

	self
		ensureGitignoreOn: projectRoot;
		ensureReadmeOn: projectRoot for: aSymbol;
		ensureChangesOn: projectRoot for: aSymbol;
		yourself
]

{ #category : #actions }
RideAppHelper >> ensureTemplatesLayoutsOn: directory for: aSymbol [

	directory ensureCreateDirectory.

	directory / 'application.html.stt' writeStreamDo: [ :stream | 
		stream nextPutAll: (self class applicationLayoutContentFor: aSymbol) ]
]

{ #category : #actions }
RideAppHelper >> ensureTemplatesSharedOn: directory for: aSymbol [

	directory ensureCreateDirectory.

	directory / '404.html.stt' writeStreamDo: [ :stream | 
		stream nextPutAll: (self class fourZeroFourContentFor: aSymbol) ].

	directory / '422.html.stt' writeStreamDo: [ :stream | 
		stream nextPutAll: (self class fourTwentyTwoContentFor: aSymbol) ].

	directory / '500.html.stt' writeStreamDo: [ :stream | 
		stream nextPutAll: (self class fiveHundredContentFor: aSymbol) ].

	directory / 'maintenance.html.stt' writeStreamDo: [ :stream | 
		stream nextPutAll: (self class maintenanceContentFor: aSymbol) ]
]

{ #category : #actions }
RideAppHelper >> ensureUploadsDirectoryOn: projectRoot [

	| file |
	file := projectRoot / 'uploads'.
	file exists ifTrue: [ 
		RideBoilerplateError signal: 'The uploads/ directory already exist.' ].

	file ensureCreateDirectory
]

{ #category : #actions }
RideAppHelper >> for: aSymbol [

	self setPackageNameTo: aSymbol.

	self resourceClass for: aSymbol.
	self resourceClass setFor: aSymbol.
	self ensureAppFilesFor: aSymbol.
	self sessionClass for: aSymbol.
	self maitreClass for: aSymbol.
	self appClass for: aSymbol.
	self serverClass for: aSymbol.
	self appErrorClass for: aSymbol.
	self abstractModelClass for: aSymbol.
	self abstractWebApplicationPresenterClass for: aSymbol.
	self homePresenterClass for: aSymbol.
	self homeTemplate for: aSymbol
]

{ #category : #testing }
RideAppHelper >> hasValidPackageName: aSymbol [

	^ aSymbol notNil and: [ aSymbol notEmpty ]
]

{ #category : #accessing }
RideAppHelper >> homePresenterClass [

	^ RideAppHomePresenterClassHelper new
]

{ #category : #accessing }
RideAppHelper >> homeTemplate [

	^ RideAppHomeTemplateHelper new
]

{ #category : #accessing }
RideAppHelper >> maitreClass [

	^ RideMaitreClassHelper new
]

{ #category : #accessing }
RideAppHelper >> resourceClass [

	^ RideResourceClassHelper new
]

{ #category : #accessing }
RideAppHelper >> serverClass [

	^ RideServerClassHelper new
]

{ #category : #accessing }
RideAppHelper >> sessionClass [

	^ RideSessionClassHelper new
]

{ #category : #actions }
RideAppHelper >> setPackageNameTo: aSymbol [

	(self hasValidPackageName: aSymbol) ifFalse: [ 
		RideBoilerplateError signal:
			'The application name needs to be defined' ].

	Ride builder defaultPackageName: aSymbol asString
]
