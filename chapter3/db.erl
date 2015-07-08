%%%-------------------------------------------------------------------
%%% @author Keisuke Ito <ito@pc047.komatsuelec.co.jp>
%%% @copyright (C) 2015, Keisuke Ito
%%% @doc
%%%
%%% @end
%%% Created :  3 Jul 2015 by Keisuke Ito <ito@pc047.komatsuelec.co.jp>
%%%-------------------------------------------------------------------
-module(db).

%% API
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2]).

%%%===================================================================
%%% API
%%%===================================================================
new() -> [].
destroy(Db) -> [].
write(Key, Value, Db) -> [{Key, Value}|Db].
delete(Key, Db) -> delete(Key, Db, []).
read(Key, Db) -> find(Key, Db).
match(Value, Db) -> match(Value, Db, []).
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%%%===================================================================
%%% Internal functions
%%%===================================================================
find(Key, [{Key, X}|_]) -> {ok, X};
find(_Key, []) -> {error, instance};
find(Key, [_|X]) -> find(Key, X).

match(_Value, [], X) -> lists:reverse(X);
match(Value, [{Y, Value}|Z], X) -> match(Value, Z, [Y|X]);
match(Value, [_|Z], X) -> match(Value, Z, X).

delete(_Key, [], Z) -> lists:reverse(Z);
delete(Key, [{Key, _}|X], Z) -> delete(Key, X, Z);
delete(Key, [Y|X], Z) -> delete(Key, X, [Y|Z]).
