module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, text, span)
import Html.Attributes exposing (src, width, class, style)
import Html.Events exposing (onClick)
import Svg as S
import Svg.Attributes as SA
import Html5.DragDrop as DragDrop
import Array exposing (Array)
import Game.GameRoute as GameRoute
import Puzzles as Puzzles exposing (Puzzle, ImageType(..))
import Debug exposing (toString, log)
import Grid exposing (Grid, Square)
import Puzzles exposing (Position)


-- MAIN
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL
type alias Model =
  { gs : GameState
  , dragDrop : DragDrop.Model Int Puzzles.Position
  }

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



-- INIT

init : () -> ( Model, Cmd Msg )
init _ = ( { gs = { level = 2
                  , status = HomePage
                  , puzzles = GameRoute.generateLevelPuzzles 2
                  , grid = GameRoute.generateLevelGrid 2 }
            , dragDrop = DragDrop.init}
          , Cmd.none )


-- UPDATE
type Msg 
  = Play 
  | Exit
  | Next
  | DragDropMsg (DragDrop.Msg Int Puzzles.Position)
  | RotateImage Int

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Play ->
      ( { model | gs = { level = model.gs.level
                        , status = Playing
                        , puzzles = model.gs.puzzles
                        , grid = model.gs.grid } }, Cmd.none )
    Exit ->
      ( { model | gs = { level = model.gs.level
                        , status = HomePage
                        , puzzles = model.gs.puzzles
                        , grid = model.gs.grid } }, Cmd.none )
    Next ->
      ( { model | gs = { level = model.gs.level + 1
                        , status = Playing
                        , puzzles = GameRoute.generateLevelPuzzles ( model.gs.level + 1 )
                        , grid = GameRoute.generateLevelGrid ( model.gs.level + 1 ) } }, Cmd.none)
    RotateImage msg_ ->
      ( { model | gs = { level = model.gs.level
                        , status = Playing
                        , puzzles = List.map (\puzzle -> updateRotation puzzle msg_) model.gs.puzzles
                        , grid = model.gs.grid } }, Cmd.none)
    DragDropMsg msg_ ->
      let
        ( model_, result ) =
            DragDrop.update msg_ model.dragDrop
      in 
        log (toString msg_) ( { model
            | dragDrop = model_
            , gs =
                case result of
                  Nothing ->
                    model.gs
                  Just (id, position, _) ->
                    updateGameSate id position model.gs
          }
        , Cmd.none
        )

updateRotation : Puzzle -> Int -> Puzzle
updateRotation puzzle id = 
  { id = puzzle.id
  , image = puzzle.image
  , rotation = ( if puzzle.id == id then
                        puzzle.rotation + 90
                      else puzzle.rotation )
  , shape = ( if puzzle.id == id then
                { right = puzzle.shape.up
                , left = puzzle.shape.down
                , up = puzzle.shape.left
                , down = puzzle.shape.right }
              else puzzle.shape )
  , position = puzzle.position }

updateGameSate : Int -> Position -> GameState -> GameState
updateGameSate id position gs =
  { level = gs.level
  , status = gs.status
  , puzzles = updatePuzzles id position gs.puzzles
  , grid = gs.grid
  }

updatePuzzles : Int -> Position -> List Puzzle -> List Puzzle
updatePuzzles id position puzzles =
  if position.x > -1 then
    List.filter ( \a -> a.id == id ) puzzles
  else
    puzzles
    

-- SUB
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW
view : Model -> Html Msg
view model =
  case model.gs.status of
    HomePage ->
      viewHomePage
    Playing ->
      viewPlayArea model
    Won ->
      viewPlayArea model


-- Homepage View
viewHomePage : Html Msg
viewHomePage = 
  div [ class "background" ]
      [ div [ class "menu" ]
            [ h1 [ class "title" ] [ text "Tangram" ]
            , div [ class "buttons" ]
                  [ menuButton Play "PLAY"
                  , menuButton Exit "EXIT" ] ]
      ]



-- PlayArea View
viewPlayArea : Model -> Html Msg
viewPlayArea model = 
  div [ class "background" ]
      [ puzzleArea model.gs
      , gridArea model.gs ]

puzzleArea : GameState -> Html Msg
puzzleArea gs =
  div ([ class "puzzleArea" ]
      ++ DragDrop.droppable DragDropMsg {x=-1, y=-1}
      )
      (List.map viewPuzzle gs.puzzles)

viewPuzzle : Puzzle -> Html Msg
viewPuzzle puzzle =
    div ([ onClick (RotateImage puzzle.id) ] ++ DragDrop.draggable DragDropMsg puzzle.id )
      [ S.svg
        [ SA.width "120"
        , SA.height "120"
        , SA.viewBox "0 0 80 120"
        , SA.style "stroke: currentColor;"
        , style "transition" "transform 0.5s"
        , style "transform" ("rotate(" ++ String.fromInt puzzle.rotation ++ "deg)") ] 
        (case puzzle.image of
          One ->
            [ S.rect [ SA.x "0", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "80", SA.y "0", SA.width "40", SA.height "40" ] []
            ]
          Seven ->
            [ S.rect [ SA.x "0", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "0", SA.y "40", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "0", SA.y "80", SA.width "40", SA.height "40" ] []
            ]
          Four ->
            [ S.rect [ SA.x "0", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "0", SA.y "40", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "40", SA.width "40", SA.height "40" ] []
            ]
          FourInLine ->
            [ S.rect [ SA.x "0", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "80", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "120", SA.y "0", SA.width "40", SA.height "40" ] []
            ]
          Six ->
            [ S.rect [ SA.x "0", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "0", SA.y "40", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "40", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "0", SA.y "80", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "80", SA.width "40", SA.height "40" ] []
            ]
        ) 
      ]

gridArea : GameState -> Html Msg
gridArea gs = 
  let
    ( width_, height_ ) =
      gs.grid.size
  in
  div [ class "gridArea" ]
      [ toIndexed2dList width_ height_
          |> List.map 
              (List.map
                        (\(a, b) ->
                            square (a, b)
                        )
              )
          |> List.map (div [ ])
          |> container
      ]

square : (Int, Int) -> Html Msg
square (a, b) =
  span ([ class "square" ]
      ++ DragDrop.droppable DragDropMsg {x=a, y=b}
      )
        [ text ("(" ++ String.fromInt(a) ++ ", " ++ String.fromInt(b) ++ ")") ]

nonBreakingSpace : String
nonBreakingSpace =
    Char.fromCode 160 |> String.fromChar


container : List (Html Msg) -> Html Msg
container =
  div [ ]

toIndexed2dList : Int -> Int -> List (List (Int,Int))
toIndexed2dList width height =
    List.range 0 height
        |> List.foldr
            (\y result ->
                (Array.initialize (width * height) (\n -> (n // width, remainderBy width n))
                    |> Array.slice (width * y) (width * y + width)
                    |> Array.toList
                )
                    :: result
            )
            []


-- BUTTONS
menuButton : Msg -> String -> Html Msg
menuButton clickMsg content =
  div
    [ class "menu-button"
    , onClick clickMsg
    ]
    [ text content ]


