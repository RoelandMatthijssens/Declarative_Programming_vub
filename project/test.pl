get_taxi_info((Position, Time), Position, Time).
get_customer_info((Id, Position, Online_time, Offline_time, Pickup_time), Id, Position, Online_time, Offline_time, Pickup_time).

t(A, B, C, D):-
	findall((Id, Pos, On, Off, -1), customer(Id, On, Off, Pos, _), Customer_info),
	best_customer((1, 0), Customer_info, A, B, C, D).
