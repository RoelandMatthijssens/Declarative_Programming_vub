connected(X, Y):-
	edge(X, Y, _).

path(X, Y, L, P, _):-
	edge(X, Y, L),
	P = [X, Y].
path(X, Y, L, P, AlreadyVisited):-
	writef('\t\ttrying node %d\n\t\twith current path:', [X]),
	printPath(P),
	write('\n'),
	edge(X, Z, L1),
	\+member(Z, AlreadyVisited),
	path(Z, Y, ZYLength, ZYPath, [X|AlreadyVisited]),
	L is L1+ZYLength,
	P = [X|ZYPath].

paths(X, Y):-
	path(X, Y, L, P, []),
	print_path(P),
	writef(' with length %d\n', [L]),
	fail.
