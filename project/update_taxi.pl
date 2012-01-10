split_log([], _, [], []).
split_log([First|Rest], Id, New_log, Roll_back_log):-
	First = ('It is', _, 'Going to pickup', Id),
	Roll_back_log = [First|Rest],
	New_log = [],
	!.
split_log([First|Rest], Id, New_log, Roll_back_log):-
	split_log(Rest, Id, New_log1, Roll_back_log),
	append([First], New_log1, New_log).

update_taxi(_, _, _, [], []).
update_taxi(_, _, -1, Taxi_list, Taxi_list):-!.
update_taxi(Taxi_info, _, Pickup_taxi, Taxi_list, New_taxi_list):-
	get_taxi_info(Taxi_info, Id, _, _, _, _, _),
	Id == Pickup_taxi,
	New_taxi_list = Taxi_list.
update_taxi(_, Customer_id, Pickup_taxi, Taxi_list, New_taxi_list):-
	delete(Taxi_list, (Pickup_taxi, Position, Time, Log, Customers_on_board, Back_home), New_taxi_list1),
	split_log(Log, Customer_id, New_log, Roll_back_log),
	roll_back_taxi_log(Roll_back_log, Position, Time, Customers_on_board, Back_home, New_position, New_time, New_customers_on_board, New_back_home),
	New_taxi_info = (Pickup_taxi, New_position, New_time, New_log, New_customers_on_board, New_back_home),
	append(New_taxi_list1, [New_taxi_info], New_taxi_list).

roll_back_taxi_log(Log, Old_Position, Old_Time, Old_Customers_on_board, Old_Back_home, Position, Time, Customers_on_board, Back_home):-
	roll_back_taxi_log1(Log, Old_Position, Old_Time, Old_Customers_on_board, Old_Back_home, Position, Time, Customers_on_board, Back_home),
	print(['reverting taxi state.']),
	print(['It is now', Time, 'instead of', Old_Time]),
	print(['At that time the taxi recided on position', Position]),
	print(['At that time he had these customers on board:', Customers_on_board]),
	print(['At that time his finished state was', Back_home]).

roll_back_taxi_log1([], Position, Time, Customers_on_board, Back_home, Position, Time, Customers_on_board, Back_home).
roll_back_taxi_log1([First|Rest], Position, Time, Customers_on_board, Back_home, New_Position, New_time, New_Customer_on_board, New_back_home):-
	roll_back_entry(First, Position, Time, Customers_on_board, Back_home, New_Position1, New_time1, New_Customer_on_board1, New_back_home1),
	roll_back_taxi_log1(Rest, New_Position1, New_time1, New_Customer_on_board1, New_back_home1, New_Position, New_time, New_Customer_on_board, New_back_home).

roll_back_entry(('It is', New_time, 'Going to pickup', _),Position, _, Customers, Back_home, Position, New_time, Customers, Back_home).
roll_back_entry(('Drove from', T_pos, 'To', _, 'Arived at', _), _, Time, Customers, Back_home, T_pos, Time, Customers, Back_home).
roll_back_entry(('Waited for customer till',Time), Position, _, Customers, Back_home, Position, Time, Customers, Back_home).
roll_back_entry(('Picked up customer', Id), Position, Time, Old_customers, Back_home, Position, Time, New_customers, Back_home):-
	delete(Old_customers, Id, New_customers).
