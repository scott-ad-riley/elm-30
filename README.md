# Elm 30

This is repo is for my elm implementations of each of the exercises from [Wes Bos' Javascript30 course](https://javascript30.com/) ([github repo](https://github.com/wesbos/JavaScript30/))

I'll add my thoughts to this file for each exercise as I progress through them and also include a `Link` for each of my finished versions.

## 01 - Drum Kit

[Link](https://squealing-icicle.surge.sh)

A lot of head bashing to end up with a `MaybeDrum`. Great to get to grips with being forced to handle all possible paths through your code.

Unfortunately to avoid elm having to mount the `<audio>` element itself and give it an `autoPlay true`, it's using ports to play elements already on the page.

I'd like to come back to this and see if I can try using a native WebAudio library in elm. I'm unsure how this would work given we can only render to a DOM (I imagine it would get handled as a side-effect-possible "thing" like ajax)

## 02 - JS and CSS Clock

[Link](https://dusty-brush.surge.sh)

Actually not as easy as I thought - though one of the examples in the official elm guide on side effects is actually building a clock so copy-pasted one or two functions from that ([it's here if you want to take a look]( https://guide.elm-lang.org/architecture/effects/time.html))

Complicated parts were the conversions of units - js gives us `new Date().getSeconds` that returns a number between `0` and `59` - elm just gives us the epoch and we need to pull off the current minute's progress then convert that to a degree to rotate the hand.

Another hiccup (mostly avoided by having an exmaple to follow in the elm guide) is that getting the system's current time is an inherently easy but impure feature of most languages. Elm's way of handling it actually doesn't seem that painful and does make a lot of sense.

## 03 - CSS Variables

[Link](https://young-sail.surge.sh)

This one's probably been the easiest so far, but also the most frustrating. [The most widely used elm library](https://github.com/rtfeldman/elm-css) for css has two functionalities - one to have dynamic styles on elements inside your `view` and the other to actually generate static stylesheets (the latter is presumably because it'll do type checking on all your values). It does also allow you to set pseudo elements (i.e. `:root` for your css variables), but not inline (i.e. inside your view function) ([see note here](https://github.com/rtfeldman/elm-css/blob/master/README.md#approach-1-inline-styles)).

Unfortunately because of this we've had to use ports again like in the first example - though to be honest whilst they're supposed to be "the devil"/"an antipattern" they haven't felt that weird, maybe because they're so thin on the js side ¯\\\_(ツ)\_/¯


## 04 - Array Cardio

No Link for this one - the code's been commented with solutions

For #6 I got the information out of the page using a pretty horrible chained DOM lookup. (Wes' videos and example have a better explanation for it).

The benefits of elm aren't the same ones i've been used to - but the elegance of syntax and useability of types becomes clear very quickly.

One notable benefit is the record-access syntax being available as a function. So the following two are actually entirely equal:
* `inventorBirthDate inventor = inventor.birthDate`
* `.birthDate`

This means we can use `List.sortBy` to do this super-easily:

```
sortedByLastName : List Inventor -> List Inventor
sortedByLastName inventors =
    List.sortBy .last inventors
```

I've also added an additional commit for this exercise to show the refactoring of the last example to use a union type. It feels more verbose and definitely overkill for the exercise - but if the code had begun to grow I think it does make a lot more sense.

## 05 - Flex Panel Gallery

No Link - I skipped this exercise

The javascript was incredibly basic and it was more focused on CSS (toggling classes to apply different transitions with flex-box and font size).

I may come back to it at some point - it does hook in to the `onTransitionEnd` event which could be interesting in elm.

## 06 - Type Ahead

[Link](https://harsh-base.surge.sh)

This was great fun - finally something a more realistic.

It's loading in via ajax a list of cities, then allowing you to type in the box to filter them by city/state (not entirely clear from the UI).

There are a few areas that were pretty interesting to build - the ajax/http part I had expected to be the most difficult but it's actually not that bad.

* The JSON Decoder took a while to understand but I love the composability of them.

* Pulling out the view helper functions so i can write `display .name` and the helper will handle getting the value out and creating the html.

* Similar to the last point, one function (with 2 helpers) to accept a list of city records and a search string and return the filtered records, and it's just a few lines long is pretty awesome.

Highlight functions: `filterCities`, `cityView`, `decodeCities`

## 07 Array Cardio

No Link (similar to last array cardio - code is commented)

Finding an element by it's id. Elm's not going to let me just return "undefined" if it can't find it - I have to return _something_. So we wrap it in a `Maybe Comment` and then when it returns and does find it the type's actually `Just Comment`, if it couldn't find it, it would return `Nothing`. If I had a model or some other code using the output of that find, i'd have to handle that `Maybe`. So it's a union type: `type Maybe = Just <YourType> | Nothing`, makes sense but does add some overhead. I could have implemented with recursion but didn't really see the benefit.

These aren't particularly tricky in elm - especially when you don't have a view (or you're just `toString`ing your result).

## 08 HTML5 Canvas

[Link](http://sable-competition.surge.sh/)

This was a bunch of fun - though not something i'd recommend using for elm. The code's a bit of a mess in it's current state but some notable parts included:

* Decoding events other than `click` to capture the mouse X and Y was pretty tricky (particularly around using the type system).
* Elm-Graphics (or `Collage`) uses a coordinate system with an origin in the center of the area - whereas javascript canvas and the browser origin is in the top left - this meant figuring out how to convert between the two which was pretty interesting.
* Performance - we're holding every single line that we draw inside of the model/store which means it starts to feel quite sluggish after quite a lot of drawing. I'm not sure of a way around this (in javascript we just get to mutate/write to a `context` and then we're responsible for clearing something later). In Elm we have the entire state of the canvas held in our model.
* The graphics library is really nice to use. It feels "elm-y" whilst still allowing you to use a canvas. If I had one or two objects that i was moving around rather than drawing repeatedly I think it would've been more appropriate to use it.
* I also grabbed some initialization values from javascript using Flags as well to see how that behaved - was very easy to implement.

I also left in (but commented out) my debug code that I used when translating the coordinate system - see `modelInfo` and `pathInfo`.
