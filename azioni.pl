%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                          %
%	    Azioni alla STRIPS	           %
%                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(azioni).

type([va(casella),prende(oggetto)]:action).
% va(C): L'agente va nella casella C.
% prende(O): L'agente prende l'oggetto O.

% Cambiare caselle in posizioni
% Creare predicato/3 che associa terreni, lista di oggetti posseduti e
% costi

mondo(p(X,Y),T,[]) :-
	mondo(p(X,Y,T,vuoto)).
mondo(p(X,Y),T,[O]) :-
	mondo(p(X,Y,T,O)),
	O \= vuoto.

stato(1,X) :-
	list_to_ord_set([in(p(1,2)),possiede(barca)],X).

test(K,[A,S2,C]) :-
	stato(K,S),
	do_action(A,S,S2,C).

%Aggiornare costo da 1 a Cost
strips:add_del(va(P),State,[in(P)],[in(C)|DEL],1) :-
	member(in(C),State),
	adiacente(C,P),
	mondo(p(P,_T,[magnete])),
%	costo(T,[],Cost),
        findall(possiede(X),(member(possiede(X),State)),DEL).

strips:add_del(va(P),State,[in(P)],[in(C)],Cost) :-
	member(in(C),State),
	adiacente(C,P),
	mondo(p(P,T,O)),
	not(member(magnete,O)),
	findall(X,(member(possiede(X),State)),Posseduti),
	costo(Posseduti),
	costo(T,Posseduti,Cost).

strips:add_del(va(p(X,Y,foresta,_)),State,[in(p(X,Y,foresta,_))],[in(C)],3) :-
	member(in(C),State),
	adiacente(C,p(X,Y,foresta,_)).

strips:add_del(va(p(X,Y,deserto,magnete)),State,[in(p(X,Y,deserto,magnete))],[in(C),possiede(_)],2) :- member(possiede(carro),State), !,
	member(in(C),State),
	adiacente(C,p(X,Y,deserto,magnete)).

strips:add_del(va(p(X,Y,deserto,_)),State,[in(p(X,Y,deserto,_))],[in(C)],2) :- member(possiede(carro),State), !,
	member(in(C),State),
	adiacente(C,p(X,Y,deserto,_)).

strips:add_del(va(p(X,Y,deserto,magnete)),State,[in(p(X,Y,deserto,magnete))],[in(C),possiede(_)],4) :- !,
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

strips:add_del(va(p(X,Y,goal,vuoto)),State,[in(p(X,Y,goal,vuoto))],[in(C)],1) :-
	member(in(C),State),
	adiacente(C,p(X,Y,goal,vuoto)).

strips:add_del(prende(X),State,[possiede(X)],[],1) :-
	(
	X = carro
	;
	X = barca
	;
	X = aereo
        ),
	not(member(possiede,X),State),
	member(in(p(_,_,_,X),State)).

%stato_prova(1,ST) :-
%	list_to_ord_set([in(p(2,2))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(debugging).
