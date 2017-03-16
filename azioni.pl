%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                          %
%	    Azioni alla STRIPS	           %
%                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(azioni).

type([va(casella),prende(oggetto)]:action).
% va(C): L'agente va nella casella C.
% prende(O): L'agente prende l'oggetto O.

strips:add_del(va(p(X,Y,foresta,magnete)),State,[in(p(X,Y,foresta,magnete))],[in(C),possiede(barca),possiede(carro),possiede(aereo)],3) :- !,
	member(in(C),State),
	adiacente(C,p(X,Y,foresta,magnete)).

strips:add_del(va(p(X,Y,foresta,_)),State,[in(p(X,Y,foresta,_))],[in(C)],3) :-
	member(in(C),State),
	adiacente(C,p(X,Y,foresta,_)).

strips:add_del(va(p(X,Y,deserto,magnete)),State,[in(p(X,Y,deserto,magnete))],[in(C),possiede(barca),possiede(carro),possiede(aereo)],2) :- member(possiede(carro),State), !,
	member(in(C),State),
	adiacente(C,p(X,Y,deserto,magnete)).

strips:add_del(va(p(X,Y,deserto,_)),State,[in(p(X,Y,deserto,_))],[in(C)],2) :- member(possiede(carro),State), !,
	member(in(C),State),
	adiacente(C,p(X,Y,deserto,_)).

strips:add_del(va(p(X,Y,deserto,magnete)),State,[in(p(X,Y,deserto,magnete))],[in(C),possiede(barca),possiede(carro),possiede(aereo)],4) :- !,
	member(in(C),State),
	adiacente(C,p(X,Y,deserto,magnete)).

strips:add_del(va(p(X,Y,deserto,_)),State,[in(p(X,Y,deserto,_))],[in(C)],4) :-
	member(in(C),State),
	adiacente(C,p(X,Y,deserto,_)).

strips:add_del(va(p(X,Y,mare,_)),State,[in(p(X,Y,mare,_))],[in(C)],2) :-
	member(in(C),State),
	member(possiede(barca),State),
	adiacente(C,p(X,Y,mare,_)).

strips:add_del(va(p(X,Y,cielo,_)),State,[in(p(X,Y,cielo,_))],[in(C)],1) :-
	member(in(C),State),
	member(possiede(aereo),State),
	adiacente(C,p(X,Y,cielo,_)).

strips:add_del(prende(X),State,[possiede(X)],[],1) :-
	(
	X = carro
	;
	X = barca
	;
	X = aereo
       ),
	member(in(p(_,_,_,X),State)).







