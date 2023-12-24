"
I'm a Ride helper dedicated to keep types of actions being done by the specialists concerned in each subject. For example, model scaffolder, presenter scaffolder, crud scaffolder, database, etc
"
Class {
	#name : #RideDoer,
	#superclass : #Object,
	#classInstVars : [
		'packageName'
	],
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideDoer class >> crud [

	^ RideCRUDHelper
]

{ #category : #accessing }
RideDoer class >> db [

	^ RideDatabaseHelper
]

{ #category : #accessing }
RideDoer class >> model [

	^ RideModelHelper
]

{ #category : #accessing }
RideDoer class >> packageName [

	^ packageName ifNil: [ 
		  self error:
			  'The packageName for the Ride boilerplate is not defined' ]
]

{ #category : #accessing }
RideDoer class >> packageName: anObject [

	packageName := anObject
]

{ #category : #accessing }
RideDoer class >> presenter [

	^ RidePresenterHelper
]

{ #category : #accessing }
RideDoer class >> view [

	^ RideViewHelper
]
