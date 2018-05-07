-module(sampleproc).
-export([start/1, trigger_send/1, recv_loop/1]).

start(M) ->
    PID1 = spawn(sampleproc, trigger_send, [M]),
    PID2 = spawn(sampleproc, recv_loop, [M]),
    io:format("[Master] sender   : ~p ~n", [PID1]),
    io:format("[Master] receiver : ~p ~n", [PID2]),
    PID1 ! {self(), {target, PID2}}.

trigger_send(M) ->
    receive
        {_From, {target, ID}} ->
            ID ! {self(), "MSG !"}
    end,
    send_loop(M).

send_loop(0) -> exit(self(), ok);
send_loop(M) when M > 0 ->
    receive
        {From, Message} ->
            io:format("[Send][Recv] ~p ~n", [Message]),
            From ! {self(), Message}
    end,
    send_loop(M-1).

recv_loop(0) -> exit(self(), ok);
recv_loop(M) when M > 0 ->
    receive
        {From, Message} ->
            io:format("[Recv][Recv] ~p ~n", [Message]),
            From ! {self(), Message}
    end,
    recv_loop(M-1).


