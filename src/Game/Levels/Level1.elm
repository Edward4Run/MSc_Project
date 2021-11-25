module Game.Levels.Level1 exposing (..)

import Puzzles exposing (..)
import Grid exposing (..)


generateGrid : Grid
generateGrid =
    { squares = Grid.genarateIndexedSquare 1 1
    , width = 1
    , height = 1
    , count = 0 }

generatePuzzles : List Puzzle
generatePuzzles =
    [{ id = 1
    , image = One
    , rotation = 0
    , shape = { right = 0, left = 0, up = 0, down = 0 }
    , position = { x = -1, y = -1 }}
    ]