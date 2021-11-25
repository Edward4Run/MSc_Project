module Game.Levels.Level5 exposing (..)

import Puzzles exposing (..)
import Grid exposing (..)

generateGrid : Grid
generateGrid =
    { squares = Grid.genarateIndexedSquare 2 4
    , width = 2
    , height = 4
    , count = 0 }

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