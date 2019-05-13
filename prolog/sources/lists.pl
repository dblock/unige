% File of predicates operating on lists
% rev(X,Y) - Y is the reverse of X
rev([],[]).
rev([H; T],L) :- rev(T,Z), append(Z,[H],L).

% append(X,Y,Z) - Z is a list starting with X and followed by Y
append([],L,L).
append([X; L1],L2,[X; L3]) :- append(L1,L2,L3).

% no_dups(X) is true if no element in X is duplicated
no_dups([]).
no_dups([E|R]):-no_dups(R), non_member(E,R).

subset([],_).
subset([E, ..S], L):- member(E,L), subset(S, L).

% non_member(E, X) is true if E is not in list X. 
%      it differs from `not member(E,X)` becuase if E is a variable the not
%      predicate backtracks and leaves E uninstanciated.
non_member(_,[]).
non_member(E,[A|B]):-E\=A, non_member(E,B).

% For a list of numeric expressions ascending tests for ascending order
ascending([]).
ascending([R]).
ascending([E1|R]):-R=[E2|R2], E1<E2, ascending(R).

:-print('rev(L,M), append(A,B,C), no_dups(L), subset(L,M), non_member(E,L), and ascending(L) loaded.').
