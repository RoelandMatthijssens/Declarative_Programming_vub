d(X, Y, R):-
	dijkstra([(0, X, X)], Y, [], R).
