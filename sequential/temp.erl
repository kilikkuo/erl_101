-module(temp).
-export([f2c/1, c2f/1, convert/1, convert2/1]).

f2c(F) ->
    5 * (F-32) / 9.

c2f(C) ->
    9 * C / 5 + 32.

convert(Temperature) ->
    {MODE, VALUE} = Temperature,
    case MODE of
        c -> c2f(VALUE);
        f -> f2c(VALUE)
    end.

convert2({c, V}) ->
    c2f(V);
convert2({f, V}) ->
    f2c(V).