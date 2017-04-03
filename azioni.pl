%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                          %
%	    Azioni alla STRIPS	           %
%                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(azioni).

type([va(posizione),prende(oggetto)]:action).
% va(P): L'agente va nella posizione P.
% prende(O): L'agente prende l'oggetto O.

strips:add_del(va(P),State,[in(P)],[in(C)|DEL],Cost) :-
	member(in(C),State),
	adiacente(C,P),
	mondo(c(P,T,[magnete])),
	costo(T,[],Cost),
        findall(possiede(X),(member(possiede(X),State)),DEL).

strips:add_del(va(P),State,[in(P)],[in(C)],Cost) :-
	member(in(C),State),
	adiacente(C,P),
	mondo(c(P,T,O)),
	not(member(magnete,O)),
	richiesto(T,R),
	(
	    R = []
	    ;
	    member(possiede(Ri),State),
	    member(Ri,R)
	),
	findall(X,(member(possiede(X),State)),Poss),
	costo(T,Poss,Cost).

strips:add_del(prende(X),State,[possiede(X)],[],1) :-
	member(in(P),State),
	mondo(c(P,_,O)),
	member(X,O),
	prendibile(X),
	not(member(possiede(X),State)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(debugging).

pred(debug_action(atom,state)).
% debug_action(S,Start): Mostra la lista delle azioni identificate
% dal piano dell'algoritmo partendo da Start per arrivare a un qualsiasi
% goal con strategia S.
% MODO: (+,+) nondet
debug_action(Strat,Start) :-
	clear_heuristic,
	load_strategy([Strat]),
	member(in(p(S1,S2)),Start),
	solve(start(Start), goal(_Goal), pn(LastNode, Rev, _C, _H)),
	Rev=[X|_],
	   (
		is_a(action,X) ->
		reverse(Rev,Path),
		writeln('--------------------'),
		write('Stato di partenza: '),
		writeln(Start),
		writeln('--------------------'),
		writeln('* Lista azioni *'),
		maplist(writeln,Path),
		writeln('--------------------'),
		length(Path,L),
		write('Cammino di lunghezza: '), writeln(L),
		write('Stato finale: '), writeln(LastNode),
		writeln('--------------------'),
		writeln('Cammino agente'),
		stampa_mondo([va(p(S1,S2))|Path])
		;
		reverse(Rev,Path),
		writeln('--------------------'),
		writeln('* Lista stati *'),
		maplist(writeln,Path),
		writeln('--------------------'),
		length(Path,L),
		write('Cammino di lunghezza: '), writeln(L),
		write('Stato finale: '), writeln(LastNode),
		writeln('--------------------'),
		writeln('Cammino agente'),
		stampa_mondo([va(p(S1,S2))|Path])
	    ).




