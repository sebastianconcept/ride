"
I help with getting normalized names out of root words matching the models names so it follows Ride conventions for their related classes.

For example, if you have an CoffeeInvoice model, then the following assumptions are valid in Ride:

- Its presenter is the CoffeInvoicePresenter class.
- The template to render its view is found in app/templates/views/coffe-invoice/index.mustache

while if you have an CryptoInvoice model, then:

- Its presenter is the CryptoInvoicePresenter class.
- The template to render its view is found in app/templates/views/crypto-invoice/index.mustache

"
Class {
	#name : #RideNameNormalizer,
	#superclass : #Object,
	#category : #'Ride-Core'
}

{ #category : #accessing }
RideNameNormalizer class >> controllerNameFromModelName: aString [

	^ self controllerNameFromURISegment: aString
]

{ #category : #accessing }
RideNameNormalizer class >> controllerNameFromURISegment: aString [

	^ self nameFromURISegment: aString suffixedWith: 'Controller'
]

{ #category : #accessing }
RideNameNormalizer class >> nameFromURISegment: aString suffixedWith: anotherString [

	"Camel cases and adds anotherString capitalized as suffix"

	| rootName |
	rootName := '' join:
		            (((self normalizedToSnakeCase: aString) substrings: '_') 
			             collect: [ :e | e capitalized ]).
	^ '{1}{2}' format: { 
			  rootName asPlural.
			  anotherString capitalized }
]

{ #category : #accessing }
RideNameNormalizer class >> normalizedToSnakeCase: aString [

	"Either coming as kebab-case or separated with dots, it will be normalized to snake case."

	^ '_' join: (aString asLowercase substrings: '-_.')
]

{ #category : #accessing }
RideNameNormalizer class >> presenterNameFromModelName: aString [

	^ self presenterNameFromURISegment: aString
]

{ #category : #accessing }
RideNameNormalizer class >> presenterNameFromURISegment: aString [

	^ self nameFromURISegment: aString suffixedWith: 'Presenter'
]
