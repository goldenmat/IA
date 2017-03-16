%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                          %
%    Generazione di mondi pseudocasuali    %
%                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(pred_dinamici).
% Predicati per la base dati dinamica

pred(size(integer)).
% size(Dim): Predicato dinamico che indica la grandezza del mondo preso
% in considerazione (come lato di un quadrato).
pred(mondo(casella)).
% mondo(X): Predicato dinamico che indica come è composto il mondo preso
% in considerazione (caselle in basi dati dinamica).
:- dynamic(size/1).
:- dynamic(mondo/1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(generazione).
% Generazione random del mondo

pred(genera_mondo(integer)).
% genera_mondo(Dim): Genera un mondo casuale, di dimensione Dim
% MODO: (+) det
genera_mondo(Dim) :-
	not(between(2,10,Dim)), !,
	writeln("Errore, inserisci un valore della dimensione compreso tra 2 e 10")
	;
	retractall(size(_)),
	retractall(mondo(_)),
	assert(size(Dim)),
	assert(mondo(p(1,1,start,vuoto))),
	forall(between(2,Dim,X1),
	       (
	           casella_random(T,O),
		   assert(mondo(p(1,X1,T,O)))
	       )
	      ),
	Dim2 is Dim-1,
	forall(between(2,Dim2,X2),
	       (
	       forall(between(1,Dim,X3),
		      (
			  casella_random(T,O),
			  assert(mondo(p(X2,X3,T,O)))
		      )
		     )
	       )),
	forall(between(1,Dim2,X4),
	       (
	           casella_random(T,O),
		   assert(mondo(p(Dim,X4,T,O)))
	       )
	      ),
	assert(mondo(p(Dim,Dim,goal,vuoto))).

pred(get_mondo(mondo)).
% get_mondo(X): Stampa il mondo come elenco di caselle
% MODO: (?) nondet
get_mondo(X) :- mondo(X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(random).
% Generazione random delle caselle

pred(casella_random(terreno, oggetto)).
% casella_random(T,O): Genera una terreno T e oggetto O casuali
% MODO: (-,-) det
casella_random(T,O) :-
	terreno_random(T),
	(
	    (
	        T = cielo;
	        T = mare
	    ), !,
	    O = vuoto
	    ;
	    T = deserto, !,
	    oggetto_d_random(O)
	    ;
	    oggetto_f_random(O)
	).

pred(terrano_random(terreno)).
% terreno_random(T): Genera un terreno casuale
% MODO: (-) det
terreno_random(R) :-
	random(1,7,X),
	associa_t(X,R).

pred(associa_t(integer,terreno)).
% associa_t(X,T): Associa il numero X al terreno T, per la generazione
% casuale
% MODO: (+,-) det
associa_t(1,mare) :- !.
associa_t(2,cielo) :- !.
associa_t(X,foresta) :-
	between(3,4,X), !.
associa_t(Y,deserto) :-
	between(5,6,Y).

pred(oggetto_f_random(oggetto)).
% oggetto_f_random(O): Genera un oggetto casuale per il terreno foresta
% MODO: (-) det
oggetto_f_random(O) :-
	random(1,11,X),
	associa_o_f(X,O).

pred(associa_o_f(integer,oggetto)).
% associa_o_f(X,O): Associa il numero X all'oggetto O, per la
% generazione casuale degli oggetti del terreno foresta
% MODO: (+,-) det
associa_o_f(1,carro) :- !.
associa_o_f(2,barca) :- !.
associa_o_f(3,aereo) :- !.
associa_o_f(4,magnete) :- !.
associa_o_f(X,vuoto) :-
	between(5,10,X).

pred(oggetto_d_random(oggetto)).
% oggetto_d_random(O): Genera un oggetto casuale per il terreno deserto
% MODO: (-) det
oggetto_d_random(O) :-
	random(1,10,X),
	associa_o_d(X,O).

pred(associa_o_d(integer,oggetto)).
% associa_o_d(X,O): Associa il numero X all'oggetto O, per la
% generazione casuale degli oggetti del terreno deserto
% MODO: (+,-) det
associa_o_d(1, barca) :- !.
associa_o_d(2, aereo) :- !.
associa_o_d(3, magnete) :- !.
associa_o_d(X, vuoto) :-
	between(4,9,X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(visualizzazione).
% Visualizzazione di un mondo

pred(significa([integer,atom],[terreno,oggetto,special])).
% Significa(S,X): associa a X il simbolo S.
% MODO: (-,+) det
significa(1,cielo).
significa(2,mare).
significa(3,foresta).
significa(4,deserto).
significa('A',aereo).
significa('B',barca).
significa('C',carro).
significa('M',magnete).
significa('S',start).
significa('G',goal).
significa(-,vuoto).

pred(stampa_mondo).
% stampa_mondo: Stampa il mondo caricato in base dati dinamica
% MODO: semidet
stampa_mondo :-
	size(D),

	write('|'),
	forall(between(1,D,K1),
	       (
		   K1 is D, !,
		   writeln('----|')
		   ;
		   write('----|')
	       )
	      ),

	forall(between(1,D,Row),
	       (
		   write('|'),
		   forall(between(1,D,Col),
			  (
			      mondo(p(Row,Col,T,O)),
			      significa(T1,T),
			      significa(O1,O),
			      write(' '),
			      write(T1),
			      write(O1),
			      write(' '),
			      (
			      Col is D, !,
			      writeln('|')
			      ;
			      write('|')
			      )
			  )
			 ),

		   write('|'),
		   forall(between(1,D,K2),
			  (
			      K2 is D, !,
			      writeln('----|')
			      ;
			      write('----|')
			  )
			 )
	       )
	      ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(mondi_tipo).
% Mondi pre-generati per rappresentare diverse situazioni

pred(carica_mondo(atom)).
% carica_mondo(X): Carica in base dati dinamica il mondo X
% MODO: (+) semidet
carica_mondo(mondo1) :-
	retractall(size(_)),
	retractall(mondo(_)),
	assert(size(5)),
	assert(mondo(p(1, 1, start, vuoto))),
	assert(mondo(p(1, 2, foresta, vuoto))),
	assert(mondo(p(1, 3, foresta, vuoto))),
	assert(mondo(p(1, 4, deserto, magnete))),
	assert(mondo(p(1, 5, mare, vuoto))),
	assert(mondo(p(2, 1, deserto, vuoto))),
	assert(mondo(p(2, 2, deserto, magnete))),
	assert(mondo(p(2, 3, mare, vuoto))),
	assert(mondo(p(2, 4, foresta, carro))),
	assert(mondo(p(2, 5, deserto, magnete))),
	assert(mondo(p(3, 1, cielo, vuoto))),
	assert(mondo(p(3, 2, mare, vuoto))),
	assert(mondo(p(3, 3, cielo, vuoto))),
	assert(mondo(p(3, 4, cielo, vuoto))),
	assert(mondo(p(3, 5, cielo, vuoto))),
	assert(mondo(p(4, 1, foresta, carro))),
	assert(mondo(p(4, 2, foresta, magnete))),
	assert(mondo(p(4, 3, mare, vuoto))),
	assert(mondo(p(4, 4, deserto, magnete))),
	assert(mondo(p(4, 5, foresta, magnete))),
	assert(mondo(p(5, 1, cielo, vuoto))),
	assert(mondo(p(5, 2, cielo, vuoto))),
        assert(mondo(p(5, 3, deserto, aereo))),
	assert(mondo(p(5, 4, mare, vuoto))),
	assert(mondo(p(5, 5, goal, vuoto))).

carica_mondo(mondo2) :-
	retractall(size(_)),
	retractall(mondo(_)),
	assert(size(5)),
	assert(mondo(p(1, 1, start, vuoto))),
	assert(mondo(p(1, 2, foresta, vuoto))),
	assert(mondo(p(1, 3, foresta, aereo))),
	assert(mondo(p(1, 4, deserto, magnete))),
	assert(mondo(p(1, 5, mare, vuoto))),
	assert(mondo(p(2, 1, deserto, aereo))),
	assert(mondo(p(2, 2, deserto, magnete))),
	assert(mondo(p(2, 3, mare, vuoto))),
	assert(mondo(p(2, 4, foresta, carro))),
	assert(mondo(p(2, 5, deserto, magnete))),
	assert(mondo(p(3, 1, cielo, vuoto))),
	assert(mondo(p(3, 2, deserto, magnete))),
	assert(mondo(p(3, 3, cielo, vuoto))),
	assert(mondo(p(3, 4, cielo, vuoto))),
	assert(mondo(p(3, 5, cielo, vuoto))),
	assert(mondo(p(4, 1, foresta, carro))),
	assert(mondo(p(4, 2, foresta, magnete))),
	assert(mondo(p(4, 3, cielo, vuoto))),
	assert(mondo(p(4, 4, deserto, magnete))),
	assert(mondo(p(4, 5, foresta, magnete))),
	assert(mondo(p(5, 1, cielo, vuoto))),
	assert(mondo(p(5, 2, foresta, vuoto))),
        assert(mondo(p(5, 3, deserto, barca))),
	assert(mondo(p(5, 4, mare, vuoto))),
	assert(mondo(p(5, 5, goal, vuoto))).

carica_mondo(mondo3) :-
	retractall(size(_)),
	retractall(mondo(_)),
	assert(size(5)),
	assert(mondo(p(1, 1, start, vuoto))),
	assert(mondo(p(1, 2, foresta, vuoto))),
	assert(mondo(p(1, 3, foresta, aereo))),
	assert(mondo(p(1, 4, deserto, magnete))),
	assert(mondo(p(1, 5, mare, vuoto))),
	assert(mondo(p(2, 1, deserto, aereo))),
	assert(mondo(p(2, 2, deserto, magnete))),
	assert(mondo(p(2, 3, mare, vuoto))),
	assert(mondo(p(2, 4, foresta, carro))),
	assert(mondo(p(2, 5, deserto, magnete))),
	assert(mondo(p(3, 1, cielo, vuoto))),
	assert(mondo(p(3, 2, mare, vuoto))),
	assert(mondo(p(3, 3, cielo, vuoto))),
	assert(mondo(p(3, 4, cielo, vuoto))),
	assert(mondo(p(3, 5, cielo, vuoto))),
	assert(mondo(p(4, 1, foresta, carro))),
	assert(mondo(p(4, 2, foresta, magnete))),
	assert(mondo(p(4, 3, cielo, vuoto))),
	assert(mondo(p(4, 4, deserto, magnete))),
	assert(mondo(p(4, 5, foresta, magnete))),
	assert(mondo(p(5, 1, cielo, vuoto))),
	assert(mondo(p(5, 2, cielo, vuoto))),
        assert(mondo(p(5, 3, deserto, barca))),
	assert(mondo(p(5, 4, mare, vuoto))),
	assert(mondo(p(5, 5, goal, vuoto))).






