"
I'm a Ride helper dedicated to database actions
"
Class {
	#name : #RideDatabaseHelper,
	#superclass : #Object,
	#category : #'Ride-Scaffolding'
}

{ #category : #actions }
RideDatabaseHelper class >> truncate: aMaplessClass [

	aMaplessClass getRepository withClientDo: [ :client | 
		client truncateMapless: aMaplessClass ]
]

{ #category : #actions }
RideDatabaseHelper class >> truncateAll [

	Ride service repository withClientDo: [ :client | 
		client truncateAll ]
]
