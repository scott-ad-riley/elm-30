module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    [ Unchecked "This is an inbox layout."
    , Unchecked "Check one item"
    , Unchecked "Hold down your Shift key"
    , Unchecked "Check a lower item"
    , Unchecked "Everything inbetween should also be set to checked"
    , Unchecked "Try do it with out any libraries"
    , Unchecked "Just regular JavaScript"
    , Unchecked "Good Luck!"
    , Unchecked "Don't forget to tweet your result!"
    ]


type alias Model =
    List Box


type Box
    = Checked String
    | Unchecked String


type Msg
    = CheckBox String
    | UncheckBox String
    | KeyDown
    | KeyUp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        checkABox clickedBoxText =
            model

        unCheckABox clickedBoxText =
            model
    in
        case msg of
            CheckBox value ->
                ( checkABox value, Cmd.none )

            UncheckBox value ->
                ( unCheckABox value, Cmd.none )

            KeyUp ->
                ( model, Cmd.none )

            KeyDown ->
                ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "inbox" ] (List.map checkBoxView model)


checkBoxView : Box -> Html Msg
checkBoxView box =
    let
        format value =
            String.words value |> String.join "-"
    in
        case box of
            Checked value ->
                div [ class "item" ]
                    [ input [ type_ "checkbox", id (format value), setChangeHandler, checked True ] []
                    , p []
                        [ label [ for (format value) ] [ text value ] ]
                    ]

            Unchecked value ->
                div [ class "item" ]
                    [ input [ type_ "checkbox", id (format value), setChangeHandler, checked False ] []
                    , p []
                        [ label [ for (format value) ] [ text value ] ]
                    ]


setChangeHandler : Attribute msg
setChangeHandler =
    on "change" (checkboxDecoder)


checkboxDecoder : Json.Decode.Decoder String
checkboxDecoder =
    Json.Decode.at [ "string" ] string
