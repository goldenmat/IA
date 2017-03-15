type(indice).
%   indici usati per le posizioni sulla griglia

%  get_size determina predicato aperto che fornisce la dimensione della
%  mappa, supposta quadrata; è fornito dalla base dati che rppresenta il
%  mondo attuale
indice(I) :-
	get_size(Max),
	between(1,Max,I).  % 1?? lasciamo davvero uno? inutile minimo 4, direi

type(deserto).
type(foresta).
type(cielo).
type(mare).
type(piastrella).
%  tipo di terreno

type([deserto, foresta, cielo, mare, piastrella]:terreno).
%  insieme dei tipi di terreno

type(aereo).
type(nave).
type(carro).
type(magnete).
type(vuoto).
%  tipi di oggetti

type([aereo, nave, carro, magnete, vuoto]:oggetto).
%  insieme degli oggetti


type([p(indice,indice, terreno, oggetto)]:casella).
%   p(X,Y) :  casella in riga X e colonna Y
%        1      2      3    ...
%   1  (1,1), (1,2), (1,3), ....
%   2  (2,1), (2,2), (2,3), ....
%   3  (3,1), (2,3), (3,3), ....



pred(adiacente(casella, casella, terreno, oggetto)).
%  adiacente(P1, P2) se P1 è adiacente a P2

adiacente(p(X1,Y1,_,_), p(X2,Y2,_,_)) :-
	( 1 is abs(X2-X1),
	  0 is abs(Y2-Y1)),!
	  ;
	( 1 is abs(Y2-Y1),
	  0 is abs(X2-X1)).

pred(distanza(tipo_distanza,casella,casella,number)).
%  distanza(D,P1,P2,X) :  distanza D fra P1 e P2 = X
%  dove D è una distanza; implementate manhattan e euclide

distanza(manhattan, p(X1,Y1,_,_),p(X2,Y2,_,_),M) :-
	M is abs(X1-X2)+abs(Y1-Y2).


