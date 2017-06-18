port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Keyboard


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Letter =
    String


type alias MP3Name =
    String


type alias KeyCode =
    Keyboard.KeyCode


type MaybeDrum
    = Drum KeyCode Letter MP3Name
    | NotADrum


type alias Model =
    List MaybeDrum


port playMp3 : String -> Cmd msg


initialModel : List MaybeDrum
initialModel =
    []


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


type Msg
    = KeyDown Keyboard.KeyCode
    | KeyUp Keyboard.KeyCode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyDown keyCode ->
            case (drumForKeyCode keyCode) of
                NotADrum ->
                    ( model, Cmd.none )

                Drum keyCode letter mp3Name ->
                    if keyAlreadyPressed keyCode model then
                        ( model, Cmd.none )
                    else
                        ( drumActivated model keyCode, playMp3 mp3Name )

        KeyUp keyCode ->
            case (drumForKeyCode keyCode) of
                NotADrum ->
                    ( model, Cmd.none )

                Drum keyCode letter mp3Name ->
                    if keyAlreadyPressed keyCode model then
                        ( drumDeactivated model keyCode, Cmd.none )
                    else
                        ( model, Cmd.none )


keyAlreadyPressed : Keyboard.KeyCode -> Model -> Bool
keyAlreadyPressed keyCode model =
    let
        modelKeyCodes =
            keyCodesIn model
    in
        List.member keyCode modelKeyCodes


keyCodesIn : List MaybeDrum -> List Keyboard.KeyCode
keyCodesIn model =
    List.map getDrumKeyCode model


getDrumKeyCode : MaybeDrum -> Keyboard.KeyCode
getDrumKeyCode drum =
    case drum of
        NotADrum ->
            0

        Drum keyCode letter mp3Name ->
            keyCode


drumActivated : List MaybeDrum -> Keyboard.KeyCode -> List MaybeDrum
drumActivated model keyCode =
    let
        drum =
            drumForKeyCode keyCode
    in
        case drum of
            NotADrum ->
                model

            Drum keyCode letter mp3Name ->
                model ++ [ drum ]


drumDeactivated : List MaybeDrum -> Keyboard.KeyCode -> List MaybeDrum
drumDeactivated model keyCode =
    List.filter (\d -> doesNotMatch d keyCode) model


doesNotMatch : MaybeDrum -> Keyboard.KeyCode -> Bool
doesNotMatch drum targetKeyCode =
    case drum of
        NotADrum ->
            False

        Drum keyCode letter mp3Name ->
            targetKeyCode /= keyCode


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyDown
        , Keyboard.ups KeyUp
        ]


drumForKeyCode : Keyboard.KeyCode -> MaybeDrum
drumForKeyCode keyCode =
    case keyCode of
        65 ->
            Drum 65 "A" "clap"

        83 ->
            Drum 83 "S" "hihat"

        68 ->
            Drum 68 "D" "kick"

        70 ->
            Drum 70 "F" "openhat"

        71 ->
            Drum 71 "G" "boom"

        72 ->
            Drum 72 "H" "ride"

        74 ->
            Drum 74 "J" "snare"

        75 ->
            Drum 75 "K" "tom"

        76 ->
            Drum 76 "L" "tink"

        _ ->
            NotADrum


view : Model -> Html Msg
view model =
    let
        drumNumbers =
            keyCodesIn model
    in
        div [ class "keys" ]
            [ drumBox (drumForKeyCode 65) drumNumbers
            , drumBox (drumForKeyCode 83) drumNumbers
            , drumBox (drumForKeyCode 68) drumNumbers
            , drumBox (drumForKeyCode 70) drumNumbers
            , drumBox (drumForKeyCode 71) drumNumbers
            , drumBox (drumForKeyCode 72) drumNumbers
            , drumBox (drumForKeyCode 74) drumNumbers
            , drumBox (drumForKeyCode 75) drumNumbers
            , drumBox (drumForKeyCode 76) drumNumbers
            ]


drumBox : MaybeDrum -> List Keyboard.KeyCode -> Html msg
drumBox drum drumNumbers =
    case drum of
        NotADrum ->
            span [] []

        Drum keyCode letter mp3Name ->
            div [ classList [ ( "key", True ), ( "playing", List.member keyCode drumNumbers ) ], dataKey keyCode ]
                [ kbd []
                    [ text letter ]
                , span [ class "sound" ]
                    [ text mp3Name ]
                ]


dataKey : Int -> Attribute msg
dataKey key =
    attribute "data-key" (toString key)
