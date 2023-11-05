"
I'm the server of the RideWelcomApp.
I customize routes and filters for this app.
"
Class {
	#name : #RideWelcomeAppServer,
	#superclass : #RideServer,
	#category : #'Ride-Examples-Core'
}

{ #category : #initialization }
RideWelcomeAppServer >> setFilters [

	"none by default"

	
]

{ #category : #initialization }
RideWelcomeAppServer >> setRoutes [

	"Set all the default routes"

	| router |
	super setRoutes.

	"Plus:"
	router := Ride service router.
	self teapot
		POST: router baseUrl , '/' -> router handleHTMLHomePagePOST;
		output: #html
]
