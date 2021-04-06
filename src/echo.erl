%%%-------------------------------------------------------------------
%%% @author golubkin
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. апр. 2021 11:40
%%%-------------------------------------------------------------------
-module(echo).
-author("golubkin").

%% API
-export([go/0, loop/0]).

go() ->
  Pid2 = spawn(echo,loop, []),
  io:format("going to send hello from PID ~w ~n", [self()]),
  Pid2 ! {self(), hello},
  receive
    {Pid2, Msg} -> io:format("P1 go ~w from PID ~w ~n", [Msg, Pid2])
  end,
  Pid2 ! stop.

loop() ->
  receive
    {From, Msg} ->
        io:format("P1 loop ~w from PID ~w My PID ~w ~n", [Msg, From, self()]),
        From ! {self(), Msg},
        loop();
    stop ->
      true
  end.
