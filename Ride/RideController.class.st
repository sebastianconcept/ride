"
I am the abstract RideController.
I provide the commonalities of all types of controllers.
See my child classes for concrete examples.

## Responsabilities:
1. Be stateless.
2. Have a model that I use to perform actions and be my source of state.
3. Handle HTTP verbs.
4. Define action methods that the frontend can provoke.
5. Define which paramenters are acceptable in a received request.
6. Set observations on the models and their respective reaction methods.
7. Define any other method that will return a rendered ouput to use in responses (HTML, JSON, XML, RSS, etc).
8. Collaborate with a presentation layer that is responsable for the concrete type of view.
"
Class {
	#name : #RideController,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'Ride-Presenters'
}
