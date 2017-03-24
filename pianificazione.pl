%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                          %
%	       Pianificazione	           %
%                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(pianificazione).

pred(arc(state,state)).
% arc(S1,S2): Esiste un arco che collega gli stati S1 e S2
arc(S1,S2) :- do_action(_,S1,S2,_).

% Definizione di vicini di un nodo
path_search:neighbours(S,TR) :-
	setof(S1,arc(S,S1),TR), !
	;
	TR = [].

% Definizione di cammini come sequenze di azioni, quindi con il costo
% transizione
path_search:tr_cost([S1,A,S2],C) :-
	do_action(A,S1,S2,C).

% Definizione di euristica; current_heuristic(E) predicato dinamico che
% imposta a E l'euristica usata
:- dynamic(current_heuristic/1).
path_search:heuristic(ST,_,H) :-
	current_heuristic(Name), !,
	h(Name,ST,H).
path_search:heuristic(_,_,0).

% Imposto i comandi per cambiare dinamicamente l'euristica
set_heuristic(H) :-
	retractall(current_heuristic(_)),
	assert(current_heuristic(H)).
clear_heuristic :-
	retractall(current_heuristic(_)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(euristiche).

pred(h(atom,state,integer)).
% h(Name,ST,H): H è l'euristica Name dello stato ST
% MODO: (+,+,-) det

% Euristica manatthan: distanza di manhattan dalla casella in cui si
% trova l'agente al goal
h(manhattan, State, H) :-
	goal_cell(G),
	member(in(X), State),
	distanza(manhattan,X,G,H).

% Euristica euclide: distanza euclidea dalla casella in cui si trova
% l'agente al goal
h(euclide, State, H) :-
	goal_cell(G),
	member(in(X), State),
	distanza(euclide,X,G,H).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(debugging).

debug_heuristic(Start,Heur) :-
	load_strategy([s:astar, p:closed]),
	load_heur(Heur), !,
	size(D),
	Goal = [in(p(D,D))|_],
	retractall(goal_cell(_)),
	assert(goal_cell(p(D,D))),
	solve(start(Start), goal(Goal), pn(LastNode, _RevPath, Cost, H)),
	F is Cost+H,
	writeln('nodo raggiunto con C:H:F':Cost:H:F),
	writeln(LastNode).

