%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                          %
%    Generazione di mondi pseudocasuali    %
%                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(predicati_dinamici).
% Predicati per la base dati dinamica

pred(size(integer)).
% size(Dim): Predicato dinamico che indica la grandezza Dim del mondo
% preso in considerazione (come lato di un quadrato).
% MODO: (-) semidet
pred(mondo(casella)).
% mondo(X): Predicato dinamico che indica come è composto il mondo preso
% in considerazione (caselle X in basi dati dinamica).
% MODO: (?) nondet
:- dynamic(size/1).
:- dynamic(mondo/1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(generazione).
% Generazione pseudorandom del mondo

pred(genera_mondo(integer)).
% genera_mondo(Dim): Genera un mondo pseudocasuale, di dimensione Dim
% MODO: (+) det
genera_mondo(Dim) :-
	not(between(2,10,Dim)), !,
	writeln("Errore, inserisci un valore della dimensione compreso tra 2 e 10")
	;
	retractall(size(_)),
	retractall(mondo(_)),
	assert(size(Dim)),
	forall(between(1,Dim,X),
	       (
	       forall(between(1,Dim,Y),
		      (
			  casella_random(T,O),
			  assert(mondo(c(p(X,Y),T,O)))
		      )
		     )
	       )
	      ).

pred(get_mondo(casella)).
% get_mondo(X): Stampa il mondo come elenco di caselle X
% MODO: (?) nondet
get_mondo(X) :- mondo(X).

pred(salva_mondo(atom)).
% salva_mondo(M): Salva il mondo in base dati dinamica nel sorgente come
% una clausola in modo che possa essere caricato tramite caricato
% utilizzando carica_mondo(M) in una seconda istanza.
salva_mondo(N) :-
	clause(carica_mondo(N),_), !,
	writeln("Errore - Il mondo esiste già, scegli un altro nome")
	;
	open('salvati.pl',append,OS,[encoding(utf8)]),
	nl(OS), write(OS,'carica_mondo('), maplist(write,[OS],[N]), write(OS,') :-'), nl(OS),
	size(D),
	tab(OS,8), write(OS,'retractall(size(_)),'), nl(OS),
	tab(OS,8), write(OS,'retractall(mondo(_)),'),nl(OS),
	tab(OS,8), write(OS,'assert(size('),maplist(write,[OS],[D]),write(OS,')),'),nl(OS),
	forall(between(1,D,X),
	       (
		   forall(between(1,D,Y),
			  (
			      tab(OS,8),
			      mondo(c(p(X,Y),T,O)),
			      write(OS,"assert(mondo(c(p("),
			      maplist(write,[OS],[X]),
			      write(OS,","),
			      maplist(write,[OS],[Y]),
			      write(OS,"),"),
			      maplist(write,[OS],[T]),
			      write(OS,","),
			      maplist(write,[OS],[O]),
			      write(OS,")))"),
			      (
				  X = D,
				  Y = D,
				  write(OS,"."),
				  nl(OS)
				  ;
				  write(OS,","),
				  nl(OS)
			      )
			  )
			 )
	       )
	      ),
	close(OS).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(random).
% Generazione pseudorandom delle caselle

pred(casella_random(terreno, list(oggetto))).
% casella_random(T,O): Genera un terreno T e lista di oggetti O
% pseudocasuali
% MODO: (-,-) det
casella_random(T,O) :-
	terreno_random(T),
	(
	    (
	        T = cielo;
	        T = mare
	    ), !,
	    O = []
	    ;
	    T = deserto, !,
	    oggetto_d_random(O)
	    ;
	    oggetto_f_random(O)
	).

pred(terreno_random(terreno)).
% terreno_random(T): Genera un terreno pseudocasuale
% MODO: (-) det
terreno_random(R) :-
	random(1,7,X),
	associa_t(X,R).

pred(associa_t(integer,terreno)).
% associa_t(X,T): Associa il numero X al terreno T, per la generazione
% pseudocasuale
% MODO: (+,-) det
associa_t(1,mare) :- !.
associa_t(2,cielo) :- !.
associa_t(X,foresta) :-
	between(3,4,X), !.
associa_t(_X,deserto).

pred(oggetto_f_random(list(oggetto))).
% oggetto_f_random(O): Genera una lista di oggetti pseudocasuale per il
% terreno foresta
% MODO: (-) det
oggetto_f_random(O) :-
	random(1,11,X),
	(
	    X = 1,
	    O = [magnete]
	    ;
	    associa_o_f(O)
	).

pred(associa_o_f(list(oggetto))).
% associa_o_f(O): Genera una lista di oggetti O, per la
% generazione pseudocasuale degli oggetti del terreno foresta
% MODO: (-) det
associa_o_f(O) :-
	O1 = [],
	random(1,5,X),
	random(1,5,Y),
	random(1,5,Z),
	(   X=1, append(O1,[aereo],O2); X\=1,O1=O2),
	(   Y=1, append(O2,[barca],O3); Y\=1,O2=O3),
	(   Z=1, append(O3,[carro],O); Z\=1,O3=O).

pred(oggetto_d_random(list(oggetto))).
% oggetto_d_random(O): Genera una lista di oggetti pseudocasuale per il
% terreno deserto
% MODO: (-) det
oggetto_d_random(O) :-
	random(1,11,X),
	(
	    X = 1,
	    O = [magnete]
	    ;
	    associa_o_d(O)
	).

pred(associa_o_d(list(oggetto))).
% associa_o_d(O): Genera una lista di oggetti O, per la
% generazione pseudocasuale degli oggetti del terreno deserto
% MODO: (-) det
associa_o_d(O) :-
	O1 = [],
	random(1,5,X),
	random(1,5,Y),
	(   X=1, append(O1,[aereo],O2); X\=1,O1=O2),
	(   Y=1, append(O2,[barca],O); Y\=1,O2=O).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(visualizzazione).
% Visualizzazione di un mondo

pred(significa(atom,[terreno,list(oggetto)])).
% significa(S,X): associa a X il simbolo S.
% MODO: (-,+) det
significa(1,cielo).
significa(2,mare).
significa(3,foresta).
significa(4,deserto).
significa('A--',[aereo]).
significa('-B-',[barca]).
significa('--C',[carro]).
significa('AB-',[aereo,barca]).
significa('A-C',[aereo,carro]).
significa('-BC',[barca,carro]).
significa('ABC',[aereo,barca,carro]).
significa('-M-',[magnete]).
significa('---',[]).

pred(stampa_mondo).
% stampa_mondo: Stampa il mondo caricato in base dati dinamica
% MODO: semidet
stampa_mondo :-
	size(D),

	write('|'),
	forall(between(1,D,K1),
	       (
		   K1 is D, !,
		   writeln('-------|')
		   ;
		   write('-------|')
	       )
	      ),

	forall(between(1,D,Row),
	       (
		   write('|'),
		   forall(between(1,D,Col),
			  (
			      mondo(c(p(Row,Col),T,O)),
			      significa(T1,T),
			      significa(O1,O),
			      write(' '),
			      write(T1),
			      write('|'),
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
			      writeln('-------|')
			      ;
			      write('-------|')
			  )
			 )
	       )
	      ).
