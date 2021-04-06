%%%-------------------------------------------------------------------
%%% @author golubkin
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. апр. 2021 12:25
%%%-------------------------------------------------------------------
-module(twoProcesses).
-author("golubkin").

%% API
-export([go/1, loop/0]).

go(M) ->
  Pid1 = spawn(twoProcesses,loop, []),
  Pid2 = spawn(twoProcesses,loop, []),
  io:format("going to send hello from PID ~w ~n", [Pid1]),
  Pid2 ! {Pid1, M}.

loop() ->
  receive
    {From, M} when is_integer(M), M > 0 ->
      io:format("loop M: received ~w from PID ~w My PID ~w ~n", [M, From, self()]),
      From ! {self(), M-1},
      loop();
    {From, M} when is_integer(M), M == 0 ->
      From ! stop,
      io:format("stopping PID ~w ~n", [self()]),
      true;
    stop ->
      io:format("stopping PID ~w ~n", [self()]),
      true
  end.