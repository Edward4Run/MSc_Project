module Game.Levels.Level2 exposing (..)

import Puzzles exposing (..)
import Grid exposing (..)

generateGrid : Grid
generateGrid =
    { squares = Grid.genarateIndexedSquare 1 3
    , width = 1
    , height = 3
    , count = 0 }

generatePuzzles : List Puzzle
generatePuzzles =
    [{ id = 1
    , image = Three
    , rotation = 0
    , shape = { right = 1, left = 1, up = 0, down = 0 }
    , position = { x = -1, y = -1 }}
    ]