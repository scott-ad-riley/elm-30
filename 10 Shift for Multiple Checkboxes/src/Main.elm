module Main exposing (main)

import Browser
import Browser.Events
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
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
    , lastCheckedIndex = Nothing
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onKeyDown (Json.Decode.map (Change Down) keyDecoder)
        , Browser.Events.onKeyUp (Json.Decode.map (Change Up) keyDecoder)
        ]


keyDecoder : Decoder String
keyDecoder =
    Json.Decode.field "key" Json.Decode.string


type alias Model =
    { boxes : List Box, checkMultiple : Bool, lastCheckedIndex : Maybe Int }


type alias Box =
    { checked : Bool, name : String }


makeBox : Bool -> String -> Box
makeBox isChecked name =
    { checked = isChecked, name = name }


type KeyStatus
    = Up
    | Down


type Msg
    = BoxClicked String Bool
    | Change KeyStatus String


storeIndexIfMatch : String -> ( Int, Box ) -> Maybe Int -> Maybe Int
storeIndexIfMatch name ( index, box ) current =
    if box.name == name then
        Just index

    else
        current


flipBoxAt : String -> Bool -> Model -> Model
flipBoxAt name isChecked model =
    let
        newBoxList =
            List.map (flipBox name isChecked) model.boxes

        lastCheckedBox =
            case isChecked of
                False ->
                    Nothing

                True ->
                    List.indexedMap Tuple.pair model.boxes
                        |> List.foldl
                            (storeIndexIfMatch name)
                            Nothing
    in
    { model | boxes = newBoxList, lastCheckedIndex = lastCheckedBox }


flipBox : String -> Bool -> Box -> Box
flipBox flippedName isChecked box =
    if box.name == flippedName then
        makeBox isChecked flippedName

    else
        box



-- get the index of the box we ticked
-- work out what indexes we need to check
-- check each of those indexes
-- ...


type alias BoxName =
    String


type alias BoxIndex =
    Int


type CheckboxIteratorState
    = SeenNeither BoxName BoxIndex
    | SeenClicked BoxIndex
    | SeenLastClicked BoxName
    | SeenBoth


type alias CheckboxAcc =
    { state : CheckboxIteratorState, boxes : List Box }


flipBoxThing : BoxName -> BoxIndex -> List Box -> Bool -> CheckboxAcc
flipBoxThing name index list isChecked =
    List.foldl (forEachBox isChecked) { state = SeenNeither name index, boxes = [] } (List.indexedMap Tuple.pair list)


forEachBox : Bool -> ( BoxIndex, Box ) -> CheckboxAcc -> CheckboxAcc
forEachBox isChecked ( boxIndex, box ) acc =
    let
        passThrough =
            { acc | boxes = acc.boxes ++ [ box ] }

        updateBox =
            { acc | boxes = acc.boxes ++ [ makeBox isChecked box.name ] }

        toState state nextAcc =
            { nextAcc | state = state }
    in
    case acc.state of
        SeenNeither name index ->
            case ( name == box.name, index == boxIndex ) of
                ( False, False ) ->
                    passThrough

                ( True, False ) ->
                    updateBox |> toState (SeenClicked index)

                ( False, True ) ->
                    updateBox |> toState (SeenLastClicked name)

                ( True, True ) ->
                    updateBox |> toState SeenBoth

        SeenBoth ->
            passThrough

        SeenClicked lastClickedIndex ->
            case lastClickedIndex == boxIndex of
                False ->
                    updateBox

                True ->
                    updateBox |> toState SeenBoth

        SeenLastClicked clickedName ->
            case clickedName == box.name of
                False ->
                    updateBox

                True ->
                    updateBox |> toState SeenBoth


flipBoxesFrom : String -> Bool -> Int -> Model -> Model
flipBoxesFrom name isChecked index model =
    let
        toModel { boxes } =
            { model | boxes = boxes }
    in
    flipBoxThing name index model.boxes isChecked |> toModel


flipMultipleBoxes : String -> Bool -> Model -> Model
flipMultipleBoxes name isChecked model =
    case model.lastCheckedIndex of
        Just index ->
            flipBoxesFrom name isChecked index model

        Nothing ->
            flipBoxAt name isChecked model


checkABox : Model -> String -> Bool -> Model
checkABox model name isChecked =
    case model.checkMultiple of
        True ->
            flipMultipleBoxes name isChecked model

        False ->
            flipBoxAt name isChecked model


updateCheckMultiple : KeyStatus -> String -> Model -> Model
updateCheckMultiple status key model =
    if key == "Shift" then
        case status of
            Up ->
                { model | checkMultiple = False }

            Down ->
                { model | checkMultiple = True }

    else
        model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    -- Debug.log "model"
    case msg of
        BoxClicked value isChecked ->
            ( checkABox model value isChecked, Cmd.none )

        Change status key ->
            ( updateCheckMultiple status key model, Cmd.none )


view : Model -> Html Msg
view { boxes } =
    div [ class "inbox" ] (List.map checkBoxView boxes)


checkBoxView : Box -> Html Msg
checkBoxView box =
    let
        formattedName =
            String.words box.name |> String.join "-"
    in
    div [ class "item" ]
        [ input [ type_ "checkbox", id formattedName, setChangeHandler box.name, checked box.checked ] []
        , span []
            [ label [ for formattedName ] [ text box.name ] ]
        ]


setChangeHandler : String -> Attribute Msg
setChangeHandler name =
    onCheck (\isChecked -> BoxClicked name isChecked)
