module Game.Levels.Level1 exposing (..)

import Puzzles exposing (..)
import Grid exposing (..)
import Array exposing (Array)
import Html.Attributes exposing (width)
import Html.Attributes exposing (height)


generateGrid : Grid
generateGrid =
    { squares = Array.repeat 3 { isCovered = False, position = { x = 0, y = 0 }}
    , size = ( 1, 3 )}

generatePuzzles : List Puzzle
generatePuzzles =
    [{ id = 1
    , image = One
    , rotation = 0
    , shape = { right = 1, left = 1, up = 0, down = 0 }
    , position = { x = -1, y = -1 }}
    ]