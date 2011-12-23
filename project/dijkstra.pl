neighbours(X, Result):-
	findall((Distance, Node), edge(X, Node, Distance), Result).

dijkstra(X):-
	dijkstra_1([(0, X, X)], [], R),
	cache_paths(R, X).

dijkstra_1([], Y, Y):-!.
dijkstra_1([(Distance_to_node, Node, Parent)|To_visit], Visited, Result):-
	neighbours(Node, Neighbours),
	unzip(Neighbours, Lengths, Nodes),
	map(add, Distance_to_node, Lengths, New_lengths),
	map(tupple_append, Node, Nodes, New_nodes1),
	zip(New_lengths, New_nodes1, New_nodes),
	queue_for_visit(New_nodes, Visited, To_visit, New_to_visit),
	sort(New_to_visit, New_to_visit2),
	dijkstra_1(New_to_visit2, [(Distance_to_node, Node, Parent)|Visited], Result).

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
