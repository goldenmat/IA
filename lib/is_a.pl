:- discontiguous([
       open_unit/0,
       closed_unit/0,
       open_pred/1,
       open_type/1,
       close_pred/1,
       close_type/1,
       pred/1,
       type/1,
       section/0,
       section/1,
       paragraph/0
   ]).
closed_unit.
/*
ONTOLOGIA BASATA SU TIPI; da includere MODULO OSPITANTE con
   :-include(<path di is_a>).  oppure
   :-consult(<path di is_a>).

I dati su cui lavora "is_a" sono i tipi della unità ospitante. Per
evitare circolarità e confusioni, un tipo i cui abitanti
rappresentano a loro volta tipi è detto "meta-tipo".

Metatipo delle <dichiarazioni di tipo>. Sono termini della forma:

  type(<nome predicato unario>)
  type(list(<generatore>):<nome tipo>).

Nei tipi con <nome predicato unario> T si assume che vi sia
un predicato T(X)  con
 -   modo (?) se il tipo è finito
 -   modo (+) se è infinito.

Esempio:  type(gatto).
richiede che sia definito un predicato gatto/1, ad es:
gatto(X) :-
    X = felix
    ;
    X = miao
    ;
    X=gatto(I),
    between(1,10,I).

Un generatore ha una delle forme

<nome funzione>(<tipo_1>,...,<tipo_n>)
   es.   [0,s(nat)]:nat introduce i generatori di nat
   -   0  (costante) e
   -   s(nat)  (funzione con un argomento di tipo nat)

{<tipo>}
Esempio:   [-(nat), {nat}]:z    introduce
-   {nat} indica che ogni termine di tipo nat è anche di
          tipo z
-   -(nat) indica che - mappa nat in z
*/

section(implementazione).
% Il metapredicato is_a e il generatore di array. ------------

pred(is_a(type_decl, any)).
%  is_a(T, X) :  X è un termine ground di tipo T.
%  MODI:  (+,?) e (?,+)  con tipi finiti
%          solo   (?,+)	 con tipi infiniti

is_a(Type, X) :-
	type(Gen:Type),	%dichiarazione nel modulo ospitante
	member(G,Gen),
	generates(G,X).
is_a(Type, X) :-
	type(Type), % dichiarazione nel modulo ospitante
	not(Type=_:_),
	call(Type, X).

generates({T},X) :-!,
	is_a(T,X).
generates(G,X) :-
	(   catch(functor(G,F,N),_,fail), length(Args,N), !
	;   catch(functor(X,F,N),_,fail), length(Types,N), !),
	G =.. [F|Types],
	X =.. [F|Args],
	maplist(is_a, Types, Args).

pred(array_generator(generator, atom, integer, type)).
%  array_generator(Gen, F, N, T) :  costruisce il generatore
%  F(T,T,...,T)  di arietà N
%  Es.   array_generator(Gen, f, 4, integer)
%  restituisce Gen = f(integer, integer, integer, integer)

array_generator(Gen, F, N, T) :-
	functor(Gen, F, N),
	foreach(between(1,N,K), arg(K, Gen, T)).

