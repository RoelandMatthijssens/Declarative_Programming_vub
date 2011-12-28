cache_paths([], _).
cache_paths([(Distance, Node, Parent)|Rest], Root):-
	build_path(Distance, Node, Parent, Rest, Root, _),
	cache_paths(Rest, Root).

build_path(Distance, Node, _, _, Root, Result_path):-
	% The path was already cached, so we just look it up.
	cached_shortest_path(Root, Node, Distance, Result_path),
	!.
build_path(_, Node, _, _, Node, [Node]):-!.

build_path(Distance, Node, Parent, Data, Root, Result_path):-
	\+cached_shortest_path(Root, Node, _, _),
	member((Next_distance, Parent, Next_parent), Data),
	build_path(Next_distance, Parent, Next_parent, Data, Root, Result_path_1),
	Result_path = [Node|Result_path_1],
	reverse(Result_path, Reversed_result_path),
	asserta(cached_shortest_path(Root, Node, Distance, Reversed_result_path)),
	!.

:- dynamic cached_shortest_path/4.
shortest_path(X, Y, D, P):-
	cached_shortest_path(X, Y, D, P),
	!.
shortest_path(X, Y, D, P):-
	assert(cached_shortests_path(X, X, 0, [X])),
	dijkstra(X),
	cached_shortest_path(X, Y, D, P),
	!.
