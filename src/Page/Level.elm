module Page.Level exposing (..)

import Browser

-- MODEL
type alias Model = Int

-- UPDATE
type Msg
    = ClickedTag

update : Msg -> Model -> Model
update msg model =
    case msg of
        ClickedTag ->
            model + 1