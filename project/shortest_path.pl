connected(X, Y):-
	edge(X, Y, _).

path(X, Y, L, P, _):-
	edge(X, Y, L),
	P = [X, Y].
path(X, Y, L, P, AlreadyVisited):-
	edge(X, Z, L1),
	\+member(Z, AlreadyVisited),
	path(Z, Y, ZYLength, ZYPath, [X|AlreadyVisited]),
	L is L1+ZYLength,
	P = [X|ZYPath].

paths(X, Y):-
	path(X, Y, L, P, []),
	printPath(P),
	writef(' with length %d\n', [L]),
	fail.

printPath([]).
printPath([X]):-
	write(X).
printPath([X|Rest]):-
	write(X),
	write(,),
	write(Rest).
