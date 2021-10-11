module Main exposing (main)

import Browser
import Html.Styled exposing (Html, a, div, h1, span, text)
import Html.Styled.Attributes as HA exposing (css, href)
import Html.Styled.Events exposing (onClick)
import Css exposing (..)
import View.Colors as Colors
import Style
import Html exposing (option)

-- MAIN
main =
    Browser.element
        { init = init
        , view = view >> Html.Styled.toUnstyled
        , update = update
        , subscriptions = always Sub.none
        }

-- MODEL
type alias Model =
  { level: Int 
  }


-- INIT

init : () -> ( Model, Cmd Msg )
init _ = ( { level = 1 }, Cmd.none )


-- UPDATE

type Msg
    = Play
    | Options
    | Collection
    | Exit

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Play ->
      ( { model | level = model.level + 1 }, Cmd.none )

    Options ->
      ( { model | level = model.level + 1 }, Cmd.none )

    Collection ->
      ( { model | level = model.level + 1 }, Cmd.none )

    Exit ->
      ( { model | level = model.level + 1 }, Cmd.none )



-- VIEW
button : Msg -> String -> Html Msg
button clickMsg content =
    span
        [ css
            [ fontWeight bold
            , fontSize (px 24)
            , Style.sansFont
            , color Colors.text
            , cursor pointer
            ]
        , onClick clickMsg
        ]
        [ text content ]

lightButton : Msg -> String -> Html Msg
lightButton clickMsg content =
    span
        [ css
            [ fontWeight bold
            , fontSize (px 24)
            , Style.sansFont
            , color Colors.white
            , cursor pointer
            ]
        , onClick clickMsg
        ]
        [ text content ]

buttons : List (Html Msg) -> Html Msg
buttons =
    div
        [ css
            [ position absolute
            , bottom (px 500)
            , left (px 0)
            , right (px 0)
            , textAlign center
            ]
        ]

spanMarginRight : Html Msg -> Html Msg
spanMarginRight child =
    span [ css [ marginRight (px 20) ] ] [ child ]

view : Model -> Html Msg
view model =
  div [ css
            [ backgroundColor Colors.gray
            , height (pct 100)
            , overflow auto
            , displayFlex
            , flexDirection column
            , alignItems center
            ]
        ]
    [ div []
      [ h1 [ ] [ text "Tangram" ] ]
    , buttons [ spanMarginRight (button Play "PLAY")
              , spanMarginRight (button Options "OPTIONS")
              , spanMarginRight (button Collection "COLLECTION")
              , spanMarginRight (button Exit "EXIT") ]
    ]