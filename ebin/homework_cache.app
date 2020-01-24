{application, 'homework_cache', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['homework_cache_app','homework_cache_sup','main','main_server']},
	{registered, [homework_cache_sup]},
	{applications, [kernel,stdlib]},
	{mod, {homework_cache_app, []}},
	{env, []}
]}.