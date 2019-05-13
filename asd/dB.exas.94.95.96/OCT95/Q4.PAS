(* ASD Examen ecrit, session d'octobre 1995                             *)
(* (c) Daniel Doubrovkine - 1996 - All Rights Reserved:)                *)
(*                          e-mail welcome: dblock@infomaniak.ch        *)
(* Question 4                                                           *)

uses strings,crt;

(*Palindrome? recursif*)
function RecursivePalindrome(QueryString: string): boolean;
begin
   if Length(QueryString)<=1 then begin
      RecursivePalindrome:=True;
      end else
   if (QueryString[1]=QueryString[Length(QueryString)])
      then RecursivePalindrome:=
           RecursivePalindrome(Copy(QueryString,2,Length(QueryString)-2))
      else RecursivePalindrome:=False;
   end;

(*Palindrome? iteratif*)
function IteratifPalindrome(QueryString: string): boolean;
var
   l: integer;
begin
   IteratifPalindrome:=False;
   for l:=1 to Length(QueryString) div 2+1 do
      if UpCase(QueryString[l]) <>
         UpCase(QueryString[Length(QueryString)-l+1]) then exit;

   IteratifPalindrome:=True;
   end;


begin
   clrscr;
   writeln(IteratifPalindrome('radar'));
   writeln(RecursivePalindrome('zut'));
end.