print_taxi(Taxi):-
	taxi_info(Taxi, Position, Customer_list),
	node(Position, X, Y),
	writef('Taxi-nr:%d is located at (%d, %d).', [Taxi, X, Y]),
	nl,
	print_customer_list(Customer_list),
	nl.

print_customer(Customer):-
	customer(Customer, Earliest_time_of_pickup, Latest_time_of_pickup, Node_id, Destination),
	node(Node_id, X, Y),
	node(Destination, X2, Y2),
	writef('Customer-nr: %d\n', [Customer]),
	writef('\tLocated at: (%d, %d)\n', [X, Y]),
	writef('\tDestination  at: (%d, %d)\n', [X2, Y2]),
	writef('\tNeeds pickup between %d and %d\n', [Earliest_time_of_pickup, Latest_time_of_pickup]),
	nl.

print_customer_list([]).
print_customer_list([First|Rest]):-
	print_customer(First),
	print_customer_list(Rest).

print_path([]).
print_path([X]):-
	write(X).
print_path([X|Rest]):-
	write(X),
	write(,),
	write(Rest).
