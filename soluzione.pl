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

pred(go_graphic(atom,posizione,posizione)).
% go(H,S,G): Risolve il mondo in base dati dinamica con euristica H,
% partendo da S e arrivando in G. Stampa il percorso seguito dall'agente
% MODO: (+,+,+) nondet
go_graphic(H,S,G) :-
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
	write('Stato finale: '), writeln(LastNode),
	writeln('--------------------'),
	writeln('Cammino agente'),
	stampa_mondo([va(S)|Plan]).

pred(go(atom)).
% go(H): Risolve il mondo in base dati dinamica di dimensione Dim con
% euristica H partendo da p(1,1) e arrivando in p(Dim,Dim)
% MODO: (+) nondet
go(H) :-
	size(D),
	go(H,p(1,1),p(D,D)).

pred(go_graphic(atom)).
% go_graphic(H): Risolve il mondo in base dati dinamica di dimensione
% Dim con euristica H partendo da p(1,1) e arrivando in p(Dim,Dim).
% Stampa il percorso seguito dall'agente
% MODO: (+) nondet
go_graphic(H) :-
	size(D),
	go_graphic(H,p(1,1),p(D,D)).

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
	writeln('--------------------'),
	go(H,p(X1,Y1),p(X2,Y2)).

pred(go_random_graphic(atom)).
% go_random(H): Risolve il mondo in base dati dinamica con euristica H e
% partendo ed arrivando in due caselle casuali. Stampa il percorso
% seguito dall'agente
% MODO: (+) nondet
go_random_graphic(H) :-
	size(Size),
	D is Size+1,
	random(1,D,X1),
	random(1,D,Y1),
	random(1,D,X2),
	random(1,D,Y2),
	write('Start: p('), maplist(write,[X1]), write(','), maplist(write,[Y1]), writeln(')'),
	write('Goal: p('), maplist(write,[X2]), write(','), maplist(write,[Y2]), writeln(')'),
	writeln('--------------------'),
	go_graphic(H,p(X1,Y1),p(X2,Y2)).

pred(start(state,state)).
% start(S,S): Stato di inizio del problema, chiamato dal predicato go/3
start(S,S).

pred(goal(state,state)).
% goal(S,S): Stato di goal del problema, chiamato dal predicato go/3
goal(S,S).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(istruzioni).

:- maplist(writeln, ['***************************************************',
		     '*                                                 *',
		     '* Digitare obiettivo. per conoscere le specifiche *',
		     '*                                                 *',
		     '* Digitare istruzioni. per visualizzare i comandi *',
		     '*                                                 *',
		     '*    Consigliato l\'uso di un font monospaziato    *',
		     '*                                                 *',
		     '***************************************************']).

obiettivo :-
	writeln('********************   PROGETTO   ********************'),
	writeln('Il progetto consiste nell\'implementazione di un gioco. Il gioco è basato su un agente che si muove in un mondo quadrato.\n\nIl mondo è costituito da caselle composte da diversi territori: aria, mare, foresta, deserto. Il passaggio da un territorio ad un altro ha un costo specifico pari a: 1 nel caso dell\'aria, 2 nel caso dell\'acqua, 3 nel caso della foresta, 4 nel caso del deserto.\n\nNel mondo si possono trovare inoltre degli oggetti, tali: aereo (senza il quale non si può andare in caselle di tipo aria), barca (senza la quale non si può andare in caselle di tipo mare) e carro (il quale abbassa il costo del movimento nel deserto da 4 a 2).\n\nUn oggetto particolare è il magnete: se l\'agente passa da una casella che lo contiene perde tutti gli oggetti che possiede al momento.\n\nIl programma creato consente di trovare una soluzione esplorando il grafo con strategia A* e potatura dei chiusi; questa ricerca può essere resa più efficiente tramite l\'utilizzo di euristiche.'),
     writeln('******************************************************\n').

istruzioni :-
	writeln('********************   COMANDI UTILI   ********************'),
     nl,
     maplist(writeln, [
	       '  + genera_mondo(<integer>).',
	       '    Genera un mondo pseudocasuale di dimensione data in input\n',
	       '  + carica_mondo(<atom>).',
	       '    Carica uno dei mondi salvati (se esiste)\n',
	       '  + salva_mondo(<atom>).',
	       '    Salve su file il mondo corrente, che potrà essere caricato tramite carica_mondo(<atom>).\n',
	       '  + stampa_mondo.',
	       '    Stampa graficamente il mondo corrente\n',
	       '  + get_mondo(X).',
	       '    Restituisce la lista delle caselle che compongono il mondo (X è una variabile)\n',
	       '  + go(<euristica>).',
	       '    Risolve il problema secondo l\'euristica inserita (se esiste), a partire da p(1,1) fino a p(Dim,Dim) con Dim dimensione del mondo\n',
	       '  + go_graphic(<euristica>).',
	       '    Come sopra, ma stampa il cammino dell\'agente\n',
	       '  + go(Start,Goal,<euristica>).',
	       '    Risolve il problema secondo l\'euristica inserita (se esiste), a partire da Start fino a Goal\n',
	       '  + go_graphic(Start,Goal,<euristica>).',
	       '    Come sopra, ma stampa il cammino dell\'agente\n',
	       '  + go_random(<euristica>).',
	       '    Risolve il problema secondo l\'euristica inserita (se esiste), a partire da uno Start e arrivando ad un Goal scelti in modo pseudocasuale\n',
	       '  + go_random_graphic(<euristica>).',
	       '    Come sopra, ma stampa il cammino dell\'agente\n'
     ]),
     nl,
     writeln('***********************************************************\n').
