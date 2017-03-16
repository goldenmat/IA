:- module(astar, []).
:- consult('../priority_collection').
ga:f_priority(pn(_N,_Path,Cost,H), P) :-
	P is Cost+H.
