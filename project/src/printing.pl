print([]):-nl.
print([First|Rest]):-
	write(First),
	write(' '),
	print(Rest).
