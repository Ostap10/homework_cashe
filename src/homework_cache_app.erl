-module(homework_cache_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

-include("mnesia_header.hrl").

start(_Type, _Args) ->
	application:start(mnesia),

	Dispatch = cowboy_router:compile([
		{'_', [
			{"/api/cache_server", cache_server, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, [{port, 8080}], #{
		env => #{dispatch => Dispatch}
	}),
	homework_cache_sup:start_link().

stop(_State) ->
	ok = cowboy:stop_listener(http).
