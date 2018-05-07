-module(nproc).
-export([start/3, recv_loop/2]).

start_n_proc(0, _) -> [];
start_n_proc(N, M) when N > 0 ->
    [spawn(nproc, recv_loop, [#{}, M])|start_n_proc(N-1, M)].

init_n_proc([], _) -> 0;

init_n_proc([H|T], First) ->
    case length(T) of
        0 ->
            H ! {self(), {init, First}};
        _Else ->
            [NH|_NT] = T,
            H ! {self(), {init, NH}},
            init_n_proc(T, First)
    end.

start(N, M, Msg) ->
    PIDs = start_n_proc(N, M),
    io:format("All PIDs : ~p ~n", [PIDs]),
    [First | _RestPIDs] = PIDs,
    init_n_proc(PIDs, First),
    First ! {self(), Msg}.


recv_loop(#{ count := N } = Map, Times) ->
    io:format(" ~p Map ~n", [Map]),
    if
        N == Times ->
            io:format(" Bye Bye ~n"),
            exit(self(), ok);
        true -> 0
    end,
    receive
        {_From, Message} ->
            C = get(client),
            C ! {self(), Message},
            io:format(" ~p Got Msg 1: ~p | (~p)/(~p) ~n", [self(), Message, N, Times])
    end,
    recv_loop(Map#{ count := N+1 }, Times);

recv_loop(X, Times) ->
    receive
        {_From, {init, Client}} ->
            io:format(" Got init Client : ~p~n", [Client]),
            put(client, Client)
    end,
    recv_loop(X#{ count => 0 }, Times).
