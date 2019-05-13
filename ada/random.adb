-- (c) Daniel Doubrovkine - uniGe - 1997 - doubrov5@cui.unige.ch
--     Soudovtzev Anton   		 - soudovt4@ 
--     Wichoud Jean-Luc			 - wichoud5@
-- source files can be found in /user/l1/doubrov5/works/ada

with TEXT_IO, CALENDAR, ADA.INTEGER_TEXT_IO;

package body random is
   use TEXT_IO, CALENDAR, ADA.INTEGER_TEXT_IO;
 
   FUNCTION random(i_num: in INTEGER) RETURN INTEGER IS
   	t1 : float;
   	t2, t3 : integer;
   
   begin
      t1:=float(360*seconds(clock));
      t2:=integer(t1);
      Delay Duration ((t2 mod 36000)/3600000);
      t3:=t2 mod i_num;
      return (t3);
   end random;
   
   procedure HAL_100(nums: in out table) is
   begin
      for cmpt in table'RANGE loop
         nums(cmpt):=random(100);
      end loop;
   end HAL_100;      
   
end random;      
   
   
      
