%%%-------------------------------------------------------------------
%%% @author golubkin
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. апр. 2021 12:52
%%%-------------------------------------------------------------------
-module(ringProcesses).
-author("golubkin").

%% API
-export([go/2, loop/2, loop/1, loop/0]).

go(N,M) ->
  Pid = spawn(ringProcesses,loop,[N]),
  io:format("going to send hello to PID ~w ~n", [Pid]),
  Pid ! {M*N}.

loop(1, FirstPid) ->
  io:format("linking ~w to ~w PID ~n", [self(), FirstPid]),
  link(FirstPid),
  loop();
loop(N, FirstPid) when is_integer(N), N > 0 ->
  Pid = spawn(ringProcesses,loop, [N-1, FirstPid]),
  io:format("linking ~w to ~w PID ~n", [self(), Pid]),
  link(Pid),
  loop().
loop(N) when is_integer(N), N > 0 ->
  Pid = spawn(ringProcesses,loop, [N-1, self()]),
  io:format("linking ~w to ~w PID ~n", [self(), Pid]),
  link(Pid),
  loop().
loop() ->
  process_flag(trap_exit, true),
  receive
    {M} when is_integer(M), M > 0 ->
      {_, L} = process_info(self(), links),
      P = lists:last(L),
      io:format("loop M: received ~w linked PID ~w My PID ~w ~n", [M, P, self()]),
%%      io:format("~w linked PIDs ~w last PID ~n", [L, P]),
      P ! {M-1},
      loop();
    {M} when is_integer(M), M == 0 ->
      io:format("stopping PID ~w ~n", [self()]),
      true;
    stop ->
      io:format("stopping PID ~w ~n", [self()]),
      true;
    {'EXIT', FromPid, Reason} ->
      io:format("stopping PID ~w. Trap exit from ~p with reason ~p~n", [self(), FromPid, Reason]),
      true;
    _Other ->
      io:format("Other message: ~p~n", [_Other]),
      loop()
  end.

