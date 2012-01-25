t(Amount,Threshold, R):-
	assert(threshold(Threshold)),
	findall((Id, 1, 0, [], [], 0), taxi(Id), Temp_taxi_list),
	first_n(Amount, Temp_taxi_list, Taxi_list),
	findall((Id, Pos, On, Off, -1, -1), customer(Id, On, Off, Pos, _), Customer_list),
	main_loop(Taxi_list, Customer_list, R, 0),
	get_statistics(R, C, T_D),
	print([]),
	print([]),
	retract(threshold(Threshold)),
	print(['total customers picked up:', C]),
	print(['total time driven:', T_D]).
