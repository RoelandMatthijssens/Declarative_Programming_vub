get_taxi_info((Position, Time), Position, Time).
get_customer_info((Id, Position, Online_time, Offline_time), Id, Position, Online_time, Offline_time).

find_best_customer(_, [], 0, -1, []).
find_best_customer(Taxi_info, [First_customer|Customer_list], Customer_id, Value, Path):-
	find_best_customer(Taxi_info, Customer_list, Customer_id2, Value2, Path2),
	get_taxi_info(Taxi_info, Taxi_position, Current_time),
	get_customer_info(First_customer, Customer_id3, Customer_position, Online_time, Offline_time),
	shortest_path(Taxi_position, Customer_position, Distance, Path3),
	get_weight(Distance, Online_time, Offline_time, Current_time, Value3),
	resolve_next_iteration_values(Value2, Value3, Customer_id2, Path2, Customer_id3, Path3, Customer_id, Value, Path).


resolve_next_iteration_values(Old_value, New_value, _, _, New_customer_id, New_path, New_customer_id, New_value, New_path):-
	New_value > Old_value,
	!.
resolve_next_iteration_values(Old_value, New_value, Old_customer_id, Old_path, _, _, Old_customer_id, Old_value, Old_path):-
	Old_value >= New_value,
	!.

get_weight(Distance_to_customer, Online_time, Offline_time, Current_time, Result):-
	Arival_time is Current_time + Distance_to_customer,
	get_weight2(Arival_time, Online_time, Offline_time, Result).

get_weight2(A, _, Off, R):-
	A > Off,!,
	R = 0.

get_weight2(A, On, Off, R):-
	A < On,!,
	Duration is Off-On,
	R is (On - A) / Duration.

get_weight2(A, On, Off, R):-
	\+ A < On,
	\+ A > Off,
	Duration is Off-On,
	R is (A - On) / Duration.
