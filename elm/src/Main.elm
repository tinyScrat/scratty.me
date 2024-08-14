{- Elm Snippets
   Various Elm code snippets.
-}


module Main exposing (..)

import Browser exposing (Document)
import Html exposing (div, footer, h1, header, main_, text)


type alias Model =
    { title : String
    , description : String
    }


type Msg
    = Loaded


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "tinyScrat" "tinyScrat's blog", Cmd.none )


view : Model -> Document Msg
view model =
    let
        title =
            model.title

        body =
            [ header [] [ h1 [] [ text title ] ]
            , main_ [] [ text model.description ]
            , footer [] [ text "2024 tinyScrat" ]
            ]
    in
    { title = title
    , body = body
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Loaded ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
