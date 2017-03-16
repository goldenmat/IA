:- module(path_search, [
		       solve/4,
	               strategy/2,
	               consult_strategy/2,
	               level_predicate/1
		       ]).
:- include('../../mchk/syntax').

open_unit.
%  Ricerca di piani:  i nodi di frontiera memorizzano piani parziali,
%  costo ed euristica.

section(import).
%  Moduli usati ======================================================

:- use_module('../ga').
%  ga è l'algoritmo generico; path_search chiude il tipi aperto
%  f_node in modo da rappresentare i cammini e info in modo da gestire
%  i limiti in caso di ricerche in spazi limitati

:- use_module('../ga_paths').
% E' specifico di SWI su Windows. IMPLEMENTA get_strategy_path
% che determina il path della directory GaPath all'interno di lib.
% Potrebbe non operare correttamente su Mac.
%
%=====================================================================

section(problem).  %================================================
%  1. Predicati e tipi aperti che il problema deve definire

open_type(p_node).
%  nodi di problema, stati o problemi parziali o transizioni o ...
%
open_type(action).
%  azioni,  OPZIONALE

type([{list(p_node)}, {list(action)}]:path).
%  Un cammino è una sequenza di nodi collegati da archi
%  Può essere anche rappresentato come una lista di azioni

type([[p_node,p_node], [p_node,action,p_node]]:transition).
%  Una transizione può essere un semplice arco [S1,S2] oppure
%  una tripla [S1,A,S2] dove A è un'azione che manda S1 in S2

open_pred(_Start:pred/1).
%  passato come parametro a solve

open_pred(_Goal:pred/1).
%  passato come parametro a solve

open_pred(neighbours(p_node, list(p_node))).
%   OBBLIGATORIO
%  lista dei nodi collegati da archi uscenti nel problema
%
open_pred(tr_cost(transition, number)).
%  OPZIONALE: può avere due forme:
%  - tr_cost([N1,N2],C): (N1,N2) arco con costo C: i cammini in un
%  f_node sono rappresentati da sequenze di p_node
%  - tr_cost([N1,A,N2],C):
%  A azione da N1 a N2 con costo C: i cammini in un f_node sono
%  rappresentati da sequenze di action MODO (+,-) det. Default: archi
%  con costo 1
tr_cost([_,_],1).

open_pred(heuristic(p_node, path, number)).
%   heuristic(P,Path, H):  H valore euristico di P con cammino Path
%   Per lo più Path è irrilevante, ma ci possono essere casi in cui
%   l'euristica riguarda l'intero cammino.
%   MODO:  (+,+,-) det
%   OPZIONALE, default 0
heuristic(_,_,0).


section(path_search).%==============================================
%  2.   Implementazione dell'algoritmo generico come ricerca di cammini
%  - Chiude f_node con nodi-cammino, ovvero nodi che rappresentano
%  cammini.
%  - Chiude i predicati aperti f_goal, f_expand,  get_solution
%  che sono legati alla struttura dei nodi-cammino
%  - Prevede i predicati aperti per la potatura dei cicli e dei nodi
%  chiusi, implementati dalle strategie di potatura


close_type([pn(state, path, number, number)]:f_node).
%   pn(P, Path, Cost, Heur):   nodo di cammino(path node):
%   - P nodo di problema
%   - Path cammino all'inverso  (sequenza di stati o di azioni)
%   - Cost costo piano
%   - Heur = euristica h(P, Path)

open_pred(prune(f_node, p_node)).
%  prune(FN,S) : il nodo S in uscita da FN è potato.
%  DFEFAULT nessuna potatura:
prune(_,_) :- fail.

open_pred(store_closed(p_node)).
% store_closed(P) : memorizza P nei nodi chiusi, se la strategia di
% potatura dei chiusi è attiva
% DEFAULT successo senza far niente:
store_closed(_).

open_pred(check_goal_bounds(info, f_node)).
%  OBBLIGATORIO, se b_strategy non è caricata si ha errore in esecuzione
%  check_goal_bounds(BS, FN): FN soddisfa i limiti BS relativi ai goals

open_pred(check_expansion_bounds(info, f_node)).
%  OBBLIGATORIO, se b_strategy non è caricata si ha errore in esecuzione
%  check_expansion_bounds(BS, FN): FN soddisfa i limiti BS relativi ai
%  nodi espansi

open_pred(init_bounds(strategy, info)).
%  OBBLIGATORIO, se b_strategy non è caricata si ha errore in esecuzione
%  init_bounds(BStrat, Bounds): Bounds sono i limiti iniziali di BStrat

open_pred(init_pruning(strategy)).
%  OBBLIGATORIO, se p_strategy non è caricata si ha errore in esecuzione
%  init_pruning(PStrat): eventuali inizializzazioni
%  Al momento p:closed azzera l'insieme dei nodi chiusi, p:cut non fa
%  nulla


ga:f_start(P,pn(P,[],0, H), BS, [FStrategy, PStrategy, BStrategy]) :-
	heuristic(P,[], H),
	consult_strategy(f_strategy, FStrategy),
	consult_strategy(p_strategy,PStrategy),
	init_pruning(PStrategy),
	consult_strategy(b_strategy, BStrategy),
	init_bounds(BStrategy,BS).

ga:f_goal(fr(no_bounds,_), Goal, pn(P,Plan,Cost,Heur), pn(P,Plan,Cost,Heur)) :- !,
	call(ga:Goal, P).
ga:f_goal(fr(BS,_), Goal, pn(P,Plan,Cost,Heur), pn(P,Plan,Cost,Heur)) :-
	check_goal_bounds(BS, pn(P,Plan,Cost,Heur)),
	call(ga:Goal, P).

ga:f_expand(FR, pn(PN,Plan,Cost,Heur), Expanded) :-
	neighbours(PN,Tr),
	extend_paths(FR,pn(PN,Plan,Cost,Heur),Tr,[],Expanded),!,
	store_closed(PN).

pred(extend_paths(fringe, f_node, list(p_node), list(f_node), list(f_node))).
%  extend_paths(FR, FN, LV, Exp1,Exp2) :
%  FN è il nodo di frontiera da espandere mediante i vicini non ancora
%  considerati LV; si ha:
%  Exp2 = Exp1 unito alle estensioni di FN non potate
%  MODO (+,+,+,+,-).
%
extend_paths(_,_, [],E, E).
extend_paths(FR, FN, [S|NextTr],E1, E2) :-
	prune(FN, S), !,
	%   Taglio dei cicli o dei chiusi
	extend_paths(FR, FN, NextTr,E1, E2).
extend_paths(fr(no_bound,Fr), pn(N,Plan,Cost, Heur), [S|NextTr],
	     Expanded1, Expanded2) :- !,
	tr(N,A,S,C),
	Cost1 is Cost+C,
	heuristic(S,[A|Plan], Heur1),!,
	extend_paths(fr(no_bound,Fr), pn(N,Plan,Cost,Heur), NextTr,
		     [pn(S,[A|Plan],Cost1,Heur1)|Expanded1],Expanded2).
extend_paths(fr(BS,Fr), pn(N,Plan,Cost, Heur), [S|NextTr],Expanded1, Expanded2) :-
	tr(N,A,S,C),
	Cost1 is Cost+C,
	heuristic(S,[A|Plan], Heur1),
	(check_expansion_bounds(BS, pn(S,[A|Plan],Cost1,Heur1)) ->
	    Expanded = [pn(S,[A|Plan],Cost1,Heur1)|Expanded1]
	;   Expanded=Expanded1), !,
	extend_paths(fr(BS,Fr), pn(N,Plan,Cost,Heur), NextTr, Expanded,Expanded2).

tr(N,A,S,C) :-
	%  Nel cammino vengono inserite le azioni A
	tr_cost([N,A,S], C).
tr(N,N,S,C) :-
	%  Nel cammino vengono inseriti i p_node N
	tr_cost([N,S], C).

section(strategies). %===============================================
%  2.  Strategie disponibili e loro caricamento.


pred(strategy(strategy, path)).
%  strategy(Strategy, Dir):   Strategy è definita nella directory Dir
%  MODO (?,?)

	%strategie definite in f_strategy
	%  sono le strategie di gestione della frontiera
strategy(S, f_strategy) :-
	member(S, [depth_first, breadth_first, lowest_cost,
		   astar, best_first]).

	%strategie definite in p_strategy
	%   sono le strategie di pruning
strategy(S, p_strategy) :-
	member(S, [cycles, closed, no_cut]).

        %strategie definite in b_strategy
	%   sono le strategie con meccanismi di limtazione dello spazio
	%   di ricerca:  bounded_search e id
strategy(bounded_search(E,Bounds), b_strategy):-
        level_predicate(E),
	(   Bounds = [_Min,_Max] ;   Bounds = [_Max]).
strategy(id(E, _StartingStep, _Up), b_strategy) :-
	level_predicate(E).

pred(level_predicate(atom)).
%  I nomi dei predicati di livello usati nelle
%  b_strategy
level_predicate(L) :-
	member(L, [depth, cost, f, priority]).
%  i predicati di livello sono definiti come segue
depth(pn(_PN,Plan,_Cost,_Heur), L) :-
	%  profondità
	length(Plan, L).
cost(pn(_PN,_Path,Cost,_Heur), Cost).
        % costo
f(pn(_PN,_Path,Cost,Heur), F) :-
	%  funzione f di A*
	F is Cost+Heur.
priority(FN, P) :-
	% priorità nella strategia attualmente in uso
	ga:f_priority(FN, P).


pred(consult_strategy(path, strategy)).
%  consult_strategy(Dir, Strat)   carica Strat dalla
%  directory Dir

consult_strategy(Dir, S) :-
	% carica il file che definisce strategia S
	% e che si trova nella directory Dir
        S =.. [Name|_],
	get_strategy_path(Dir, Path),
	%  NB, get_strategy_path usa in modo specifico
	%  le primitive di SWI per accedere ai files
	atom_concat(Path, Name, StrategyFile),
	consult(StrategyFile).





