-- Complex Test Prog (C) Daniel Doubrovkine - 1997 - uniGe - doubrov5@cui.unige.ch

with TEXT_IO;
use TEXT_IO;

with COMPLEX_NUMBER;
use COMPLEX_NUMBER;

procedure COMPLEX_TEST is

package REAL_IO is new Float_IO(Float);
use REAL_IO;

X, Y: Complex_Type;

	procedure Show_Complex(Num: in Complex_Type) is 
	begin
		PUT(Re_Complex(Num));
		if Im_Complex(Num) /= 0.0 then
			PUT("+i*");
			PUT(Im_Complex(Num));
			End If;
		new_line;
	end Show_Complex;

begin
	PUT_LINE("Complex (c) Daniel Doubrovkine - 1997 - uniGe - doubrov5@cui.unige.ch");
	X := Construct_Complex(3.0, 4.0);
	Y := Construct_Complex(1.0, 2.0);
	PUT("X:             "); Show_Complex(X);
	PUT("Y:             "); Show_Complex(Y);	
	PUT("Re(X):         "); PUT(Re_Complex(X)); new_line;
	PUT("Im(X):         "); PUT(Im_Complex(X)); new_line;
	PUT("X+Y:           "); Show_Complex(X + Y);
	PUT("X-Y:           "); Show_Complex(X - Y);
	PUT("X*Y:           "); Show_Complex(X * Y);
	PUT("X/Y:           "); Show_Complex(X/Y);
	PUT("-Y:            "); Show_Complex(-Y);
	PUT("+X:            "); Show_Complex(+X);
	PUT("Compl(X):      "); Show_Complex(C_Complex(X));
	PUT("1/X:           "); Show_Complex(1.0/X);
	PUT("X**3:          "); Show_Complex(X**3);
	PUT("X**-2:         "); Show_Complex(X**(-2));
	PUT("3/X:           "); Show_Complex(3.0/X);
end COMPLEX_TEST;
