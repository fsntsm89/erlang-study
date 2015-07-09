%%%-------------------------------------------------------------------
%%% @author Keisuke Ito <ito@pc047.komatsuelec.co.jp>
%%% @copyright (C) 2015, Keisuke Ito
%%% @doc
%%%
%%% @end
%%% Created :  9 Jul 2015 by Keisuke Ito <ito@pc047.komatsuelec.co.jp>
%%%-------------------------------------------------------------------
-module(add_one).

%% API
-export([start/0, request/1, loop/0]).

%%%===================================================================
%%% API
%%%===================================================================
start() ->
    register(add_one, spawn_link(add_one, loop, [])).

request(Int) ->
    add_one ! {request, self(), Int},
    receive
        {result, Result} -> Result
    after 1000 -> timeout
    end.

loop() ->
    receive
        {request, Pid, Msg} ->
            Pid ! {result, Msg + 1}
    end,
    loop().

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%%%===================================================================
%%% Internal functions
%%%===================================================================
