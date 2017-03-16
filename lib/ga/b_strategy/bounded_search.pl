:- module(bounded_search, []).

closed_unit.
% Unità che pone un limite minimo e uno massimo sulla ricerca

path_search:check_goal_bounds(bounded_search(F, [Min,_]),FN) :-
	path_search:call(F, FN, H),
	H >= Min.

path_search:check_expansion_bounds(bounded_search(F, [_,Max]),FN):-
	path_search:call(F, FN, H),
	H =< Max.

path_search:init_bounds(BS,BS).
