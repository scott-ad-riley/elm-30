module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Inventor =
    { first : String
    , last : String
    , year : Int
    , passed : Int
    }


inventors : List Inventor
inventors =
    [ { first = "Albert", last = "Einstein", year = 1879, passed = 1955 }
    , { first = "Isaac", last = "Newton", year = 1643, passed = 1727 }
    , { first = "Galileo", last = "Galilei", year = 1564, passed = 1642 }
    , { first = "Marie", last = "Curie", year = 1867, passed = 1934 }
    , { first = "Johannes", last = "Kepler", year = 1571, passed = 1630 }
    , { first = "Nicolaus", last = "Copernicus", year = 1473, passed = 1543 }
    , { first = "Max", last = "Planck", year = 1858, passed = 1947 }
    , { first = "Katherine", last = "Blodgett", year = 1898, passed = 1979 }
    , { first = "Ada", last = "Lovelace", year = 1815, passed = 1852 }
    , { first = "Sarah E.", last = "Goode", year = 1855, passed = 1905 }
    , { first = "Lise", last = "Meitner", year = 1878, passed = 1968 }
    , { first = "Hanna", last = "Hammarström", year = 1829, passed = 1909 }
    ]



-- Array.prototype.filter()
-- 1. Filter the list of inventors for those who were born in the 1500's


bornIn1500s : List Inventor -> List Inventor
bornIn1500s inventors =
    List.filter (\i -> i.passed < 1600 && i.passed >= 1500) inventors



-- Array.prototype.map()
-- 2. Give us an array of the inventors' first and last names


firstAndLastNames : List Inventor -> List String
firstAndLastNames inventors =
    List.map (\i -> i.first ++ " " ++ i.last) inventors



-- Array.prototype.sort()
-- 3. Sort the inventors by birthdate, oldest to youngest


sortedByBirthDate : List Inventor -> List Inventor
sortedByBirthDate inventors =
    List.sortBy .year inventors



-- Array.prototype.reduce()
-- 4. How many years did all the inventors live?


totalNumberOfYearsLived : List Inventor -> Int
totalNumberOfYearsLived inventors =
    List.foldl (ageSum) 0 inventors


ageSum : Inventor -> Int -> Int
ageSum inventor acc =
    acc + (age inventor)


age : Inventor -> Int
age inventor =
    inventor.passed - inventor.year



-- 5. Sort the inventors by years lived


sortedByYearsLived : List Inventor -> List Inventor
sortedByYearsLived inventors =
    List.sortBy (age) inventors



-- 6. create a list of Boulevards in Paris that contain 'de' anywhere in the name
-- https://en.wikipedia.org/wiki/Category:Boulevards_in_Paris
-- see readme for how I got that info out the page (nobody queries the dom in elm...)


type alias Boulevard =
    String


boulevards : List Boulevard
boulevards =
    [ "Boulevards of Paris", "City walls of Paris", "Thiers wall", "Wall of Charles V", "Wall of Philip II Augustus", "City gates of Paris", "Haussmann's renovation of Paris", "Boulevards of the Marshals", "Boulevard Auguste-Blanqui", "Boulevard Barbès", "Boulevard Beaumarchais", "Boulevard de l'Amiral-Bruix", "Boulevard des Capucines", "Boulevard de la Chapelle", "Boulevard de Clichy", "Boulevard du Crime", "Boulevard Haussmann", "Boulevard de l'Hôpital", "Boulevard des Italiens", "Boulevard de la Madeleine", "Boulevard de Magenta", "Boulevard Montmartre", "Boulevard du Montparnasse", "Boulevard Raspail", "Boulevard Richard-Lenoir", "Boulevard de Rochechouart", "Boulevard Saint-Germain", "Boulevard Saint-Michel", "Boulevard de Sébastopol", "Boulevard de Strasbourg", "Boulevard du Temple", "Boulevard Voltaire", "Boulevard de la Zone" ]


boulevardsWithDe : List Boulevard -> List Boulevard
boulevardsWithDe boulevards =
    List.filter nameContainsDe boulevards


nameContainsDe : Boulevard -> Bool
nameContainsDe boulevard =
    String.contains "de" boulevard



-- 7. sort Exercise
-- Sort the people alphabetically by last name


sortedByLastName : List Inventor -> List Inventor
sortedByLastName inventors =
    List.sortBy .last inventors



-- 8. Reduce Exercise
-- Sum up the instances of each of these


vehicles : List Vehicle
vehicles =
    asVehicleTypes [ "car", "car", "truck", "truck", "bike", "walk", "car", "van", "bike", "walk", "car", "van", "car", "truck" ]


type Vehicle
    = Car
    | Truck
    | Bike
    | Van
    | Walk
    | NotAVehicle


type alias VehicleSum =
    { car : Int
    , truck : Int
    , bike : Int
    , van : Int
    , walk : Int
    }


asVehicleTypes : List String -> List Vehicle
asVehicleTypes vehicleStrings =
    List.map toVehicle vehicleStrings


toVehicle : String -> Vehicle
toVehicle vehicleString =
    case vehicleString of
        "car" ->
            Car

        "truck" ->
            Truck

        "bike" ->
            Bike

        "van" ->
            Van

        "walk" ->
            Walk

        _ ->
            NotAVehicle


sumOfEachType : List Vehicle -> VehicleSum
sumOfEachType vehicles =
    List.foldl addToCounter initialSum vehicles


initialSum : VehicleSum
initialSum =
    { car = 0
    , truck = 0
    , bike = 0
    , van = 0
    , walk = 0
    }


addToCounter : Vehicle -> VehicleSum -> VehicleSum
addToCounter vehicle vehicleSum =
    case vehicle of
        Car ->
            { vehicleSum | car = vehicleSum.car + 1 }

        Truck ->
            { vehicleSum | truck = vehicleSum.truck + 1 }

        Bike ->
            { vehicleSum | bike = vehicleSum.bike + 1 }

        Van ->
            { vehicleSum | van = vehicleSum.van + 1 }

        Walk ->
            { vehicleSum | walk = vehicleSum.walk + 1 }

        NotAVehicle ->
            vehicleSum



-- Printing to screen for debugging


main : Html.Html msg
main =
    pre [ style [ ( "white-space", "normal" ) ] ]
        [ text (toString (sumOfEachType vehicles))
        ]
