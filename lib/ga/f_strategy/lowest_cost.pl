:- module(lowest_cost, []).
:- consult('../priority_collection').
ga:f_priority(pn(_N,_Path,Cost,_H), Cost).
