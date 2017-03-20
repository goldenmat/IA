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

type([deserto, foresta, cielo, mare, piastrella]:terreno).
% Tipi di terreno

type([aereo, nave, carro, magnete, vuoto]:oggetto).
% Tipi di oggetto

type([start,goal]:special).
% Tipi speciali di terreno (caselle di start e goal)

type([p(indice,indice, [terreno,special], oggetto)]:casella).
% p(X,Y,T,O): casella in riga X, colonna Y, di terreno T e contenente
% oggetto O. Il terreno è special per le caselle di start e goal.
%
%           1               2	       3      ....
% 1  (1,1,start,vuoto), (1,2,T,O), (1,3,T,O), ....
% 2  (2,1,T,O),         (2,2,T,O), (2,3,T,O), ....
% 3  (3,1,T,O),         (2,3,T,O), (3,3,T,O), ....

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

pred(adiacente(cardinale,casella,casella)).
% adiacente(D,P1,P2): Il punto P1 è adiacente al punto P2 in direzione D
% MODO: (?,+,?) nondet
adiacente(D,p(X1,Y1,_,_),p(X2,Y2,_,_)) :-
	ground(X1),!,
	dir(D,DX,DY),
	X2 is X1+DX,
	Y2 is Y1+DY,
	indice(X2),
	indice(Y2).
adiacente(D,p(X1,Y1,_,_),p(X2,Y2,_,_)) :-
	ground(X2),
	dir(D,DX,DY),
	X1 is X2+DX,
	Y1 is Y2+DY,
	indice(X1),
	indice(Y1).

pred(adiacente(casella,casella)).
% adiacente(P1,P2): Il punto P1 è adiacente al punto P2
% MODO: (?,+) nondet
adiacente(P1,P2) :-
	adiacente(_,P1,P2).

pred(distanza(casella,casella,number)).
% distanza(C1,C2,N): N è la distanza di manhattan tra le caselle C1 e C2
% MODO: (+,+,-) det
distanza(p(X1,Y1,_,_),p(X2,Y2,_,_),N) :-
	N is abs(X1-X2)+abs(Y1-Y2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(fluenti).

type([in(casella), possiede(oggetto)]:fluent).
% in(C): L'agente si trova in C.
% possiede(O): L'agente possiede l'oggetto O.
