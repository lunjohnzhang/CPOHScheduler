# Day Schedule View

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Introduction

DayScheduleView is a custom view for iOS applications. DayScheduleView will
present a single day in a scrollable 24-hour list, divided into 30 minute
periods. DayScheduleView integrates with [EventKit](https://developer.apple.com/documentation/eventkit)
and custom appointment or event management code and displays events within
the day at the time that they occur. DayScheduleView supports interaction
between the user and the appointments that are displayed in the schedule.

## Documentation

For instructions and code examples for how to use DayScheduleView, please
read the [Wiki](https://github.com/nakedsoftware/DayScheduleView/wiki).

## Installation

Day Schedule View is compatible with [Carthage](https://github.com/Carthage/Cartage)
or [CocoaPods](https://cocoapods.org).

### Carthage Installation

Day Schedule View is installable using [Carthage](https://github.com/Carthage/Carthage).
To use Day Schedule View in your own project, add the following line to your
`Cartfile`:

    github "nakedsoftware/DayScheduleView"

Next, run:

    carthage update

This will download the source code or binary release package for Day Schedule
View and make the framework available for your application.

Day Schedule View is available as either a dynamically-linked framework for
iOS applications, or as a statically linked framework. We recommend using the
statically-linked framework for performance reasons.

### CocoaPods Installation

To use Day Schedule View in your own project, add the following line to your
`Podfile` for the target that you want to link Day Schedule View into:

    pod 'DayScheduleView'

Then install the source code into your application or framework:

    pod install

## Contributing Bug Fixes and New Features

### Gitflow Workflow

The DayScheduleView framework is built following the [Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
workflow. In Gitflow, there are two primary branches:

* **master** represents the current release of DayScheduleView and is intended
  for use in production applications or for developing new applications.
* **develop** represents the next version of DayScheduleView that is under
  development. You should be cautious using this version in production
  applications or for development. This branch contains new features that are
  under active development and may not be fully implemented or tested.

We recommend when contributing changes or working with the source code that
you follow the Gitflow workflow and create feature branches from **develop**
or bug fix branches and submit pull requests from those branches.

### Contributing Changes

DayScheduleView is open source and we encourage you to try our code, use it,
and contribute back any changes that you want to share with others who are
also using DayScheduleView. Contributions are made via GitHub
[pull requests](https://help.github.com/articles/about-pull-requests/). When
pull requests are submitted, we will review them as soon as possible, evaluate
the change against our vision for the framework, and determine whether or not
to include the pull request.

Please note that not all pull requests are accepted into DayScheduleView. We
encourage all of our users to play with the source code and make and contribute
changes. Please do not think negatively of us or think that we think negatively
of your pull request. Our goal in releasing this source code publicly and
openly is to share this component with others who may find it useful, but in
doing so, we take on the responsibility to ensure that DayScheduleView will
continue to provide value to all users. In some cases, new features may be too
specific to a certain domain or a specific use case that does not make sense
to be included for the broader user base that we are seeking to support. In
those cases, we may not be able to include your pull request. It is not that
we see no value in it, but it just may not make sense to include it for
everyone. In that case, we fully encourage you to continue to provide that
feature with your own public fork of our repository and to share it with those
that could also gain value from that feature.
