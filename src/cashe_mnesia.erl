%%%-------------------------------------------------------------------
%%% @author step
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Feb 2020 12:16
%%%-------------------------------------------------------------------
-module(cashe_mnesia).
-author("step").

%% API
-export([
  start/0,
  insert/3,
  lookup/1
]).
%%-compile(export_all).
-include("mnesia_header.hrl").

start() ->
  mnesia:stop(),
  mnesia:create_schema([node()]),
	mnesia:start(),
	mnesia:create_table(value,[{attributes, record_info(fields, value)}]),
	mnesia:create_table(time,[{attributes, record_info(fields, time)}]),
	mnesia:wait_for_tables([value, time], 20000).

insert(Key, Value, Time) ->
  TimeStamp=erlang:system_time(second)+Time,
  Data = #value{key=Key, value=Value},
  Data1 = #time{key=Key, time=TimeStamp},

    mnesia:dirty_write(Data),
%%    F = fun() ->     end,
%%  case mnesia:transaction(F) of
%%    {_, ok} -> ok;
%%      _ -> error
%%  end,
mnesia:dirty_write(Data1).

lookup (Key) ->
 NowTime = erlang:system_time(second),
 [{time, _Key, Time}] = mnesia:dirty_read({time, Key}),

%% [{time, _Key, Time}] = mnesia:transaction(F),
  [{value, _Key, Value}] = if
    Time >= NowTime ->mnesia:dirty_read({value, Key});
    true ->[{value, _Key, <<"time is up">>}]
  end,
  Value.

