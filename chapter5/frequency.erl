%%%-------------------------------------------------------------------
%%% @author Keisuke Ito <ito@mf02.komatsuelec.co.jp>
%%% @copyright (C) 2015, Keisuke Ito
%%% @doc
%%%
%%% @end
%%% Created :  8 Jul 2015 by Keisuke Ito <ito@mf02.komatsuelec.co.jp>
%%%-------------------------------------------------------------------
-module(frequency).

%% API
-export([start/0, stop/0, allocate/0, deallocate/1]).
-export([init/0]).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% initialize the server.
%%--------------------------------------------------------------------
start() ->
    register(frequency, spawn(frequency, init, [])).

init() ->
    Frequencies = {get_frequencies(), []},
    loop(Frequencies).

% Hard Coded.
get_frequencies() ->
     [10,11,12,13,14,15].

%%--------------------------------------------------------------------
%% client functions.
%%--------------------------------------------------------------------
stop() -> call(stop).
allocate() -> call(allocate).
deallocate(Freq) -> call({deallocate, Freq}).

%%%===================================================================
%%% Internal functions
%%%===================================================================

%%--------------------------------------------------------------------
%% protocol in a functional interface.
%%--------------------------------------------------------------------
call(Message) ->
    frequency ! {request, self(), Message},
    receive
        {reply, Reply} -> Reply
    end.

%%--------------------------------------------------------------------
%% main loop
%%--------------------------------------------------------------------
loop(Frequencies) ->
    receive
        {request, Pid, allocate} ->
            {NewFrequencies, Reply} = allocate(Frequencies, Pid),
            reply(Pid, Reply),
            loop(NewFrequencies);
         {request, Pid, {deallocate, Freq}} ->
            NewFrequencies = deallocate(Frequencies, Freq),
            reply(Pid, ok),
            loop(NewFrequencies);
        {request, Pid, stop} ->
            reply(Pid, ok)
    end.

reply(Pid, Reply) ->
    Pid ! {reply, Reply}.

%% deallocate frequencies
allocate({[], Allocated}, _Pid) ->
    {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->
{{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}.

deallocate({Free, Allocated}, Freq) ->
    NewAllocated=lists:keydelete(Freq, 1, Allocated),
    {[Freq|Free], NewAllocated}.
