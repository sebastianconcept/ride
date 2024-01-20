"
I am the a presenter for Web Applications.

I have 2 renderers, ""page"" and ""ajax"". 

The page renderer renders my instances wrapped in a layout template.

The ajax renderer does not do that.

The routing of the application will define what action methods are evaluated in my instances and these will render using one or the other.

If they need to render in something else, they can specialize and choose a different renderer.
"
Class {
	#name : #RideWebApplicationPresenter,
	#superclass : #RidePresenter,
	#category : #'Ride-Presenters'
}
