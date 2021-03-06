%%%-------------------------------------------------------------------
%%% @author step
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Jan 2020 14:23
%%%-------------------------------------------------------------------
-module(main_server).
-behaviour(gen_server).
-author("step").

%% API
-export([
  init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2
  ]).

-export([
  start/0,
  insert/3,
  lookup/1,
  delete_obsolete/0,
  delete_obsolete_version_1/0
]).

insert(Key, Value, Time) ->
  gen_server:call(?MODULE, {insert, Key, Value, Time}).

lookup(Key) ->
  gen_server:call(?MODULE, {lookup, Key}).

delete_obsolete() ->
  gen_server:cast(?MODULE, {delete_obsolete}).

delete_obsolete_version_1() ->
  gen_server:cast(?MODULE, {delete_obsolete_version_1}).

start() ->
  gen_server:start({local, main_server}, ?MODULE, [], []).

init(_Args) ->
  {ok, cashe_mnesia:start()}.

handle_call({insert, Key, Value, Time}, _Form, _State) ->
  NewState = cashe_mnesia:insert(Key, Value, Time),
  {reply, NewState, NewState};
handle_call({lookup, Key}, _Form, _State) ->
  NewState = cashe_mnesia:lookup(Key),
  {reply, NewState, NewState}.

%%handle_call({delete_obsolete_version_1}, _Form, _State) ->
%%  NewState = main:delete_obsolete_version_1(),
%%  {reply, NewState, NewState}.

handle_cast({delete_obsolete}, _State) ->
  NewState = main:delete_obsolete(),
  {noreply, NewState};
handle_cast({delete_obsolete_version_1}, _State) ->
  NewState = main:delete_obsolete_version_1(),
  {noreply, NewState}.

handle_info(_Info, State) ->
  {noreply, State}.