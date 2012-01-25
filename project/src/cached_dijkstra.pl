:- dynamic cached_shortest_path/3.
shortest_path(X, Y, D):-
	cached_shortest_path(X, Y, D),
	!.
shortest_path(X, Y, D):-
	dijkstra(X),
	cached_shortest_path(X, Y, D),
	!.
