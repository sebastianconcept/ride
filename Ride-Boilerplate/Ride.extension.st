Extension { #name : #Ride }

{ #category : #'*Ride-Boilerplate' }
Ride class >> doer [

	"Answers a new Ride helper dedicated to keep types of actions being done by the specialists concerned in each subject. For example, these who can create boilerplate for model, presenter , crud, database actions, etc"

	^ RideDoer new
]
