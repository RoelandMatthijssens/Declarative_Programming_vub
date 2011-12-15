connected(X, Y):-
	edge(X, Y, _).

path([X| AlreadyVisited], X, [X|AlreadyVisited], L).
path([X| AlreadyVisited], Y, P, L):-
	edge(X, Z, Length),
	\+member(Z, [X|AlreadyVisited]),
	path([Z, X|AlreadyVisited], Y, ZYPath, ZYLength),
	P=[X|ZYPath],
	L is Length+ZYLength.

paths(X, Y):-
	path([X], Y, P, L),
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
