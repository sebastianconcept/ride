"
I'm a Ride helper dedicated to keep types of actions being done by the specialists concerned in each subject. For example, model, presenter, crud, database, etc
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
RideBuilder >> presenter [

	^ RidePresenterHelper new
]

{ #category : #accessing }
RideBuilder >> view [

	^ RideViewHelper new
]
