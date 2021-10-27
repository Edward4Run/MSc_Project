module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import View.Display as Display
import View.Puzzles as Puzzles
import Page exposing (GameState(..))
import Draggable
import Svg exposing (circle, ellipse, line, svg, rect)
import Svg.Attributes as SA exposing (width, height, viewBox, x, y)
import Svg.Events exposing (onMouseUp)

-- MAIN
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Position =
    { x : Float
    , y : Float
    }

-- MODEL
type alias Model =
  { level : Int
  , state : GameState
  , xy : Position
  , drag : Draggable.State ()
  }

-- INIT

init : () -> ( Model, Cmd Msg )
init _ = ( { level = 1, state = HomePage, xy = Position 32 32, drag = Draggable.init}, Cmd.none )

dragConfig : Draggable.Config () Msg
dragConfig =
    Draggable.basicConfig OnDragBy

-- UPDATE
type Msg
    = Play
    | Exit
    | OnDragBy Draggable.Delta
    | DragMsg (Draggable.Msg ())

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Play ->
      ( { model | state = Playing }, Cmd.none )
    Exit ->
      ( { model | state = Won }, Cmd.none )
    OnDragBy ( dx, dy ) ->
            ( { model | xy = Position (model.xy.x + dx) (model.xy.y + dy) }
            , Cmd.none
            )
    DragMsg dragMsg ->
        Draggable.update dragConfig dragMsg model


-- SUB
subscriptions : Model -> Sub Msg
subscriptions { drag } =
    Draggable.subscriptions DragMsg drag

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
        , gridArea]

puzzleArea : Model -> Html Msg
puzzleArea model = 
  div [ style "width" "500px"
      , style "height" "500px"
      , style "border" "1px solid black"
      , style "display" "flex"
      , style "justify-content" "center"
      , style "align-items" "center" ]
      [ seven model ]

gridArea : Html Msg
gridArea = 
  div [ style "width" "500px"
      , style "height" "500px"
      , style "border" "1px solid black"
      , style "display" "flex"
      , style "justify-content" "center"
      , style "align-items" "center" ]
      [ div [ style "width" "40px"
            , style "height" "40px"
            , style "background" Display.gray
            , style "border" "1px solid black" ] []
      , div [ style "width" "40px"
            , style "height" "40px"
            , style "background" Display.gray
            , style "border" "1px solid black" ] []
      , div [ style "width" "40px"
            , style "height" "40px"
            , style "background" Display.gray
            , style "border" "1px solid black" ] [] ]

seven : Model -> Html Msg
seven model = 
  let
    translate =
        "translate(" ++ String.fromFloat model.xy.x ++ "px, " ++ String.fromFloat model.xy.y ++ "px)"
  in
  svg
    [ style "transform" translate
    , width "120"
    , height "40"
    , viewBox "0 0 120 40"
    , style "stroke" "currentColor"
    , style "cursor" "move"
    , Draggable.mouseTrigger () DragMsg
    ]
    [ rect [ x "0", y "0", width "40", height "40" ] []
    , rect [ x "40", y "0", width "40", height "40" ] []
    , rect [ x "80", y "0", width "40", height "40" ] []
    ]