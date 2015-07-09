%%%-------------------------------------------------------------------
%%% @author Keisuke Ito <ito@pc047.komatsuelec.co.jp>
%%% @copyright (C) 2015, Keisuke Ito
%%% @doc
%%%
%%% @end
%%% Created :  9 Jul 2015 by Keisuke Ito <ito@pc047.komatsuelec.co.jp>
%%%-------------------------------------------------------------------
-module(add_two).

%% API
-export([start/0, request/1, loop/0]).

%%%===================================================================
%%% API
%%%===================================================================
start() ->
    process_flag(trap_exit, true),
    Pid = spawn_link(add_two, loop, []),
    register(add_two, Pid),
    {ok, Pid}.

request(Int) ->
    add_two ! {request, self(), Int},
    receive
        {result, Result} -> Result;
        {'Exit', _Pid, Reason} -> {error, Reason}
    after 1000 -> timeout
    end.

loop() ->
    receive
        {request, Pid, Msg} ->
            Pid ! {result, Msg + 2}
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
