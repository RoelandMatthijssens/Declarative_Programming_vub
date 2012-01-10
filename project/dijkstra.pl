neighbours(X, Result):-
	findall((Distance, Node), edge(X, Node, Distance), Result).

cache_distances(X):-
	visited(Distance, Node),
	assert(cached_shortest_path(X, Node, Distance)),
	fail.

dijkstra(X):-
	dijkstra_1([(0, X)]),
	cache_distances(X) -> true;
	retractall(visited(_, _)).

dijkstra_1([]):-!.
dijkstra_1([(Distance_to_node, Node)|To_visit]):-
	neighbours(Node, Neighbours),
	assert(visited(Distance_to_node, Node)),
	unzip(Neighbours, Lengths, Nodes),
	map(add, Distance_to_node, Lengths, New_lengths),
	zip(New_lengths, Nodes, New_nodes),
	queue_for_visit(New_nodes, To_visit, New_to_visit),
	sort(New_to_visit, New_to_visit2),
	dijkstra_1(New_to_visit2).

queue_for_visit([], Result, Result).
queue_for_visit([(D,N)|Node_list], To_visit, Result):-
	queue_node(N, D, To_visit, R),
	queue_for_visit(Node_list, R, Result).


queue_node(Node, _, To_visit, Result):-
	visited(_,Node),
	Result=To_visit,
	!.
queue_node(Node, New_distance, To_visit, Result):-
	\+member((_, Node), To_visit),
	append([(New_distance, Node)], To_visit, Result),
	!.
queue_node(Node, New_distance, To_visit, Result):-
	member((Old_distance, Node), To_visit),
	New_distance < Old_distance,
	remove_node((Old_distance, Node), To_visit, New_to_visit),
	append([(New_distance, Node)], New_to_visit, Result),
	!.
queue_node(Node, New_distance, To_visit, Result):-
	member((Old_distance, Node), To_visit),
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
