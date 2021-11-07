port module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, text, img, p)
import Html.Attributes exposing (src, width, class)
import Html.Events exposing (onClick)
import Html5.DragDrop as DragDrop
import Json.Decode exposing (Value)
import Array exposing (Array)

port dragstart : Value -> Cmd msg


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
    , isCompleted : Bool
    }

type Status
    = HomePage
    | Playing
    | Won

type alias Puzzle =
  { img : String
  , position : Position
  }

type Position
  = Left
  | Right

type alias Gridfield =
    { width : Int
    , height : Int
    }


-- INIT

init : () -> ( Model, Cmd Msg )
init _ = ( { gs = { level = 1
                  , status = HomePage
                  , isCompleted = False }
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
                        , isCompleted = False
                        , status = Playing } }, Cmd.none )
    Exit ->
      ( { model | gs = { level = model.gs.level
                        , isCompleted = model.gs.isCompleted
                        , status = HomePage} }, Cmd.none )
    Next ->
      ( { model | gs = { level = model.gs.level + 1
                        , isCompleted = model.gs.isCompleted
                        , status = Playing } }, Cmd.none)
    DragDropMsg msg_ ->
      let
        ( model_, result ) =
            DragDrop.update msg_ model.dragDrop
      in
        ( { model
            | dragDrop = model_
            , gs = { isCompleted = False
                    , status = 
                      if model.gs.isCompleted == False then
                          model.gs.status
                      else
                          Won 
                      , level = model.gs.level}
          }
        , DragDrop.getDragstartEvent msg_
            |> Maybe.map (.event >> dragstart)
            |> Maybe.withDefault Cmd.none
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
      viewHomePage model
    Playing ->
      viewPlayArea model
    Won ->
      viewPlayArea model


-- Homepage View
viewHomePage : Model -> Html Msg
viewHomePage model = 
  div [ class "background" ]
      [ div [ class "menu" ]
            [ h1 [ class "title" ] [ text "Tangram" ]
            , buttons [ button Play "PLAY"
                      , button Exit "EXIT" ]]
      ]

button : Msg -> String -> Html Msg
button clickMsg content =
  div
    [ class "button"
    , onClick clickMsg
    ]
    [ text content ]

buttons : List (Html Msg) -> Html Msg
buttons =
  div
    [ class "buttons" ]


-- PlayArea View
viewPlayArea : Model -> Html Msg
viewPlayArea model = 
  div [ class "background" ]
      [ puzzleArea model
      , gridArea model
      , button Exit "EXIT"]

puzzleArea : Model -> Html Msg
puzzleArea model = 
  div ([ class "puzzleArea" ]
      ++ (if model.data.position /= Left then
                    DragDrop.droppable DragDropMsg Left

          else
              []
          )
      )
      (if model.data.position == Left then
        [ img (src "assets/puzzles/one.png" :: width 120 :: DragDrop.draggable DragDropMsg 1) [] ]

      else
          []
      )

gridArea : Model -> Html Msg
gridArea model = 
  div ([ class "gridArea" ]
      ++ (if model.data.position /= Right then
            DragDrop.droppable DragDropMsg Right

          else
              []
          )
      )
      [ div [ class "grid-container" ]
          (if model.data.position == Right then
            [ img (src "assets/puzzles/one.png" :: width 120 :: DragDrop.draggable DragDropMsg 1) [] ]

          else
            [ div [ class "grid" ] []
            , div [ class "grid" ] []
            , div [ class "grid" ] [] ]
          )
      ]

puzzleinit : Int -> Html Msg
puzzleinit level = 
  case level of
    1 ->
      img (src "assets/puzzles/one.png" :: width 120 :: DragDrop.draggable DragDropMsg 1) []

    2 ->
      img (src "assets/puzzles/one.png" :: width 120 :: DragDrop.draggable DragDropMsg 1) []

    _ ->
      img [] []

grids : Int -> Html Msg
grids level = 
  case level of
    1 ->
      div []
          [ div [ class "grid" ] []
          , div [ class "grid" ] []
          , div [ class "grid" ] [] ]
                
    2 ->
      div []
          [ div [ class "grid" ] []
          , div [ class "grid" ] []
          , div [ class "grid" ] [] ]

    _ ->
      div [] []

