%%%-------------------------------------------------------------------
%%% @author golubkin
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. март 2021 16:47
%%%-------------------------------------------------------------------
-module(time).
-author("golubkin").

%% API
-export([swedish_date/0]).

swedish_date()->
  {Y,M,D} = date(),
  YY = string:right(integer_to_list(Y), 2, $0),
  MM = string:right(integer_to_list(M), 2, $0),
  DD = string:right(integer_to_list(D), 2, $0),
  YY ++ MM ++ DD.
