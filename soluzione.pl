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
	    writeln(H:'Caricata euristica')
	;   writeln(H:'Euristica non disponibile, assumo euristica 0'),
	    clear_heuristic),
	load_strategy([s:astar, p:closed]).

pred(go(atom)).
% go(H): Risolve il mondo in base dati dinamica con euristica H
% MODO: (+) semidet
go(H) :-
	load_heur(H),!,
	solve(start, goal, pn(LastNode, RevPlan, Cost, _)),
	reverse(RevPlan, Plan),
        writeln('Soluzione con costo':Cost),
	maplist(writeln, Plan),
        writeln(LastNode).

pred(start(state)).
% start(S): Stato di inizio del problema, indipendente dalla dimensione
% del mondo
start([in(p(1,1,start,vuoto))]).

pred(goal(state)).
% goal(S): Stato di goal del problema, dipendente dalla dimensione del
% mondo
goal([in(p(Dim,Dim,goal,vuoto))]) :-
	size(Dim).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(istruzioni).

% Da prendere quelle di Sam e ampliare









