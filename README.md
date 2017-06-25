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
