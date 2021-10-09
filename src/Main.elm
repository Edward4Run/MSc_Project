module Main exposing (main)

import Browser
import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Page.Home exposing (Model)

-- MAIN
main = 
    Browser.sandbox
      { init = init
      , view = view
      , update = update
      }

-- MODEL

type alias Model = Int


-- INIT

init : Model
init =
  0


-- UPDATE

type Msg
    = Increment
    | Decrement

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1


-- VIEW

view : Model -> Html Msg
view model =
  div [ class "container" ]
    [ div []
      []
    , div [ class ""]
      [ button [ class "play-button", onClick Decrement ]
    [ text "PLAY" ] ]
    , div []
      [ button [ class "options-button", onClick Decrement ]
    [ text "OPTIONS" ]]
    , div []
      [ button [ class "collection-button", onClick Increment ]
    [ text "COLLECTION" ]]
    , div []
      [ button [ class "exit-button", onClick Decrement ]
    [ text "EXIT" ]]
    
    
    
    
    ]