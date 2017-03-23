%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                          %
%                Ontologia                 %
%                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(ontologia).

type(indice).
% Gli indici usati per le posizioni sulla griglia.
% size(Dim) è un predicato aperto contenuto in mondi.pl, che stabilisce
% la dimensione del lato del mondo.

indice(I) :-
	size(Max),
	between(1,Max,I).

type([p(indice,indice)]:posizione).
% Le posizioni delle caselle all'interno della griglia rappresentante il
% mondo

type([deserto, foresta, cielo, mare]:terreno).
% Tipi di terreno

type([aereo, nave, carro, magnete]:oggetto).
% Tipi di oggetto

type([c(posizione, terreno, list(oggetto))]:casella).
% c(p(X,Y),T,O): casella in riga X, colonna Y, di terreno T e contenente
% oggetto O. Il terreno è special per le caselle di start e goal.
%
%           1              2	          3       ....
% 1  c(p(1,1),T,O), c(p(1,2),T,O), c(p(1,3),T,O), ....
% 2  c(p(2,1),T,O), c(p(2,2),T,O), c(p(2,3),T,O), ....
% 3  c(p(3,1),T,O), c(p(2,3),T,O), c(p(3,3),T,O), ....

pred(costo(terreno,list(oggetto),integer)).
% costo(T,O,C): L'azione di muoversi su una casella con terreno T,
% possedendo una lista O di oggetti ha costo C.
% MODO: (+,+,-) det
costo(cielo,_,1).
costo(mare,_,2).
costo(foresta,_,3).
costo(deserto,X,2) :-
	member(carro,X), !.
costo(deserto,_X,4).

pred(richiesto(terreno,list(oggetto))).
% richiesto(T,O): Per poter muoversi su un terreno T c'è bisogno della
% lista di oggetti O
% MODO: (+,?) det
richiesto(foresta,[]).
richiesto(deserto,[]).
richiesto(mare,[barca]).
richiesto(cielo,[aereo]).

pred(prendibile(oggetto)).
% prendibile(O): L'oggetto O è prendibile dall'agente
% MODO: (+) semidet
prendibile(aereo).
prendibile(barca).
prendibile(carro).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(geometria).

type([nord,sud,ovest,est]:cardinale).
% I 4 punti cardinali.

type([0,1,-1]:spostamento).
% Spostamenti unitari, o assenza di spostamento (0).

pred(dir(cardinale,spostamento,spostamento)).
% dir(D,S1,S2): S1 e S2 sono gli spostamenti unitari in direzione D
% MODO: (-,+,+) det
% MODO: (+,-,-) det
dir(ovest,-1,0).
dir(est,1, 0).
dir(nord,0,-1).
dir(sud,0,1).

pred(adiacente(cardinale,posizione,posizione)).
% adiacente(D,P1,P2): Il punto P1 è adiacente al punto P2 in direzione D
% MODO: (?,+,?) nondet
adiacente(D,p(X1,Y1),p(X2,Y2)) :-
	ground(X1),!,
	dir(D,DX,DY),
	X2 is X1+DX,
	Y2 is Y1+DY,
	indice(X2),
	indice(Y2).
adiacente(D,p(X1,Y1),p(X2,Y2)) :-
	ground(X2),
	dir(D,DX,DY),
	X1 is X2+DX,
	Y1 is Y2+DY,
	indice(X1),
	indice(Y1).

pred(adiacente(posizione,posizione)).
% adiacente(P1,P2): Il punto P1 è adiacente al punto P2
% MODO: (?,+) nondet
adiacente(P1,P2) :-
	adiacente(_,P1,P2).

pred(distanza(atom,posizione,posizione,number)).
% distanza(D,P1,P2,N): N è la distanza di tipo D tra le posizioni P1
% e P2
% MODO: (+,+,+,-) det
distanza(manhattan,p(X1,Y1),p(X2,Y2),N) :-
	N is abs(X1-X2)+abs(Y1-Y2).
distanza(euclide,p(X1,Y1),p(X2,Y2),N) :-
	N is sqrt((X1-X2)^2+(Y1-Y2)^2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(fluenti).


type([in(posizione), possiede(oggetto)]:fluent).
% in(P): L'agente si trova nella posizione P.
% possiede(O): L'agente possiede l'oggetto O.
