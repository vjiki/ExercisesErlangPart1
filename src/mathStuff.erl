%%%-------------------------------------------------------------------
%%% @author golubkin
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. март 2021 13:17
%%%-------------------------------------------------------------------
-module(mathStuff).
-author("golubkin").

-import(math, [pi/0]).

%% API
-export([perimeter/1]).

perimeter({square, Side}) ->
  4*Side;
perimeter({circle, Radius}) ->
  2* pi() * Radius;
perimeter({triangle, A, B, C}) ->
   A+B+C.