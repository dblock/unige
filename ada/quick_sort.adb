with TEXT_IO;
with STACKHANDLER;

procedure QUICK_SORT is
package INT_IO is new TEXT_IO.INTEGER_IO(INTEGER);
package NEW_STACKHANDLER is new STACKHANDLER(INTEGER, 100);

use TEXT_IO;
use INT_IO;
use NEW_STACKHANDLER;

task type SORT is
  pragma PRIORITY(2);
end SORT;

-- longueur de la liste de depart
  M : constant := 10;
-- nombre de processus
  P : constant := 3;
  LIST : array (1..M) of INTEGER;
  P_SORT : array (1..P) of SORT;

task RESSOURCE is
  pragma PRIORITY(2);
  entry POSER(ELG,ELD : in INTEGER);
  entry PRENDRE(ELG,ELD  : out INTEGER);
end RESSOURCE;

task body RESSOURCE is

begin
  loop
    select
      when not FULL =>
        accept POSER(ELG,ELD : in INTEGER) do
		 -- attend de recevoir un segment
 	  PUSH(ELG);
	  PUSH(ELD);
	end POSER;
      or
	when not EMPTY =>
	  accept PRENDRE(ELG,ELD: out INTEGER) do
		 -- est pret restituer un segment
	    POP(ELD);
	    POP(ELG);
	  end PRENDRE;
    end select;
  end loop;
end RESSOURCE;


task body SORT is
  ELG,ELD : INTEGER;
  MEDIUM,G,D,I : INTEGER;
  
begin
    PUT_LINE ("On entre dans la tache P_SORT ");  
  loop  
    RESSOURCE.PRENDRE(ELG,ELD);
    PUT ("Indices a trier: ");
    PUT("g = "); PUT (ELG); PUT (" d = "); PUT (ELD); NEW_LINE;
    if ELG < ELD then 
      G := ELG;
      D := ELD;
      MEDIUM := LIST((ELG + ELD) / 2);
      loop
        while LIST(G) < MEDIUM loop G := G+1; end loop;
        while LIST(D) > MEDIUM loop D := D-1; end loop;
        if G <= D then
          I := LIST(G);
          LIST(G) := LIST(D);
          LIST(D) := I;
          G := G+1;
          D := D-1;
        end if;
        exit when G > D;
      end loop;
      for I in 1..M loop PUT (LIST(I), WIDTH => 5); end loop; NEW_LINE;
      I := ELD;
      ELD := D; 
      RESSOURCE.POSER(ELG,ELD); 
      ELG := G;
      ELD := I;
      RESSOURCE.POSER(ELG,ELD); 
    end if;
  end loop;
end SORT;

task WATCHDOG is
  pragma PRIORITY(1);
end WATCHDOG;

task body WATCHDOG is 

  ELG, ELD : INTEGER;
begin
  PUT("Entrez ");
  PUT(M,WIDTH => 2);
  PUT(" nombres a trier: ");
  NEW_LINE;
  for I in 1..M loop GET(LIST(I)); end loop;
  ELG := 1;
  ELD := M;
  RESSOURCE.POSER(ELG,ELD);
  loop
    if EMPTY then
      for I in 1..M loop 
        PUT(LIST(I),WIDTH => 5); 
      end loop;
      NEW_LINE;
      for I in 1..P loop abort P_SORT(I); end loop;
      abort RESSOURCE;
      exit;
    end if;
  end loop;
end WATCHDOG;

  
begin
  null;
end QUICK_SORT;  
