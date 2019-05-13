corr(1, ' un').
corr(2, ' deux').
corr(3, ' trois').
corr(4, ' quatre').
corr(5, ' cinq').
corr(6, ' six').
corr(7, ' sept').
corr(8, ' huit').
corr(9, ' neuf').
corr(10, ' dix').
corr(11, ' onze').
corr(12, ' douze').
corr(13, ' treize').
corr(14, ' quatorze').
corr(15, ' quinze').
corr(16, ' seize').
corr(20, ' vingt').
corr(30, ' trente').
corr(40, ' quarante').
corr(50, ' cinquante').
corr(60, ' soixante').
corr(70, ' septante').
corr(80, ' quatre-vingt').
corr(90, ' nonante').
blanc(1, '').
blanc(0, '').

do_liste(0,[]):- !.
do_liste(N, L):-
		Reste is N mod 1000,
     	Entier is N//1000,
		do_liste(Entier,L1),
		append(L1,[Reste],L).

traduit([]):- !.
traduit(L):-
			length(L,Taille),
			append([T|_],Q,L),
			( (T=0, blanc(0,X), blanc(0,Y), blanc(0,Z), write(X), write(Y), write(Z));

			  (T<17, corr(T,X), write(X));

			  (T<100, Val1 is *(T//10,10), corr(Val1,X), write(X),
				      Val2 is -(T,Val1), ((Val2=0, blanc(0,Y)); corr(Val2,Y)), write(Y));

			  (Val1 is T//100, Temp is -(T,*(Val1,100)),
			             ((Val1>1, corr(Val1,X)); (Val1=1, blanc(1,X))), write(X), write(' cent'),
			  (((Val2 is Temp, Val2<20, ((Val2=0, blanc(0,Y)); corr(Val2,Y)));
			             (Val2 is *(Temp//10,10), corr(Val2,Y))), write(Y)),
			   Val3 is -(Temp,Val2), ((Val3=0, blanc(0,Z)); corr(Val3,Z)), write(Z))),

			((T=0, write(''));
			 (Taille=1, write(''));
			 (Taille=2, write(' mille'));
			 (Taille=3, write(' million'));
			 (Taille=4, write(' milliard'))),	   
traduit(Q).

go:- 
	write('Entrer un nombre (< 2147483647): '),
	read(N),
	((N=0, write(' zero')); (do_liste(N, L), traduit(L))).
