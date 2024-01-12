"
I'm a Ride helper dedicated to database actions
"
Class {
	#name : #RideDatabaseHelper,
	#superclass : #Object,
	#category : #'Ride-Boilerplate'
}

{ #category : #actions }
RideDatabaseHelper >> truncate: aMaplessClass [

	aMaplessClass getRepository withClientDo: [ :client | 
		client truncateMapless: aMaplessClass ]
]

{ #category : #actions }
RideDatabaseHelper >> truncateAll [

	Ride service repository withClientDo: [ :client | 
		client truncateAll ]
]
