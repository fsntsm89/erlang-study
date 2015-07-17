%%%-------------------------------------------------------------------
%%% @author Keisuke Ito <ito@pc088.komatsuelec.co.jp>
%%% @copyright (C) 2015, Keisuke Ito
%%% @doc
%%%
%%% @end
%%% Created : 14 Jul 2015 by Keisuke Ito <ito@pc088.komatsuelec.co.jp>
%%%-------------------------------------------------------------------
-module(tuples1).

%% API
-export([test/1, test/2]).

%%%===================================================================
%%% API
%%%===================================================================
test1() ->
    showPErson(joe()).

test2() ->
    showPerson(birthday(joe())).

%%%===================================================================
%%% Internal functions
%%%===================================================================
birthday({Name, Age, Phone}) ->
    {Name, Age+1, Phone}.

joe() ->
    {"Joe", 21, "999-999"}.

showPErson({Name, Age, Phone}) ->
    io:format("name: ~p age: ~p phone: ~p~n", [Name, Age, Phone]).
