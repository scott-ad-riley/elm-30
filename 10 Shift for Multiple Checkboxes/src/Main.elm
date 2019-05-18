module Main exposing (Model, Msg(..), checkBoxView, init, initialModel, main, update, view)

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
        [ makeBox False "This is an inbox layout."
        , makeBox False "Check one item"
        , makeBox False "Hold down your Shift key"
        , makeBox False "Check a lower item"
        , makeBox False "Everything inbetween should also be set to checked"
        , makeBox False "Try do it with out any libraries"
        , makeBox False "Just regular JavaScript"
        , makeBox False "Good Luck!"
        , makeBox False "Don't forget to tweet your result!"
        ]
    }


type alias Model =
    { boxes : List Box, checkMultiple : Bool }


type alias Box =
    { checked : Bool, name : String }


makeBox : Bool -> String -> Box
makeBox isChecked name =
    { checked = isChecked, name = name }


type Msg
    = BoxClicked String Bool
    | KeyDown
    | KeyUp


flipBoxAt : String -> Bool -> List Box -> List Box
flipBoxAt name isChecked list =
    List.map (flipBox name isChecked) list


flipBox : String -> Bool -> Box -> Box
flipBox flippedName isChecked box =
    if box.name == flippedName then
        makeBox isChecked flippedName

    else
        box


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
        formattedName =
            String.words box.name |> String.join "-"
    in
    div [ class "item" ]
        [ input [ type_ "checkbox", id formattedName, setChangeHandler box.name, checked box.checked ] []
        , p []
            [ label [ for formattedName ] [ text box.name ] ]
        ]


setChangeHandler : String -> Attribute Msg
setChangeHandler name =
    onCheck (\isChecked -> BoxClicked name isChecked)
