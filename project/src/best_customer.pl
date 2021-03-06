to_late(Pos, Time, Customer_info):-
	get_customer_info(Customer_info,_, Pos2, _, Off, _, _),
	shortest_path(Pos, Pos2, Dist),
	Time+Dist > Off.

someone_else_is_better(_, _, Customer_info):-
	get_customer_info(Customer_info, _, _, _, _, Pickup_time, _),
	Pickup_time \= -1,!.

someone_else_is_better(Pos, Time, Customer_info):-
	get_customer_info(Customer_info, _, Pos2, On, _, Pickup_time, _),
	shortest_path(Pos, Pos2, Dist),
	abs(On - (Time + Dist), R1),
	abs(On - Pickup_time, R2),
	threshold(Amount),
	R2/Amount =< R1,!.

best_customer(Taxi_info, Customer_list, Customer_id, Value, Arival_time):-
	get_taxi_info(Taxi_info, _, Taxi_position, Current_time, _, _, _),
	exclude(to_late(Taxi_position, Current_time), Customer_list, Customer_list2),
	exclude(someone_else_is_better(Taxi_position, Current_time), Customer_list2, New_customer_list),
	find_best_customer(Taxi_info, New_customer_list, Customer_id, Value, Arival_time).

find_best_customer(_, [], -1, 0, 0):-!.
%we_will_check_validity_of_the_result_by_using_the_customer_id_gt_0
find_best_customer(Taxi_info, [Customer], Customer_id, Value, Arival_time):-
	get_taxi_info(Taxi_info, _, Taxi_position, Current_time, _, _, _),
	get_customer_info(Customer, Customer_id, Customer_position, Online_time, Offline_time, _, _),
	shortest_path(Taxi_position, Customer_position, Distance),
	get_weight(Distance, Online_time, Offline_time, Current_time, Value),
	Arival_time is Current_time + Distance,
	!.

find_best_customer(Taxi_info, [First_customer|Customer_list], Customer_id, Value, Arival_time):-
	find_best_customer(Taxi_info, Customer_list, Customer_id2, Value2, Arival_time2),
	get_taxi_info(Taxi_info, _, Taxi_position, Current_time, _, _, _),
	get_customer_info(First_customer, Customer_id3, Customer_position, Online_time, Offline_time, _, _),
	shortest_path(Taxi_position, Customer_position, Distance),
	get_weight(Distance, Online_time, Offline_time, Current_time, Value3),
	Arival_time3 is Current_time + Distance,
	resolve_next_iteration_values(Value2, Value3, Customer_id2, Arival_time2, Customer_id3, Arival_time3, Customer_id, Value, Arival_time).

resolve_next_iteration_values(Old_value, New_value, _, _, New_customer_id, New_arival_time, New_customer_id, New_value, New_arival_time):-
	New_value > Old_value,
	!.
resolve_next_iteration_values(Old_value, New_value, Old_customer_id, Old_arival_time, _, _,Old_customer_id, Old_value, Old_arival_time):-
	Old_value >= New_value,
	!.

get_weight(0, Online_time, Offline_time, Current_time, Result):-
	!,
	Arival_time is Current_time,
	Result is ((Arival_time-Online_time)/((Offline_time-Online_time)+1)).
get_weight(Distance_to_customer, Online_time, Offline_time, Current_time, Result):-
	Arival_time is Current_time + Distance_to_customer,
	Result is ((Arival_time-Online_time)/((Offline_time-Online_time)+1))*(1/(Distance_to_customer+1)).%+1 to protect against zero_divisor
