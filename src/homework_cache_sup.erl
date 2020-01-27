-module(homework_cache_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) ->
	ChildSpecification = [
		#{id => cache,
			start => {main_server, start, []},
			restart => permanent,
			shutdown => 1000,
			type => worker,
			modules => [main_server]}
	],
	{ok, {{one_for_one, 1, 5}, ChildSpecification}}.
