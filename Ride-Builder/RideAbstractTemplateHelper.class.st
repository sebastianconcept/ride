"
I have commonalities among the concrete helpers for creating templates
"
Class {
	#name : #RideAbstractTemplateHelper,
	#superclass : #RideBoilerplateHelper,
	#instVars : [
		'js'
	],
	#category : #'Ride-Builder'
}

{ #category : #accessing }
RideAbstractTemplateHelper class >> getPathFor: aSymbol [

	^ Ride resource viewsDirectory / aSymbol asSnakeCase
]

{ #category : #initialization }
RideAbstractTemplateHelper >> initialize [

	js := false
]

{ #category : #accessing }
RideAbstractTemplateHelper >> js [

	^ js
]

{ #category : #accessing }
RideAbstractTemplateHelper >> js: anObject [

	js := anObject
]

{ #category : #actions }
RideAbstractTemplateHelper >> withJs [

	js := true
]

{ #category : #actions }
RideAbstractTemplateHelper >> withoutJs [

	js := false
]
