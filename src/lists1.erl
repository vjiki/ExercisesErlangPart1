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

%%min(L) -> lists:min(L).
%%max(L) -> lists:max(L).


max([]) -> [];
max([X|[]]) -> X;
max([X|Y]) -> erlang:max(X,max(Y)).
%%max(X, []) when is_atom(X) -> [];
%%max(X, []) -> X.
%%max(X,Y) when is_integer(X), is_integer(Y), X > Y -> X;
%%max(X,Y) when is_integer(Y) -> Y;
%%max(X,Y) when is_integer(X) -> X.

min([]) -> [];
min([X|[]]) -> X;
min([X|Y]) -> erlang:min(X,min(Y)).
%%min(X, []) -> X.
%%min(X,Y) ->
%%  if X < Y -> X;
%%    true -> Y
%%  end.


min_max(L) -> {min(L), max(L)}.

