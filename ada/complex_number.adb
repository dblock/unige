PACKAGE BODY Complex_Number IS

	Function Construct_Complex(Re, Im: Float) RETURN Complex_Type IS
	begin
		RETURN((Re, Im));
	End Construct_Complex;

	Function Re_Complex(Num : Complex_Type) RETURN Float IS
	begin
		RETURN(Num.Re);
	End Re_Complex;
	
    	Function Im_Complex(Num : Complex_Type) RETURN Float IS
	begin
		RETURN(Num.Im);
	End Im_Complex;

    	Function "+"(Num : Complex_Type) RETURN Complex_Type IS
	begin
		RETURN(Num);
	End "+";

    	Function "-"(Num : Complex_Type) RETURN Complex_Type IS
	begin
		RETURN((- Num.Re, - Num.Im));
	End "-";

    	Function "+"(Left, Right: Complex_Type) RETURN Complex_Type IS
	begin
		RETURN((Left.Re + Right.Re, Left.Im + Right.Im));
	End "+";

    	Function "-"(Left, Right: Complex_Type) RETURN Complex_Type IS
	begin
		RETURN((Left.Re - Right.Re, Left.Im - Right.Im));
	End "-";

    	Function "*"(Left, Right: Complex_Type) RETURN Complex_Type IS
	begin
		RETURN((Left.Re * Right.Re - Left.Im * Right.Im, 
			Left.Re * Right.Im + Left.Im * Right.Re));
	End "*";

	Function Inv_Complex(Num: Complex_Type) RETURN Complex_Type IS
	z_div : FLOAT;
	begin
		z_div := Num.Re ** 2 + Num.Im ** 2;
		RETURN((Num.Re / z_div,
		        - Num.Im / z_div));
	End Inv_Complex;

	Function "*"(i_Num: FLOAT; c_Num: Complex_Type) RETURN Complex_Type IS
	begin
		RETURN((i_Num * c_Num.Re, i_Num * c_Num.Im));
	End "*";
	
	Function "*"(c_Num: Complex_Type; i_Num: FLOAT) RETURN Complex_Type IS
	begin
		RETURN(i_Num * c_Num);
	End "*";

    	Function "/"(Left, Right: Complex_Type) RETURN Complex_Type IS
	begin
		RETURN(Left * (Inv_Complex(Right)));
	End "/";

	Function C_Complex(Num: Complex_Type) RETURN Complex_Type IS
	begin
		RETURN(Num.Re, - Num.Im);
	End C_Complex;

	Function "/"(i_Num: FLOAT; c_Num: Complex_Type) RETURN Complex_Type IS
	begin
		RETURN(i_Num * Inv_Complex(c_Num));
	End "/";

	Function "**"(Num: Complex_Type; Power: INTEGER) RETURN Complex_Type IS
	begin
		if Power < 0 then RETURN(Inv_Complex(Num ** (- Power))); end if;
		if Power = 0 then 
			RETURN((1.0,0.0));
		else
			RETURN(Num * (Num ** (Power - 1)));
		end if;
	End "**";

END Complex_Number;
