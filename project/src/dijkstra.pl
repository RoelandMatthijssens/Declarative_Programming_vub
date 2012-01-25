use_module(library(ordsets)).

neighbours(X, Result):-
	findall((Distance, Node), edge(X, Node, Distance), Result).

cache_distances(X):-
	visited(Distance, Node),
	assert(cached_shortest_path(X, Node, Distance)),
	fail.

dijkstra(X):-
	list_to_ord_set([(0, X)], Q),
	dijkstra_1(Q),
	cache_distances(X) -> true;
	retractall(visited(_, _)).

dijkstra_1(Q):-ord_empty(Q),!.
dijkstra_1([(Distance_to_node, Node)|Q]):-
	neighbours(Node, Neighbours),
	assert(visited(Distance_to_node, Node)),
	unzip(Neighbours, Lengths, Nodes),
	map(add, Distance_to_node, Lengths, New_lengths),
	zip(New_lengths, Nodes, New_nodes),
	queue_for_visit(New_nodes, Q, New_Q),
	dijkstra_1(New_Q).

queue_for_visit([], Result, Result).
queue_for_visit([(D,N)|Node_list], Q, Result):-
	queue_node(N, D, Q, R),
	queue_for_visit(Node_list, R, Result).


queue_node(Node, _, Q, Result):-
	visited(_,Node),
	Result=Q,
	!.
queue_node(Node, New_distance, Q, Result):-
	\+memberchk((_, Node), Q),
	ord_add_element(Q, (New_distance, Node), Result),
	!.
queue_node(Node, New_distance, Q, Result):-
	memberchk((Old_distance, Node), Q),
	New_distance < Old_distance,
	ord_add_element(Q, (New_distance, Node), Result),
	!.
queue_node(Node, New_distance, Q, Result):-
	memberchk((Old_distance, Node), Q),
	New_distance >= Old_distance,
	Result=Q,
	!.
