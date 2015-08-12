%%%-------------------------------------------------------------------
%%% @author Keisuke Ito <ito@mf04.komatsuelec.co.jp>
%%% @copyright (C) 2015, Keisuke Ito
%%% @doc
%%%
%%% @end
%%% Created : 11 Aug 2015 by Keisuke Ito <ito@mf04.komatsuelec.co.jp>
%%%-------------------------------------------------------------------
-module(serial).

%% API
-export([treeToList/1, listToTree/1, tree0/0, tree1/0]).

-include_lib("eunit/include/eunit.hrl").

%%%===================================================================
%%% API
%%%===================================================================

treeToList({leaf, N}) ->
    [2, N];

treeToList({node, T1, T2}) ->
    TTL1 = treeToList(T1),
    [Size1|_] = TTL1,
    TTL2 = treeToList(T2),
    [Size2|_] = TTL2,
    [Size1 + Size2 + 1| TTL1 ++ TTL2].

listToTree([2, N]) ->
    {leaf, N};

listToTree([_|Code]) ->
    case Code of
        [M|_] ->
            {Code1, Code2} = lists:split(M, Code),
            {node,
             listToTree(Code1),
             listToTree(Code2)
            }
    end.

tree0() ->
    {leaf, ant}.

tree1() ->
    {node,
     {node,
      {leaf, cat},
      {node,
       {leaf, dog},
       {leaf, emu}
      }
     },
     {leaf, fish}
    }.


%%%===================================================================
%%% Test functions
%%%===================================================================
leaf_test() ->
    ?assertEqual(tree0(), listToTree(treeToList(tree0()))).

node_test() ->
    ?assertEqual(tree1(), listToTree(treeToList(tree1()))).

leaf_value_test() ->
    ?assertEqual([2, ant], treeToList(tree0())).

node_value_test() ->
    ?assertEqual([11, 8, 2, cat, 5, 2, dog, 2, emu, 2, fish], treeToList(tree1())).

leaf_negative_test() ->
    ?assertError(badarg, listToTree([1, ant])).

node_negative_test() ->
    ?assertError(badarg, listToTree([8, 6, 2, cat, 2, dog, emu, fish])).
