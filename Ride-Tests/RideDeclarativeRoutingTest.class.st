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
