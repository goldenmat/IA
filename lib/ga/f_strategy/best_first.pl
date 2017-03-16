:- module(best_first, []).
:- consult('../priority_collection').
ga:f_priority(pn(_N,_Path,_Cost,H), H).
