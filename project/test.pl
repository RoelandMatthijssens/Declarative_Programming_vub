get_taxi_info((Id, Position, Time, Log, Customers_on_board), Id, Position, Time, Log, Customers_on_board).
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

main_loop1(L, _, L, 0):-!.
%taxi_full
main_loop1(Taxi_list, Customer_list, Result, Timer):-
	head(Taxi_list, First),
	get_taxi_info(First, Taxi_id, Taxi_position, Time, Log, Customers_on_board),
	length(Customers_on_board, Amount),
	Amount == 4,
	head(Customers_on_board, Customer_id),
	%Change_this_to_some_logic_to_get_best_to_drop_off
	tail(Customers_on_board, New_customers_on_board),
	logg(('Dropped off', Customer_id),Log, New_log),
	update_element(First, (Taxi_id, Taxi_position, Time, New_log, New_customers_on_board), Taxi_list, New_taxi_list),
	New_timer is Timer - 1,
	main_loop1(New_taxi_list, Customer_list, Result, New_timer),
	!.

main_loop1(Taxi_list, Customer_list, Result, Timer):-
	write(Timer), nl,
	head(Taxi_list, First),
	best_customer(First, Customer_list, Id, _, _, Arival_time),
	get_taxi_info(First, Taxi_id, Taxi_position, Time, Log, Customers),
	append(Customers, [Id], New_customers),
	update_element((Id, Customer_position, On, Off, _, _), (Id, Customer_position, On, Off, Arival_time, Taxi_id), Customer_list, New_customer_list),
	log_pickup(Id, Time, Taxi_position, Customer_position, On, Arival_time, Log, New_log),
	max(On, Arival_time, New_time),
	update_element(First, (Taxi_id, Customer_position, New_time, New_log, New_customers), Taxi_list, New_taxi_list),
	New_timer is Timer-1,
	main_loop1(New_taxi_list, New_customer_list, Result, New_timer),
	!.

t(Times,R):-
	findall((Id, 1, 0, [], [1, 2, 3]), taxi(Id), Taxi_list),
	findall((Id, Pos, On, Off, -1, -1), customer(Id, On, Off, Pos, _), Customer_list),
	main_loop1(Taxi_list, Customer_list, R, Times).
