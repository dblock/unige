	with TEXT_IO;
	use TEXT_IO;

PACKAGE BODY Stack IS

	MaxItems : Constant := 10;
	StackArray : ARRAY (1 .. MaxItems) OF INTEGER;
	ItemCount : NATURAL RANGE 0..MaxItems;

	PROCEDURE PushInt(N: INTEGER) IS
	begin
		ItemCount := ItemCount + 1;
		StackArray(ItemCount):=N;
		EXCEPTION
		WHEN NUMERIC_ERROR|CONSTRAINT_ERROR 
                  => PUT_LINE("push::stack overflow");
                WHEN OTHERS => PUT_LINE ("push::ooops, fatal error");
                RAISE; 
	End PushInt;	

	FUNCTION PopInt RETURN INTEGER IS
	begin
		ItemCount := ItemCount - 1;
		RETURN(StackArray(ItemCount + 1));
		EXCEPTION
		WHEN NUMERIC_ERROR|CONSTRAINT_ERROR
                  => PUT_LINE("pop::stack overflow");
                     RETURN (-1);
                WHEN OTHERS => PUT_LINE ("pop::ooops, fatal error");
                            RETURN (-1);
	End PopInt;	
 
	BEGIN
	ItemCount:=0;
END Stack;
