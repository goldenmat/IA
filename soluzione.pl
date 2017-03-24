%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                          %
%	        Soluzione	           %
%                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(soluzione).

pred(implemented_heur(atom)).
% implemented_heur(H): Metaprogrammazione, dice se l'euristica H è
% definita nel programma
% MODO: (+) semidet
implemented_heur(H) :-
	clause(h(H,_,_),_).

pred(load_heur(atom)).
% load_heur(H): Carica in base dati dinamica l'euristica H, se esiste
% MODO: (+) det
load_heur(H) :-
	(   implemented_heur(H) ->
	    set_heuristic(H),
	    write('Caricata euristica: '), maplist(writeln,[H])
	;   maplist(write,[H]), writeln(': Euristica non disponibile, assumo euristica 0'),
	    clear_heuristic),
	load_strategy([s:astar, p:closed]).

pred(goal_cell(casella)).
% Predicato dinamico di goal_cell, usato per ottenere l'euristica
:- dynamic(goal_cell/1).

pred(go(atom,posizione,posizione)).
% go(H,S,G): Risolve il mondo in base dati dinamica con euristica H,
% partendo da S e arrivando in G
% MODO: (+,+,+) nondet
go(H,S,G) :-
	load_heur(H), !,
	Start = [in(S)],
	Goal = [in(G)|_],
	retractall(goal_cell(_)),
	assert(goal_cell(G)),
	solve(start(Start), goal(Goal), pn(LastNode, RevPlan, Cost, _)),
	reverse(RevPlan, Plan),
	writeln('--------------------'),
        write('Soluzione con costo: '), maplist(writeln,[Cost]),
	writeln('--------------------'),
	writeln('* Lista azioni *'),
	maplist(writeln, Plan),
	writeln('--------------------'),
	write('Stato finale: '), writeln(LastNode).

pred(go(atom)).
% go(H): Risolve il mondo in base dati dinamica di dimensione Dim con
% euristica H partendo da p(1,1) e arrivando in p(Dim,Dim)
% MODO: (+) nondet
go(H) :-
	size(D),
	go(H,p(1,1),p(D,D)).

pred(go_random(atom)).
% go_random(H): Risolve il mondo in base dati dinamica con euristica H e
% partendo ed arrivando in due caselle casuali
% MODO: (+) nondet
go_random(H) :-
	size(Size),
	D is Size+1,
	random(1,D,X1),
	random(1,D,Y1),
	random(1,D,X2),
	random(1,D,Y2),
	write('Start: p('), maplist(write,[X1]), write(','), maplist(write,[Y1]), writeln(')'),
	write('Goal: p('), maplist(write,[X2]), write(','), maplist(write,[Y2]), writeln(')'),
	go(H,p(X1,Y1),p(X2,Y2)).

pred(start(state,state)).
% start(S,S): Stato di inizio del problema, chiamato dal predicato go/3
start(S,S).

pred(goal(state,state)).
% goal(S,S): Stato di goal del problema, chiamato dal predicato go/3
goal(S,S).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(istruzioni).

% Da prendere quelle di Sam e ampliare
