port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


initialModel : Model
initialModel =
    { spacing = "10"
    , blur = "10"
    , colour = "#ffc600"
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


port spacing : String -> Cmd msg


port blur : String -> Cmd msg


port colour : String -> Cmd msg


type alias Model =
    { spacing : String
    , blur : String
    , colour : String
    }


type Msg
    = Spacing String
    | Blur String
    | Colour String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Spacing value ->
            ( { model | spacing = value }, spacing (value ++ "px") )

        Blur value ->
            ( { model | blur = value }, blur (value ++ "px") )

        Colour value ->
            ( { model | colour = value }, colour value )


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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


maxValue : String -> Html.Attribute msg
maxValue value =
    Html.Attributes.max value


minValue : String -> Html.Attribute msg
minValue value =
    Html.Attributes.min value
