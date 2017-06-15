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


type alias Drum =
    { keyCode : Keyboard.KeyCode
    , letter : String
    , mp3Name : String
    }


type alias Model =
    List Drum


port playMp3 : String -> Cmd msg


initialModel : List Drum
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
            if List.member keyCode (keyCodesIn model) then
                ( model, Cmd.none )
            else
                ( drumActivated model (drumForKeyCode keyCode), playMp3 (drumForKeyCode keyCode).mp3Name )

        KeyUp keyCode ->
            if List.member keyCode (keyCodesIn model) then
                ( drumDeactivated model keyCode, Cmd.none )
            else
                ( model, Cmd.none )


keyCodesIn : List Drum -> List Keyboard.KeyCode
keyCodesIn model =
    List.map getDrumKeyCode model


getDrumKeyCode : Drum -> Keyboard.KeyCode
getDrumKeyCode drum =
    drum.keyCode


drumActivated : List Drum -> Drum -> List Drum
drumActivated model drum =
    model ++ [ drum ]


drumDeactivated : List Drum -> Keyboard.KeyCode -> List Drum
drumDeactivated model keyCode =
    List.filter (\el -> el.keyCode /= keyCode) model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyDown
        , Keyboard.ups KeyUp
        ]


drumForKeyCode : Keyboard.KeyCode -> Drum
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
            Debug.crash "Not a real drum dude"


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


drumBox : Drum -> List Keyboard.KeyCode -> Html msg
drumBox drum drumNumbers =
    div [ classList [ ( "key", True ), ( "playing", List.member drum.keyCode drumNumbers ) ], dataKey drum.keyCode ]
        [ kbd []
            [ text drum.letter ]
        , span [ class "sound" ]
            [ text drum.mp3Name ]
        ]


dataKey : Int -> Attribute msg
dataKey key =
    attribute "data-key" (toString key)
