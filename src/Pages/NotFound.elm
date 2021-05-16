module Pages.NotFound exposing (view)

import Browser exposing (Document)
import Element exposing (text)


view : Document msg
view =
    { title = "Not found"
    , body =
        [ Element.layout [] <|
            Element.el [] (text "This page couldn't be found :(")
        ]
    }
