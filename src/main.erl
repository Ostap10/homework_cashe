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
  delete_obsolete_version_1/0

]).

create() ->
  ets:new(cache,[named_table]),
  ok.

insert(Key, Value, Time) ->
  ets:insert(cache, {Key, Value, Time + erlang:system_time(second)}),
 ok.

lookup(Key) ->
  TimeStamp1 = erlang:system_time(second),
  List = ets:lookup(cache, Key),
  case List of
    [{_Key, Value, Time}] when TimeStamp1 =< Time -> {ok,Value};
    [{_Key, _Value, Time}] when TimeStamp1 > Time -> "time is up";
    _ -> []
end.

delete_obsolete() ->
  TimeStamp1 = erlang:system_time(second),
  MS = ets:fun2ms(
    fun({Key, _Value, Time})
      when TimeStamp1 > Time  ->
        Key
    end),
  List_Key = ets:select(cache, MS),
  delete(List_Key).

delete([])->
  ok;
delete([H | T]) ->
  ets:delete(cache, H),
  delete(T).

delete_obsolete_version_1() ->
   Timestamp1 = erlang:system_time(second),
   Key1 = ets:first(cache),
   List_key = next(Key1, [], Timestamp1),
   delete(List_key).

next('$end_of_table', List_key,_Timestamp1) ->
  List_key;
next(Key, List_key, Timestamp1) ->
  [{_Key, _Value, Time}] = ets:lookup(cache, Key),
  KeyNext = ets:next(cache, Key),
  case Time < Timestamp1 of
     true ->  next(KeyNext, [Key | List_key], Timestamp1);
      _ -> next(KeyNext, List_key, Timestamp1)
  end.