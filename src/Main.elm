module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, span, text, img)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import View.Display as Display
import View.Puzzles as Puzzles
import Page exposing (GameState(..))

-- MAIN
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


-- MODEL
type alias Model =
  { level : Int
  , state : GameState
  }

-- INIT

init : () -> ( Model, Cmd Msg )
init _ = ( { level = 1, state = NotPlaying}, Cmd.none )


-- UPDATE

type Msg
    = Play
    | Exit

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Play ->
      ( { model | state = Playing }, Cmd.none )
    Exit ->
      ( { model | state = Won }, Cmd.none )


-- SUB


-- VIEW
button : Msg -> String -> Html Msg
button clickMsg content =
    div
        [ style "width" "200px"
        , style "height" "50px"
        , style "font-size" "24px"
        , style "font-family" "Chalkduster"
        , style "background-color" Display.white
        , style "margin" "10px"
        , style "cursor" "pointer"
        , style "border-radius" "10px"
        , style "line-height" "50px"
        , onClick clickMsg
        ]
        [ text content ]


buttons : List (Html Msg) -> Html Msg
buttons =
    div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "align-items" "center"
        , style "text-align" "center"
        ]

spanMarginRight : Html Msg -> Html Msg
spanMarginRight child =
    span [ style "margin-bottom" "20px" ] [ child ]


view : Model -> Html Msg
view model =
  case model.state of
    NotPlaying ->
      div [ style "overflow" "auto"
          , style "height" "100vh"
          , style "display" "flex"
          , style "flex-direction" "column"
          , style "align-items" "center"
          , style "background-color" Display.background
          ]
          [ div [ style "width" "300px"
                , style "height" "400px"
                , style "margin-top" "200px"
                , style "display" "flex"
                , style "flex-direction" "column"
                , style "align-items" "center"
                , style "background-color" Display.lightGray ]
            [ h1 [ style "text-align" "center"
                  , style "font-family" "Marker Felt" ]
                  [ text "Tangram" ]
            , buttons [ button Play "PLAY"
                      , button Exit "EXIT" ]]
          ]
    Playing ->
      div [ style "overflow" "auto"
          , style "height" "100vh"
          , style "display" "flex"
          , style "justify-content" "center"
          , style "align-items" "center"
          , style "background-color" Display.background
          ]
          [puzzleArea
          , gridArea
          , puzzleArea]
    Won ->
      text "You Won!"

puzzleArea : Html Msg
puzzleArea = 
  div [ style "width" "500px"
      , style "height" "500px"
      , style "border" "1px solid black"
      , style "display" "flex"
      , style "justify-content" "center"
      , style "align-items" "center"]
      [ Puzzles.seven ]

gridArea : Html Msg
gridArea = 
  div [ style "width" "500px"
      , style "height" "500px"
      , style "border" "1px solid black"]
      []