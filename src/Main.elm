module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, text, span)
import Html.Attributes exposing (width, height, class, style)
import Html.Events exposing (onClick)
import Svg exposing (svg, rect)
import Svg.Attributes exposing (viewBox, x, y)
import Html5.DragDrop as DragDrop
import Game.GameRoute as GameRoute exposing (GameState, Status(..))
import Puzzles exposing (Puzzle, ImageType(..))
import Grid exposing (Grid, Square)
import Debug exposing (toString, log)


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


-- INIT

init : () -> ( Model, Cmd Msg )
init _ = ( { gs = { level = 1
                  , status = HomePage
                  , puzzles = GameRoute.generateLevelPuzzles 1
                  , grid = GameRoute.generateLevelGrid 1 }
            , dragDrop = DragDrop.init}
          , Cmd.none )


-- UPDATE
type Msg 
  = Play 
  | Exit
  | Next
  | Restart
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
    Restart ->
      ( { model | gs = { level = model.gs.level
                        , status = Playing
                        , puzzles = GameRoute.generateLevelPuzzles model.gs.level
                        , grid = GameRoute.generateLevelGrid model.gs.level } }, Cmd.none)
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
                    GameRoute.updateLevelGameStatus id position model.gs
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
      viewPlayArea model.gs
    Won ->
      viewPlayArea model.gs


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
viewPlayArea : GameState -> Html Msg
viewPlayArea gs =
  div [ class "background" ]
      [ puzzleArea gs
      , gridArea gs 
      , div [ class "buttons" ]
            [ gameButton Restart "Restart"
            , gameButton Next "Next"
            , gameButton Exit "EXIT" ] ]

puzzleArea : GameState -> Html Msg
puzzleArea gs =
  div ([ class "puzzleArea" ]
      ++ DragDrop.droppable DragDropMsg {x=-1, y=-1}
      )
      (List.map viewPuzzle gs.puzzles)

viewPuzzle : Puzzle -> Html Msg
viewPuzzle puzzle =
    div ([ onClick (RotateImage puzzle.id) ] ++ DragDrop.draggable DragDropMsg puzzle.id )
      [ case puzzle.image of
          One ->
            svg
              [ width 120
              , height 40
              , viewBox "0 0 120 40"
              , style "stroke" "currentColor"
              , style "transition" "transform 0.5s"
              , style "transform" ("rotate(" ++ String.fromInt puzzle.rotation ++ "deg)")
              ]
              [ rect [ x "0", y "0", width 40, height 40 ] []
              , rect [ x "40", y "0", width 40, height 40 ] []
              , rect [ x "80", y "0", width 40, height 40 ] []
              ]
          Seven ->
            svg
              [ width 80
              , height 120
              , viewBox "0 0 80 120"
              , style "stroke" "currentColor"
              , style "transition" "transform 0.5s"
              , style "transform" ("rotate(" ++ String.fromInt puzzle.rotation ++ "deg)")
              ]
              [ rect [ x "0", y "0", width 40, height 40 ] []
              , rect [ x "40", y "0", width 40, height 40 ] []
              , rect [ x "0", y "40", width 40, height 40 ] []
              , rect [ x "0", y "80", width 40, height 40 ] []
              ]
          Four ->
            svg
              [ width 80
              , height 80
              , viewBox "0 0 80 80"
              , style "stroke" "currentColor"
              , style "transition" "transform 0.5s"
              , style "transform" ("rotate(" ++ String.fromInt puzzle.rotation ++ "deg)")
              ]
              [ rect [ x "0", y "0", width 40, height 40 ] []
              , rect [ x "40", y "0", width 40, height 40 ] []
              , rect [ x "0", y "40", width 40, height 40 ] []
              , rect [ x "40", y "40", width 40, height 40 ] []
              ]
          FourInLine ->
            svg
              [ width 160
              , height 40
              , viewBox "0 0 160 40"
              , style "stroke" "currentColor"
              , style "transition" "transform 0.5s"
              , style "transform" ("rotate(" ++ String.fromInt puzzle.rotation ++ "deg)")
              ]
              [ rect [ x "0", y "0", width 40, height 40 ] []
              , rect [ x "40", y "0", width 40, height 40 ] []
              , rect [ x "80", y "0", width 40, height 40 ] []
              , rect [ x "120", y "0", width 40, height 40 ] []
              ]
          Six ->
            svg
              [ width 80
              , height 120
              , viewBox "0 0 80 120"
              , style "stroke" "currentColor"
              , style "transition" "transform 0.5s"
              , style "transform" ("rotate(" ++ String.fromInt puzzle.rotation ++ "deg)")
              ]
              [ rect [ x "0", y "0", width 40, height 40 ] []
              , rect [ x "40", y "0", width 40, height 40 ] []
              , rect [ x "0", y "40", width 40, height 40 ] []
              , rect [ x "40", y "40", width 40, height 40 ] []
              , rect [ x "0", y "80", width 40, height 40 ] []
              , rect [ x "40", y "80", width 40, height 40 ] []
              ]
      ]

gridArea : GameState -> Html Msg
gridArea gs = 
  div [ class "gridArea" ]
      [ gs.grid.squares
          |> List.map 
            (List.map
              (\a ->
                  viewSquare a
              )
            )
          |> List.map (div [ ])
          |> container
      ]

viewSquare : Square -> Html Msg
viewSquare s =
  let
    covered =
      if s.isCovered then
        [ style "background-color" "#000000"]
      else
        [ style "background-color" "#FFFFFF"]
        ++ DragDrop.droppable DragDropMsg { x = s.position.x, y = s.position.y }
  in
  span ([ class "square" ]
      ++ covered
      )
      [ text nonBreakingSpace ]

nonBreakingSpace : String
nonBreakingSpace =
    Char.fromCode 160 |> String.fromChar

container : List (Html Msg) -> Html Msg
container =
  div [ ]


-- BUTTONS
menuButton : Msg -> String -> Html Msg
menuButton clickMsg content =
  div
    [ class "menu-button"
    , onClick clickMsg
    ]
    [ text content ]

gameButton : Msg -> String -> Html Msg
gameButton clickMsg content =
  div
    [ class "game-button"
    , onClick clickMsg
    ]
    [ text content ]