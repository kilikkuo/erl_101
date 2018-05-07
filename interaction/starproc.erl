-module(starproc).
-export([start/3, recv_loop/0]).

start_proc(0) -> [];
start_proc(N) when N > 0 ->
    [spawn(starproc, recv_loop, [])|start_proc(N-1)].


start(N, M, Msg) ->
    PIDs = start_proc(N),
    io:format("PIDs : ~p ~n", [PIDs]),
    [First | RestPIDs] = PIDs,
    First ! {self(), {start_send, RestPIDs, {Msg, M}}}.

send_to_clients([], _) -> 0;
send_to_clients([H|T], Message) ->
    H ! {self(), Message},
    send_to_clients(T, Message).

recv_loop() ->
    receive
        {_From, {start_send, Clients, {Message, M}}} ->
            put(is_server, 1),
            put(clients, Clients),
            io:format("[~p] Ready to send message to clients : ~p ~n", [M, Clients]),
            send_to_clients(Clients, {Message, M});
        {From, Message} ->
            {Msg, M} = Message,
            IsServer = get(is_server),
            if
                IsServer =:= 1 ->
                    Clients = get(clients),
                    if
                        M =:= 1 ->
                            io:format("[~p] bye ~n", [From]),
                            put(clients, [C || C <- Clients, C =/= From]),
                            exit(From, ok);
                        true ->
                            io:format("[~p] Ready to send message to client : ~p~n", [M-1, From]),
                            From ! {self(), {Msg, M-1}}
                    end,
                    NewClients = get(clients),
                    if
                        length(NewClients) == 0 ->
                            io:format("[~p] bye ~n", [self()]),
                            exit(self(), ok);
                        true -> ok
                    end;
                true ->
                    io:format("[~p] received (~p) ~p ~n", [self(), M, Msg]),
                    From ! {self(), {Msg, M}}
            end
    end,
    recv_loop().