"
I have delarations on how to treat routes.

For example, I can make

GET /admin/dashboard

To be processed as sending the message to DashboardController>>index

and 

POST /admin/jobs/1/beCompleted

To be processed as sending the message JobsController>>beCompleted after settig its model to be the Job with ID 1.

"
Class {
	#name : #RideRouterDeclarative,
	#superclass : #RideRouterStrategy,
	#category : #'Ride-Core'
}
