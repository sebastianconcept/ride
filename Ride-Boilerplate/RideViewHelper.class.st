"
I help with the boilerplate of the views
"
Class {
	#name : #RideViewHelper,
	#superclass : #RideBoilerplateHelper,
	#category : #'Ride-Boilerplate'
}

{ #category : #actions }
RideViewHelper >> for: aSymbol [

	RideBoilerplateError signal:
		('You need to specify the type of view for {1}. Check my accessor methods to see what''s available.' 
			 format: { aSymbol })
]

{ #category : #accessing }
RideViewHelper >> mustache [

	^ RideMustacheHelper new
]

{ #category : #accessing }
RideViewHelper >> stt [

	^ RideSTTemplateHelper new
]
