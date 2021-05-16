module Route exposing (Route(..), fromUrl)

import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, top)


type Route
    = Home
    | NotFound


fromUrl : Url -> Route
fromUrl url =
    url
        |> Parser.parse parser
        |> Maybe.withDefault NotFound


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home top ]
