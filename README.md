# Elm Application Boilerplate

Standard boilerplate for an Elm application with `Browser.application`.

Boostrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).
Refer to its documentation if you need to use any of its features. Alternatively, just substitute in your custom build toolchain.

## General structure

The code here just defines the basic structure you need for a `Browser.application` program.

There's a `Route` module which defines routes (duh) and how to parse those.

I've used `elm-ui` for the (minimal) `view` because that's what I usually use for side projects.

## Set up

Run `npm install` to install the create-elm-app binary and start the dev server with `npm start`.

## Considerations

I've removed the service worker code included with create-elm-app because it's usually done more harm than good in my experience. Feel free to copy it in to get that functionality back.
