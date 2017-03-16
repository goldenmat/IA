:- module(cycles, []).

closed_unit.
%  Chiude i predicati di pruning per la strategia di taglio dei
%  cicli su cammino singolo.

path_search:init_pruning(_).

path_search:prune(pn(N, Path, _,_), V) :-
	member(V, [N|Path]).

path_search:store_closed(_,_).

