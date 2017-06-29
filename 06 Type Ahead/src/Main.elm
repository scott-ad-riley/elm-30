module Main exposing (..)

import Json.Decode exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Regex exposing (..)


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchCities )


type alias Model =
    ( List City, List City )


type alias City =
    { name : String
    , latitude : Float
    , longitude : Float
    , population : String
    , rank : String
    , state : String
    }


initialModel : ( List City, List City )
initialModel =
    ( [], [] )


type Msg
    = LoadCities (Result Http.Error (List City))
    | FilterCities String


fetchCities : Cmd Msg
fetchCities =
    let
        url =
            "https://gist.githubusercontent.com/Miserlou/c5cd8364bf9b2420bb29/raw/2bf258763cdddd704f8ffd3ea9a3e81d25e2c6f6/cities.json"

        request =
            Http.get url decodeCities
    in
        Http.send LoadCities request


decodeCities : Decoder (List City)
decodeCities =
    Json.Decode.list
        (map6 City
            (at [ "city" ] string)
            (at [ "latitude" ] float)
            (at [ "longitude" ] float)
            (at [ "population" ] string)
            (at [ "rank" ] string)
            (at [ "state" ] string)
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ( all, filtered ) =
    case msg of
        LoadCities (Ok response) ->
            ( ( response, response ), Cmd.none )

        LoadCities (Err nope) ->
            ( ( all, filtered ), Cmd.none )

        FilterCities searchString ->
            ( ( all, (filterCities searchString all) ), Cmd.none )


filterCities : String -> List City -> List City
filterCities search cities =
    let
        term =
            caseInsensitive (regex search)

        matches name state city =
            (contains term (name city)) || (contains term (state city))
    in
        List.filter (matches .name .state) cities


view : Model -> Html Msg
view ( _, cities ) =
    div []
        [ input [ type_ "text", placeholder "enter text to search...", onInput FilterCities ]
            []
        , div
            []
            (List.map
                cityView
                cities
            )
        ]


cityView : City -> Html msg
cityView city =
    let
        display field =
            li [] [ text (field city) ]
    in
        ul [ style [ ( "list-style-type", "none" ) ] ]
            [ (display .name)
            , (display .population)
            , (display .rank)
            , (display .state)
            ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
