module Pages.Home exposing (Model, Msg, init, subscriptions, update, view)

import Browser exposing (Document)
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
import Time


type alias Model =
    Int


type Msg
    = Tick


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick ->
            ( model + 1, Cmd.none )


view : Model -> Document Msg
view model =
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
                , Element.el [ centerX ]
                    (text <| "You've been here for: " ++ String.fromInt model ++ " seconds.")
                ]
        ]
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 (\_ -> Tick)
