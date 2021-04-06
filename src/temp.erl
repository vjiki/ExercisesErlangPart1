%%%-------------------------------------------------------------------
%%% @author golubkin
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. март 2021 12:02
%%%-------------------------------------------------------------------
-module(temp).
-author("golubkin").

%% API
-export([convert/1]).
-export([f2c/1]).
-export([c2f/1]).

f2c(F) -> (F - 32)*(5/9).
c2f(C) -> (9/5) * C + 32.

convert({c, C}) -> {f, (9/5) * C + 32};
convert({f, F})  -> {c, (F - 32)*(5/9)};
convert({Tag, X})       -> {Tag, X}.

