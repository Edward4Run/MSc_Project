module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, text, img, span)
import Html.Attributes exposing (src, width, class)
import Html.Events exposing (onClick)
import Html5.DragDrop as DragDrop
import Json.Decode exposing (Value)
import Array exposing (Array)
import View.Puzzles as Puzzles


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
  , dragDrop : DragDrop.Model Int Position
  }

type alias GameState =
    { level : Int
    , status : Status
    }

type Status
    = HomePage
    | Playing
    | Won

type Position
  = Left
  | Right


-- INIT

init : () -> ( Model, Cmd Msg )
init _ = ( { gs = { level = 2
                  , status = HomePage }
            , dragDrop = DragDrop.init}
          , Cmd.none )


-- UPDATE
type Msg 
  = Play
  | Exit
  | Next
  | DragDropMsg (DragDrop.Msg Int Position)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Play ->
      ( { model | gs = { level = model.gs.level
                        , status = Playing } }, Cmd.none )
    Exit ->
      ( { model | gs = { level = model.gs.level
                        , status = HomePage} }, Cmd.none )
    Next ->
      ( { model | gs = { level = model.gs.level + 1
                        , status = Playing } }, Cmd.none)
    DragDropMsg msg_ ->
      let
        ( model_, result ) =
            DragDrop.update msg_ model.dragDrop
      in
        ( { model
            | dragDrop = model_
            , gs = { status = 
                      if model.gs.status == Won then
                          model.gs.status
                      else
                          Won
                      , level = model.gs.level}
          }
        , Cmd.none
        )


-- SUB
subscriptions : Model -> Sub Msg
subscriptions model=
  Sub.none


-- VIEW
view : Model -> Html Msg
view model =
  case model.gs.status of
    HomePage ->
      viewHomePage
    Playing ->
      viewPlayArea model.gs.level
    Won ->
      viewPlayArea model.gs.level


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

menuButton : Msg -> String -> Html Msg
menuButton clickMsg content =
  div
    [ class "menu-button"
    , onClick clickMsg
    ]
    [ text content ]


-- PlayArea View
viewPlayArea : Int -> Html Msg
viewPlayArea level = 
  div [ class "background" ]
      [ puzzleArea level
      , gridArea level
      , menuButton Exit "EXIT" ]

puzzleArea : Int -> Html Msg
puzzleArea level = 
  let
    puzzles = 
      case level of
        1 ->
          [ img (src "assets/puzzles/one.png" :: width 120 :: DragDrop.draggable DragDropMsg 1) [] ]

        2 ->
          [ img (src "assets/puzzles/seven.png" :: width 120 :: DragDrop.draggable DragDropMsg 1) []
          , img (src "assets/puzzles/seven.png" :: width 120 :: DragDrop.draggable DragDropMsg 2) [] ]

        _ ->
          [ ]
  in
  div ([ class "puzzleArea" ]
      ++ DragDrop.droppable DragDropMsg Left
      )
      puzzles

gridArea : Int -> Html Msg
gridArea level = 
  let
    ( width_, height_ ) =
      case level of
          1 -> (1, 3)
          2 -> (4, 3)
          _ -> (0, 0)
  in
  toIndexed2dList width_ height_
    |> List.map 
        (List.map
                  (\a ->
                      square a
                  )
        )
    |> List.map (div [ class "grid-column" ])
    |> container

square : Int -> Html Msg
square a = 
  div ([ class "square" ]
      ++ DragDrop.droppable DragDropMsg Right
      )
        [ ]

container : List (Html Msg) -> Html Msg
container =
    div [ class "gridArea" ]
        

toIndexed2dList : Int -> Int -> List (List Int)
toIndexed2dList width height =
    List.range 0 height
        |> List.foldl
            (\y result ->
                (Array.repeat (width * height) 1
                    |> Array.slice (width * y) (width * y + width)
                    |> Array.toList
                )
                    :: result
            )
            []

