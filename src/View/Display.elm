module View.Display exposing (..)

import Html exposing (div)
import Html.Attributes exposing (style)

--Colors
gray = "#C4C4C4"
lightGray = "#CCCCCC"
red =  "#E65A5A"
blackString = "#000000"
black = blackString
white = "#ffffff"
text = "#545454"

--Display
background = 
    div [ style "overflow" "auto"
      , style "height" "100vh"
      , style "display" "flex"
      , style "justify-content" "center"
      , style "align-items" "center"
      , style "background-color" lightGray
      ]

menu = 
    div [ style "width" "300px"
            , style "height" "300px"
            , style "display" "flex"
            , style "flex-direction" "column"
            , style "align-items" "center"
            , style "background-color" gray
            , style "border-radius" "10px" ]

button =
    div
        [ style "width" "200px"
        , style "height" "50px"
        , style "font-size" "24px"
        , style "font-family" "Chalkduster"
        , style "background-color" white
        , style "margin" "10px"
        , style "cursor" "pointer"
        , style "border-radius" "10px"
        , style "line-height" "50px"
        ]