-- Stack Test Prog (C) Daniel Doubrovkine - 1997 - uniGe - doubrov5@cui.unige.ch

with TEXT_IO;
use TEXT_IO;

with Stack;
use Stack;

procedure STACK_TEST is
	package INT_IO is new TEXT_IO.INTEGER_IO (integer);
	use INT_IO;
begin

	PUT_LINE("Stack (c) Daniel Doubrovkine - 1997 - uniGe - doubrov5@cui.unige.ch");
	PushInt(10);
	PushInt(5);
	PUT(PopInt); new_line;
	PUT(PopInt); new_line;
	PUT(PopInt); new_line;
end STACK_TEST;
