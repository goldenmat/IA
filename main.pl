:- include(library(is_a)).
:- use_module(library(search)).
:- use_module(library(strips)).
:- include(library(declaration_syntax)).

:- writeln('******   COMANDI    *******'),
   nl,
   maplist(writeln, [
	       '   genera_mondo(I).',
	       '   genera un mondo con la dimensione inserita in I [I è un nat]',
	       '   stampa_mondo',
	       '   permette la visualizzazione del mondo',
	       '   get_mondo(X).',
	       '   restituisce il mondo casella per casella, X è una variabile',
	       '   carica_mondo(<mondo>).',
	       '   permette di caricare un mondo predefinito [mondo1, mondo2, mondo3]'
	   ]),
   nl, nl,
   writeln('***************************'),
   nl.

:- consult(mondi).
