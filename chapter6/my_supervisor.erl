%%%-------------------------------------------------------------------
%%% @author Keisuke Ito <ito@pc088.komatsuelec.co.jp>
%%% @copyright (C) 2015, Keisuke Ito
%%% @doc
%%%
%%% @end
%%% Created : 13 Jul 2015 by Keisuke Ito <ito@pc088.komatsuelec.co.jp>
%%%-------------------------------------------------------------------
-module(my_supervisor).

%% API
-export([start_link/2, stop/1]).
-export([init/1]).

%%%===================================================================
%%% API
%%%===================================================================
start_link(Name, ChildSpecList) ->
    register(Name, spawn_link(my_supervisor, init, [ChildSpecList])),
    ok.

init(ChildSpecList) ->
    process_flag(trap_exit, true),
    loop(start_children(ChildSpecList)).

stop(Name) ->
    Name ! {stop, self()},
    receive {reply, Reply} -> Reply end.

%%%===================================================================
%%% Internal functions
%%%===================================================================
start_children([]) -> [];
start_children([{M, F, A} | ChildSpecList]) ->
    case (catch apply(M, F, A)) of
        {ok, Pid} ->
            [{Pid, {M, F, A}}|start_children(ChildSpecList)];
        _ ->
            start_children(ChildSpecList)
    end.

restart_child(Pid, ChildList) ->
    {value, {Pid, {M, F, A}}} = lists:keysearch(Pid, 1, ChildList),
    {ok, NewPid} = apply(M, F, A),
    [{NewPid, {M, F, A}}|lists:keydelete(Pid, 1, ChildList)].

loop(ChildList) ->
    receive
       {'Exit', Pid, _Reason} ->
            NewChildList = restart_child(Pid, ChildList),
            loop(NewChildList);
        {stop, From} ->
            From ! {reply, terminate(ChildList)}
    end.

terminate([{Pid, _}|ChildList]) ->
    exit(Pid, kill),
    terminate(ChildList);
terminate(_ChildList) -> ok.
