-module(demo).
-export([double/1]).

% Comment

double(Value) ->
  times(Value, 2).
times(X, Y) ->
  X * Y.
