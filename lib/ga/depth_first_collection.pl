:- module(depth_first_collection, []).

close_type([{list(f_node)}]:collection).
%  Chiude i predicati aperti di ga relativi ai nodi
%  collezionati in frontiera con una lista in quanto
%  le liste sono strutture LIFO (Last In First Out)


ga:f_empty(I,fr(I,[])).

ga:f_select(fr(I,[NF|F]), NF, fr(I,F)).

ga:f_add(fr(I, F1), [N|L],fr(I, [N|F2])) :-
	ga:f_add(fr(I,F1),L, fr(I,F2)).
ga:f_add(Frontiera, [], Frontiera).
