:- module(breadth_first_collection, []).


close_type([dl(list(f_node), list(f_node))]:collection).
%  Chiude i predicati aperti di ga relativi ai nodi
%  collezionati in frontiera con una difference list
%  per gestire una coda (FIFO) in modo efficiente

ga:f_empty(Info, fr(Info,dl(U, U))) :-
	var(U).

ga:f_select(fr(_, dl(F1,_F2)),_,_) :-
	var(F1),
	!,
	fail.
ga:f_select(fr(Info, dl([NF|F1], F2)), NF, fr(Info, dl(F1,F2))).

ga:f_add(fr(Info, dl(F1,[N|U])), [N|L], fr(Info, DL)) :-
	ga:f_add(fr(Info, dl(F1,U)), L,  fr(Info, DL)).
ga:f_add(F, [], F).



