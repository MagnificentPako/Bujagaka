module Helpers exposing (..)

import Html exposing (..)
import Bass as B exposing (..)
import Msg exposing (..)
import Html.Attributes as Attributes
import Json.Encode
import Json.Decode as Decode
import Model exposing (..)
import Dropdown exposing (Dropdown)
import Html.Events as Events

contained : List (Html Msg) -> Html Msg
contained = div [ Attributes.class "container" ]

empty : Html Msg
empty = div [] []

title : List (Html Msg) -> Html Msg
title = 
    p
        [ style
            [ B.h1
            , B.center
            ]
        ]
            

content : List (Html Msg) -> Html Msg
content = 
    div
        [ style 
            [ B.p2
            , B.border
            , B.rounded
            , B.h4
            ]
        ] 

textHtml: String -> Html msg
textHtml t =
    span
        [ Json.Encode.string t
            |> Attributes.property "innerHTML"
        ]
        []

decodeChapter : Decode.Decoder String
decodeChapter = 
    Decode.at ["content"] Decode.string

makeDropdown : Model -> Html Msg
makeDropdown model = 
    div
        []
        [ Html.map ProviderSelected <|
            Dropdown.view
                model.items
                model.selectedItem
                .name
                model.dropdown
        ]

inputField : String -> (String -> Msg) -> Html Msg
inputField name msg = 
    input 
        [ Attributes.placeholder name, Events.onInput msg ] 
        []

shouldDisableButton : Model -> Bool
shouldDisableButton model =
    let
        isNothing : Maybe a -> Bool
        isNothing m = case m of
            Just a -> False
            Nothing -> True
    in
        isNothing  model.selectedItem
                || model.bookId    == ""
                || model.chapterId == ""

chapterSelection : Model -> Html Msg
chapterSelection model =
    div
        []
        [ inputField "Book ID" UpdateBookId
        , inputField "Chapter ID" UpdateChapterId
        , button 
            [ onClick RetrieveChapter, disabled <| shouldDisableButton model  ]
            [ text "Submit" ]
        , makeDropdown model
        ]