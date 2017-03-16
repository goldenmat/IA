:- module(ga_paths, [get_strategy_path/2]).

% E' specifico di SWI su Windows. IMPLEMENTA get_strategy_path
% che determina il path della directory GaPath all'interno di lib.
% Funziona anche su Ubuntu.
% Da vedere cosa accade su Mac.

get_strategy_path(GaPath, SPath) :-
	module_property(ga_paths,file(File)),
	file_directory_name(File, GaDir),
	atomic_list_concat([GaDir,'/',GaPath, '/'], SPath).
