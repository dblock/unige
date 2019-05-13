-- (c) Daniel Doubrovkine - uniGe - 1997 - doubrov5@cui.unige.ch
--     Soudovtzev Anton   		 - soudovt4@ 
--     Wichoud Jean-Luc			 - wichoud5@
-- source files can be found in /user/l1/doubrov5/works/ada

with TEXT_IO, random, ADA.INTEGER_TEXT_IO;

PROCEDURE random_test IS

   use TEXT_IO, random, ADA.INTEGER_TEXT_IO;

   nums: table;

   procedure sort(nums: in out table) is
	i, j, t: INTEGER;
   begin
	i := 1;
	while i < nums'LAST loop
		j:=nums'LAST;
		while i<=j loop
			if nums(j) < nums(j-1) then
				t := nums(j);
				nums(j) := nums(j-1);
				nums(j-1):=t;
				end if;
			j:= j - 1;
		end loop;
	i := i + 1;
	end loop;
   end sort;
 
   procedure show(nums: IN TABLE) IS
   begin
      for cmpt IN nums'RANGE loop
         PUT (nums(cmpt));
      end loop;
   end show;      
   
begin

   HAL_100(nums);
   PUT ("unsorted : "); new_line; show(nums); new_line;
   sort(nums);
   PUT ("sorted   : "); new_line; show(nums); new_line;
   
END random_test;    
      
   
