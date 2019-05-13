% collection of list manipulation operations - DRAFT RJB May 90
rev([],[]).
rev([H; T],L) :- rev(T,Z), append(Z,[H],L).

append([],L,L).
append([X; L1],L2,[X; L3]) :- append(L1,L2,L3).

nodups([]).
nodups([E|R]):-nodups(R), non_member(E,R).

subset([],_).
subset([E, ..S], T):- member(E,T), subset(S, T).

non_member(_,[]).
non_member(E,[A|B]):-E\=A, non_member(E,B).

ascending([]).
ascending([R]).
ascending([E1|R]):-R=[E2|R2], E1<E2, ascending(R).

sort([], []):-!. sort([A], [A]):-!.
sort([A, B], [A, B]):- A<=B,!.
sort([A, B], [B, A]):- B<A,!.
sort(A, B):- split(A, A1, A2), sort(A1, B1), sort(A2, B2), merge(B1,B2,B).

split([],[],[]):-!.  split([A],[],[A]):-!.  
split([A1, A2|A3], [A1|B1], [A2|B2]):-split(A3, B1, B2).

merge(A,A,A):-!. merge([],A,A):-!. merge(A,[],A):-!.
merge([A1|A],[B1|B],[A1|C]):-A1<=B1,merge(A,      [B1|B],C).
merge([A1|A],[B1|B],[B1|C]):-A1>B1, merge([A1|A],B,      C).

permuted(A,B):-sort(A,C),sort(B,C).

common(A,A,A):-!. common([],A,A):-!. common(A,[],A):-!.
common([A1|A],[A1|B],[A1|C]):-common(A,B,C),!.
common([A1|A],[B1|B],C):-common(A,B,C).

