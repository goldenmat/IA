
carica_mondo(mondo4) :-
        assert(mondo(c(p(1,1),foresta,[]))),
        assert(mondo(c(p(1,2),cielo,[]))),
        assert(mondo(c(p(1,3),deserto,[]))),
        assert(mondo(c(p(2,1),deserto,[]))),
        assert(mondo(c(p(2,2),deserto,[]))),
        assert(mondo(c(p(2,3),deserto,[barca]))),
        assert(mondo(c(p(3,1),mare,[]))),
        assert(mondo(c(p(3,2),foresta,[]))),
        assert(mondo(c(p(3,3),deserto,[]))).
