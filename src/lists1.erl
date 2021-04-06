%%%-------------------------------------------------------------------
%%% @author golubkin
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. март 2021 16:37
%%%-------------------------------------------------------------------
-module(lists1).
-author("golubkin").

%% API
-export([min/1]).
-export([max/1]).
-export([min_max/1]).

max([]) -> [];
max([X|[]]) -> X;
max([X|Y]) -> erlang:max(X,max(Y)).

min([]) -> [];
min([X|[]]) -> X;
min([X|Y])  -> erlang:min(X,min(Y)).

min_max(L) -> {min(L), max(L)}.
