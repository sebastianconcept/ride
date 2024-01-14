"
I am the a presenter for Web Applications.

I have 2 renderers because the page renderer renders my instances wrapped in a layout template and the ajax renderer does not do that.
"
Class {
	#name : #RideWebApplicationPresenter,
	#superclass : #RidePresenter,
	#instVars : [
		'page',
		'ajax'
	],
	#category : #'Ride-Presenters'
}

{ #category : #accessing }
RideWebApplicationPresenter >> index [

	"Returns the rendered representation of the receiver in its main entry point.
	For example, for an HTML representation what would be in it as index.html"

	^ page render: #index for: self
]

{ #category : #initialization }
RideWebApplicationPresenter >> initialize [

	super initialize.
	page := (Ride service renderers at: #layoutWrappers) at:
		        self class defaultRendererSelector.

	ajax := self getRenderer
]
