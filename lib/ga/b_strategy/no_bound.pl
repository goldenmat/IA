:- module(no_bound, []).

closed_unit.
% Unità che non pone limiti sulla ricerca

path_search:check_goal_bounds(_,_) :- !.

path_search:check_expansion_bounds(_,_) :- !.

path_search:init_bounds(_,no_bound) :- !.
