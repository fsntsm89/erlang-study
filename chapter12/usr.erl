%%%-------------------------------------------------------------------
%%% @author Keisuke Ito <ito@mf02.komatsuelec.co.jp>
%%% @copyright (C) 2015, Keisuke Ito
%%% @doc
%%%
%%% @end
%%% Created :  5 Aug 2015 by Keisuke Ito <ito@mf02.komatsuelec.co.jp>
%%%-------------------------------------------------------------------
%% API
%% Operation & Maintenance API
-export([start_link/0, start_link/1, stop/0]).
%% Internal Server Functions API
-export([init/1, terminate/2, handle_call/3, handle_cast/2]).
%% Customer Service API
-export([add_usr/3, delete_usr/1, set_service/3, set_status/2,
         delete_disabled/0, lookup_id/1]).
%% Service API
-export([lookup_msisdn/1, service_flag/2]).


-behavior(gen_server).
-include("usr.hrl").

%%%===================================================================
%%% Internal Server Functions API
%%%===================================================================
init(FileName) ->
    usr_db:create_tables(FileName),
    usr_db:restore_backup(),
    {ok, null}.

%%%===================================================================
%%% Operation & Maintenance API
%%%===================================================================
start_link() ->
    start_link("usrDb").

start_link(FileName) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, FileName, []).

stop() ->
    gen_server:cast(?MODULE, stop).

%%%===================================================================
%%% Customer Service API
%%%===================================================================
add_usr(PhoneNo, CustId, Plan) when Plan == prepay; Plan == postpay ->
    gen_server:call(?MODULE, {add_usr, PhoneNo, CustId, Plan}).

delete_usr(CustId) ->
    gen_server:call(?MODULE, {delete_usr, CustId}).

set_service(CustId, Service, Flag) when Flag == true; Flag == false ->
    gen_server:call(?MODULE, {set_service, CustId, Service, Flag}).

set_status(CustId, Status) when Status == enabled; Status == disabled ->
    gen_server:call(?MODULE, {set_status, CustId, Status}).

delete_disabled() ->
    gen_server:call(?MODULE, delete_disabled).

lookup_id(CustId) ->
    usr_db:lookup_id(CustId).

%%%===================================================================
%%% Service API
%%%===================================================================
lookup_msisdn(PhoneNo) ->
    usr_db:lookup_msisdn(PhoneNo).

service_flag(PhoneNo, Service) ->
    case usr_db:lookup_msisdn(PhoneNo) of
        {ok, #usr{services=Services, status=enabled}} ->
            lists:member(Service, Services);
        {ok, #usr{status=disabled}} ->
            {error, disabled};
        {error, Reason} ->
            {error, Reason}
    end.

%%%===================================================================
%%% Callback functions
%%%===================================================================
terminate(_Reason, LoopData) ->
    usr_db:close_tables().

handle_cast(stop, LoopData) ->
    {stop, normal, LoopData}.
%%%===================================================================
%%% Internal functions
%%%===================================================================
