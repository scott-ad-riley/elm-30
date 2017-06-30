module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Person =
    { name : String
    , year : Int
    }


people : List Person
people =
    [ { name = "Wes", year = 1988 }
    , { name = "Kait", year = 1986 }
    , { name = "Irv", year = 1970 }
    , { name = "Lux", year = 2015 }
    ]


type alias Comment =
    { text : String
    , id : Int
    }


comments : List Comment
comments =
    [ { text = "Love this!", id = 523423 }
    , { text = "Super good", id = 823423 }
    , { text = "You are the best", id = 2039842 }
    , { text = "Ramen is my fav food ever", id = 123523 }
    , { text = "Nice Nice Nice!", id = 542328 }
    ]



-- Some and Every Checks
-- Array.prototype.some() // is at least one person 19 or older?


containsAdult : List Person -> Bool
containsAdult people =
    List.any isAdult people


isAdult : Person -> Bool
isAdult person =
    (2017 - person.year) >= 19



-- Array.prototype.every() // is everyone 19 or older?


allAdults : List Person -> Bool
allAdults people =
    List.all isAdult people



-- Array.prototype.find()
-- Find is like filter, but instead returns just the one you are looking for
-- find the comment with the ID of 823423


findCommentById : List Comment -> Int -> Maybe Comment
findCommentById comments idToFind =
    let
        matchId comment =
            withId idToFind comment
    in
        List.head (List.filter matchId comments)


withId : Int -> Comment -> Bool
withId idToFind comment =
    comment.id == idToFind



-- Array.prototype.findIndex()
-- Find the comment with this ID
-- delete the comment with the ID of 823423


commentsWithoutId : List Comment -> Int -> List Comment
commentsWithoutId comments idToRemove =
    let
        withoutId comment =
            not (withId idToRemove comment)
    in
        Tuple.first (List.partition withoutId comments)



-- Printing to screen for debugging


main : Html.Html msg
main =
    pre [ style [ ( "white-space", "normal" ) ] ]
        [ text (toString (commentsWithoutId comments 823423)) ]
