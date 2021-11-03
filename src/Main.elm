port module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, text, img)
import Html.Attributes exposing (style, src, width)
import Html.Events exposing (onClick)
import View.Display as Display
import View.Puzzles as Puzzles
import Page exposing (GameState(..))
import Html5.DragDrop as DragDrop
import Json.Decode exposing (Value)
import Svg.Attributes exposing (result)

port dragstart : Value -> Cmd msg

-- MAIN
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type Position
    = Left
    | Right

-- MODEL
type alias Model =
  { level : Int
  , state : GameState
  , data : { count : Int, position : Position }
  , dragDrop : DragDrop.Model Int Position
  }

-- INIT

init : () -> ( Model, Cmd Msg )
init _ = ( { level = 1, state = HomePage, data = { count = 0, position = Left} , dragDrop = DragDrop.init}, Cmd.none )

-- UPDATE
type Msg
    = Play
    | Exit
    | DragDropMsg (DragDrop.Msg Int Position)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Play ->
      ( { model | state = Playing }, Cmd.none )
    Exit ->
      ( { model | state = Won }, Cmd.none )
    DragDropMsg msg_ ->
            let
                ( model_, result ) =
                    DragDrop.update msg_ model.dragDrop
            in
            ( { model
                | dragDrop = model_
                , data =
                    case result of
                        Nothing ->
                            model.data

                        Just ( count, position, _ ) ->
                            { count = count + 1, position = position }
                , state = 
                    case model.data.position of
                        Left ->
                          model.state
                        Right ->
                          Won
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
  case model.state of
    HomePage ->
      viewHomePage model
    Playing ->
      viewPlayArea model
    Won ->
      text "You Won!"

viewHomePage : Model -> Html Msg
viewHomePage model = 
  Display.background
      [ Display.menu
        [ h1 [ style "text-align" "center"
              , style "font-family" "Marker Felt" ]
              [ text "Tangram" ]
        , buttons [ button Play "PLAY"
                  , button Exit "EXIT" ]]
      ]

button : Msg -> String -> Html Msg
button clickMsg content =
    div
        [ style "width" "200px"
        , style "height" "50px"
        , style "font-size" "24px"
        , style "font-family" "Chalkduster"
        , style "background-color" Display.white
        , style "margin-top" "30px"
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

viewPlayArea : Model -> Html Msg
viewPlayArea model = 
  Display.background
        [ puzzleArea model
        , gridArea model ]

puzzleArea : Model -> Html Msg
puzzleArea model = 
  div ([ style "width" "500px"
      , style "height" "500px"
      , style "border" "1px solid black"
      , style "display" "flex"
      , style "justify-content" "space-around"
      , style "align-items" "center"
      , style "margin" "20px" ]
      ++ (if model.data.position /= Left then
                    DragDrop.droppable DragDropMsg Left

                else
                    []
               )
      )
      (if model.data.position == Left then
        [ img (src "assets/puzzles/one.png" :: width 120 :: DragDrop.draggable DragDropMsg 1) []
        ]

      else
          [
          ]
      )

gridArea : Model -> Html Msg
gridArea model = 
  div [ style "width" "500px"
      , style "height" "500px"
      , style "border" "1px solid black"
      , style "display" "flex"
      , style "justify-content" "center"
      , style "align-items" "center" ]
      [ div ([ style "display" "flex"
              , style "justify-content" "center"
              , style "align-items" "center"]
              ++ (if model.data.position /= Right then
                    DragDrop.droppable DragDropMsg Right

                else
                    []
               )
            )
            (if model.data.position == Right then
              [ img (src "assets/puzzles/one.png" :: width 120 :: DragDrop.draggable DragDropMsg 1) []
              ]

            else
                [ div [ style "width" "40px"
                      , style "height" "40px"
                      , style "background" Display.gray
                      , style "border-style" "solid"
                      , style "border-width" "1px 0 1px 1px" ] []
                , div [ style "width" "40px"
                      , style "height" "40px"
                      , style "background" Display.gray
                      , style "border-style" "solid"
                      , style "border-width" "1px 0 1px 1px" ] []
                , div [ style "width" "40px"
                      , style "height" "40px"
                      , style "background" Display.gray
                      , style "border-style" "solid"
                      , style "border-width" "1px 1px 1px 1px" ] [] 
                ]
            )
      ]
      