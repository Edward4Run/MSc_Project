module View.Puzzles exposing (..)

import Css
import Html.Styled exposing (Html)
import Svg.Styled as Svg exposing (circle, ellipse, line, svg, rect)
import Svg.Styled.Attributes exposing (..)

arrowUp : Html msg
arrowUp =
    svg
        [ width "42"
        , height "42"
        , viewBox "0 0 42 24"
        , fill "none"
        , Svg.Styled.Attributes.style "stroke: currentColor;"
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
        [ width "120"
        , height "120"
        , viewBox "0 0 120 120"
        ]
        [ rect
            [ x "10"
            , y "10"
            , width "100"
            , height "100"
            , rx "15"
            , ry "15"
            ]
            []
        ]