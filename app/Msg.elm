module Msg exposing (..)

import Model exposing (..)
import Dropdown exposing (Dropdown)
import Dropdown exposing (Event(ItemSelected))
import Http exposing (..)
import Helpers exposing (decodeChapter)

type Msg = ProviderSelected (Dropdown.Msg Provider)
         | UpdateBookId String
         | UpdateChapterId String
         | RetrieveChapter
         | ReceiveChapter (Result Http.Error String)

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