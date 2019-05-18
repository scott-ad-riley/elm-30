module Main exposing (Box(..), Model, Msg(..), checkBoxView, init, initialModel, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)


main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    { checkMultiple = False
    , boxes =
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
    }


type alias Model =
    { boxes : List Box, checkMultiple : Bool }


type Box
    = Checked String
    | Unchecked String


type Msg
    = BoxClicked String Bool
    | KeyDown
    | KeyUp


flipBoxAt : String -> Bool -> List Box -> List Box
flipBoxAt name isChecked list =
    List.map (flipBox name isChecked) list


flipBox : String -> Bool -> Box -> Box
flipBox flippedName isChecked box =
    let
        handleBox name =
            case name == flippedName of
                True ->
                    newBox

                False ->
                    box

        newBox =
            case isChecked of
                True ->
                    Checked flippedName

                False ->
                    Unchecked flippedName
    in
    case box of
        Checked name ->
            handleBox name

        Unchecked name ->
            handleBox name


checkABox : Model -> String -> Bool -> Model
checkABox { boxes, checkMultiple } name isChecked =
    let
        return updatedBoxList =
            { boxes = updatedBoxList, checkMultiple = checkMultiple }
    in
    case checkMultiple of
        True ->
            return boxes

        False ->
            return (flipBoxAt name isChecked boxes)


update : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
update msg ( model, cmd ) =
    case msg of
        BoxClicked value isChecked ->
            ( checkABox model value isChecked, cmd )

        KeyUp ->
            ( { model | checkMultiple = False }, cmd )

        KeyDown ->
            ( { model | checkMultiple = True }, cmd )


view : ( Model, Cmd Msg ) -> Html Msg
view ( { boxes }, cmd ) =
    div [ class "inbox" ] (List.map checkBoxView boxes)


checkBoxView : Box -> Html Msg
checkBoxView box =
    let
        format value =
            String.words value |> String.join "-"
    in
    case box of
        Checked boxName ->
            div [ class "item" ]
                [ input [ type_ "checkbox", id (format boxName), setChangeHandler boxName, checked True ] []
                , p []
                    [ label [ for (format boxName) ] [ text boxName ] ]
                ]

        Unchecked boxName ->
            div [ class "item" ]
                [ input [ type_ "checkbox", id (format boxName), setChangeHandler boxName, checked False ] []
                , p []
                    [ label [ for (format boxName) ] [ text boxName ] ]
                ]


setChangeHandler : String -> Attribute Msg
setChangeHandler name =
    onCheck (\isChecked -> BoxClicked name isChecked)
