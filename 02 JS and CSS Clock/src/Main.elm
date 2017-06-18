module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Time exposing (Time, second)


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    Time


type Msg
    = Tick Time


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( newTime, Cmd.none )


view : Model -> Html Msg
view model =
    let
        secondAngle =
            toDegree model 60

        minuteAngle =
            toDegree model 3600

        hourAngle =
            toDegree model 86400
    in
        div [ class "clock" ]
            [ div [ class "clock-face" ]
                [ div [ class "hand hour-hand", rotate hourAngle ]
                    []
                , div [ class "hand min-hand", rotate minuteAngle ]
                    []
                , div [ class "hand second-hand", rotate secondAngle ]
                    []
                ]
            ]


toDegree : Time -> Int -> Float
toDegree model secondsPerUnit =
    (toFloat (round (Time.inSeconds model) % secondsPerUnit)) / (toFloat secondsPerUnit) * 360 + 90


rotate : Float -> Html.Attribute msg
rotate angle =
    style
        [ ( "transform", "rotate(" ++ (toString angle) ++ "deg)" ) ]
