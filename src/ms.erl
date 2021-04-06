%%%-------------------------------------------------------------------
%%% @author golubkin
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. апр. 2021 14:02
%%%-------------------------------------------------------------------
-module(ms).
-author("golubkin").

%% API
-export([start/1, to_slave/2, master/1, master/2, slave/0]).

%% N   - number of slave processes
start(N) ->
    Pid = spawn(ms, master, [N,[]]),
    register(master, Pid),
    true.

to_slave(Message, N) ->
    master ! {Message, N}.

master(0, L) ->
    master(L);
master(N, L) when is_integer(N), N > 0 ->
    Pid = spawn(ms,slave,[]),
    link(Pid),
    master(N-1, L ++ [{N,Pid}]).

master(L) ->
    process_flag(trap_exit, true),
    receive
        {Message, N} ->
            {_,Pid} = lists:keyfind(N, 1, L),
            Pid ! {Message, N},
            master(L);
        {'EXIT', FromPid, Reason} ->
            {N,_} = lists:keyfind(FromPid, 2, L),
            Pid = spawn(ms,slave,[]),
            link(Pid),
            io:format("~s~w~n", [Reason,N]),
            T = (L -- [{N,FromPid}]) ++ [{N,Pid}],
            master(T);
        stop ->
            io:format("stopping master PID ~w ~n", [self()]),
            true;
        _Other ->
            io:format("Other message: ~p~n", [_Other]),
            master(L)
    end.

slave() ->
    process_flag(trap_exit, true),
    receive
        {die,_} ->
            exit("master restarting dead slave");
        {Msg,N} ->
            io:format("Slave ~w got message: ~p~n", [N,Msg]),
            slave();
        {'EXIT', FromPid, Reason} ->
            io:format("stopping PID ~w. Trap exit from ~p with reason ~p~n", [self(), FromPid, Reason]),
            true;
        _Other ->
            io:format("Other message: ~p~n", [_Other]),
            slave()
    end.
