:- module(ga, [solve/4,
	       search/4
	       ]).
:- include('../mchk/syntax').

open_unit.
%  ga:  acronimo di "generic algorithm"

open_type(f_node).
%  un nodo di frontiera contiene un nodo di problema
%  ed eventuali informazioni addizionali, necessarie per
%  selezionare il nodo, tagliarlo, ecc.
%
open_type(collection).
%  collezione di f_node, con operazioni di inserimento ed estrazione
%
open_type(info_node).
%  informazioni sul nodo in esame
%
type([fr(info,collection)]:fringe).
%  fr(Info, Active) contiene una collezione di nodi attivi in frontiera
%  ed eventuali informazioni utili per la selezione e inserimento dei
%  nodi di frontiera
%
open_pred(f_empty(any, fringe)).
%  f_empty(Info, F0) :  F0 frontiera vuota con informazione Info
%  Modo (-) det

open_pred(f_priority(f_node, number)).
% OPZIONALE
% f_priority(N, P) :  P priorità di N in strategie
% che ordinano i nodi in base alla loro priorità
% Ogni strategia che usa f_priority lo deve chiudere

open_pred(f_select(fringe, f_node, fringe)).
%   f_select(F1, FN, F2) : seleziona ed estrae da F1 il nodo di
%   espansione corrente, lasciando il resto in F2.
%   Modo: (+,-,-) det.
%
open_pred(f_expand(fringe, f_node, list(f_node), fringe)).
%  f_expand(Fringe,FN, Exp, Fringe2): espande FN nella lista dei vicini
%  attivi Exp usando eventualmente le informazioni in Fringe1 ed
%  aggiornandole in Fringe2.
%  MODO  (+,+,-,-) det

open_pred(f_add(fringe, list(f_node), fringe)).
%  f_add(F1, Exp,F2): aggiunge Exp a F1, originando
%  F2 in base alla strategia
%  MODO: (+,+,,-) det.

open_pred(f_start(p_node, f_node, any)).
%   f_start(P0, FN, Info) :   FN è il primo f_node, costruito
%   da P0 di start e Info le informazioni addizionali su P0
%   MODO (+,-,-) det.

open_pred(f_goal(fringe, f_node, checked_node, fringe)).
%   f_goal(Fringe, FN, CK, Fringe1) verifica se FN è una
%   soluzione usando le info in Fringe e aggiornandole in Fringe1;
%   CK = solved(Sol) oppure  checked(FN)
%   Se Sol è una soluzione vale solved(Sol)
%
open_pred(id_increment(info, info)).
%  id_increment(Inf1, Inf2): si ha iterative deepening, viene
%  incrementato il livello memorizzato in Info e si itera la ricerca
%  con i nuovi limiti. SE iterative deepening non è attiva fallisce
%  e non si ha nessuna iterazione [DEFAULT]
id_increment(_,_) :- fail.

pred(solve(pred/1, pred/1,f_node)).
%   solve(Start, Goal, Sol) :   Sol nodo Goal raggiunto da
%   un nodo di start N (cioe' ottenuto con call(Start,N))


solve(Start, Goal, Sol, Strategy) :-
	call(Start, S),
	f_start(S, FN, Info, Strategy),
	f_empty(Info,Empty),!,
	solve_id(FN, Empty, Goal, Sol).

solve_id(FN, fr(Info, Empty), Goal, Sol) :-
	search(FN, fr(Info, Empty), Goal, Sol);
	id_increment(Info,NewInfo),
        solve_id(FN, fr(NewInfo, Empty), Goal, Sol).

pred(search(f_node, fringe, pred/1, f_node, number, number, number)).
%   search(FN, F, Goal, Sol, Bound, Inc1, Inc2) :
%   Caso Incr = 0:  FN nodo selezionato corrente e Sol nodo
%   Goal raggiunto da (FN unito F) con limite Bound;
%   Caso Incr > 0:  non ci sono soluzioni con profondità
%   (misurata da costo+euristica) =< Bound;  Incr è
%   l'incremento minimo
%   MODO  (+,+,+,-,+,+,-) nondet

search(FN, Fringe, Goal, Sol) :-
	f_goal(Fringe, Goal, FN, Sol)
	;
	f_expand(Fringe, FN, Expansion),
	f_add(Fringe, Expansion,Fringe2),
	f_select(Fringe2, NextFN, NextFringe),!,
	search(NextFN, NextFringe, Goal, Sol).





