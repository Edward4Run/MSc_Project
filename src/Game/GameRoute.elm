module Game.GameRoute exposing (..)

import Game.Levels.Level1 as Level1 exposing (..)
import Game.Levels.Level2 as Level2 exposing (..)
import Grid exposing (Grid, Square)
import Puzzles exposing (Puzzle, Position)
import Dict


type alias GameState =
    { level : Int
    , status : Status
    , puzzles : List Puzzle
    , grid : Grid
    }

type Status
    = HomePage
    | Playing
    | Won

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

updateLevelGameStatus : Int -> Position -> GameState -> GameState
updateLevelGameStatus id position gs =
    let
        dragpuzzle =
            gs.puzzles
                |> List.map (\item -> (item.id, item))
                |> Dict.fromList
                |> Dict.get id
    in
    { level = gs.level
    , status = if gs.grid.count /= ( gs.grid.width * gs.grid.height ) then gs.status else Won
    , puzzles = updatePuzzles id position gs.puzzles
    , grid = { squares = updateSquares dragpuzzle position gs
            , width = gs.grid.width
            , height = gs.grid.height
            , count = countCovered gs.grid }
    }


updatePuzzles : Int -> Position -> List Puzzle -> List Puzzle
updatePuzzles id position puzzles =
    if position.x > -1 then
        List.filter ( \a -> a.id /= id ) puzzles
    else
        puzzles

updateSquares : Maybe Puzzle -> Position -> GameState -> List ( List Square )
updateSquares dragpuzzle position gs =
    gs.grid.squares
        |> List.map 
            (List.map
              (\a ->
                  updateSquare a dragpuzzle position
              )
            )

updateSquare : Square -> Maybe Puzzle -> Position -> Square
updateSquare square dragpuzzle position =
    case dragpuzzle of
        Nothing ->
            square

        Just puzzle ->
            let
                covered =
                    if square.position.y == position.y
                        && square.position.x >= ( position.x - puzzle.shape.up ) 
                        && square.position.x <= ( position.x + puzzle.shape.down ) then
                        True
                    else if square.position.x == position.x
                        && square.position.y >= ( position.y - puzzle.shape.left ) 
                        && square.position.y <= ( position.y + puzzle.shape.right )
                        then
                        True
                    else
                        False
            in
            if covered then
                { isCovered = True, position = square.position }
            else
                square


countCovered : Grid -> Int
countCovered grid =
    grid.squares
        |> List.concat
        |> List.filter (\a -> a.isCovered == True )
        |> List.length