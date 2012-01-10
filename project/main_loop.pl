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
	best_customer(First, Customer_list, Id, _, _),
	Id == -1,
	initiate_drop_off(First, New_taxi_info),
	append(Taxi_list, [New_taxi_info], New_taxi_list),
	New_timer is Timer - 1,
	main_loop1(New_taxi_list, Customer_list, Result, New_timer),
	!.

%normal_case_updating_a_customer_and_picking_him_up
main_loop1([First|Taxi_list], Customer_list, Result, Timer):-
	write(Timer),nl,
	best_customer(First, Customer_list, Id, _, Arival_time),
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


