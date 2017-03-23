%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                          %
%	       Mondi salvati		   %
%                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(mondi_salvati).
% Mondi pre-generati per rappresentare diverse situazioni

pred(carica_mondo(atom)).
% carica_mondo(X): Carica in base dati dinamica il mondo X
% MODO: (+) semidet
carica_mondo(mondo1) :-
	retractall(size(_)),
	retractall(mondo(_)),
	assert(size(5)),
	assert(mondo(c(p(1, 1), foresta, []))),
	assert(mondo(c(p(1, 2), foresta, []))),
	assert(mondo(c(p(1, 3), foresta, []))),
	assert(mondo(c(p(1, 4), deserto, [magnete]))),
	assert(mondo(c(p(1, 5), mare, []))),
	assert(mondo(c(p(2, 1), deserto, []))),
	assert(mondo(c(p(2, 2), deserto, [magnete]))),
	assert(mondo(c(p(2, 3), mare, []))),
	assert(mondo(c(p(2, 4), foresta, [carro]))),
	assert(mondo(c(p(2, 5), deserto, [magnete]))),
	assert(mondo(c(p(3, 1), cielo, []))),
	assert(mondo(c(p(3, 2), mare, []))),
	assert(mondo(c(p(3, 3), cielo, []))),
	assert(mondo(c(p(3, 4), cielo, []))),
	assert(mondo(c(p(3, 5), cielo, []))),
	assert(mondo(c(p(4, 1), foresta, [carro]))),
	assert(mondo(c(p(4, 2), foresta, [magnete]))),
	assert(mondo(c(p(4, 3), mare, []))),
	assert(mondo(c(p(4, 4), deserto, [magnete]))),
	assert(mondo(c(p(4, 5), foresta, [magnete]))),
	assert(mondo(c(p(5, 1), cielo, []))),
	assert(mondo(c(p(5, 2), cielo, []))),
        assert(mondo(c(p(5, 3), deserto, [aereo]))),
	assert(mondo(c(p(5, 4), mare, []))),
	assert(mondo(c(p(5, 5), foresta, []))).

carica_mondo(mondo2) :-
	retractall(size(_)),
	retractall(mondo(_)),
	assert(size(5)),
	assert(mondo(c(p(1, 1), foresta, []))),
	assert(mondo(c(p(1, 2), foresta, []))),
	assert(mondo(c(p(1, 3), foresta, [aereo]))),
	assert(mondo(c(p(1, 4), deserto, [magnete]))),
	assert(mondo(c(p(1, 5), mare, []))),
	assert(mondo(c(p(2, 1), deserto, [aereo]))),
	assert(mondo(c(p(2, 2), deserto, [magnete]))),
	assert(mondo(c(p(2, 3), mare, []))),
	assert(mondo(c(p(2, 4), foresta, [carro]))),
	assert(mondo(c(p(2, 5), deserto, [magnete]))),
	assert(mondo(c(p(3, 1), cielo, []))),
	assert(mondo(c(p(3, 2), deserto, [magnete]))),
	assert(mondo(c(p(3, 3), cielo, []))),
	assert(mondo(c(p(3, 4), cielo, []))),
	assert(mondo(c(p(3, 5), cielo, []))),
	assert(mondo(c(p(4, 1), foresta, [carro]))),
	assert(mondo(c(p(4, 2), foresta, [magnete]))),
	assert(mondo(c(p(4, 3), cielo, []))),
	assert(mondo(c(p(4, 4), deserto, [magnete]))),
	assert(mondo(c(p(4, 5), foresta, [magnete]))),
	assert(mondo(c(p(5, 1), cielo, []))),
	assert(mondo(c(p(5, 2), foresta, []))),
        assert(mondo(c(p(5, 3), deserto, [barca]))),
	assert(mondo(c(p(5, 4), mare, []))),
	assert(mondo(c(p(5, 5), foresta, []))).

carica_mondo(mondo3) :-
	retractall(size(_)),
	retractall(mondo(_)),
	assert(size(5)),
	assert(mondo(c(p(1, 1), foresta, []))),
	assert(mondo(c(p(1, 2), foresta, []))),
	assert(mondo(c(p(1, 3), foresta, [aereo]))),
	assert(mondo(c(p(1, 4), deserto, [magnete]))),
	assert(mondo(c(p(1, 5), mare, []))),
	assert(mondo(c(p(2, 1), deserto, [aereo]))),
	assert(mondo(c(p(2, 2), deserto, [magnete]))),
	assert(mondo(c(p(2, 3), mare, []))),
	assert(mondo(c(p(2, 4), foresta, [carro]))),
	assert(mondo(c(p(2, 5), deserto, [magnete]))),
	assert(mondo(c(p(3, 1), cielo, []))),
	assert(mondo(c(p(3, 2), mare, []))),
	assert(mondo(c(p(3, 3), cielo, []))),
	assert(mondo(c(p(3, 4), cielo, []))),
	assert(mondo(c(p(3, 5), cielo, []))),
	assert(mondo(c(p(4, 1), foresta, [carro]))),
	assert(mondo(c(p(4, 2), foresta, [magnete]))),
	assert(mondo(c(p(4, 3), cielo, []))),
	assert(mondo(c(p(4, 4), deserto, [magnete]))),
	assert(mondo(c(p(4, 5), foresta, [magnete]))),
	assert(mondo(c(p(5, 1), cielo, []))),
	assert(mondo(c(p(5, 2), cielo, []))),
        assert(mondo(c(p(5, 3), deserto, [barca]))),
	assert(mondo(c(p(5, 4), mare, []))),
	assert(mondo(c(p(5, 5), foresta, []))).
