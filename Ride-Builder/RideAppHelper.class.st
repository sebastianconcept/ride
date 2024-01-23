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
RideAppHelper class >> feedbackContentFor: aSymbol [

	^ '<div class="feedback">
	<h4>Feedback</h4>
	<p>This UI needs to get this feedback displayed.</p>
</div>
' format: { aSymbol }
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

### Development Setup

In a new directory for your project, get a fresh Pharo image and run it:
```
mkdir {2}
cd {2}
curl get.pharo.org/64/100 | bash
curl get.pharo.org/64/vm100 | bash
./pharo-ui Pharo.image
```

### Install {1}App in a Pharo image

If you check in `BaselineOf{1}App`, with `development` it will install the project''s `Core`, `Builder` and `Tests` packages and with `deploy`, just the `Core` package:
```Smalltalk
Metacello new
  baseline: ''{1}'';
  repository: ''github://{3}/{1}'';
  load: #( #development ).
```

### Handy snippets
```Smalltalk
"Force your environment to have `MODE` as `deveopment`:"
Ride beDevEnvironment.
```

```Smalltalk
"Stop and reset what any previously running Ride-based service:"
Ride stop; reset.

"Tell Ride to work with your application in the image:"
{1}App install.

"You can also start and stop the service with the main helper of your app:"
{1}App stop.
{1}App start.

{1}App restart.

"One-liner stop, reset and restart:"
{1}App stop; reset. {1}App install; restart.
```

### Starting {1}App''s next feature fast
Ride offers a convenient way to quickly draft the basic elements needed for implementing "the next feature" of an API or Web App. While developing {1} as a service, it won''t be rare that you need to create a new model and to have some consumable representation of it hence need a new presenter for that model. For example, if the {1} web application needs to implement a feature regarding to publishing articles, you will think in an `Article` model and eventually an `ArticlesPresenter` to show and manipulate many `Article`s. 

In that scenario, Ride''s builder helps by making available the following methods:

```Smalltalk
"Set the default package that will be the destination of the generated code:"
Ride builder defaultPackageName: ''{1}''.

"Create the {1}Model subclass Article"
Ride create model for: #Article.

"Create {1}Presenter subclass ArticlesPresenter"
Ride create presenter for: #Article.

"Create the STTemplate-based template in: templates/views/articles/index.html.stt"
Ride create view stt for: #Article.
```

## MVP

By using these basic code generators, Ride also can create the elemental Model-View-Presenter triad for a given model in one shot:

```Smalltalk
"Create the model and presenter classes and the stt template file for `Article`
at `projectRoot/app/templates/views/articles/index.html.stt`:"
Ride create mvp for: #Article.

"Same as before but `ArticlesPresenter` loads custom JavaScript:"
Ride create mvp withJs for: #Article.

"Have an unstyled functioning CRUD for the `Article` models:"
Ride create mvp crud for: #Article.
```

## API
Ride can also help when a service doesn''t need HTML for a UI and an API is enough.

Following the Article example, say you need to make a system to offer fetching and manipulating these articles, this is how to boilerplate a RESTful endpoint doing the basic CRUD operations for `Article`:
```Smalltalk
Ride create api crud for: #Article.
```
' format: { 
			  aSymbol.
			  aSymbol uncapitalized.
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

	directory / 'feedback.html.stt' writeStreamDo: [ :stream | 
		stream nextPutAll: (self class feedbackContentFor: aSymbol) ].

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
