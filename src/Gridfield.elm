module Gridfield exposing (..)

import Array
import Html exposing (Html, div)
import Html.Attributes exposing (..)
import Matrix exposing (Matrix)
import Point exposing (Point)
import Square exposing (Content(..), Square, Visibility(..))

type alias GridLevel =
    { level : Int
    , gridWidth : Int
    , gridHeight : Int
    }

type alias Gridfield =
    Matrix Square


--VIEW
container : List (Html msg) -> Html msg
container =
    div
        [ ]

viewEmpty : Int -> Html msg
viewEmpty level =
    Matrix.repeat (gridSize level) (Square Covered Empty)
        |> view
        
view : Gridfield -> Html msg
view gridfield =
    Matrix.toIndexed2dList gridfield
        |> List.map
            (List.map
                (\( ( x, y ), square ) ->
                    Square.view (Point.Point y x)
                )
            )
        |> List.map (div [ ])
        |> container

gridSize : Int -> (Int, Int)
gridSize level = 
    case level of
       1 -> (3, 1)
       2 -> (4, 2)
       _ -> (0, 0)