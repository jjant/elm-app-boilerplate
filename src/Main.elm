module Main exposing (..)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation exposing (Key)
import Html
import Pages.Home as Home
import Pages.NotFound as NotFound
import Route
import Url exposing (Url)



---- MODEL ----


type alias Model =
    { key : Key
    , pageState : PageState
    }


type PageState
    = Home Home.Model
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
            Home.init
                |> toMainTuple Home HomeMsg

        Route.NotFound ->
            ( NotFound, Cmd.none )


toMainTuple : (pageModel -> PageState) -> (pageMsg -> PageMsg) -> ( pageModel, Cmd pageMsg ) -> ( PageState, Cmd Msg )
toMainTuple toModel toMsg ( model, cmd ) =
    ( toModel model, Cmd.map (PageMsg << toMsg) cmd )



---- UPDATE ----


type Msg
    = NoOp
    | PageMsg PageMsg
    | LinkClicked UrlRequest
    | UrlChanged Url


type PageMsg
    = HomeMsg Home.Msg


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

        PageMsg pageMsg ->
            let
                ( newPageState, pageCmds ) =
                    updatePage pageMsg model.pageState
            in
            ( { model | pageState = newPageState }, pageCmds )

        NoOp ->
            ( model, Cmd.none )


updatePage : PageMsg -> PageState -> ( PageState, Cmd Msg )
updatePage pageMsg pageState =
    case ( pageMsg, pageState ) of
        ( HomeMsg homeMsg, Home homeModel ) ->
            Home.update homeMsg homeModel
                |> toMainTuple Home HomeMsg

        ( _, _ ) ->
            ( pageState, Cmd.none )



---- VIEW ----


view : Model -> Document Msg
view model =
    case model.pageState of
        Home homeModel ->
            Home.view homeModel
                |> mapView fromHomeMsg

        NotFound ->
            NotFound.view


mapView : (a -> b) -> Document a -> Document b
mapView f { title, body } =
    { title = title
    , body = List.map (Html.map f) body
    }



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.pageState of
        Home homeModel ->
            Home.subscriptions homeModel
                |> Sub.map fromHomeMsg

        NotFound ->
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



---- MISC ----


fromHomeMsg : Home.Msg -> Msg
fromHomeMsg =
    HomeMsg >> PageMsg
