"
I'm a Ride helper dedicated to access types of building actions needed for a Web App or API.

It might be doing something to the database or it could be creating a new class to use as model or a presenter for it.

It could also mean to use these as the step to build something that requires several steps.

Example:

```
""Create the RideModel subclass for Article""
Ride create model for: #Article.

""Create the RidePresenter subclass for Article""
Ride create presenter for: #Article.
```

```
""Create the model and presenter classes for Article and one template as view
so you have html out of ArticlePresenter >> index.""

Ride create mvp for: #Article.
```

```
""Create the model and presenter classes for Article and the templates
that allow you to Create, Read, Update and Delete Article models.""

Ride create mvp crud for: #Article.
```
"
Class {
	#name : #RideBuilder,
	#superclass : #Object,
	#instVars : [
		'packageName'
	],
	#classInstVars : [
		'defaultPackageName'
	],
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RideBuilder class >> defaultPackageName [

	^ defaultPackageName ifNil: [ 
		  self error:
			  'The packageName for the Ride boilerplate is not defined' ]
]

{ #category : #accessing }
RideBuilder class >> defaultPackageName: anObject [

	defaultPackageName := anObject
]

{ #category : #accessing }
RideBuilder >> api [

	^ RideAPIHelper new
		  doer: self;
		  yourself
]

{ #category : #accessing }
RideBuilder >> app [

	^ RideAppHelper new
		  doer: self;
		  yourself
]

{ #category : #accessing }
RideBuilder >> db [

	^ RideDatabaseHelper new
]

{ #category : #accessing }
RideBuilder >> defaultPackageName: aString [

	self class defaultPackageName: aString
]

{ #category : #initialization }
RideBuilder >> initializePackageName [

	^ packageName := self class defaultPackageName
]

{ #category : #accessing }
RideBuilder >> model [

	^ RideModelHelper new
]

{ #category : #accessing }
RideBuilder >> mvp [

	^ RideMVPHelper new
		  doer: self;
		  yourself
]

{ #category : #actions }
RideBuilder >> newApp: aSymbol [

	self defaultPackageName: aSymbol.
	self app for: aSymbol
]

{ #category : #accessing }
RideBuilder >> packageName [

	^ packageName ifNil: [ self initializePackageName ]
]

{ #category : #accessing }
RideBuilder >> packageName: anObject [

	packageName := anObject
]

{ #category : #accessing }
RideBuilder >> pluralPresenter [

	^ RidePluralPresenterHelper new
]

{ #category : #accessing }
RideBuilder >> presenter [

	^ RidePresenterHelper new
]

{ #category : #accessing }
RideBuilder >> view [

	^ RideViewHelper new
]
