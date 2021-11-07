module Square exposing (..)

import Char
import Html exposing (Attribute, Html, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as Decode
import Point exposing (Point)
import View.Colors as Colors
import View.Icons

type Content
    = Mine
    | Empty
    | Number1
    | Number2
    | Number3
    | Number4
    | Number5
    | Number6
    | Number7
    | Number8


type Visibility
    = Covered
    | Flagged
    | Uncovered

type alias Square =
    { visibility : Visibility
    , content : Content
    }

nonBreakingSpace : String
nonBreakingSpace =
    Char.fromCode 160 |> String.fromChar


view : Point -> Html msg
view point =
    span
        [ 
        ]
        [ text nonBreakingSpace ]

