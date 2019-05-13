% Prolog First Lab (c) Daniel Doubrovkine - uniGe.CH - 1996
% doubrov5@cui.unige.ch / http://www.infomaniak.ch/~dblock
%  version 1.1 with a little more intelligent approach :)
% ---------------------------------------------------------
% Define a database relationship of the family tree kind.
%---------------------------------------------------------
%  I'll use structures of this kind:
% 
%    person(Name, Mother's Name, Father's name, Spouse, Sex).
%

person('Fred','Unknown','Unknown','Sue','F').
person('Sue','Unknown','Unknown','Fred','M').
person('Henri','Sue','Fred','None','M').
person('Bill','Sue','Fred','None','M').
person('Barb','Sue','Fred','None','M').
person('Cathy','Unknown','Henri','None','M').
person('Bob','Unknown','Barb','None','M').

mother(Name) :- person(Name, Mother, _, _, _), print(Mother), nl.
father(Name) :- person(Name, _, Father, _, _), print(Father), nl.
oma(Name) :- person(Name, Mother, _, _, _), person(Name, _, Father, _, _), mother(Father), mother(Mother).
opa(Name) :- person(Name, Mother, _, _, _), person(Name, _, Father, _, _), father(Father), father(Mother).
hasparent(Offspring, Name):- person(Offspring, Name, _, _, _); person(Offspring, _, Name, _, _).
children(Name) :- setof(Offspring, hasparent(Offspring, Name), Child), print(Child), nl.
                  
% for queries, you can try the following:
% oma('Bob').
% children('Fred'). 

