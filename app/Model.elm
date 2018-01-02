module Model exposing (..)

import Dropdown exposing(Dropdown)

type alias Model = {
    dropdown: Dropdown,
    items: List Provider,
    selectedItem: Maybe Provider,
    bookId: String,
    chapterId: String,
    chapterContent: String
}

type alias Provider = 
    { name: String
    , type_: ProviderType
    }

type ProviderType = RoyalRoadL
                  | WebNovel
                  | FanFiction