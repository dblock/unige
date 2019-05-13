
package body STACKHANDLER is

  subtype BORNE is INTEGER range 1..N;
  STACK1 : array (BORNE) of INFO;
  PTR : INTEGER := N;

  procedure PUSH(EL : in INFO) is
  begin
    if not FULL then
      STACK1(PTR) := EL;
      PTR := PTR - 1;
    end if;
  end PUSH;

  procedure POP(EL : out INFO) is
  begin
    if not EMPTY then
      PTR := PTR + 1;
      EL := STACK1(PTR);
    end if;
  end POP;

  function EMPTY return BOOLEAN is
  begin
    return PTR = N;
  end EMPTY;

  function FULL return BOOLEAN is
  begin
    return PTR = 0;
  end FULL;

end STACKHANDLER;    
