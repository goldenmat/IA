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
	not(between(2,30,Dim)), !,
	writeln("Errore, inserisci un valore della dimensione compreso tra 2 e 30")
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

pred(subset(list,list)).
% subset(L1,L2): restituisce true se L1 è un sottoinsieme ordinato di
% L2
% MODO: (+,+) semidet
% MODO: (?,+) nondet
subset([],[]).
subset(T1,[_|T2]) :-
	subset(T1,T2).
subset([H|T1],[H|T2]) :-
	prefix_subset(T1,T2).

pred(prefix_subset(list,list)).
% prefix_subset(L1,L2): restituisce true se L1 è un sottoinsieme
% ordinato di L2 che incomincia dal primo elemento (a meno che sia L1
% sia []).
% MODO: (+,+) semidet
% MODO: (?,+) nondet
prefix_subset([],_).
prefix_subset([H|T1],[H|T2]) :-
	prefix_subset(T1,T2).

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
		   writeln('-----|')
		   ;
		   write('-----|')
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
			      write(T1),
			      write('|'),
			      write(O1),
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
			      writeln('-----|')
			      ;
			      write('-----|')
			  )
			 )
	       )
	      ).

pred(stampa_mondo(list(action))).
% stampa_mondo(C): Stampa il mondo caricato in base dati dinamica, nel
% quale viene evidenziato il cammino C
% MODO: (+) semidet
stampa_mondo(C) :-
	size(D),

	write('|'),
	forall(between(1,D,K1),
	       (
		   K1 is D, !,
		   writeln('-----|')
		   ;
		   write('-----|')
	       )
	      ),

	forall(between(1,D,Row),
	       (
		   write('|'),
		   forall(between(1,D,Col),
			  (
			      mondo(c(p(Row,Col),T,O)),
			      significa(T1,T),
			      (
				  start_cell(p(Row,Col)), !,
				  ansi_format([bold, fg(green)],'S|',[]),
				  assert(attiva)
				  ;
				  member(va(p(Row,Col)),C),
				  ansi_format([bold, fg(red)],'~w|',[T1]),
				  assert(attiva)
				  ;
				  not(member(va(p(Row,Col)),C)),
				  write(T1), write('|')
			      ),
			      (
				  goal_cell(p(Row,Col)), !,
				  ansi_format([bold, fg(green)],'-G-',[]),
				  retractall(attiva)
				  ;
				  O = [magnete],
				  attiva,
				  ansi_format([bold, fg(red)],'-M-',[]),
				  retractall(attiva)
				  ;
				  stampa_oggetti(Row,Col,O,C),
				  retractall(attiva)
			      ),
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
			      writeln('-----|')
			      ;
			      write('-----|')
			  )
			 )
	       )
	      ).

pred(attiva).
% Predicato dinamico che salva la cella in considerazione, per la stampa
% del mondo
:- dynamic(attiva/0).

pred(stampa_oggetti(indice,indice,list(oggetto),list(action))).
% stampa_oggetti(Row,Col,O,Path): stampa gli oggetti O della posizione
% p(Row,Col) di colori diversi a seconda se siano stati presi nel Path o
% meno
% MODO: (+,+,+,+) det

% Caso 0
stampa_oggetti(_,_,[],_) :- !,
	significa(W,[]),
	write(W).

% Caso 1
stampa_oggetti(Row,Col,X,C) :-
	length(X,1), !,
	member(O,X),
	(
	    subset([va(p(Row,Col)),prende(O)],C),
	    (
		O = aereo,
		ansi_format([bold, fg(yellow)],'A',[]),
		write('--')
		;
		O = barca,
		write('-'),
		ansi_format([bold, fg(yellow)],'B',[]),
		write('-')
		;
		O = carro,
		write('--'),
		ansi_format([bold, fg(yellow)],'C',[])
	    )
	    ;
	    not(subset([va(p(Row,Col)),prende(O)],C)),
	    significa(W,X),
	    write(W)
	).

% Caso 2
stampa_oggetti(Row,Col,X,C) :-
	length(X,2), !,
	member(O1,X),
	member(O2,X),
	O1 \= O2,
	(
	    not(subset([va(p(Row,Col)),prende(O1)],C)),
	    not(subset([va(p(Row,Col)),prende(O2)],C)),
	    significa(W,X),
	    write(W)
	    ;
	    not(subset([va(p(Row,Col)),prende(O1),prende(O2)],C)),
	    subset([va(p(Row,Col)),prende(O1)],C),
	    (
		O1 = aereo,
		(
		    O2 = barca,
		    ansi_format([bold, fg(yellow)],'A',[]),
		    write('B-')
		    ;
		    O2 = carro,
		    ansi_format([bold, fg(yellow)],'A',[]),
		    write('-C')
		)
		;
		O1 = barca,
		(
		    O2 = aereo,
		    write('A'),
		    ansi_format([bold, fg(yellow)],'B',[]),
		    write('-')
		    ;
		    O2 = carro,
		    write('-'),
		    ansi_format([bold, fg(yellow)],'B',[]),
		    write('C')
		)
		;
		O1 = carro,
		(
		    O2 = barca,
		    write('-B'),
		    ansi_format([bold, fg(yellow)],'C',[])
		    ;
		    O2 = aereo,
		    write('A-'),
		    ansi_format([bold,fg(yellow)],'C',[])
		)
	    )
	    ;
	    subset([va(p(Row,Col)),prende(O1),prende(O2)],C),
	    (
		((O1 = aereo, O2 = barca);(O1 = barca, O2 = aereo)),
		ansi_format([bold, fg(yellow)], 'AB', []),
		write('-')
		;
		((O1 = aereo, O2 = carro);(O1 = carro, O2 = aereo)),
		ansi_format([bold, fg(yellow)], 'A', []),
		write('-'),
		ansi_format([bold, fg(yellow)], 'C', [])
		;
		((O1 = barca, O2 = carro);(O1 = carro, O2 = barca)),
		write('-'),
		ansi_format([bold,fg(yellow)], 'BC', [])
	    )
	).

% Caso 3
stampa_oggetti(Row,Col,X,C) :-
	member(O1,X),
	member(O2,X),
	member(O3,X),
	O1 \= O2,
	O1 \= O3,
	O2 \= O3,
	(
	    not(subset([va(p(Row,Col)),prende(O1)],C)),
	    not(subset([va(p(Row,Col)),prende(O2)],C)),
	    not(subset([va(p(Row,Col)),prende(O3)],C)),
	    significa(W,X),
	    write(W)
	    ;
	    not(subset([va(p(Row,Col)),prende(O1),prende(O2)],C)),
	    not(subset([va(p(Row,Col)),prende(O1),prende(O3)],C)),
	    not(subset([va(p(Row,Col)),prende(O2),prende(O3)],C)),
	    subset([va(p(Row,Col)),prende(O1)],C),
	    (
		O1 = aereo,
		ansi_format([bold, fg(yellow)],'A',[]),
		write('BC')
		;
		O1 = barca,
		write('A'),
		ansi_format([bold, fg(yellow)],'B',[]),
		write('C')
		;
		O1 = carro,
		write('AB'),
		ansi_format([bold, fg(yellow)],'C',[])
	    )
	    ;
	    not(subset([va(p(Row,Col)),prende(O1),prende(O2),prende(O3)],C)),
	    subset([va(p(Row,Col)),prende(O1),prende(O2)],C),
	    (
		((O1 = aereo, O2 = barca);(O1 = barca, O2 = aereo)),
		ansi_format([bold, fg(yellow)], 'AB', []),
		write('C')
		;
		((O1 = aereo, O2 = carro);(O1 = carro, O2 = aereo)),
		ansi_format([bold, fg(yellow)], 'A', []),
		write('B'),
		ansi_format([bold, fg(yellow)], 'C', [])
		;
		((O1 = barca, O2 = carro);(O1 = carro, O2 = barca)),
		write('A'),
		ansi_format([bold, fg(yellow)], 'BC', [])
	    )
	    ;
	    subset([va(p(Row,Col)),prende(O1),prende(O2),prende(O3)],C),
	    ansi_format([bold, fg(yellow)], 'ABC', [])
	 ).







