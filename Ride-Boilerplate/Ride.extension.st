Extension { #name : #Ride }

{ #category : #'*Ride-Boilerplate' }
Ride class >> builder [

	"Answers a new Ride helper dedicated to keep types of actions being done 
	by the specialists concerned in each subject. 
	Today these are those who can create boilerplate code for: 
	1. the Ride-based application, 
	2. new models
	3. new presenters
	4. a model and its presenter able to CRUD for it and 
	5. database actions."

	^ RideBuilder new
]

{ #category : #'*Ride-Boilerplate' }
Ride class >> create [

	self beDevEnvironment.
	^ self builder
]
