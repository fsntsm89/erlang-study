%%%-------------------------------------------------------------------
%%% @author Keisuke Ito <ito@pc088.komatsuelec.co.jp>
%%% @copyright (C) 2015, Keisuke Ito
%%% @doc
%%%
%%% @end
%%% Created : 14 Jul 2015 by Keisuke Ito <ito@pc088.komatsuelec.co.jp>
%%%-------------------------------------------------------------------
-module(records1).

%% API
-export([birthday/1, joe/0, showPerson/1]).

-record(person, {name, age=0, phone}).
%-record(name, {first, surname})
%P = #pernson{name = #name{first = "Robert",
%                          surname = "Virding"}}
%First = (P#person.name)#name.first.
%%%===================================================================
%%% API
%%%===================================================================
birthday(#person{age=Age} = P) ->
    P#person{age=Age+1}.

joe() ->
    #person{name="Joe",
            age=21,
            phone="999-999"}.

showPerson(#person{age=Age, phone=Phone, name=Name}) ->
    io:format(":name: ~p age: ~p phone: ~p~n", [Name, Age, Phone]).
%%%===================================================================
%%% Internal functions
%%%===================================================================
