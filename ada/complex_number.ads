PACKAGE Complex_Number IS
        TYPE Complex_Type IS Private;
        I : CONSTANT Complex_Type;	
	-- construct a complex number
	Function Construct_Complex(Re, Im: Float) RETURN Complex_Type;
	-- real part of a complex number
	Function Re_Complex(Num : Complex_Type) RETURN Float;
	-- imaginary part of a complex number
	Function Im_Complex(Num : Complex_Type) RETURN Float;
	-- positive complex number
	Function "+"(Num : Complex_Type) RETURN Complex_Type;
	-- negative complex number
	Function "-"(Num : Complex_Type) RETURN Complex_Type; 
	-- summation of two complex numbers
	Function "+"(Left, Right: Complex_Type) RETURN Complex_Type;
	-- difference between two complex numbers
	Function "-"(Left, Right: Complex_Type) RETURN Complex_Type;
	-- product of two complex numbers
	Function "*"(Left, Right: Complex_Type) RETURN Complex_Type;
	-- division of two complex numbers
	Function "/"(Left, Right: Complex_Type) RETURN Complex_Type;
	-- complement a + ib -> a - ib	
	Function C_Complex(Num: Complex_Type) RETURN Complex_Type;
	-- inverse z -> 1/z
	Function Inv_Complex(Num: Complex_Type) RETURN Complex_Type;
	-- power of a complex number
	Function "**"(Num: Complex_Type; Power: INTEGER) RETURN Complex_Type;
	-- float / Complex
	Function "/"(i_Num: FLOAT; c_Num: Complex_Type) RETURN Complex_Type;
	-- float * complex
	Function "*"(i_Num: FLOAT; c_Num: Complex_Type) RETURN Complex_Type;
	-- complex * float;
	Function "*"(c_Num: Complex_Type; i_Num: FLOAT) RETURN Complex_Type;
	-- private definitions of complex type
	Private
		TYPE Complex_Type is 
			Record
			Re, Im: Float := 0.0;
			End Record;
        I : CONSTANT Complex_Type :=(0.0,1.0);
END Complex_Number;

 
