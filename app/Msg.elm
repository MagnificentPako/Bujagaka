module Msg exposing (..)

import Model exposing (..)
import Dropdown exposing (Dropdown)
import Http exposing (..)

type Msg = ProviderSelected (Dropdown.Msg Provider)
         | UpdateBookId String
         | UpdateChapterId String
         | RetrieveChapter
         | ReceiveChapter (Result Http.Error String)