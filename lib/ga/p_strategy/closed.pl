:- module(closed, []).

closed_unit.
%  Chiude i predicati di pruning per la strategia di taglio dei
%  nodi chiusi (pruning cicli su cammini multipli).

pred(closed(p_node)).
:- dynamic(closed/1).
%  closed(P,H):  P chiuso con euristica H
%  DB dinamica: ci si affida alla efficienza dell'accesso
%  hash alla base dati dinamica	in Prolog
%  MODO  (?) nondet

path_search:init_pruning(_) :-
	retractall(closed(_)).

path_search:prune(pn(V,_,_,_), V) :- !.
path_search:prune(_, V) :-
	closed(V).

path_search:store_closed(N) :-
	closed(N), !.
path_search:store_closed(N) :-
	assert(closed(N)).
