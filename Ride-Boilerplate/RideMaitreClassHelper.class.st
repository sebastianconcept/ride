"
I help with the creation of the concrete maitre class of the Ride-based application
"
Class {
	#name : #RideMaitreClassHelper,
	#superclass : #RideOneClassCreationHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #accessing }
RideMaitreClassHelper >> classNameFor: aSymbol [

	^ '{1}Maitre' format: { aSymbol }
]

{ #category : #actions }
RideMaitreClassHelper >> defaultCommentsFor: aSymbol [

	^ 'I am the maitre of the {1} Ride-based application.

In the same fashion a Maitre in a restaurant doesn''t cook or performes details and yet he makes sure customers are having a good experience, I take care or orchestrating system collatorators. 
	
A good {1}Maitre is in charge of making sure that the {1} user'' journey makes sense (for the user) as the cohesive sum of all the things done by the collaborators of the application.' 
		  format: { aSymbol asString }
]

{ #category : #accessing }
RideMaitreClassHelper >> targetPackageNameTag [

	^ 'Core'
]

{ #category : #accessing }
RideMaitreClassHelper >> targetedSuperclass [

	^ RideMaitre
]
