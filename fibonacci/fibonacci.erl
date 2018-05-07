-module(fibonacci).

-export([fib/1, fib_forward/1]).

fib(0) ->
    0;
fib(1) ->
    1;
fib(N) when N >= 2 ->
    fib(N-2) + fib(N-1).

fib_forward(N) ->
    fib_forward_internal(N, 0, 1).

fib_forward_internal(0, R, _Next) ->
    R;
fib_forward_internal(N, R, Next) when N > 0 ->
    fib_forward_internal(N-1, Next, R+Next).