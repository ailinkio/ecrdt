%%%-------------------------------------------------------------------
%%% @author Evgeniy Khramtsov <>
%%% @copyright (C) 2015, Evgeniy Khramtsov
%%% @doc
%%%
%%% @end
%%% Created : 20 Dec 2015 by Evgeniy Khramtsov <>
%%%-------------------------------------------------------------------
-module(ecrdt_reg).

%% API
-export([assign/1, value/1, merge/1, merge/2, merge/3, merge/4]).

%%%===================================================================
%%% API
%%%===================================================================
-spec assign(T) -> ecrdt:register(T).
assign(X) ->
    {X, erlang:monotonic_time()}.

-spec value(ecrdt:register(T)) -> T.
value({X, _}) ->
    X.

-spec merge([ecrdt:register()]) -> ecrdt:register().
merge([]) ->
    erlang:error(badarg);
merge(Rs) ->
    hd(do_merge(Rs)).

-spec merge(ecrdt:register(), ecrdt:register()) -> ecrdt:register().
merge({X1, T1}, {X2, T2}) ->
    if T1 >= T2 -> {X1, T1};
       true -> {X2, T2}
    end.

-spec merge(ecrdt:register(), ecrdt:register(T),
	    fun((_ :: T) -> term())) -> ecrdt:register().
merge({X1, T1}, {X2, T2}, Fun) ->
    if T1 >= T2 ->
	    {X1, T1};
       true -> 
	    Fun(X2),
	    {X2, T2}
    end.

-spec merge(ecrdt:register(), ecrdt:register(T),
	    fun((_ :: T) -> term()), term()) -> {ecrdt:register(), term()}.
merge({X1, T1}, {X2, T2}, Fun, Default) ->
    if T1 >= T2 ->
	    {{X1, T1}, Default};
       true ->
	    {{X2, T2}, Fun(X2)}
    end.

%%%===================================================================
%%% Internal functions
%%%===================================================================
do_merge([R1, R2|Rs]) ->
    do_merge([merge(R1, R2)|Rs]);
do_merge(Rs) ->
    Rs.
