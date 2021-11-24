module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, text, span)
import Html.Attributes exposing (width, class, style)
import Html.Events exposing (onClick)
import Svg as S
import Svg.Attributes as SA
import Html5.DragDrop as DragDrop
import Array exposing (Array)
import Game.GameRoute as GameRoute exposing (GameState, Status(..))
import Puzzles as Puzzles exposing (Puzzle, ImageType(..))
import Debug exposing (toString, log)
import Grid exposing (Grid)
import Puzzles exposing (Position)
import Grid exposing (Square)


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
  { gs : GameRoute.GameState
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
            [ gameButton Next "Next"
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
      [ S.svg
        [ SA.width "120"
        , SA.height "120"
        , SA.viewBox "0 0 120 120"
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
  div [ class "gridArea" ]
      [ gs.grid.squares
          |> List.map 
            (List.map
              (\a ->
                  square a
              )
            )
          |> List.map (div [ ])
          |> container
      ]

square : Square -> Html Msg
square s =
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
      [ text ("(" ++ String.fromInt(s.position.x) ++ ", " ++ String.fromInt(s.position.y) ++ ")") ]

nonBreakingSpace : String
nonBreakingSpace =
    Char.fromCode 160 |> String.fromChar

container : List (Html Msg) -> Html Msg
container =
  div [ ]

toIndexed2dList : Grid -> List (List (Int, Int))
toIndexed2dList grid =
    List.range 0 grid.height
        |> List.foldr
            (\y result ->
                (Array.initialize (grid.width * grid.height) (\n -> (n // grid.width, remainderBy grid.width n))
                    |> Array.slice (grid.width * y) (grid.width * y + grid.width)
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

gameButton : Msg -> String -> Html Msg
gameButton clickMsg content =
  div
    [ class "game-button"
    , onClick clickMsg
    ]
    [ text content ]