"
I'm a Ride helper dedicated to keep types of actions being done by the specialists concerned in each subject. For example, model scaffolder, presenter scaffolder, crud scaffolder, database, etc
"
Class {
	#name : #RideDoer,
	#superclass : #Object,
	#category : #'Ride-Scaffolding'
}

{ #category : #accessing }
RideDoer class >> db [

	^ RideDatabaseHelper
]
