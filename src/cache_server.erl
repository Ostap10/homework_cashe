%%%-------------------------------------------------------------------
%%% @author step
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Feb 2020 18:59
%%%-------------------------------------------------------------------
-module(cache_server).
-author("step").

%% API
-export([
  init/2
]).


init(Req0, Opts) ->
  Method = cowboy_req:method(Req0),
  HasBody = cowboy_req:has_body(Req0),
  Req = maybe_echo(Method, HasBody, Req0),
  {ok, Req, Opts}.

maybe_echo(<<"POST">>, true, Req0) ->
  {ok, PostVals, Req} = cowboy_req:read_urlencoded_body(Req0),
  Echo = proplists:get_value(<<"action">>, PostVals),
  echo(Echo, Req, PostVals);
maybe_echo(<<"POST">>, false, Req) ->
  cowboy_req:reply(400, Req);
maybe_echo(_, _, Req) ->
  %% Method not allowed.
  cowboy_req:reply(405, Req).


echo(undefined, Req, _) ->
  cowboy_req:reply(400, Req);
echo(Echo, Req, PostVals) ->
  case Echo of
    <<"insert">> ->
      cowboy_req:reply(200, #{
        <<"content-type">> => <<"text/plain; charset=utf-8">>
      },
        jsx:encode([{<<"result">>,
        main_server:insert(
          binary_to_atom(proplists:get_value(<<"key">>, PostVals), latin1),
          binary_to_atom(proplists:get_value(<<"value">>, PostVals),latin1),
          erlang:system_time(second)+6000)}]),
        Req);
    <<"lookup">> -> cowboy_req:reply(200, #{
      <<"content-type">> => <<"aplication/json">>
    },
      jsx:encode([{<<"result">>, main_server:lookup(binary_to_atom(proplists:get_value(<<"key">>, PostVals), latin1))}]), Req);
%%      lookup_by_date -> cowboy_req:reply(200, [], lookup_by_date(PostVals), Req);
    _ -> cowboy_req:reply(400, Req)
  end.


