get_taxi_info((Position, Time), Position, Time).
get_customer_info((Id, Position, Online_time, Offline_time), Id, Position, Online_time, Offline_time).

to_late(Pos, Time, Customer_info):-
	get_customer_info(Customer_info,_, Pos2, _, Off),
	shortest_path(Pos, Pos2, Dist, _),
	Time+Dist > Off.

best_customer(Taxi_info, Customer_list, Customer_id, Value, Path, Arival_time):-
	get_taxi_info(Taxi_info, Taxi_position, Current_time),
	exclude(to_late(Taxi_position, Current_time), Customer_list, New_customer_list),
	find_best_customer(Taxi_info, New_customer_list, Customer_id, Value, Path, Arival_time).

find_best_customer(_, [], 0, -1000, [], 0).
find_best_customer(Taxi_info, [First_customer|Customer_list], Customer_id, Value, Path, Arival_time):-
	find_best_customer(Taxi_info, Customer_list, Customer_id2, Value2, Path2, Arival_time2),
	get_taxi_info(Taxi_info, Taxi_position, Current_time),
	get_customer_info(First_customer, Customer_id3, Customer_position, Online_time, Offline_time),
	shortest_path(Taxi_position, Customer_position, Distance, Path3),
	get_weight(Distance, Online_time, Offline_time, Current_time, Value3),
	Arival_time3 is Current_time + Distance,
	resolve_next_iteration_values(Value2, Value3, Customer_id2, Path2, Arival_time2, Customer_id3, Path3, Arival_time3, Customer_id, Value, Path, Arival_time).

resolve_next_iteration_values(Old_value, New_value, _, _, _, New_customer_id, New_path, New_arival_time, New_customer_id, New_value, New_path, New_arival_time):-
	New_value > Old_value,
	!.
resolve_next_iteration_values(Old_value, New_value, Old_customer_id, Old_path, Old_arival_time, _, _,_, Old_customer_id, Old_value, Old_path, Old_arival_time):-
	Old_value >= New_value,
	!.

get_weight(0, Online_time, Offline_time, Current_time, Result):-
	!,
	Arival_time is Current_time,
	Result is ((Arival_time-Online_time)/(Offline_time-Online_time)).
get_weight(Distance_to_customer, Online_time, Offline_time, Current_time, Result):-
	Arival_time is Current_time + Distance_to_customer,
	Result is ((Arival_time-Online_time)/(Offline_time-Online_time))*(1/Distance_to_customer).
