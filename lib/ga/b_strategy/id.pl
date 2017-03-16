:- module(id, []).

closed_unit.
% Unità che chiude il predicato ga:id (iterative deepening
% dell'algoritmo generico) e i predicati di gestione degli
% incrementi nel caso di path_search

:- consult('../depth_first_collection').

pred(increment(number)).
:- dynamic(increment/1).
% increment(Incr): si ha iterative deepening e Incr è l'incremento per
% iterazione corrente; prima della iterazione successiva Incr è
% azzerato, per prepararlo al calcolo dell'incremento successivo
% Modo	(-) det

ga:id_increment(id(M,BS), NewBS) :-
	retract(increment(K)),
	K > 0,
	increment_bounds(id(M,BS),K,NewBS),
	assert(increment(0)).

increment_bounds(id(M,[_Min,Max,UP]), K, id(M, [Min1,Max1,UP])) :-
	Max1 is Max+K,
	Max1 < UP,!,
	Min1 is Max+1.

path_search:init_bounds(id(F, K, Up), id(F,[K,K,Up]))  :-
       retractall(increment(_)),
       assert(increment(0)).

path_search:check_goal_bounds(id(F,[Min|_]), FN) :-
	%  Mostra solo i goals con F >= Min
	path_search:call(F,FN,C),!,
	C >= Min.

path_search:check_expansion_bounds(id(F,[_Min,Max,_]), FN) :-
	path_search:call(F,FN,HP),
	Incr is max(0, HP-Max),
	update_increment(Incr),!,
	Incr=0.

update_increment(Incr1) :-
	retract(increment(Incr)),
	next_incr(Incr,Incr1,NextIncr),
	assert(increment(NextIncr)).

next_incr(0,X,Z) :- !,
	Z is X.
next_incr(X,0,Z) :- !,
	Z is X.
next_incr(X,Y,Z) :- Z is min(X,Y).




