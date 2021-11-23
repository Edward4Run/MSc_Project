module Grid exposing (..)

import Array exposing (Array)
import Puzzles exposing (Position)

type alias Grid =
    { squares : Array Square
    , size : ( Int, Int )
    }


type alias Square =
    { isCovered : Bool
    , position : Position
    }


