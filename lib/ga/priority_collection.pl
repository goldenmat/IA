:- module(priority_collection,[]).

closed_unit.
%  Chiude i predicati aperti di ga relativi ai nodi
%  collezionati in frontiera con una coda di priorità
%  usando la libreria SWI prolog heap.pl
%  Gestisce la collezione dei nodi di frontiera
%  in base al predicato aperto priority

close_type([{heap(f_node)}]:collection).

ga:f_empty(I,fr(I,heap(nil,0))).

ga:f_select(fr(I,heap(Heap1,N)), Node, fr(I, Heap2)) :-
	N > 0,
	delete_from_heap(heap(Heap1, N), _, Node, Heap2).

ga:f_add(fr(I, Heap1), [FN|L],fr(I, Heap2)) :-
	ga:f_priority(FN, Priority),
	add_to_heap(Heap1, Priority, FN, Heap),
	ga:f_add(fr(I,Heap),L, fr(I,Heap2)).
ga:f_add(Frontiera, [], Frontiera).
