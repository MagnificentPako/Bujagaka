module App exposing (..)

import Html exposing (..)
import Lorem as Lorem
import Helpers exposing (..)
import Model exposing (..)
import Msg exposing (..)
import Dropdown exposing (Dropdown, Event(ItemSelected))
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (placeholder, disabled)
import Http
import Json.Decode as Decode
import Json.Encode

init : ( Model, Cmd Msg )
init =
    ( Model
        Dropdown.init
        [ Provider "RoyalRoad" RoyalRoadL
        , Provider "Webnovel.com" WebNovel
        , Provider "Fanfiction.net" FanFiction
        ]
        Nothing
        ""
        ""
        ""
    , Cmd.none )

view : Model -> Html Msg
view model =
    contained
        [ chapterSelection model
        , title [ text "Bujagaka" ]
        , empty
        , empty
        , content [ p [] [ textHtml model.chapterContent ] ]
        ]

main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }