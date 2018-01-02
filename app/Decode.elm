module Decode exposing (..)

import Json.Decode as Decode

decodeChapter : Decode.Decoder String
decodeChapter = 
    Decode.at ["content"] Decode.string
