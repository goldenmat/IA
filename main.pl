:- include(library(is_a)).
:- use_module(library(search)).
:- use_module(library(strips)).
:- include(library(declaration_syntax)).

section(ontologia).
% Parte 1 - Include i file dell'ontologia e della generazione di mondi

:- consult(ontologia).
:- consult(mondi).

section(azioni).
% Parte 2 - Include il file delle azioni alla STRIPS

:- consult(azioni).
