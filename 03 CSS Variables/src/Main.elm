module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }


initialModel : Model
initialModel =
    { spacing = "10"
    , blur = "10"
    , colour = "#ffc600"
    }


type alias Model =
    { spacing : String
    , blur : String
    , colour : String
    }


type Msg
    = Spacing String
    | Blur String
    | Colour String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Spacing value ->
            { model | spacing = value }

        Blur value ->
            { model | blur = value }

        Colour value ->
            { model | colour = value }


view : Model -> Html Msg
view model =
    div [ class "controls" ]
        [ label [ for "spacing" ]
            [ text "Spacing:" ]
        , input [ value model.spacing, onInput Spacing, type_ "range", maxValue "200", minValue "10" ]
            []
        , label [ for "blur" ]
            [ text "Blur:" ]
        , input [ value model.blur, onInput Blur, type_ "range", maxValue "25", minValue "0" ]
            []
        , label [ for "base" ]
            [ text "Base Color" ]
        , input [ value model.colour, onInput Colour, type_ "color" ]
            []
        ]


maxValue : String -> Html.Attribute msg
maxValue value =
    Html.Attributes.max value


minValue : String -> Html.Attribute msg
minValue value =
    Html.Attributes.min value
