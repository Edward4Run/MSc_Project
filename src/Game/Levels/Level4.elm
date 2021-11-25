module Game.Levels.Level4 exposing (..)

import Puzzles exposing (..)
import Grid exposing (..)

generateGrid : Grid
generateGrid =
    { squares = Grid.genarateIndexedSquare 4 2
    , width = 4
    , height = 2}

generatePuzzles : List Puzzle
generatePuzzles =
    [{ id = 1
    , image = One
    , rotation = 0
    , shape = { right = 0, left = 0, up = 0, down = 0 }
    , position = { x = -1, y = -1 }}
    , { id = 2
    , image = Three
    , rotation = 0
    , shape = { right = 1, left = 1, up = 0, down = 0 }
    , position = { x = -1, y = -1 }}
    , { id = 3
    , image = Seven
    , rotation = 0
    , shape = { right = 1, left = 0, up = 0, down = 2 }
    , position = { x = -1, y = -1 }}]