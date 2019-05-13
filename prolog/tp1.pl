% Prolog First Lab (c) Daniel Doubrovkine - uniGe.CH - 1996
% doubrov5@cui.unige.ch / http://www.infomaniak.ch/~dblock
%  version 1.0 brute approach
%  check version 1.1 for more interesting code
% ---------------------------------------------------------
% Define a database relationship of the family tree kind.
%---------------------------------------------------------

married(fred, sue).
married(sue, fred).

father(fred, bill).
father(fred, henri).
father(fred, barb).
father(henri, cathy).
father(barb, bob).

mother(sue, barb).
mother(sue, bill).
mother(sue, henri).

daughter(cathy, henri).
son(bill, fred).
son(henri, fred).
son(barb, fred).
son(bob, barb).
son(henri, sue).
son(bill, sue).
son(barb, sue).

parent(X, Y):- father(X, Y); mother(X, Y).

oma(X, Y) :- mother(X, Z), parent(Z, Y).
opa(X, Y) :- father(X, Z), parent(Z, Y).

grand(X, Y):-oma(X, Y); opa(X, Y).
child(X, Y) :- parent(Y, X).

% more complex definitions are useless for such easy constructions
% so we'll drop the grandson complex def and declare one like this:

grandson(bob, stu).
grandson(bob, fred).
granddaughter(cathy, sue).
granddaughter(cathy, fred).

%etc...

% questions may be whatever... check the version 1.1 for more interresting stuff
