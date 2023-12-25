"
I'm a Ride helper dedicated to keep types of actions being done by the specialists concerned in each subject. For example, model, presenter, crud, database, etc
"
Class {
	#name : #RideDoer,
	#superclass : #Object,
	#instVars : [
		'packageName'
	],
	#classInstVars : [
		'defaultPackageName'
	],
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideDoer class >> defaultPackageName [

	^ defaultPackageName ifNil: [ 
		  self error:
			  'The packageName for the Ride boilerplate is not defined' ]
]

{ #category : #accessing }
RideDoer class >> defaultPackageName: anObject [

	defaultPackageName := anObject
]

{ #category : #accessing }
RideDoer >> api [

	^ RideAPIHelper new
		  doer: self;
		  yourself
]

{ #category : #accessing }
RideDoer >> controller [

	^ RideControllerHelper new
]

{ #category : #accessing }
RideDoer >> db [

	^ RideDatabaseHelper new
]

{ #category : #accessing }
RideDoer >> defaultPackageName: aString [

	self class defaultPackageName: aString
]

{ #category : #initialization }
RideDoer >> initializePackageName [

	^ packageName := self class defaultPackageName
]

{ #category : #accessing }
RideDoer >> model [

	^ RideModelHelper new
]

{ #category : #accessing }
RideDoer >> mvc [

	^ RideMVCHelper new
		  doer: self;
		  yourself
]

{ #category : #accessing }
RideDoer >> mvp [

	^ RideMVPHelper new
		  doer: self;
		  yourself
]

{ #category : #accessing }
RideDoer >> packageName [

	^ packageName ifNil: [ self initializePackageName ]
]

{ #category : #accessing }
RideDoer >> packageName: anObject [

	packageName := anObject
]

{ #category : #accessing }
RideDoer >> presenter [

	^ RidePresenterHelper new
]

{ #category : #accessing }
RideDoer >> view [

	^ RideViewHelper new
]
