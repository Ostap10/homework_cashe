{application, 'homework_cache', [
	{description, "New project"},
	{vsn, "0.2.0"},
	{modules, ['cache_server','cashe_mnesia','homework_cache_app','homework_cache_sup','main','main_server']},
	{registered, [homework_cache_sup]},
	{applications, [kernel,stdlib,mnesia,cowboy,jsx]},
	{mod, {homework_cache_app, []}},
	{env, []}
]}.