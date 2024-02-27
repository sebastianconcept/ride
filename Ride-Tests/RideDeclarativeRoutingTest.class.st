Class {
	#name : #RideDeclarativeRoutingTest,
	#superclass : #RideTest,
	#category : #'Ride-Tests'
}

{ #category : #tests }
RideDeclarativeRoutingTest >> testSimpleWithoutParameters [

	| server response |
	server := Teapot on
		          GET: '/coffee_invoices' -> [ :req | 'CoffeInvoice1' ];
		          start.
	response := (ZnEasy get: 'http://localhost:1701/coffee_invoices') entity
		            string.
	self assert: response equals: 'CoffeInvoice1'.
	server stop
]

{ #category : #tests }
RideDeclarativeRoutingTest >> testTryingToAddAnAlreadyDefinedRoute [

	| server routes |
	routes := OrderedCollection new.
	server := RideServer new.

	self
		shouldnt: [
		server addRouteDefinition: { (#PATCH -> '/posts/<id>') } to: routes ]
		raise: RideAlreadyDefinedRouteError.

	self
		shouldnt: [
		server addRouteDefinition: { (#GET -> '/posts/<id>') } to: routes ]
		raise: RideAlreadyDefinedRouteError.

	self
		should: [
		server addRouteDefinition: { (#PATCH -> '/posts/<id>') } to: routes ]
		raise: RideAlreadyDefinedRouteError
]
