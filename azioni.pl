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

debug_action(Before,Strategy,After) :-
	load_strategy([Strategy]),
	solve(start(Before),goal(_),pn(After,RevPath,_,_)),
	reverse([After|RevPath],Path),
	states_to_transitions(Path,Trans),
	length(RevPath,Len),
	write('Cammino con lunghezza: '),
	maplist(writeln,[Len]),
	maplist(show_action, Trans).

show_action(X) :-
	writeln(X).
