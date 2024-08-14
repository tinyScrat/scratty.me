module Sandbox exposing (main)

import Browser
import Html exposing (Html, div, h1, text)


type alias Model =
    { title : String
    , description : String
    }


type Msg
    = SayHi


init : Model
init =
    Model "title" "description"


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.title ]
        , div [] [ text model.description ]
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        SayHi ->
            { model | description = "Hi" }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
