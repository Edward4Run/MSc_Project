module Page exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Html5.DragDrop as DragDrop

-- TYPE

type GameState
    = Playing
    | Won
    | NotPlaying

gridContainer : Html none
gridContainer =
    div [ class "grid-container" ]
        [ gridRow
        , gridRow
        , gridRow
        , gridRow
        ]


gridRow : Html none
gridRow =
    div [ class "grid-row" ]
        [ div [ class "grid-cell" ]
            []
        , div [ class "grid-cell" ]
            []
        , div [ class "grid-cell" ]
            []
        , div [ class "grid-cell" ]
            []
        ]