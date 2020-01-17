%%%-------------------------------------------------------------------
%%% @author step
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Jan 2020 15:57
%%%-------------------------------------------------------------------
-module(main).
-author("step").
-include_lib("stdlib/include/ms_transform.hrl").

%% API
-export([
  create/0,
  insert/3,
  lookup/1,
  delete_obsolete/0,
  lookup1/1
]).

create() ->
  ets:new(cache,[named_table]),
  ok.

insert(Key, Value, Time) ->
  ets:insert(cache, {Key, Value, Time, erlang:monotonic_time(second)}),
 ok.

lookup(Key1) ->
  TimeStamp1 = erlang:monotonic_time(second),
  MS = ets:fun2ms(
    fun({Key, Value, Time, TimeStamp})
        when TimeStamp1 - TimeStamp =< Time andalso Key == Key1 ->
            Value
    end),
  H = ets:select(cache, MS),
  case H of
      [] -> "time is up";
      _ -> {ok, H}
  end.

delete_obsolete() ->
  TimeStamp1 = erlang:monotonic_time(second),
  MS = ets:fun2ms(
    fun({Key, _Value, Time, TimeStamp})
      when TimeStamp1 - TimeStamp > Time  ->
        Key
    end),
  List_Key = ets:select(cache, MS),
  delete(List_Key)
  .

lookup1 (Key) ->
  ets:lookup(cache,Key).

delete([])->
  ok;
delete([H | T]) ->
  ets:delete(cache, H),
  delete(T).
