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

### Enhancing developer productivity
Ride offers you a convenient way to quickly draft the basic elements needed for implementing a feature based in a new model. For example, given a CoffeeSystem web application a new `CoffeeInvoice` model, you could:

```smalltalk
"Set the default package that will be the destination of the generated code"
Ride draft defaultPackageName: 'CoffeeSystem'.

"Create a RideModel subclass CoffeeInvoice used as app domain state"
Ride draft model for: #CoffeeInvoice.

"Create a RidePresenter subclass CoffeeInvoicePresenter"
Ride draft presenter for: #CoffeeInvoice.

"Create the template templates/views/coffee_invoices/index.mustache"
Ride draft view mustache for: #CoffeeInvoice.
```

## MVP

Using these basic code generators, Ride also can create the elemental Model-View-Presenter code for a given model:

```smalltalk
"Create the model and presenter classes and mustache template file for CoffeeInvoice"
Ride draft mvp for: #CoffeeInvoice.

"Same as before but CoffeeInvoicePresenter loads custom JavaScript"
Ride draft mvp withJs for: #CoffeeInvoice.

"Have an unstyled but functioning CRUD for the CoffeeInvoice models based on MVP"
Ride draft mvp crud for: #CoffeeInvoice.
```

## MVC

If you prefer the completely stateless approach instead, Ride has that with its Model-View-Controller approach:

```smalltalk
"Create the model and controller classes and mustache template file for CoffeeInvoice"
Ride draft mvc for: #CoffeeInvoice.

"Same as before but in addition to that it has custom JavaScript"
Ride draft mvc withJs for: #CoffeeInvoice.

"Have an unstyled but functioning CRUD for the CoffeeInvoice models based on MVC"
Ride draft mvc crud for: #CoffeeInvoice.
```

## API
If you need an API and you like to keep concerns organized with MVC, this is how you can generate its boilerplate code:
```smalltalk
Ride draft api crud for: #CoffeeInvoice.
```