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

% Euristica manatthan/euclide: distanza di manhattan/euclide dalla
% casella in cui si trova l'agente al goal
h(D, State, H) :-
	goal_cell(G),
	member(in(X), State),
	distanza(D,X,G,H).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(debugging).

pred(debug_heuristic(posizione,posizione,atom)).
% debug_heuristic(P1,P2,H): Esegue il debug dell'euristica H partendo
% dalla casella P1 fino ad arrivare alla casella P2. In particolare per
% ogni soluzione stampa il costo, l'euristica verso il goal standard
% (p(Dim,Dim) - Dim dimensione del mondo) e la somma di questi ultimi
% MODO: (+,+,+) nondet
debug_heuristic(Start,Goal,Heur) :-
	load_strategy([s:astar, p:closed]),
	load_heur(Heur), !,
	size(D),
	G = [in(Goal)|_],
	retractall(goal_cell(_)),
	assert(goal_cell(p(D,D))),
	solve(start([in(Start)]), goal(G), pn(LastNode, _RevPath, Cost, H)),
	F is Cost+H,
	write('Nodo raggiunto con Costo(C) - Euristica(H) - Costo di frontiera(C+H): '),
	write('('), maplist(write,[Cost]), write(' - '), maplist(write,[H]), write(' - '), maplist(write,[F]), writeln(')'),
	writeln(LastNode).

pred(debug_heuristic(atom)).
% debug_heuristic(H): Esegue il debug dell'euristica H partendo dalla
% casella p(1,1) fino ad arrivare alla casella p(Dim,Dim) con Dim
% dimensione del mondo. Per ogni soluzione stampa i valori di costo,
% euristica e la somma di questi ultimi
debug_heuristic(Heur) :-
	size(D),
	debug_heuristic(p(1,1),p(D,D),Heur).





