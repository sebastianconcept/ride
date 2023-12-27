"
I follow the convetion of correlating URI segments with sub controllers.

For example, I will make

GET /admin/dashboard

To be processed as reaching the root controller and asking for its child 'admin' expecting an AdminController with a child DashboardController to whom I can make it perform the method #index.

and 

POST /admin/jobs/1/beCompleted

To be processed as reaching the root controller and asking for its child 'jobs' expecting an JobsController that will be initialized with a model based on that ID value 1, so in model it will have Job ID 1 for then to receive its #beCompleted method.

"
Class {
	#name : #RideRouterURISegmentsAsSubComponent,
	#superclass : #RideRouterStrategy,
	#category : #'Ride-Core'
}
