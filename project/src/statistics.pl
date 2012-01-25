get_statistics([First|Rest], C, T_DT):-
	get_taxi_info(First, _, _, _, Log, _, _),
	scan_log(Log, Customers_picked_up, Taxi_time_driven),
	get_statistics(Rest, C2, T_DT2),
	C is Customers_picked_up + C2,
	T_DT is Taxi_time_driven + T_DT2.

get_statistics([], 0, 0).

scan_log([], 0, 0).
scan_log([First|Rest], C, TD):-
	scan(First, C1, TD1),
	scan_log(Rest, C2, TD2),
	C is C1 + C2,
	TD is TD1 + TD2.

scan(('Picked up customer', _), 1, 0).
scan(('Drove from',X,'To',Y,'Arived at',_), 0, Distance):-shortest_path(X, Y, Distance).
scan(_, 0,0).
