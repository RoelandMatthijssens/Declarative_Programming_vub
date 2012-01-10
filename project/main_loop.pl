%main_loop1(L, _, L, 0):-!.

%taxi_back_home
main_loop1([First|Taxi_list], Customer_list, Result, Timer):-
	get_taxi_info(First, Id, _, _, _, _, 1),
	append(Taxi_list, [First], New_taxi_list),
	print(['Taxi', Id, 'is going home.']),
	main_loop(New_taxi_list, Customer_list, Result, Timer),
	!.

%taxi_full
main_loop1([First|Taxi_list], Customer_list, Result, Timer):-
	get_taxi_info(First, Id, _, _, _, Customers_on_board, _),
	length(Customers_on_board, Amount),
	Amount == 4,
	print(['Taxi', Id, 'is full']),
	initiate_drop_off(First, New_taxi_info),
	append(Taxi_list, [New_taxi_info], New_taxi_list),
	main_loop(New_taxi_list, Customer_list, Result, Timer),
	!.

%cant_improve_a_customer
main_loop1([First|Taxi_list], Customer_list, Result, Timer):-
	best_customer(First, Customer_list, Id, _, _),
	get_taxi_info(First, Taxi_id, _, _, _, _, _),
	Id == -1,
	print(['Taxi', Taxi_id, 'is currently unable to improve the pickup time of a customer']),
	initiate_drop_off(First, New_taxi_info),
	append(Taxi_list, [New_taxi_info], New_taxi_list),
	main_loop(New_taxi_list, Customer_list, Result, Timer),
	!.

%normal_case_updating_a_customer_and_picking_him_up
main_loop1([First|Taxi_list], Customer_list, Result, Timer):-
	best_customer(First, Customer_list, Id, _, Arival_time),
	get_taxi_info(First, Taxi_id, Taxi_position, Time, Log, Customers, Back_home),
	append(Customers, [Id], New_customers),
	delete(Customer_list, (Id, Customer_position, On, Off, Pickup_time, Pickup_taxi), Temp_customer_list),
	New_customer_info = (Id, Customer_position, On, Off, Arival_time, Taxi_id),
	print(['The best customer for Taxi', Taxi_id, 'to improve is customer nr', Id, 'located at', Customer_position]),
	print(['This customer is currently being picked up by',Pickup_taxi,'at',Pickup_time]),
	print(['The taxi can be there at', Arival_time, 'and the customer needs to be picked up between', On, 'and', Off]),
	append(Temp_customer_list, [New_customer_info], New_customer_list),
	update_taxi(First, Id, Pickup_taxi, Taxi_list, New_taxi_list),
	log_pickup(Id, Time, Taxi_position, Customer_position, On, Arival_time, Log, New_log),
	max(On, Arival_time, New_time),
	New_taxi_info = (Taxi_id, Customer_position, New_time, New_log, New_customers, Back_home),
	append(New_taxi_list, [New_taxi_info], New_taxi_list2),
	main_loop(New_taxi_list2, New_customer_list, Result, Timer),
	!.

taxis_online([], 0, 0).
taxis_online([First|Rest], Online, Offline):-
	get_taxi_info(First, _, _, _, _, _, 0),
	taxis_online(Rest, New_online, Offline),
	Online is New_online + 1.
taxis_online([First|Rest], Online, Offline):-
	get_taxi_info(First, _, _, _, _, _, 1),
	taxis_online(Rest, Online, New_offline),
	Offline is New_offline + 1.

main_loop([First|Rest], Customer_list, Result, Old_timer):-
	Timer is Old_timer + 1,
	taxis_online([First|Rest], Online, Offline),
	Total is Online + Offline,
	check_for_continue([First|Rest], Customer_list, Result, Timer, Total, Offline).

check_for_continue(R, _, R, Timer, X, X):-
	print(['Finished calculation in', Timer, 'steps']),
	!.
check_for_continue([First|Rest], Customer_list, Result, Timer, Total, Offline):-
	get_taxi_info(First, Id, _, Time, _, _, _),
	0 =< Id, Id =< 125,
	print([]),
	print([]),
	print([]),
	print(['******************************************']),
	print(['Calculating action for taxi', Id, '| time =', Time]),
	print(['Only', Offline, 'of the', Total, 'taxis are home']),
	print(['******************************************']),
	main_loop1([First|Rest], Customer_list, Result, Timer).

