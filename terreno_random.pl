% Generazione random del mondo

genera_mondo(Mondo,Dim) :-
	not(between(1,10,Dim)), !,
	writeln("Errore, inserisci un valore della dimensione compreso tra 1 e 10")
	;
	Mondo1 = [p(1,1,piastrelle,vuoto)],
	forall(between(1,Dim,R1),
	       (
		   aggiungi_casella(Mondo1, 1, R1, Mondo1)
	       )
	      ),
	append(Mondo1,[p(Dim,Dim,piastrelle,vuoto)],Mondo).

aggiungi_casella(Mondo, Dim1, Dim2, Result) :-
	casella_random(T,O),
	append(Mondo, c(Dim1, Dim2, T, O), Result).

section(generazione_random).

% Generazione random delle caselle

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
	    oggetto_random(O)
	).

terreno_random(R) :-
	random(1,7,X),
	associa_t(X,R).

associa_t(1,mare) :- !.
associa_t(2,cielo) :- !.
associa_t(X,foresta) :-
	between(3,4,X), !.
associa_t(Y,deserto) :-
	between(5,6,Y).

oggetto_random(O) :-
	random(1,11,X),
	associa_o(X,O).

associa_o(1,carro) :- !.
associa_o(2,barca) :- !.
associa_o(3,aereo) :- !.
associa_o(4,magnete) :- !.
associa_o(X,vuoto) :-
	between(5,10,X).

oggetto_d_random(O) :-
	random(1,10,X),
	associa_o_d(X,O).

associa_o_d(1,barca) :- !.
associa_o_d(2, aereo) :- !.
associa_o_d(3, magnete) :- !.
associa_o_d(X, vuoto) :-
	between(4,9,X).

% Visualizzazione di un mondo

stampa_mondo :-
	dimensione(D),
	write(+),
	forall(between(1,D,K),
	       (
		   K is D, !,
		   writeln(--+)
		   ;
		   write(--+)
	       ),
	      ),
	forall(between(1,D,J),

	       write(+),
	       forall(between(1,D,K),
		      (
			  K is D, !,
			  writeln(--+)
			  ;
			  write(--+)
		      ),
		     )
	      ).
