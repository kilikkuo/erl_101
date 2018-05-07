-module(lists1).
-export([min/1, max/1, min_max/1, min_case/1]).


min(L) ->
    [H|T] = L,
    if
        length(T) =:= 0 ->
            H;
        true ->
            REST_MIN = min(T),
            if
            H =< REST_MIN ->
                H;
            true ->
                REST_MIN
            end
    end.

min_case(L) ->
    [H|T] = L,
    case length(L) of
        0 ->
            H;
        _Else ->
            erlang:min(H, min(T))
    end.

max(L) ->
    [H|T] = L,
    case length(T) of
        0 -> H;
        _Else ->
            MAX_T = max(T),
            if
                MAX_T >= H ->
                    MAX_T;
                true ->
                    H
            end
    end.

min_max(L) ->
    {min(L), max(L)}.