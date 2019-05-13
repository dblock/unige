type

  Point = record
     x,y: integer;
     end;

  TPolygon = ^Polygon;
  Polygon= record
     Som: array [0..10] of Point;   {array of sommets}
     QSom: integer;                     {number of sommets in the poly}
     end;


var
   P1: TPolygon;
   P2: TPolygon;
begin
   new(P1);
   new(P2);

end.