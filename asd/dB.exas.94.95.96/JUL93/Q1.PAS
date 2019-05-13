(*
Examen d'ASD - Juillet 1993 - Question 1

Backtracking - Daniel Doubrovkine - e-mail welcome: dblock@infomaniak.ch

Vous disposez de six jetons, num‚rot‚s de 1 … 3.
i.e il y a deux jetons de chaque num‚ro.
Il s'agit de les ordonner de maniŠre … ce qu'il y ait un jeton entre chaque
jeton 1, 2 jetons entre chaque jeton 2 et 3 jetons entre chaque jeton 3.

D‚crire un algorithme utilisant le backtracking permettant de resoudre
ce probleme pour cel… vous devrez d'abord d‚finir en pascal:

þ un tableau de n cases o— n repr‚sente le nombre de jetons, dans
  l'exemple pr‚c‚dent, n=6, de valeurs comprises entre 1 et n/2.
  Ce tableau repr‚sentera la s‚quence des jetons.

þ une proc‚dure v‚rifier qui permet de voir si on peut placer le jeton
  i dans une case k du tableau

þ une proc‚dure enregistrer qui permet de m‚moriser un coup dans le tableau

þ une proc‚dure effacer qui permet d'annuller un coup dans un tableau

þ une proc‚dure fini qui determine si le tableau est plein et si on est
  arriv‚s … une solution

asnwers for:

1 : no solutions
2 : no solutions
3 : 2 3 1 2 1 3 (2 solutions)
4 : 2 3 4 2 1 3 1 4 (2 solutions)
5 : no solutions
6 : no solutions
7 : 7 4 1 5 1 6 4 3 7 5 2 3 6 2 (52 solutions)
*)

uses crt;

const
 CoinsNb = 4;

var
 CoinsArray: array[1..CoinsNb*2] of integer;
 CoinsPlaced: integer;
 Finished : boolean;

procedure OutPut;
var
   i: integer;
begin
   for i:=1 to CoinsPlaced do write(CoinsArray[i],' ');
   writeln;
   end;

function Valid: boolean;
var
   i,cnt: integer;
begin
   cnt:=0;
   Valid:=False;
   for i:=1 to CoinsPlaced-1 do
      if CoinsArray[i]=CoinsArray[CoinsPlaced] then inc(cnt);
      if cnt>1 then exit;
      if cnt=1 then begin
         if CoinsArray[CoinsPlaced]+1>=CoinsPlaced then exit;
         if CoinsArray[CoinsPlaced] <>
            CoinsArray[CoinsPlaced-CoinsArray[CoinsPlaced]-1] then exit;
         end;
      Valid:=True;
   end;

procedure Add(coin: integer);
begin
   inc(CoinsPlaced);
   CoinsArray[CoinsPlaced]:=coin;
   end;

procedure Rem;
begin
   dec(CoinsPlaced);
   end;

function Fin:boolean;
begin
   if (CoinsPlaced=CoinsNb*2) and Valid then Fin:=True else Fin:=False;
   end;

procedure BackTrack;
begin
   if CoinsPlaced=0 then begin
      Finished:=True;
      exit;
      end;
   if CoinsArray[CoinsPlaced]>=CoinsNb then begin
      Rem;
      BackTrack;
      end else begin
      inc(CoinsArray[CoinsPlaced]);
      end;
   end;

var
  Solutions: integer;
begin
  clrscr;
  CoinsPlaced:=0;
  Solutions:=0;
  Finished:=False;
  while (not finished) do begin
     if (Valid) then begin
        Add(1);
        end else BackTrack;
     if Fin then begin
        inc(Solutions);
        output;
        BackTrack;
        end;
     end;
  writeln('Found ',Solutions,' solutions.');
end.