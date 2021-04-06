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
-export([go/3, loop/2, loop/1]).

%% Msg - is argument which contains Message
%% N   - is number of processes in the ring
%% M   - is a number of times which msg shall be sent between two Processes
go(Msg,N,M) ->
    Pid = spawn(ringProcesses,loop,[N]),
    io:format("going to send ~p msg to PID ~w ~n", [Msg,Pid]),
    Pid ! {Msg,M*N}.

loop(1, FirstPid) ->
    %%io:format("linking ~w to ~w PID ~n", [self(), FirstPid]),
    link(FirstPid),
    loop(FirstPid);
loop(N, FirstPid) when is_integer(N), N > 0 ->
    Pid = spawn(ringProcesses,loop, [N-1, FirstPid]),
    %%io:format("linking ~w to ~w PID ~n", [self(), Pid]),
    link(Pid),
    loop(Pid).
loop(N) when is_integer(N), N > 0 ->
    Pid = spawn(ringProcesses,loop, [N-1, self()]),
    %%io:format("linking ~w to ~w PID ~n", [self(), Pid]),
    link(Pid),
    loop(Pid);
loop(Pid) when is_pid(Pid) ->
    process_flag(trap_exit, true),
    receive
        {Msg,M} when is_integer(M), M > 0 ->
            %%{_, L} = process_info(self(), links),
            %%P = lists:last(L),
            %%io:format("received ~w linked PID ~w My PID ~w ~n", [M, P, self()]),
            %%io:format("~w linked PIDs ~w last PID ~n", [L, P]),
            io:format("received ~p on PID ~w ~n", [Msg, self()]),
            Pid ! {Msg,M-1},
            loop(Pid);
        {_,M} when is_integer(M), M == 0 ->
            io:format("stopping PID ~w ~n", [self()]),
            true;
        {'EXIT', FromPid, Reason} ->
            io:format("stopping PID ~w. Trap exit from ~p with reason ~p~n", [self(), FromPid, Reason]),
            true;
        _Other ->
            io:format("Other message: ~p~n", [_Other]),
            loop(Pid)
    end.

