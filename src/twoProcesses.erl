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
-export([go/2, loop/0]).

%% Msg - is argument which contains Message
%% M   - is a number of times which msg shall be sent between two Processes
go(Msg, M) ->
    Pid1 = spawn(twoProcesses,loop, []),
    Pid2 = spawn(twoProcesses,loop, []),
    %%  io:format("going to send ~p msg from PID ~w to ~w PID ~n", [Msg,Pid1,Pid2]),
    Pid2 ! {Pid1, Msg, M}.

loop() ->
    receive
      {From, Msg, M} when is_integer(M), M > 0 ->
          %%      io:format("received ~p msg ~w times from PID ~w My PID ~w ~n", [Msg, M, From, self()]),
          io:format("received ~p msg on PID ~w ~n", [Msg, self()]),
          From ! {self(), Msg, M-1},
          loop();
      {From, _, M} when is_integer(M), M == 0 ->
          From ! stop,
          io:format("stopping own PID ~w ~n", [self()]),
          true;
      stop ->
          io:format("stopping PID ~w ~n", [self()]),
          true
    end.