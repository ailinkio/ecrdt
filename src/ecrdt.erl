%%%-------------------------------------------------------------------
%%% @author Evgeniy Khramtsov <>
%%% @copyright (C) 2015, Evgeniy Khramtsov
%%% @doc
%%%
%%% @end
%%% Created : 20 Dec 2015 by Evgeniy Khramtsov <>
%%%-------------------------------------------------------------------
-module(ecrdt).

%% API
-export([type/1, value/1, merge/2]).

-include("ecrdt.hrl").

%%%===================================================================
%%% API
%%%===================================================================
type(#ecrdt_s{}) -> ecrdt_sets;
type(#ecrdt_c{}) -> ecrdt_counter;
type({_, _}) -> ecrdt_reg;
type(#ecrdt_d{}) -> ecrdt_dict.

value(X) ->
    Mod = type(X),
    Mod:value(X).

merge(X1, X2) ->
    Mod = type(X1),
    Mod:merge(X1, X2).

%%%===================================================================
%%% Internal functions
%%%===================================================================
