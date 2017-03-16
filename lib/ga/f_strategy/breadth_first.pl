:- module(breadth_first, []).
:- consult('../breadth_first_collection').
ga:f_priority(pn(N,Path,_,_), P) :-
	length([N|Path],P).
