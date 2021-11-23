module Puzzles exposing (..)

import Html exposing (Html, Attribute)
import Svg exposing (circle, ellipse, line, svg, rect)
import Svg.Attributes exposing (..)

type alias Puzzle =
  { id : Int
  , image : ImageType
  , rotation : Int
  , shape : Shape
  , position : Position
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

type alias Position =
  { x : Int
  , y : Int
  }