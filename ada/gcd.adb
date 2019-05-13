-- Tp1 - ADA (c) Daniel Doubrovkine - uniGe - 1997
-- doubrov5@cui.unige.ch
-- PGCD of two or more numbers

with TEXT_IO; 
use TEXT_IO;

procedure GCD is
	package INT_IO is new TEXT_IO.INTEGER_IO (integer);
	use INT_IO;
	in_X, in_Y: INTEGER;
	
	function GCD_STUPID(X, Y : in INTEGER) return INTEGER is
	begin
	   if Y = 0 then return(X);
	   else return GCD_STUPID(Y, X mod Y);
	   end if;
	end GCD_STUPID;

	function GCD_LOOP(X, Y : in INTEGER) return INTEGER is
	T, TX, TY: INTEGER;
 	begin
		TX := X;
		TY := Y;
		loop
			if TY = 0 then return(TX);
			else 
			T := TX;
			TX := TY;
			TY := T mod TY;
			end if;
		end loop;
	end GCD_LOOP;

begin
   PUT_LINE ("(c) Daniel Doubrovkine - 1997 - uniGE - doubrov5@cui.unige.ch");
   PUT_LINE ("Greatest Common Divisor between:");
   PUT ("X: "); GET (in_X);
   PUT ("Y: "); GET (in_Y);
   PUT ("GCD between X and Y is: ");
   PUT (GCD_STUPID(in_X, in_Y));
   PUT (" or ");
   PUT (GCD_LOOP(in_X, in_Y));
   new_line;
end GCD;
