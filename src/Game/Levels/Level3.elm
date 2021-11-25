module Game.Levels.Level3 exposing (..)

import Puzzles exposing (..)
import Grid exposing (..)

generateGrid : Grid
generateGrid =
    { squares = Grid.genarateIndexedSquare 4 2
    , width = 4
    , height = 2
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