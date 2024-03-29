# Ride

The Smalltalk web application framework with productivity as a feature.

[![Release](https://img.shields.io/github/v/tag/sebastianconcept/ride?label=release)](https://github.com/sebastianconcept/ride/releases)
[![Unit Tests](https://github.com/sebastianconcept/ride/actions/workflows/build.yml/badge.svg)](https://github.com/sebastianconcept/ride/actions/workflows/build.yml)

[![Coverage Status](https://codecov.io/github/sebastianconcept/ride/coverage.svg?branch=main)](https://codecov.io/gh/sebastianconcept/ride/branch/master)

[![Pharo 11](https://img.shields.io/badge/Pharo-11-%23383932.svg)](https://pharo.org/download)
[![Pharo 10](https://img.shields.io/badge/Pharo-10-%23383932.svg)](https://pharo.org/download)

[![License](https://img.shields.io/badge/license-MIT-green)](./LICENSE.txt)
[![Social](https://img.shields.io/github/stars/sebastianconcept/ride?style=social)]()

[![Commits](https://img.shields.io/github/commit-activity/m/sebastianconcept/ride)](https://github.com/sebastianconcept/ride/graphs/commit-activity)

## Features

- MVP - Model-View-Presenter architecture.
- Declarative routing.
- Multiple View options for rendering HTML, JSON, XML and more.
- Default Views based in smart efficient templates using [STTemplate](https://github.com/sebastianconcept/STTemplate).
- Versatile and comfortable persistence without lock-in using [Mapless](https://github.com/sebastianconcept/Mapless).
- Intuitive conventions.
- Made with scalability and performance in mind.
- [RESTful](https://restfulapi.net/).
- Builder to scaffold useful code fast.
- ~~Basic validation~~. To be done.
- Optional custom JavaScript for presenters.
- AJAX via [htmx](https://htmx.org/).
- ~~Able to deploy containerized from day one~~. To be done.

---

1. [Description](#description)
2. [Examples](#examples)
3. [Hello World](#hello-world)
4. [Install](#install)
5. [Guides](#guides)
6. [Talks](#talks)

## Description

Ride is a framework designed for building Web Applications and [RESTful](https://restfulapi.net/) APIs, optimizing for developer productivity while preserving production efficiency and scalability. Ride focuses on eliminating the hurdles to quickly build and deploy real projects without compromising your architecture's ability to scale in production.

It comes equipped with a builder that streamlines the process of scaffolding models, views, presenters, [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) operations and their unit tests for the models you need. Ride removes many technical obstacles, allowing you to progress rapidly in your application development journey from proof of concept and startup product to a growing business.

## Install

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

```Smalltalk
Metacello new
  baseline: 'Ride';
  repository: 'github://sebastianconcept/ride';
  onConflict: [ :ex | ex useIncoming ];
  load.
```

## Examples

```Smalltalk
"Stop anything Ride that is currently running in the image and reset caches"
Ride stop; reset.

"A Ride-based application has its own helper RideService subclass. Like BlogApp in this example:"

"Install BlogApp as the Ride service"
BlogApp install.

"Start and stop the service"
BlogApp start.
BlogApp stop.

"Service restart"
BlogApp restart.
```

#### Enhanced developer productivity

Ride offers you a convenient way to quickly create the basic elements needed for implementing basic operations in a new model. For example, given a `Blog` web application to publish `Post` and `Comment` models, you could find the following snippets helpful for pushing useful things fast:

```smalltalk
"Set the default package name that will be the destination
of the code generated by Ride's builder"
Ride create app setPackageNameTo: #Blog.

"Create the foundational Smalltalk code and files
of the project using the given root word 'Blog' "
Ride create app for: #Blog.

"Create the Smalltalk code and files for having
basic CRUD features in a model named `Post`"
Ride create mvp crud for: #Post.

"Same for a model named `Comment`"
Ride create mvp crud for: #Comment.
```

#### MVP

Ride also can help you create the raw elements of the Model-View-Presenter code separately for a given model:

```smalltalk
"Create the model and presenter classes and STTemplate file at
`views/templates/posts/index.html.stt` for Post"
Ride create mvp for: #Post.

"Same as before but PostsPresenter loads custom JavaScript"
Ride create mvp withJs for: #Post.
```

Or even as its individual parts:

```smalltalk
"Create a RideModel subclass Subscription used to
store people subscribed to the blog."
Ride create model for: #Subscription.

"Create a RidePresenter subclass SubscriptionPresenter"
Ride create presenter for: #Subscription.

"Create the template correponding to Subscription at
templates/views/subscriptions/index.stt"
Ride create view stt for: #Subscription.
```

#### API

If you need an API and you like to keep concerns organized with MVP, this is how you can generate its boilerplate code:

```smalltalk
Ride create api crud for: #Post.
```

## Guides

- [Make a Blog with comments using Ride in 8 minutes](./MakeABlogWithCommentsUsingRideInEightMinutes.md).
- [Building a Twitter like application with Ride](./BuildingATwitterLikeApplicationWithRide.md).
- [Ride-based SaaS template](./RideBasedSaaSTemplate.md).
- [Add auth to your Ride-based web application](AddAuthToYourRideBasedWebApplication.md).
- [Deploying your Ride-based web application on the cloud](DeployingYourRideBasedWebApplicationOnTheCloud.md).

## Talks

Ride was presented for the first time at [Smalltalks 2023](https://smalltalks2023.fast.org.ar/) organized by [F.A.S.T.](https://www.fast.org.ar/) at [Universidad Nacional de Quilmes](https://www.unq.edu.ar/).

#### November 2023

[RAD with templates, htmx and stateless Smalltalk images by Sebastian Sastre](https://www.youtube.com/watch?v=4_gmvN0pimI)
