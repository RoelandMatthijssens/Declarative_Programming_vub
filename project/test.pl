get_taxi_info((Id, Position, Time, Log, Customers_on_board, Back_home), Id, Position, Time, Log, Customers_on_board, Back_home).
get_customer_info((Id, Position, Online_time, Offline_time, Pickup_time, Pickup_taxi), Id, Position, Online_time, Offline_time, Pickup_time, Pickup_taxi).

update_element(E, New_e, List, Result_list):-
	delete(List, E, New_list),
	Result_list1 = [New_e|New_list],
	rotate_list(Result_list1, Result_list).

rotate_list([X|Xs], Result):-
	append(Xs, [X], Result).

max(X, Y, X):- X>=Y,!.
max(X, Y, Y):- X<Y,!.

log_pickup(Id, Time, T_pos, C_pos, On, Arival, L0, Result):-
	Arival >= On,
	logg(('It is', Time, 'Going to pickup', Id),L0, L1),
	logg(('Drove from', T_pos, 'To', C_pos, 'Arived at', Arival),L1, L2),
	logg(('Picked up customer', Id),L2, L3),
	Result = L3.

log_pickup(Id, Time, T_pos, C_pos, On, Arival, L0, Result):-
	Arival < On,
	logg(('It is', Time, 'Going to pickup', Id),L0, L1),
	logg(('Drove from', T_pos, 'To', C_pos, 'Arived at', Arival),L1, L2),
	logg(('Waited for customer till',On),L2, L3),
	logg(('Picked up customer', Id),L3, L4),
	Result = L4.

logg(Entry, Old_log, New_log):-
	append(Old_log, [Entry], New_log).


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

	
roll_back_taxi_log([], Position, Time, Customers_on_board, Back_home, Position, Time, Customers_on_board, Back_home).
roll_back_taxi_log([First|Rest], Position, Time, Customers_on_board, Back_home, New_Position, New_time, New_Customer_on_board, New_back_home):-
	roll_back_entry(First, Position, Time, Customers_on_board, Back_home, New_Position1, New_time1, New_Customer_on_board1, New_back_home1),
	roll_back_taxi_log(Rest, New_Position1, New_time1, New_Customer_on_board1, New_back_home1, New_Position, New_time, New_Customer_on_board, New_back_home).


roll_back_entry(('It is', New_time, 'Going to pickup', _),Position, _, Customers, Back_home, Position, New_time, Customers, Back_home).
roll_back_entry(('Drove from', T_pos, 'To', _, 'Arived at', _), _, Time, Customers, Back_home, T_pos, Time, Customers, Back_home).
roll_back_entry(('Waited for customer till',Time), Position, _, Customers, Back_home, Position, Time, Customers, Back_home).
roll_back_entry(('Picked up customer', Id), Position, Time, Old_customers, Back_home, Position, Time, New_customers, Back_home):-
	delete(Old_customers, Id, New_customers).

main_loop1(L, _, L, 0):-!.

%taxi_back_home
main_loop1([First|Taxi_list], Customer_list, Result, Timer):-
	get_taxi_info(First, _, _, _, _, _, 1),
	append(Taxi_list, [First], New_taxi_list),
	New_timer is Timer - 1,
	main_loop1(New_taxi_list, Customer_list, Result, New_timer),
	!.

%taxi_full
main_loop1([First|Taxi_list], Customer_list, Result, Timer):-
	get_taxi_info(First, _, _, _, _, Customers_on_board, _),
	length(Customers_on_board, Amount),
	Amount == 4,
	initiate_drop_off(First, New_taxi_info),
	append(Taxi_list, [New_taxi_info], New_taxi_list),
	main_loop1(New_taxi_list, Customer_list, Result, Timer),
	!.

%cant_improve_a_customer
main_loop1([First|Taxi_list], Customer_list, Result, Timer):-
	best_customer(First, Customer_list, Id, _, _, _),
	Id == -1,
	initiate_drop_off(First, New_taxi_info),
	append(Taxi_list, [New_taxi_info], New_taxi_list),
	New_timer is Timer - 1,
	main_loop1(New_taxi_list, Customer_list, Result, New_timer),
	!.

%normal_case_updating_a_customer_and_picking_him_up
main_loop1([First|Taxi_list], Customer_list, Result, Timer):-
	write(Timer),nl,
	best_customer(First, Customer_list, Id, _, _, Arival_time),
	get_taxi_info(First, Taxi_id, Taxi_position, Time, Log, Customers, Back_home),
	append(Customers, [Id], New_customers),
	delete(Customer_list, (Id, Customer_position, On, Off, _, Pickup_taxi), Temp_customer_list),
	New_customer_info = (Id, Customer_position, On, Off, Arival_time, Taxi_id),
	append(Temp_customer_list, [New_customer_info], New_customer_list),
	update_taxi(First, Id, Pickup_taxi, Taxi_list, New_taxi_list),
	log_pickup(Id, Time, Taxi_position, Customer_position, On, Arival_time, Log, New_log),
	max(On, Arival_time, New_time),
	New_taxi_info = (Taxi_id, Customer_position, New_time, New_log, New_customers, Back_home),
	append(New_taxi_list, [New_taxi_info], New_taxi_list2),
	New_timer is Timer-1,
	main_loop1(New_taxi_list2, New_customer_list, Result, New_timer),
	!.

t(Times,R):-
	findall((Id, 1, 0, [], [], 0), taxi(Id), Taxi_list),
	findall((Id, Pos, On, Off, -1, -1), customer(Id, On, Off, Pos, _), Customer_list),
	main_loop1(Taxi_list, Customer_list, R, Times).
