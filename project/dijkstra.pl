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

neighbours(X, Result):-
	findall((Length, Node), edge(X, Node, Length), Result).

dijkstra([], _, Y, Y):-!.
dijkstra(_, G, [(D, G, P)|Y], [(D, G, P)|Y]):-!.
dijkstra([(Distance_to_node, Node, Parent)|To_visit], Goal, Visited, Result):-
	neighbours(Node, Neighbours),
	unzip(Neighbours, Lengths, Nodes),
	map(add, Distance_to_node, Lengths, New_lengths),
	map(tupple_append, Node, Nodes, New_nodes1),
	zip(New_lengths, New_nodes1, New_nodes),
	queue_for_visit(New_nodes, Visited, To_visit, New_to_visit),
	sort(New_to_visit, New_to_visit2),
	dijkstra(New_to_visit2, Goal, [(Distance_to_node, Node, Parent)|Visited], Result).

queue_for_visit([], _, Result, Result).
queue_for_visit([(D,N,P)|Node_list], Visited, To_visit, Result):-
	queue_node(N, D, P, To_visit, Visited, R),
	queue_for_visit(Node_list, Visited, R, Result).


queue_node(Node, _, _, To_visit, Visited, Result):-
	member((_,Node,_), Visited),
	Result=To_visit,
	!.
queue_node(Node, New_distance, New_parent, To_visit, Visited, Result):-
	\+member((_,Node,_), Visited),
	\+member((_, Node, _), To_visit),
	append([(New_distance, Node, New_parent)], To_visit, Result),
	!.
queue_node(Node, New_distance, New_parent, To_visit, Visited, Result):-
	\+member((_,Node,_), Visited),
	member((Old_distance, Node, Old_parent), To_visit),
	New_distance < Old_distance,
	remove_node((Old_distance, Node, Old_parent), To_visit, New_to_visit),
	append([(New_distance, Node, New_parent)], New_to_visit, Result),
	!.

queue_node(Node, New_distance, _, To_visit, Visited, Result):-
	\+member((_,Node,_), Visited),
				member((Old_distance, Node, _), To_visit),
	New_distance >= Old_distance,
	Result=To_visit,
	!.

remove_node(_, [], []):-!.
remove_node(X, [X|L], R):-
	remove_node(X, L, R1),
	R=R1,
	!.

remove_node(X, [Y|L], R):-
	\+X==Y,
	remove_node(X, L, R1),
	R = [Y|R1],
	!.
