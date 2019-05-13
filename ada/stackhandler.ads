generic
  type INFO is private;
  N : INTEGER;
package STACKHANDLER is

  procedure PUSH(EL : in INFO);
-- on place un element de type INFO sur la pile

  procedure POP(EL : out INFO);
-- on prend un element de type INFO de la pile

  function EMPTY return BOOLEAN;
-- retourne vrai si la pile est vide

  function FULL return BOOLEAN;
-- retourne vrai si la pile est pleine

end STACKHANDLER;
