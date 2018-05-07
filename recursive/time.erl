-module(time).
-export([swedish_date/0]).

prepare_str(S) ->
    if
        S =< 10 ->
            "0" ++ erlang:integer_to_list(S);
        true ->
            erlang:integer_to_list(S)
    end.

swedish_date() ->
    {Y, M, D} = date(),
    Y2 = Y rem 100,
    FY = erlang:integer_to_list(Y2),
    FM = prepare_str(M),
    FD = prepare_str(D),
    io:format(" ~p ~n", [FY ++ FM ++ FD]).
