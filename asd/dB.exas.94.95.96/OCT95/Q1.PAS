(* ASD Examen ecrit, session d'octobre 1995                             *)
(* (c) Daniel Doubrovkine - 1996 - All Rights Reserved:)                *)
(*                          e-mail welcome: dblock@infomaniak.ch        *)
(* Question 1                                                           *)
uses crt;

type
  Matrix = array[1..10,1..10] of integer;
  Vector = array[1..10] of integer;

{scalar product of two vectors}
function ScalarProduct(FirstVector, SecondVector: Vector):integer;
var
   i: integer;
   TempSum: integer;
begin
   TempSum:=0;
   for i:=1 to 10 do TempSum:=TempSum+FirstVector[i]*SecondVector[i];
   ScalarProduct:=TempSum;
   end;

{matrix product, fusion, it is impossible to return a Matrix type!
 so this procedure must ask for the result matrix (var ResultMatrix)}
procedure MatrixFusion(FirstMatrix, SecondMatrix: Matrix;
                       var ResultMatrix: Matrix);
var
   LineVector, ColumnVector: Vector;
   column,line,t: integer;
begin
   for line:=1 to 10 do begin
       {construct line vector}
       for t:=1 to 10 do LineVector[t]:=FirstMatrix[line,t];
    for column:=1 to 10 do begin
        {construct column vector}
        for t:=1 to 10 do ColumnVector[t]:=FirstMatrix[t,column];
        {place the scalar product result into new matrix}
        ResultMatrix[line,column]:=ScalarProduct(LineVector,ColumnVector);
       end;
      end;
   end;

{draws a matrix on the screen}
procedure DrawMatrix(MatrixToDraw: Matrix);
var
   column, line: integer;
begin
   for column:=1 to 10 do begin
     for line:=1 to 10 do write(MatrixToDraw[line,column],' ');
     writeln;
     end;
   end;

{this part was nit asked, it illustrates how to use the functions}
var
   TryMatrix: Matrix;
   column, line: integer;
begin
   clrscr;
   {initialize the matrix with random values}
   for column:=1 to 10 do begin
     for line:=1 to 10 do TryMatrix[line,column]:=Random(5);
     end;
   {draw the matrix on the screen}
   DrawMatrix(TryMatrix);
   writeln;
   {multiply the matrix with itself}
   MatrixFusion(TryMatrix,TryMatrix,TryMatrix);
   {output the result to the screen}
   DrawMatrix(TryMatrix);
   end.


end.