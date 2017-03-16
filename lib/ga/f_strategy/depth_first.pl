:- module(depth_first, []).
:- consult('../depth_first_collection').
ga:f_priority(pn(N,Path,_,_), P) :-
	length([N|Path],P).
