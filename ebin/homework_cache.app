{application, 'homework_cache', [
	{description, "New project"},
	{vsn, "0.2.0"},
	{modules, ['cache_server','homework_cache_app','homework_cache_sup','main','main_server']},
	{registered, [homework_cache_sup]},
	{applications, [kernel,stdlib,cowboy,jsx]},
	{mod, {homework_cache_app, []}},
	{env, []}
]}.