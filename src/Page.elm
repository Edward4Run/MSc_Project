module Page exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Html5.DragDrop as DragDrop

-- TYPE

type GameState
    = Playing
    | Won
    | NotPlaying