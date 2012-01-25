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
