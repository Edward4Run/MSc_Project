module View.Puzzles exposing (..)

import Html exposing (Html)
import Svg exposing (circle, ellipse, line, svg, rect)
import Svg.Attributes exposing (..)
import Svg.Events exposing (onMouseUp)

arrowUp : Html msg
arrowUp =
    svg
        [ width "42"
        , height "42"
        , viewBox "0 0 42 24"
        , fill "none"
        , style "stroke: currentColor;"
        ]
        [ Svg.path
            [ d "M1.84338 22.1964L20.9999 3.03992L40.1563 22.1964"
            , strokeWidth "3"
            ]
            []
        ]

seven : Html msg
seven = 
    svg
        [ width "80"
        , height "120"
        , viewBox "0 0 80 120"
        , style "stroke: currentColor;"
        ]
        [ rect [ x "0", y "0", width "40", height "40" ] []
        , rect [ x "0", y "40", width "40", height "40" ] []
        , rect [ x "0", y "80", width "40", height "40" ] []
        , rect [ x "40", y "0", width "40", height "40" ] []
        ]