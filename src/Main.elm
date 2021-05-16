module Main exposing (..)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation exposing (Key)
import Element
    exposing
        ( centerX
        , image
        , padding
        , px
        , spacing
        , text
        , width
        )
import Element.Region as Region
import Route
import Url exposing (Url)



---- MODEL ----


type alias Model =
    { key : Key
    , pageState : PageState
    }


type PageState
    = Home
    | NotFound


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    let
        ( pageState, pageCmds ) =
            initPage url
    in
    ( { pageState = pageState, key = key }, pageCmds )


initPage : Url -> ( PageState, Cmd Msg )
initPage url =
    let
        route =
            Route.fromUrl url
    in
    case route of
        Route.Home ->
            ( Home, Cmd.none )

        Route.NotFound ->
            ( NotFound, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | LinkClicked UrlRequest
    | UrlChanged Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Navigation.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Navigation.load url
                    )

        UrlChanged url ->
            let
                ( pageState, pageCmds ) =
                    initPage url
            in
            ( { model | pageState = pageState }, pageCmds )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Document Msg
view _ =
    { title = "Your elm app!"
    , body =
        [ Element.layout [] <|
            Element.column
                [ centerX
                , padding 16
                , spacing 16
                ]
                [ image
                    [ width (px 200)
                    , centerX
                    ]
                    { src = "/logo.svg", description = "Elm logo" }
                , Element.el [ centerX, Region.heading 1 ]
                    (text "Your Elm App is working!")
                ]
        ]
    }



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



---- PROGRAM ----


type alias Flags =
    {}


main : Program Flags Model Msg
main =
    Browser.application
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }
