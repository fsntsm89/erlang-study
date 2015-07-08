%%%-------------------------------------------------------------------
%%% @author Keisuke Ito <ito@sy07.komatsuelec.co.jp>
%%% @copyright (C) 2015, Keisuke Ito
%%% @doc
%%%
%%% @end
%%% Created :  6 Jul 2015 by Keisuke Ito <ito@sy07.komatsuelec.co.jp>
%%%-------------------------------------------------------------------
-module(exe5).

%% API
-export([filter/2, reverse/1, concatenate/1]).

%%%===================================================================
%%% API
%%%===================================================================
filter(List, Key) -> filter(List, Key, []).
reverse(List) -> lists:reverse(List).
concatenate(List) -> lists:reverse(merge_list(List, [])).
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%%%===================================================================
%%% Internal functions
%%%===================================================================
filter([], _Key, Z) -> reverse(Z);
filter([X|Y], Key, Z) when X =< Key -> filter(Y, Key, [X|Z]);
filter([_|Y], Key, Z) -> filter(Y, Key, Z).

merge_list([], List) ->  List;
merge_list([X|Y], List) when is_list(X) == true ->
    merge_list(Y, merge_list(X, List));
merge_list([X|Y], List) -> merge_list(Y, [X|List]).

