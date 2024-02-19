Jan 23, 2024
===================================
- Added smalltalkCI
- Added Codecov
- Added which Pharo versions are supported (currently only Pharo10)

Jan 2, 2024
===================================
- Added more extensions to `BockClosure` based on `logLevel:` so the application can log content that will be computed only if the log level is allowing that. This is specially convenient for cases when you want to do some handy but costly log in debug mode: `[ 'Prints only when LOGLEVEL=#DEBUG'  ] logDebug`.

Dec 31, 2023
===================================
- Added 3 extensions to `BockClosure`, `serviceCacheAt:`, `sessionCacheAt:` and `systemValueAt:` where the value will be returned for a key using the receiver block as source which only evaluates if the value is absent.

Dec 28, 2023
===================================
- So far there was MVC and MVP being maintained because the design intention was aimed at staying completely stateless for MVC and preserving presentation state and its relations with their models in MVP. And all that would be hold from `rootPresenter` in `RideSession`. Not anymore. After further consideration, the stateless/stateful usage might be needed to be conveniently used from app to app and in a per route basis. Hence, the routing is how this is going to be defined. For that, the router now has a strategy and `Ride` will have only MVP. The two routing strategies introduced now are `RideDeclarativeRouting` and `RideSubcomponentRouting`. While `RideDeclarativeRouting` is implemented, `RideSubcomponentRouting` is still to be implemented.

Dec 25, 2023
===================================
- Added `CHANGES.md`
- Started the work for generating boilerplate code, invoked with `Ride draft ...` so users can easily start a CRUD on a model used as MVP, MVC and API.