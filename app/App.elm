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

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ProviderSelected dropdownMsg ->
            let
                ( updatedDropdown, event ) =
                    Dropdown.update dropdownMsg model.dropdown
            in
                case event of
                    ItemSelected provider ->
                        ({ model
                            | dropdown = updatedDropdown
                            , selectedItem = Just provider
                        }, Cmd.none)
                    _ ->
                        ({ model | dropdown = updatedDropdown }, Cmd.none)
        UpdateBookId bid ->
            ({ model | bookId = bid }, Cmd.none)
        UpdateChapterId cid ->
            ({ model | chapterId = cid}, Cmd.none)
        RetrieveChapter ->
            case model.selectedItem of
                Nothing -> (model, Cmd.none)
                Just provider ->
                    (model, getChapter provider.type_ model.bookId model.chapterId)
        ReceiveChapter (Ok newContent) ->
            ({model | chapterContent = newContent}, Cmd.none)
        ReceiveChapter (Err _) ->
            (model, Cmd.none)

view : Model -> Html Msg
view model =
    contained
        [ chapterSelection model
        , title [ text "Bujagaka" ]
        , empty
        , empty
        , content [ p [] [ textHtml model.chapterContent ] ]
            --(Lorem.paragraphs 12
            --    |> Lorem.wrapInHtml (p []))
        ]

main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }

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

getChapter : ProviderType -> String -> String -> Cmd Msg
getChapter pt bid cid =
    let
        providerName = case pt of
            RoyalRoadL -> "rrl"
            WebNovel -> "ffn"
            FanFiction -> "webnovel"
        url =
            "http://localhost:5000/" ++ providerName ++ "/" ++ bid ++ "/chapter/" ++ cid
        request =
            Http.get url decodeChapter
    in
        Http.send ReceiveChapter request