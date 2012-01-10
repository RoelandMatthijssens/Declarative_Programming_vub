get_best_drop_off1([First|Rest], Position, Result_id, Distance):-
	customer(First, _, _, _, Destination),
	shortest_path(Position, Destination, Distance2),
	get_best_drop_off1(Rest, Position, _, Distance1),
	Distance1 >= Distance2,
	Distance = Distance2,
	Result_id = First.
get_best_drop_off1([First|Rest], Position, Result_id, Distance):-
	customer(First, _, _, _, Destination),
	shortest_path(Position, Destination, Distance2),
	get_best_drop_off1(Rest, Position, Best, Distance1),
	Distance1 < Distance2,
	Distance = Distance1,
	Result_id = Best.
get_best_drop_off1([Result_id], Position, Result_id , Distance):-
	customer(Result_id, _, _, _, Destination),
	shortest_path(Position, Destination, Distance).

get_best_drop_off(Taxi_info, Customer_id, Destination, Arival_time, New_customers_on_board):-
	get_taxi_info(Taxi_info, _, Position, Time, _, Customers, _),
	get_best_drop_off1(Customers, Position, Customer_id, Distance),
	delete(Customers, Customer_id, New_customers_on_board),
	customer(Customer_id, _, _, _, Destination),
	Arival_time is Time + Distance.

initiate_drop_off((Taxi_id, Pos, Time, Log, [], _), Result):-
	Result = (Taxi_id, Pos, Time, Log, [], 1),
	!.
initiate_drop_off(Taxi_info, Result):-
	get_taxi_info(Taxi_info, Taxi_id, _, Time, Log, _, Back_home),
	get_best_drop_off(Taxi_info, Customer_id, Destination, Arival_time, New_customers_on_board),
	Log_entry = ('It is', Time, 'Dropping off customer', Customer_id, 'at', Destination, 'arived at', Arival_time),
	append(Log, [Log_entry], New_log),
	New_taxi_info = (Taxi_id, Destination, Arival_time, New_log, New_customers_on_board, Back_home),
	Result = New_taxi_info,
	!.
