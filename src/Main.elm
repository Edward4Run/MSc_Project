port module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, span, text, img)
import Html.Attributes as HA exposing (..)
import Html.Events exposing (onClick)
import View.Colors as Colors
import View.Puzzles as Puzzles
import Html5.DragDrop as DragDrop
import Page exposing (GameState(..))
import Json.Decode exposing (Value)

-- MAIN
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }

port dragstart : Value -> Cmd msg

type Position
    = Up
    | Middle
    | Down

-- MODEL
type alias Model =
  { level : Int
  , state : GameState
  , data : { count : Int, position : Position }
  , dragDrop : DragDrop.Model Int Position
  }

-- INIT

init : () -> ( Model, Cmd Msg )
init _ = ( { level = 1, state = NotPlaying, data = { count = 0, position = Up }, dragDrop = DragDrop.init }, Cmd.none )


-- UPDATE

type Msg
    = Play
{-    | Options
    | Collection -}
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
        }
      , DragDrop.getDragstartEvent msg_
          |> Maybe.map (.event >> dragstart)
          |> Maybe.withDefault Cmd.none
      )



-- VIEW
button : Msg -> String -> Html Msg
button clickMsg content =
    span
        [ onClick clickMsg
        ]
        [ text content ]

lightButton : Msg -> String -> Html Msg
lightButton clickMsg content =
    span
        [ onClick clickMsg
        ]
        [ text content ]

buttons : List (Html Msg) -> Html Msg
buttons =
    div
        [ 
        ]

spanMarginRight : Html Msg -> Html Msg
spanMarginRight child =
    span [ ] [ child ]

gridContainer : Html none
gridContainer =
    div [ class "grid-container"
        ]
    [ gridRow
        ]


gridRow : Html none
gridRow =
    div [ class "grid-row" ]
        [ div [ class "grid-cell" ]
            [ h1 [ ] [text "test"] ]
        ]

divStyle =
    [ style "border" "1px solid black"
    , style "padding" "50px"
    , style "text-align" "center"
    ]

view : Model -> Html Msg
view model =
  case model.state of
    NotPlaying ->
      div [ 
          ]
      [ div []
        [ h1 [ ] [ text "Tangram" ] ]
      , buttons [ spanMarginRight (button Play "PLAY")
                , spanMarginRight (button Exit "EXIT") ]
      ]
    Playing ->
      let
        dropId =
            DragDrop.getDropId model.dragDrop

        position =
            DragDrop.getDroppablePosition model.dragDrop
      in
      div []
          [ viewDiv Up model.data dropId position
          , viewDiv Middle model.data dropId position
          , viewDiv Down model.data dropId position
          ]
    Won ->
      text "You Won!"

viewDiv position data dropId droppablePosition =
    let
        highlight =
            if dropId |> Maybe.map ((==) position) |> Maybe.withDefault False then
                case droppablePosition of
                    Nothing ->
                        []

                    Just pos ->
                        if pos.y < pos.height // 2 then
                            [ style "background-color" "cyan" ]

                        else
                            [ style "background-color" "magenta" ]

            else
                []
    in
    div
        (divStyle
            ++ highlight
            ++ (if data.position /= position then
                    DragDrop.droppable DragDropMsg position

                else
                    []
               )
        )
        (if data.position == position then
            [ img (src "assets/四方.png" :: width 100 :: DragDrop.draggable DragDropMsg data.count) []
            , text (String.fromInt data.count)
            ]

         else
            []
        )
    