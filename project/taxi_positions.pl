init_taxis(Taxi, Node_id):-
	taxi(Taxi),
	assert(taxi_info(Taxi, Node_id,[])),
	print_taxi(Taxi),
	fail.

move_taxi(Taxi, Node_id):-
	retract(taxi_info(Taxi, _, Old_customer_list)),
	assert(taxi_info(Taxi, Node_id, Old_customer_list)),
	print_taxi(Taxi).

