%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                           %
%   PROGETTO (tipo 2) - Mondo accidentato   %
%              Barban Gabriele              %
%              Chiesa Samuele               %
%              Dell'Oro Matteo              %
%                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- include(library(is_a)).
:- use_module(library(search)).
:- use_module(library(strips)).
:- include(library(declaration_syntax)).

section(ontologia).
% Parte 1 - Include i file dell'ontologia, della generazione di mondi e
% dei mondi salvati.

:- consult(ontologia).
:- consult(generazione).
:- consult(salvati).

section(azioni).
% Parte 2 - Include il file delle azioni alla STRIPS

:- consult(azioni).

section(pianificazione).

% Parte 3 - Include il file che definisce i vicini di un nodo, la forma
% dei cammini e implementa le euristiche

:- consult(pianificazione).

section(soluzione).

% Parte 4 - Include il file che definisce l'algoritmo di soluzione

:- consult(soluzione).





