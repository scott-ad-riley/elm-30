module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)
import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Flags =
    { width : Float
    , height : Float
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initialModel flags, Cmd.none )


type alias Model =
    { lastX : Float
    , lastY : Float
    , isDrawing : Bool
    , lines : List Line
    , currentWidth : Float
    , currentColour : Float
    , widthIncreasing : Bool
    , screenWidth : Float
    , screenHeight : Float
    }


type alias Point =
    { x : Float
    , y : Float
    }


type alias Line =
    { startX : Float
    , startY : Float
    , endX : Float
    , endY : Float
    , colour : Float
    , width : Float
    }


initialModel : Flags -> Model
initialModel { width, height } =
    { lastX = 0.0
    , lastY = 0.0
    , isDrawing = False
    , lines = []
    , currentWidth = 20.0
    , widthIncreasing = True
    , currentColour = 0.0
    , screenWidth = width
    , screenHeight = height
    }


type Msg
    = MouseDown Point
    | MouseUp Point
    | MouseMove Point


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        newWidth =
            if model.widthIncreasing then
                model.currentWidth + 2
            else
                model.currentWidth - 2

        shouldIncreaseWidth =
            if (model.widthIncreasing && model.currentWidth >= 100.0) then
                False
            else if (not model.widthIncreasing && model.currentWidth <= 15.0) then
                True
            else
                model.widthIncreasing

        addNewLine at model =
            { model
                | lines = model.lines ++ (createLine model at)
                , lastX = at.x
                , lastY = at.y
                , currentColour = model.currentColour + 1
                , currentWidth = newWidth
                , widthIncreasing = shouldIncreaseWidth
            }

        startDrawing at =
            { model
                | isDrawing = True
                , lastX = at.x
                , lastY = at.y
            }

        stopDrawing at =
            { model
                | isDrawing = False
                , lastX = at.x
                , lastY = at.y
            }
    in
        case msg of
            MouseDown at ->
                ( startDrawing at, Cmd.none )

            MouseUp at ->
                ( stopDrawing at, Cmd.none )

            MouseMove to ->
                if model.isDrawing then
                    ( addNewLine to model, Cmd.none )
                else
                    ( model, Cmd.none )


createLine : Model -> Point -> List Line
createLine model point =
    [ { startX = (convertX model.lastX model.screenWidth)
      , startY = (convertY model.lastY model.screenHeight)
      , endX = (convertX point.x model.screenWidth)
      , endY = (convertY point.y model.screenHeight)
      , colour = model.currentColour
      , width = model.currentWidth
      }
    ]


convertX : Float -> Float -> Float
convertX coordinate screenWidth =
    let
        width =
            screenWidth / 2
    in
        coordinate - width


convertY : Float -> Float -> Float
convertY coordinate screenHeight =
    let
        height =
            screenHeight / 2
    in
        if coordinate < height then
            height - coordinate
        else
            (coordinate - height) * -1.0


view : Model -> Html Msg
view model =
    div
        [ style [ ( "background-color", "#eee" ) ], handleMouseDown, handleMouseUp, handleMouseMove ]
        [ canvas model
          -- , modelInfo model
          -- , pathsInfo model.lines
        ]


handleMouseDown : Attribute Msg
handleMouseDown =
    on "mousedown" (Json.Decode.map MouseDown pointDecoder)


handleMouseUp : Attribute Msg
handleMouseUp =
    on "mouseup" (Json.Decode.map MouseUp pointDecoder)


handleMouseMove : Attribute Msg
handleMouseMove =
    on "mousemove" (Json.Decode.map MouseMove pointDecoder)


pointDecoder : Json.Decode.Decoder Point
pointDecoder =
    Json.Decode.map2 Point
        (at [ "clientX" ] float)
        (at [ "clientY" ] float)


canvas : Model -> Html msg
canvas model =
    let
        lineStyling line =
            { color = hsl (degrees line.colour) 1 0.5
            , width = line.width
            , cap = Round
            , join = Smooth
            , dashing = []
            , dashOffset = 0
            }

        modelPaths =
            List.map lineToPath model.lines

        lineToPath line =
            traced (lineStyling line) (segment ( line.startX, line.startY ) ( line.endX, line.endY ))

        width =
            round model.screenWidth

        height =
            round model.screenHeight
    in
        collage width height modelPaths |> toHtml


modelInfo : Model -> Html msg
modelInfo model =
    div []
        [ Html.text ("X:" ++ toString model.lastX ++ " ")
        , Html.text ("Y:" ++ toString model.lastY ++ " ")
        , Html.text ("converted to X:" ++ toString (convertX model.lastX) ++ " ")
        , Html.text ("converted to Y:" ++ toString (convertY model.lastY) ++ " ")
        ]


pathsInfo : List Line -> Html msg
pathsInfo lines =
    div [] (List.map lineToHtml lines)


lineToHtml : Line -> Html msg
lineToHtml line =
    p [] [ Html.text (toString line) ]
