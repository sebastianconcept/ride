# Ride
The Smalltalk web application framework with productivity as a feature.

[![Unit Tests](https://github.com/sebastianconcept/ride/actions/workflows/build.yml/badge.svg)](https://github.com/sebastianconcept/ride/actions/workflows/build.yml)
![Tests](https://img.shields.io/badge/tests-3-green)
[![Coverage Status](https://codecov.io/github/sebastianconcept/ride/coverage.svg?branch=main)](https://codecov.io/gh/sebastianconcept/ride/branch/master)

[![License](https://img.shields.io/badge/license-MIT-green)](./LICENSE.txt)
[![Release](https://img.shields.io/github/v/tag/sebastianconcept/ride?label=release)](https://github.com/sebastianconcept/ride/releases)

[![Pharo 10](https://img.shields.io/badge/Pharo-10-%23aac9ff.svg)](https://pharo.org/download)

## Features

- MVP - Model-View-Presenter architecture.
- Declarative routing.
- Multiple View options for rendering HTML, JSON, XML and more.
- Default Views based in smart efficient templates: [STTemplate](https://github.com/sebastianconcept/STTemplate).
- Versatile and comfortable default persistence: [Mapless](https://github.com/sebastianconcept/Mapless)
- Intuitive conventions.
- Made with scalability and performance in mind.
- RESTful.
- Builder to scaffold code.
- Basic validation.
- Optional custom JavaScript for presenters.
- AJAX via [htmx](https://htmx.org/).
- Able to deploy containerized from day one.
___
1. [Description](#description)
2. [Examples](#examples)
3. [Install](#install)
4. [Snippets](#snippets)

### Description


Ride is a framework designed for building Web Applications and RESTful APIs, emphasizing developer productivity, production efficiency, and scalability. It comes equipped with a builder that streamlines the process of scaffolding models, views, presenters, the CRUD operations and their unit tests, enabling you to rapidly progress in your development journey.

### Install

#### Fetch a fresh Pharo image

```
mkdir my-ride-app
cd my-ride-app
curl get.pharo.org/64/100 | bash
curl get.pharo.org/64/vm100 | bash
```
And run it
```
./pharo-ui Pharo.image
```

#### Install Ride in it

Essential core:

```Smalltalk
Metacello new
  baseline: 'Ride';
  repository: 'github://sebastianconcept/ride';
  load.
```

All optionals:
```Smalltalk
Metacello new
  baseline: 'Ride';
  repository: 'github://sebastianconcept/ride';
  load: #( 'Core' 'Tests' 'Examples' ).
```

### Snippets
Handy to start stop the Ride in the Welcome example app:
```Smalltalk
Ride stop; reset.

"Your application, say BlogApp, will have its own helper class:"
BlogApp install.

BlogApp stop.
BlogApp start.

BlogApp restart.
```

### Enhancing developer productivity
Ride offers you a convenient way to quickly create the basic elements needed for implementing a feature based in a new model. For example, given a `Blog` web application to publish `Post` and `Comment` models, you could:

```smalltalk
"Set the default package that will be the destination of the generated code"
Ride create defaultPackageName: 'MyBlog'.

"Create a RideModel subclass Post used as app domain state"
Ride create model for: #Post.

"Create a RidePresenter subclass PostsPresenter"
Ride create presenter for: #Post.

"Create the template templates/views/posts/index.stt"
Ride create view stt for: #Post.
```

## MVP

Using these basic code generators, Ride also can create the elemental Model-View-Presenter code for a given model:

```smalltalk
"Create the model and presenter classes and mustache template file for Post"
Ride create mvp for: #Post.

"Same as before but PostsPresenter loads custom JavaScript"
Ride create mvp withJs for: #Post.

"Have an unstyled but functioning CRUD for the Post models based on MVP"
Ride create mvp crud for: #Post.
```

## API
If you need an API and you like to keep concerns organized with MVP, this is how you can generate its boilerplate code:
```smalltalk
Ride create api crud for: #Post.
```