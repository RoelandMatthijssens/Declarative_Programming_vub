first([H|_], H).
head([H|_], H).
tail([_|T], T).
nth(N, [_|L], R):-
	N1 is N-1,
	nth(N1, L, R).
nth(0, [H|_], H).

map(_,_,[],[]):-!.
map(FunctionName, Arg, [H|T], [NH|NT]):-
	Function=..[FunctionName, Arg, H, NH],
	call(Function),
	map(FunctionName, Arg, T, NT).

add(A, B, R):-
	R is A+B.

tupple_prepend(A, B, R):-
	R=(A, B).
tupple_append(A, B, R):-
	R=(B, A).

unzip([(A, B)], [A], [B]):-!.
unzip([(A, B)|L1], [A|L2], [B|L3]):-
	unzip(L1, L2, L3).

zip([], _, []):-!.
zip(_, [], []):-!.
zip([H1|L1], [H2|L2], [(H1, H2)|L3]):-
	zip(L1, L2, L3).

