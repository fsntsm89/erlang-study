%%%-------------------------------------------------------------------
%%% @author Keisuke Ito <ito@mf02.komatsuelec.co.jp>
%%% @copyright (C) 2015, Keisuke Ito
%%% @doc
%%%
%%% @end
%%% Created :  8 Jul 2015 by Keisuke Ito <ito@mf02.komatsuelec.co.jp>
%%%-------------------------------------------------------------------
-module(server).

%% API
-export([start/2, stop/1, call/2]).
-export([init/1]).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

start(Name, Data) ->
    Pid = spawn(generic_handler, init, [Data]),
    register(Name, Pid), ok.

stop(Name) ->
    Name ! {stop, self()},
    receive {reply, Reply} -> Reply end.

call(Name, Msg) ->
    Name ! {request, self(), Msg},
    reveive {reply, Reply} -> Reply end.

reply(To, Msg) ->
    To ! {reply, Msg}.

init(Data) ->
    loop(initialize(Data)).

%%%===================================================================
%%% Internal functions
%%%===================================================================
loop(State) ->
    receive
        {request, From, Msg} ->
            {Reply, NewState} = handle_msg(Msg, State),
            reply(From, Reply),
            loop(NewState);
        {stop, From} ->
            reply(From, terminate(State))
    end.
