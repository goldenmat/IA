:- module(search, [solve/3,
		   strategy_request/2,
		   strategy_request/1,
		   load_strategy/1,
		   get_loaded_strategy/1,
		   get_solution/3,
		   search_help/0]).
:- include('declaration_syntax').
:- use_module('ga/path_search/path_search').

search_help :-
	nl,
	maplist(writeln,
		[
		 'ALGORITMO DI RICERCA',
		 'search_help:',
		 'strategy_request(R) mostra le trategie implementate',
		 'Il problema deve definire:',
		 '    path_search:tr_cost([+N1,?N2],?C)   :  costo di un arco',
		 '		  con questa forma i cammini sono sequenze di nodi',
		 '    path_search:tr_cost([+N1,?A, ?N2],?C)   :  costo di un''azione',
		 '		  con questa forma i cammini sono sequenze di azioni',
		 '    path_search:neighbous(+N,?L)   :  L lista vicini di L',
		 '    path_search:heuristic(+N,+Path, ?H)   :  H euristica di N',
		 '                raggiunto con cammino Path',
		 'Viene fornito il predicato:',
		 '    solve(+Start, +Goal, -Sol)   : ',
		 '           Start, Goal predicati unari chiamati con call',
		 '           Sol = pn(N, RevPath, Cost, Heur)',
		 '    get_solution(+Sol, -Cost, -Path) :  estrae cammino e soluzione',
		 'Per caricare una o più strategie usare:',
		 '    load_strategy(+R)  :  R lista di richieste di strategia',
		 '    get_loded_strategy(R): mostra la strategia corrente',
		 '    strategy_reqest(+R)  :  R e'' una richiesta di strategia possibile']),
	nl.


solve(Start, Goal, Sol) :-
	get_loaded_strategy(L),!,
	solve(Start, Goal, Sol, L).

:- dynamic(loaded_strategy/1).
get_loaded_strategy([FS, PS, BS]) :-
	(   loaded_strategy(f_strategy:FS), !
	;   FS = depth_first),
	(   loaded_strategy(p_strategy:PS),!
	;   PS = no_cut),
	(   loaded_strategy(b_strategy:BS), !
	;   BS = no_bound).

load_strategy(L) :-
	is_list(L), !,
	retractall(loaded_strategy(_)),
	maplist(load_strategy, L).
load_strategy(R) :-
	strategy_request(R,S),!,
	assert(loaded_strategy(S)).

strategy_request(s:S, f_strategy:S) :-
       strategy(S, f_strategy).
strategy_request(p:S, p_strategy:S) :-
	strategy(S, p_strategy).
strategy_request(b:BS,b_strategy:Bound) :-
	strategy(Bound, b_strategy),
	bound_strategy(BS, Bound),
	explain_vars(Bound).
strategy_request(id:BS,b_strategy:Bound) :-
	strategy(Bound, b_strategy),
	id_strategy(BS, Bound),
	explain_vars(Bound).
strategy_request(R) :-
	strategy_request(R,_).

bound_strategy(no_bound, no_bound).
bound_strategy(L:Max, bounded_search(L,[0,Max])):-
	(var(Max)); not(var(Max)), not(Max=_:_),
	level_predicate(L).
bound_strategy(L:Min:Max, bounded_search(L,[Min,Max])):-
	level_predicate(L).
id_strategy(no_id, no_bound).
id_strategy(L, id(L, 0, Inf)):-
	infinite(Inf),
	level_predicate(L).
id_strategy(L:max(MaxLevel), id(L, 0, MaxLevel)):-
	level_predicate(L).
id_strategy(L:K,  id(L, K, Inf)):-
	infinite(Inf),
	level_predicate(L).
id_strategy(L:K:max(MaxLevel), id(L, K, MaxLevel)):-
	level_predicate(L).

get_solution(pn(N, RevPath, Cost, _), Cost, Path) :-
	reverse([N|RevPath], Path).

explain_vars(bounded_search(_L, [Max])) :-
	(   Max='<max>',!; true).
explain_vars(bounded_search(_L, [Min,Max])) :-
	(   Min='<min>',!; true),
	(   Max='<max>',!; true).
explain_vars(id(_L, K, Up)) :-
	( K='<livello iniziale>',!; true),
	( Up='<max>',!; true ).

infinite(Inf) :-
	catch((Inf = +inf, Inf > 0), _, Inf = 10e100).
