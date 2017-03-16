:- module(no_cut,[]).

closed_unit.
%  Chiude i predicati di pruning nel caso di nessun pruning

path_search:init_pruning(_).
path_search:prune(_,_) :- fail.
path_search:store_closed(_,_).

