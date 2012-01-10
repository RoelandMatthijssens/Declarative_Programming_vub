t(Times,R):-
	findall((Id, 1, 0, [], [], 0), taxi(Id), Taxi_list),
	findall((Id, Pos, On, Off, -1, -1), customer(Id, On, Off, Pos, _), Customer_list),
	main_loop1(Taxi_list, Customer_list, R, Times).
