"
I am the abstract controller that is user session aware.
I provide access to models via a user session.
Subcontrollers here are always expecting a RideSession instance to help them find the models of any subcontroller they themselves create.
"
Class {
	#name : #RideSessionBasedController,
	#superclass : #RideController,
	#category : #'Ride-Controllers'
}
