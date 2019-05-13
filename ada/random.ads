-- (c) Daniel Doubrovkine - uniGe - 1997 - doubrov5@cui.unige.ch
--     Soudovtzev Anton   		 - soudovt4@ 
--     Wichoud Jean-Luc			 - wichoud5@
-- source files can be found in /user/l1/doubrov5/works/ada
package random is

   TYPE table IS ARRAY (0..99) OF INTEGER;
   
   FUNCTION random(i_num: IN INTEGER) RETURN INTEGER;
   PROCEDURE HAL_100(nums: IN OUT table); 
     
end random;      
