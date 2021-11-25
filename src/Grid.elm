module Grid exposing (..)

import Puzzles exposing (Position)
import Array

type alias Grid =
    { squares : List ( List Square )
    , width : Int
    , height : Int
    , count : Int
    }


type alias Square =
    { isCovered : Bool
    , position : Position
    }

genarateIndexedSquare : Int -> Int -> List ( List Square )
genarateIndexedSquare width height =
    List.range 0 height
        |> List.foldr
            (\y result ->
                (Array.initialize (width * height) (\n -> { isCovered = False, position = { x = n // width, y = remainderBy width n}})
                    |> Array.slice (width * y) (width * y + width)
                    |> Array.toList
                )
                    :: result
            )
            []