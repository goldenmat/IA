check_bounds(no_bound, _) :-!.
check_bounds(id_limit(E,[Min|_]), FN) :-!,
	call(E, FN, L),
	L >= Min.
check_bounds(lev_limit(_E,[_Max]),_FN) :-!.
check_bounds(lev_limit(E,[Min,_Max]),FN) :-!,
	call(E, FN, L),
	L >= Min.
