# Ride


### Install in a Pharo image

Essential core:

```Smalltalk
Metacello new
  baseline: 'Ride';
  repository: 'github://sebastianconcept/Ride';
  load.
```

All optionals:
```Smalltalk
Metacello new
  baseline: 'Ride';
  repository: 'github://sebastianconcept/Ride';
  load: #('Core' 'Examples' 'Tools').
```

### Snippets
Handy to start stop the Ride in the Welcome example app:
```Smalltalk
Ride stop; reset.

RideWelcomeApp install.

Ride stop.
Ride start.

Ride restart.
```

