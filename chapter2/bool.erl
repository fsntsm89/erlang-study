-module(bool).
-export([b_not/1]).
-export([b_and/2]).
-export([b_or/2]).
-export([b_nand/2]).

b_not(X) ->
  not(X).
b_and(X, Y) ->
  X and Y.
b_or(X, Y) ->
  X or Y.
b_nand(X, Y) ->
  b_not(b_and(X, Y)).
