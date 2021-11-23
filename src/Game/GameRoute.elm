module Game.GameRoute exposing (..)

import Game.Levels.Level1 as Level1 exposing (..)
import Game.Levels.Level2 as Level2 exposing (..)
import Grid exposing (Grid)
import Puzzles exposing (Puzzle)

generateLevelGrid : Int -> Grid
generateLevelGrid level =
    case level of
        1 ->
            Level1.generateGrid

        _ ->
            Level2.generateGrid

generateLevelPuzzles : Int -> List Puzzle
generateLevelPuzzles level =
    case level of
        1 ->
            Level1.generatePuzzles
        
        _ ->
            Level2.generatePuzzles