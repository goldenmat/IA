%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                          %
%	    Azioni alla STRIPS	           %
%                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(azioni).

type([va(posizione),prende(oggetto)]:action).
% va(P): L'agente va nella posizione P.
% prende(O): L'agente prende l'oggetto O.

test_state(K,[A,S2,C]) :-
	list_to_ord_set(K,S),
	do_action(A,S,S2,C).

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


