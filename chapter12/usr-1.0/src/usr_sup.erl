%%%-------------------------------------------------------------------
%%% @author Keisuke Ito <ito@pc087.komatsuelec.co.jp>
%%% @copyright (C) 2015, Keisuke Ito
%%% @doc
%%%
%%% @end
%%% Created :  6 Aug 2015 by Keisuke Ito <ito@pc087.komatsuelec.co.jp>
%%%-------------------------------------------------------------------
-module(usr_sup).
-behavior(supervisor).

%% API
-export([start_link/0]).
-export([init/1]).

%%%===================================================================
%%% API
%%%===================================================================
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(FileName) ->
    UsrChild = {usr, {usr, start_link, []},
                permanent, 2000, worker, [usr, usr_db]},
    {ok, {{one_for_all, 1, 1}, [UsrChild]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
