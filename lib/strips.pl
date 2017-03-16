:- module(strips, [do_action/4, states_to_transitions/2,  models/2]).
:- include('mchk/syntax').

open_unit.
/* -----------------------------------------------------------
STRIPS.   Una semplice implementazione di un linguaggio
di azioni alla STRIPS.
L'unità fornisce:

Il tipo state, implementato come ordset(fluent).

Il tipo transition,  con generatore tr(state, action, state)
tr(S1,A,S2)  è una transizione da S1 a S2 con azione A

Il predicato do_action(Azione, Stato, Stato), con modo:
(?, +, ?)
Dato uno stato S trova tutte le azioni A e stati S' tali
che A è eseguibile in S e fa passare a S'

Il predicato states_to_transitions(list(State), list(transition))
che mappa una sequenza di stati [S1,S2,...,Sn] nella
sequenza [tr(S1,A1,S2), tr(S2,A2,S3), ..., tr(Sn-1,An-1,Sn)].

L'utente deve fornire:

Il tipo fluent di dati dei fluenti;  i fluenti sono proprietà
del mondo che possono cambiare nel tempo.

Il tipo action delle azioni.

Il predicato  add_del(Act,St, Add, Del) che descrive l'effetto
di una azione Act possibile nello stato St tramite la lista Add
dei fluenti che diventano veri e Del di quelli che diventano falsi
------------------------------------------------------------------*/

section(simboli_definiti).%========================================
% I tipi e i predicati definiti da strips.

type(ordset(fluent) as state).
%   stati come insiemi (ordinati) di fluenti

type([tr(state,action,state)]:transition).
%  tr(S1,A,S2) rappresenta una transizione S1->A->S2

pred(do_action(action, state, state)).
%  do_action(Act, S1, S2) significa: Act fa passare da S1 a S2
%  MODO:   (-,+,-) nondet

pred(states_to_transitions(list(state), list(transition))).
%   states_transitions(L, T):  mappa una sequenza di stati
%   [S_1,S_2,....,S_n] in
%   [tr(S_1,A_1,S_2), tr(S_2,A_2,S_3),...,tr(S_n-1,A_n-1,S_n)]
%   dove A_k è l'azione che fa passare da S_k a S_k+1

pred(models(state, goal)).
%  models(ST, G) :   G vera nella interpretazione di
%  Herbrand ST  (insieme ordinato di atomiche ground,
%  caso conoscenza completa).
%  MODO:  (+,?) nondet.

section(simboli_aperti).%==========================================
% I tipi e i predicati aperti di actions.

open_type(action).
%  le azioni dell'agente che provocano le transizioni di stato

open_type(fluent).
%  i fluenti

open_pred(add_del(action, state, list(fluent), list(fluent))).
%   add_del(A, S, Add, Del) rappresenta l'effetto di una
%   azione A come segue:
%       1)   A è possibile nello stato S
%       2)   La sua esecuzione rende veri i fluenti in Add
%            e falsi quelli in Del
%  MODO:  (?, +, ?, ?) nondet.
%  Dato uno stato S,  add_del(A,S,Add,Del) trova le azioni
%  A possibili in S e il loro effetto Add e Del

section(implementazione).%==========================================
% Non documentata, vedere il codice. --------------------

do_action(Act, S1, S2, Cost) :-
	add_del(Act, S1, Add, Del, Cost),
	%  Act è possibile in S1 con
	%  effetto Add, Del; tolgo Del
	%  e aggiungo Add
	del(Del, S1, S),
	add(Add,S,S2).

del([X|L], S, S1) :-
	ord_del_element(S,X,SX),
	del(L,SX,S1).
del([],S,S).

add([X|L], S, S1) :-
	ord_add_element(S,X,SX),
	add(L,SX,S1).
add([],S,S).



:- dynamic(prec/1).
states_to_transitions([S|States], Transitions) :-
	retractall(prec(_)),
	assert(prec(S)),
	maplist(to_trasition, States, Transitions).

to_trasition(S,tr(S1,A,S)) :-
	retract(prec(S1)),
	assert(prec(S)),
	do_action(A,S1,S,_).

models(ST, Body) :-
	is_list(Body), !,
	maplist(models(ST), Body).
models(ST, non(F)) :- !,
	not(member(F,ST)).
models(ST, forall(P, Q)) :- !,
	forall(P, models(ST,Q)).
models(_ST, call(P)) :- !,
	call(P).
models(ST, F) :-
	member(F,ST).




