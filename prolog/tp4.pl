est_distance('Geneve', 'Lausanne', 62).
est_distance('Fribourg', 'Bâle', 157).
est_distance('Lausanne', 'Yverdon', 31).
est_distance('Lausanne', 'Fribourg', 78).
est_distance('Yverdon', 'Neuchâtel', 56).
est_distance('Fribourg', 'Berne', 32).
est_distance('Berne', 'Neuchâtel', 45).
est_distance('Berne', 'Zurich', 122).
est_distance('Zurich', 'Bâle', 85).
est_distance('Lausanne', 'Lugano', 312).
est_distance('Lugano', 'Berne', 282).
est_distance(X, X, 0).
'Geneve'(['Lausanne',[],[]]).
'Yverdon'(['Lausanne', 'Neuchâtel']).

est_distance(X, Y, Dist):- est_distance(Y, X, Dist).

distance(X, Y, Dist):- est_distance(X, Y, Dist), !.
distance(X, Z, Dist):- est_distance(X, Y, Dist1), member(Y, [X]),
					   Dist is +(Dist1, Dist),
					   distance(Y, Z, Dist).
