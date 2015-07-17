%%%-------------------------------------------------------------------
%%% @author Keisuke Ito <ito@pc088.komatsuelec.co.jp>
%%% @copyright (C) 2015, Keisuke Ito
%%% @doc
%%%
%%% @end
%%% Created : 15 Jul 2015 by Keisuke Ito <ito@pc088.komatsuelec.co.jp>
%%%-------------------------------------------------------------------
-module(hof1).

%% API
-export([evens/1, palins/1, foreach/2]).

%%%===================================================================
%%% API
%%%===================================================================
evens([]) ->
    [];
evens([X|Xs]) ->
    case X rem 2 == 0 of
        true ->
            [X| evens(Xs)];
        _ ->
            evens(Xs)
    end.

palins([]) ->
    [];
palins([X|Xs]) ->
    case palin(X) of
        true ->
            [X| palins(Xs)];
        _ ->
            palins(Xs)
    end.

foreach(_F, []) ->
    ok;
foreach(F, [X|Xs]) ->
    F(X),
    foreach(F, Xs).

%%%===================================================================
%%% Internal functions
%%%===================================================================

palin(X) -> X == lists:reverse(X).

