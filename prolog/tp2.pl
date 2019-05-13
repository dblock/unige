%  (c) Daniel Doubrovkine - S.T.I. - uniGe.CH - All Rights Reserved - 1996 
%        doubrov5@cui.unige.ch / http://www.infomaniak.ch/~dblock
% ==========================================================================
%                 Prolog Second Lab (19.11.96) - Lists
% ==========================================================================
% note: Prolog Rulz.

% there're system predicates is_list and concat
% neithertheless, here's a redifinition

        islist([]).                
        islist([_|Tail]) :- islist(Tail).

% first item in the new list: head of the first list
% second item is the new list is the concatenation of the tail of the first
% list with the second list...

% concatenating right list to left list

        rconcat([], Z, Z).
        rconcat([A|X], Y, [A|Z]) :- rconcat(X, Y, Z).

% concatenating left list to right list

        lconcat(Z, [], Z).
        lconcat(X, [A|Y], [A|Z]) :- lconcat(X, Y, Z).

% length of a list

        llen([], Z) :- Z is 0.
        llen([_|Tail],Z) :- llen(Tail, X), Z is X + 1.

% --------------------------------------------------------------------------
% some fun stuff you can do with a list
% (to make this lab complete for future generations:)
% --------------------------------------------------------------------------
% functions built in SWI:

%       member(X,[X|R]).
%       member(X,[Y|R]) :- member(X,R).
 
%       intersection([X|Y],M,[X|Z]) :- member(X,M), intersection(Y,M,Z).
%       intersection([X|Y],M,Z) :- \+ member(X,M), intersection(Y,M,Z).
%       intersection([],M,[]).

%       union([X|Y],Z,W) :- member(X,Z),  union(Y,Z,W).
%       union([X|Y],Z,[X|W]) :- \+ member(X,Z), union(Y,Z,W).
%       union([],Z,Z).

%       subset([X|R],S) :- member(X,S), subset(R,S).
%       subset([],_).

%       reverse([X|Y],Z,W) :- reverse(Y,[X|Z],W).
%       reverse([],X,X).
%       reverse(A,R) :- reverse(A,[],R).

% merge sorts numerical values in a list

        mergesort([],[]).
        mergesort([A],[A]).
        mergesort([A,B|R],S) :-  
                split([A,B|R],L1,L2),
                mergesort(L1,S1),
                mergesort(L2,S2),
                merge(S1,S2,S).

                split([],[],[]).
                split([A],[A],[]).
                split([A,B|R],[A|Ra],[B|Rb]) :-  split(R,Ra,Rb).

% merges numerical lists in order

        merge(A,[],A).
        merge([],B,B).
        merge([A|Ra],[B|Rb],[A|M]) :-  A =<B, merge(Ra,[B|Rb],M).
        merge([A|Ra],[B|Rb],[B|M]) :-  A >B,  merge([A|Ra],Rb,M).
