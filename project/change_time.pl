change_time(Amount):-
	current_time(Current),
	retract(current_time(Current)),
	New_time is Current+Amount,
	assert(current_time(New_time)).
