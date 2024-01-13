Extension { #name : #Ride }

{ #category : #'*Ride-Boilerplate' }
Ride class >> doer [

	"Answers a new Ride helper dedicated to keep types of actions being done by the specialists concerned in each subject. Today these are those who can create boilerplate for the initial Ride-based application, new models, new presenters, crud for them and database actions."

	^ RideDoer new
]
