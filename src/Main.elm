module Main exposing (main)

import Browser
import Html exposing (Html, div, button)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (onClick)
import Svg.Button exposing (Button, Colors, Content(..))
import Grid exposing (..)

-- MAIN
main = 
    Browser.element 
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }

-- CONSTANTS
gridSize = Size 40 20
cellSize = Size 20 20

-- MODEL
type Model
  = Failure
  | Loading
  | Success String

init : () -> (Model, Cmd Msg)
init _ =
  ( Loading
  , Cmd.none
  )

type Operation
    = Increment
    | Decrement

-- UPDATE
type Msg 
    = Play
    | Options
    | Collection
    | Exit
    | ButtonMsg Svg.Button.Msg Operation

update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
  case msg of
    Play ->
      ( model
      , Cmd.none
      )
    Options ->
      ( model
      , Cmd.none
      )
    Collection ->
      ( model
      , Cmd.none
      )
    Exit ->
      ( model
      , Cmd.none
      )
    ButtonMsg m operation ->
        let
            button =
               getButton operation model

            ( isClick, btn, _ ) =
                Svg.Button.update (\bm -> ButtonMsg bm operation)
                    m
                    button
        in
        operate isClick operation mdl

playContent : Svg.Button.Content
playContent =
    Svg.Button.TextContent "PLAY"
    
incrementButton : Svg.Button.Button ()
incrementButton =
    Svg.Button.simpleButton (100, 50) ()

-- SUB
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW
view : Model -> Html Msg
view model =
  svg [ width "100%"
      , height "auto"
      , viewBox ("0 0 " ++ String.fromInt (gridSize.width * cellSize.width) ++ " " ++ String.fromInt (gridSize.height * cellSize.height))
      ]
      [ image
        [ x "300"
        , y "50"
        , width "200"
        , height "300"
        ]
        []
      , svg.button.render
          (x, y)
          playContent
          (\m -> ButtonMsg m Increment)
          incrementButton
      ]
  