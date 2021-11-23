module Game.Levels.Level2 exposing (..)

import Puzzles exposing (..)
import Grid exposing (..)
import Array exposing (Array)

generateGrid : Grid
generateGrid =
    { squares = Array.repeat 8 { isCovered = False, position = { x = 0, y = 0 }}
    , size = ( 2, 4 )}

generatePuzzles : List Puzzle
generatePuzzles =
    [{ id = 1
    , image = Seven
    , rotation = 0
    , shape = { right = 1, left = 0, up = 0, down = 2 }
    , position = { x = -1, y = -1 }}
    , { id = 2
    , image = Seven
    , rotation = 0
    , shape = { right = 1, left = 0, up = 0, down = 2 }
    , position = { x = -1, y = -1 }}]