module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, text, span)
import Html.Attributes exposing (src, width, class, style)
import Html.Events exposing (onClick)
import Svg as S
import Svg.Attributes as SA
import Html5.DragDrop as DragDrop
import Array exposing (Array)
import View.Puzzles as Puzzles
import Debug exposing (toString, log)


-- MAIN
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL
type alias Model =
  { gs : GameState
  , dragDrop : DragDrop.Model Int Puzzles.Position
  }

type alias GameState =
    { level : Int
    , status : Status
    , puzzles : List Puzzle
    }

type Status
    = HomePage
    | Playing
    | Won

type alias Puzzle =
  { id : Int
  , image : ImageType
  , imageRotation : Int
  , shape : Shape
  , position : Puzzles.Position
  }

type ImageType
  = One
  | Seven
  | Four
  | FourInLine
  | Six

type alias Shape =
  { right : Int
  , left : Int
  , up : Int
  , down : Int
  }


-- INIT

init : () -> ( Model, Cmd Msg )
init _ = ( { gs = { level = 2
                  , status = HomePage
                  , puzzles = puzzlesinitial }
            , dragDrop = DragDrop.init}
          , Cmd.none )

puzzlesinitial : List Puzzle
puzzlesinitial =
  [{ id = 1
  , image = One
  , imageRotation = 0
  , shape = { right = 1, left = 0, up = 0, down = 2 }
  , position = { x = -1, y = -1 }}
  , { id = 2
  , image = Seven
  , imageRotation = 0
  , shape = { right = 1, left = 0, up = 0, down = 2 }
  , position = { x = -1, y = -1 }}]


-- UPDATE
type Msg 
  = Play
  | Exit
  | Next
  | DragDropMsg (DragDrop.Msg Int Puzzles.Position)
  | RotateImage Int

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Play ->
      ( { model | gs = { level = model.gs.level
                        , status = Playing
                        , puzzles = model.gs.puzzles } }, Cmd.none )
    Exit ->
      ( { model | gs = { level = model.gs.level
                        , status = HomePage
                        , puzzles = model.gs.puzzles } }, Cmd.none )
    Next ->
      ( { model | gs = { level = model.gs.level + 1
                        , status = Playing
                        , puzzles = model.gs.puzzles } }, Cmd.none)
    RotateImage msg_ ->
      ( { model | gs = { level = model.gs.level
                        , status = Playing
                        , puzzles = model.gs.puzzles } }, Cmd.none)
    DragDropMsg msg_ ->
      let
        ( model_, result ) =
            DragDrop.update msg_ model.dragDrop
      in 
        log (toString msg_) ( { model
            | dragDrop = model_
            , gs = { status = 
                      if model.gs.status == Won then
                          model.gs.status
                      else
                          Won
                      , level = model.gs.level
                      , puzzles = model.gs.puzzles }
          }
        , Cmd.none
        )


-- SUB
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW
view : Model -> Html Msg
view model =
  case model.gs.status of
    HomePage ->
      viewHomePage
    Playing ->
      viewPlayArea model
    Won ->
      viewPlayArea model


-- Homepage View
viewHomePage : Html Msg
viewHomePage = 
  div [ class "background" ]
      [ div [ class "menu" ]
            [ h1 [ class "title" ] [ text "Tangram" ]
            , div [ class "buttons" ]
                  [ menuButton Play "PLAY"
                  , menuButton Exit "EXIT" ] ]
      ]



-- PlayArea View
viewPlayArea : Model -> Html Msg
viewPlayArea model = 
  div [ class "background" ]
      [ puzzleArea model.gs
      , gridArea model.gs.level ]

-- haven't finished
puzzleArea : GameState -> Html Msg
puzzleArea gs =
  div ([ class "puzzleArea" ]
      ++ DragDrop.droppable DragDropMsg {x=-1, y=-1}
      )
      (List.map viewPuzzle gs.puzzles)

gridArea : Int -> Html Msg
gridArea level = 
  let
    ( width_, height_ ) =
      case level of
          1 -> (1, 3)
          2 -> (2, 4)
          _ -> (0, 0)
  in
  div [ class "gridArea" ]
      [ toIndexed2dList width_ height_
          |> List.map 
              (List.map
                        (\(a, b) ->
                            square (a, b)
                        )
              )
          |> List.map (div [ ])
          |> container
      ]

square : (Int, Int) -> Html Msg
square (a, b) =
  span ([ class "square" ]
      ++ DragDrop.droppable DragDropMsg {x=a, y=b}
      )
        [ text ("(" ++ String.fromInt(a) ++ ", " ++ String.fromInt(b) ++ ")") ]

nonBreakingSpace : String
nonBreakingSpace =
    Char.fromCode 160 |> String.fromChar


container : List (Html Msg) -> Html Msg
container =
  div [ ]

toIndexed2dList : Int -> Int -> List (List (Int,Int))
toIndexed2dList width height =
    List.range 0 height
        |> List.foldr
            (\y result ->
                (Array.initialize (width * height) (\n -> (n // width, remainderBy width n))
                    |> Array.slice (width * y) (width * y + width)
                    |> Array.toList
                )
                    :: result
            )
            []

-- BUTTONS
menuButton : Msg -> String -> Html Msg
menuButton clickMsg content =
  div
    [ class "menu-button"
    , onClick clickMsg
    ]
    [ text content ]


--PUZZLES
viewPuzzle : Puzzle -> Html Msg
viewPuzzle puzzle =
    S.svg
        ([ SA.width "120"
        , SA.height "120"
        , SA.viewBox "0 0 80 120"
        , SA.style "stroke: currentColor;"
        , style "transition" "transform 0.5s"
        , style "transform" ("rotate(" ++ String.fromInt puzzle.imageRotation ++ "deg)")
        , onClick (RotateImage puzzle.id) ]
        ++ DragDrop.draggable DragDropMsg 1 )
        (case puzzle.image of
          One ->
            [ S.rect [ SA.x "0", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "80", SA.y "0", SA.width "40", SA.height "40" ] []
            ]
          Seven ->
            [ S.rect [ SA.x "0", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "0", SA.y "40", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "0", SA.y "80", SA.width "40", SA.height "40" ] []
            ]
          Four ->
            [ S.rect [ SA.x "0", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "0", SA.y "40", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "40", SA.width "40", SA.height "40" ] []
            ]
          FourInLine ->
            [ S.rect [ SA.x "0", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "80", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "120", SA.y "0", SA.width "40", SA.height "40" ] []
            ]
          Six ->
            [ S.rect [ SA.x "0", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "0", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "0", SA.y "40", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "40", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "0", SA.y "80", SA.width "40", SA.height "40" ] []
            , S.rect [ SA.x "40", SA.y "80", SA.width "40", SA.height "40" ] []
            ]
        )