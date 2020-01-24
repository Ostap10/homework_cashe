%%%-------------------------------------------------------------------
%%% @author step
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Jan 2020 15:37
%%%-------------------------------------------------------------------
-module(server_cache_test).
-author("step").

-include_lib("eunit/include/eunit.hrl").

cache_test_ () ->
  Key1 = 1,
  Key2 = 2,
  Key3 = 3,

  Value1 = one,
  Value2 = two,
  Value3 = three,

  Time1 = 180,
  Time2 = 120,
  Time3 = 60,
  main_server:start(),
  [
    ?_assert(main_server:insert(Key1, Value1, Time1) =:= ok),
    ?_assert(main_server:insert(Key2, Value2, Time2) =:= ok),
    ?_assert(main_server:insert(Key3, Value3, Time3) =:= ok),

    ?_assert(main_server:lookup(Key1) =:= {ok,Value1}),
    ?_assert(main_server:lookup(Key2) =:= {ok,Value2}),
    ?_assert(main_server:lookup(Key3) =:= {ok,Value3})
  ].


cache2_test_ () ->
  Key1 = 1,
  Key2 = 2,
  Key3 = 3,

  Value1 = one,
  Value2 = two,
  timer:sleep(61000),

  [
    ?_assert(main_server:lookup(Key3) =:= "time is up"),
    ?_assert(main_server:lookup(Key1) =:= {ok,Value1}),
    ?_assert(main_server:lookup(Key2) =:= {ok,Value2}),
    ?_assert(main_server:delete_obsolete() =:= ok)
  ].

cache_deleteV1_test_ () ->
  Key1 = 1,
  Key2 = 2,
  Key3 = 3,

  Value1 = one,
  timer:sleep(61000),
  [
    ?_assert(main_server:lookup(Key3) =:= []),
    ?_assert(main_server:lookup(Key1) =:= {ok,Value1}),
    ?_assert(main_server:lookup(Key2) =:= "time is up"),
    ?_assert(main_server:delete_obsolete_version_1() =:= ok)
  ].
