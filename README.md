# Story App

Story application developed with Flutter

## Table of contents

- [Overview](#overview)
  - [Screenshot](#screenshot)
  - [Built with](#built-with)
- [Introduction](#introduction)
  - [Screens (UI)](#ui-screens)
  - [Widgets (UI)](#ui-widgets)
  - [Logic](#logic)
  - [Data](#data)
  - [Other](#other)
  - [Packages](#packages)
- [Author](#author)

## Overview

### Screenshot

![Design preview](./assets/app-screenshot.png)

### Built with

Languages:

- Dart
- Flutter

Concepts:

- UI: Slivers, Videos Players, Cached Images and Videos
- Logic: Bloc Design Patter
- Data: APIs (Photo and Video), Models, Repositories

## Introduction

An instagram-like story feature built with bloc.

Features include:

- Full screen Video Player
- Cached image and video stories
- Hero animation while opening stories
- Automated animation and passing stories when finished
- Progress bar with 5 second image and dynamic video duration
- Instagram-like cubic transition between stories
- Hold and rest stories and resume afterwards
- Go to previous or next story when tapped left or right
- Dismmisible story which can be dismissed by pulling down
- Scroll animation to the related story avatar when stories closed
- Story ordering with respect to time published the story
- List stories accordingly whether its seen before or not
- Continue to story where you left off

### Screens (UI)

There are 3 main and 5 test screens:

Story Page: Main Story Page that shows stories
Home Page: Home page with photo posts and stories at the top
Welcome Page: Page that includes the bottom navbar
Test Pages: There are 5 test pages in the others folder

### Widgets (UI)

Below you can see the list of widgets in the UI component seperated from the screens.

Photo Post: Photo posts which is on the Home Page
Story Avatar: Story Avatars at the top of the Home Page
Video Player: Full screen video player widget
Animated Bar: Animated progress bar for the stories
Progress Bar: Progress bar with progress bars - Deprecated
Progress Bars: Individual progress bars - Deprecated

### Logic

BLoc design pattern and state managemenet library used for logic.

Blocs and cubits are two folders but there are 5 blocs in total:

Stories Bloc: Stories are fetched and updated
Story Bloc: Story logic with open/close/next/prev events
Story Content Bloc: Story Content logic with extra pause and resume options
Internet Cubit: Internet is fetched through internet cubit
User Bloc: Initialized but Deprecated, could be further improvement

### Data

Data is composed of 3 parts: Models, Providers and Repositories

Models:

User: User model implemented here
Story: Story and Story Content model is implemented here

Providers:

Photos: Photo provider consist of different implementations

1. Takes photos through JSON Placeholder website
2. Uses assets folder to get previously placed photos
3. Fethes photos from Pexels APIs

First is not used due to image quality, only second and third is used to mix them and not to overload Pexels API and push API limits

Videos: Videos are fetched through Pexels API
Note: Only a few videos are fetched through the API

Both photo and video API requests can be modified, there is quotas written on each one

Repos:

User: Users are fetched here, through samples users
Story Content: Story Contents are generated through providers and models
Story: Story generation for each of the user with random order
Stories: Stories are gathered in one place with random order

### Other

Assets: Sample images and videos are included in the assets folder
Constants: Some constant image/video data and other constants are here
l10n: Localization folders are here with English and Turkish languages
Services: Some other services are implemented here

Navigator Service: Page navigations are managed here
Shared Preferences Service: Local data such as Seen/Unseen Stories are managed here

### Packages

You can see pubspec file to see packages.

For cubic transition between stories the flutter carousel slider package is used: flutter_carousel_slider

However, due to incapabilities, it resulted in some bugs. But the package is forked and edited in order to fix the issues and downloaded from my github while using in the application.

Also, the fix is sent as a pull request to the package owner: https://github.com/UdaraWanasinghe/FlutterCarouselSlider

## Author

Erke Canbazoğlu

- Linkedin - [Erke Canbazoğlu](https://www.linkedin.com/in/erkecanbazoglu/)
- Github - [erkecanbazoglu](https://github.com/erkecanbazoglu)
