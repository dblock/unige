{there're not many comments, really sorry, better code and less talk!}
program pcc;    {Le Plus Court Chemin (promise, last word in french)}
uses crt;       {Uses C (?!*) RunTime}

{.$DEFINE Debug}        {remove the dot for debug info}
{$DEFINE Direc}         {use the directional links or not}

type            {Object type definitions}

PArc=^TArc;     {pointer to the arc record}
PGraph=^TGraph; {pointer to the graph object}
PNodes=^TNodes; {nodes table pointer}

{stack record object - LIFO & FIFO}
PStackRecord=^StackRecord;
 StackRecord=record
    PreviousRecord : PStackRecord;
    Item           : PGraph;
    NextRecord     : PStackRecord;
    end;

StackModes=(LIFO,FIFO);   {Stack modes available (do you know anything else?}
{stack object definition}
TStack=object
   FirstItem :  PStackRecord;
   Mode      :  StackModes;
   Items     :  integer;
   LastItem  :  PStackRecord;
   constructor  Create(MyMode:StackModes);
   procedure    Push(ToGraph:PGraph);
   function     Pop:PGraph;
   end;

{graph object definition}
TGraph=object
   Id  : integer;
   Visited:integer;
   Arcs: PArc;
   CameFrom:PGraph;
   constructor Create(MyId:integer;var NodesTable:PNodes);
   procedure LinkNode(var ToNode:TGraph;NodeWeight:integer);
   function HasArc(var ToNode:TGraph):boolean;
   procedure TraceRoute(EndWith:integer;Table:PNodes);
   procedure OptimalFlood(EndWith:integer;Table:PNodes);
   end;
{nodes table object definition}
TNodes=object
   Name:string;
   FirstNode:PArc;
   constructor Create(MyName:string);
   procedure AddNode(ToNode:PGraph);
   function  Node(id:integer):PGraph;
   procedure Show;
   end;
{arc record definition}
TArc=record
   NodePtr:PGraph;
   NextArc:PArc;
   {changes made 30.05.96}
   Pseudo:Boolean; {arc has single direction, Pseudo arc TRUE is backwards}
   Weight:Integer; {weight of the arc}
   Flood:Integer; {weight used}
   end;

constructor TStack.Create(MyMode:StackModes);
begin
   Mode:=MyMode;
   Items:=0;
   FirstItem:=nil;
   LastItem:=nil;
   end;

procedure TStack.Push(ToGraph:PGraph);
var Item:PStackRecord;
begin
   {$IFDEF Debug} writeln('Pushing ',ToGraph^.id,' (added to ',Items,' record(s))'); {$ENDIF}
   new(Item);
   if FirstItem<>nil then FirstItem^.PreviousRecord:=Item;
   Item^.PreviousRecord:=nil;
   Item^.Item:=ToGraph;
   Item^.NextRecord:=FirstItem;
   FirstItem:=Item;
   If LastItem=nil then LastItem:=Item;
   Items:=Items+1;
   end;

function TStack.Pop:PGraph;
var PopItem:PStackRecord;
begin
   Pop:=nil;
   if items=0 then exit;
   items:=items-1;
   case Mode of
        LIFO: begin
              PopItem:=FirstItem;
              FirstItem:=FirstItem^.NextRecord;
              Pop:=PopItem^.Item;
              {$IFDEF Debug} writeln('Poped ',PopItem^.Item^.id,' (LIFO) from stack.'); {$ENDIF}
              end;
        FIFO: begin
              PopItem:=LastItem;
              If LastItem^.PreviousRecord<>nil then begin
                 LastItem:=LastItem^.PreviousRecord;
                 LastItem^.PreviousRecord^.NextRecord:=nil;
                 Pop:=PopItem^.Item;
                 end else LastItem:=nil;
              {$IFDEF Debug} writeln('Poped ',PopItem^.Item^.id,' (FIFO) from stack.'); {$ENDIF}
              Pop:=PopItem^.Item;
              end;
        end;
   end;

constructor TNodes.Create(MyName:string);
begin
   Name:=MyName;
   FirstNode:=nil;
   end;

procedure TNodes.Show;
var MyNode:PArc;
begin
   writeln(Name);
   new(MyNode);
   MyNode:=FirstNode;
   while MyNode<>nil do begin
      writeln(MyNode^.NodePtr^.id);
      MyNode:=MyNode^.NextArc;
      end;
   end;

function TNodes.Node(id:integer):PGraph;
var MyNode:PArc;
begin
   MyNode:=FirstNode;
   while(MyNode<>nil) do begin
      if MyNode^.NodePtr^.id=id then begin
         Node:=MyNode^.NodePtr;
         exit;
         end;
      MyNode:=MyNode^.NextArc;
      end;
      Node:=nil;
   end;

procedure TNodes.AddNode(ToNode:PGraph);
var MyNode:PArc;
begin
   MyNode:=FirstNode;
   while(MyNode<>nil) do begin
      if MyNode^.NodePtr=ToNode then exit;
      MyNode:=MyNode^.NextArc;
      end;
   new(MyNode);
   MyNode^.NextArc:=FirstNode;
   MyNode^.NodePtr:=ToNode;
   FirstNode:=MyNode;
   end;


constructor TGraph.Create(MyId:integer;var NodesTable:PNodes);
begin
   {$IFDEF Debug}writeln('Created node ',MyId);{$ENDIF}
   Id:=MyId;
   Visited:=0;
   Arcs:=nil;
   NodesTable^.AddNode(@Self);
   CameFrom:=nil;
   end;

procedure TGraph.LinkNode(var ToNode:TGraph;NodeWeight:integer);
var
   NewArc:PArc;
begin
   {create a new arc and link it to the target node}
   {$IFDEF Debug} writeln('Bidirectionally linking ',Id,' to ',ToNode.id); {$ENDIF}

   if @ToNode=@Self then begin
      {$IFDEF Debug}writeln('  ...can''t link not to itself.'); {$ENDIF}
      exit;
      end;

   if HasArc(ToNode)=False then begin
      new(NewArc);
      NewArc^.NodePtr:=@ToNode;
      NewArc^.NextArc:=Arcs;
      NewArc^.Weight:=NodeWeight;
      NewArc^.Flood:=0;
      NewArc^.Pseudo:=False;
      Arcs:=NewArc;
      {$IFDEF Debug}writeln('  ...linked ',Id,' to ',ToNode.Id,' (true arc of weight: ', NodeWeight,')');{$ENDIF}
      end else begin
      {$IFDEF Debug}writeln('  ...link ',Id,' to ',ToNode.Id,' already exists.');{$ENDIF}
      end;

   {link the target node to the current node (bidirectional link)}
   if ToNode.HasArc(Self)=False then begin
      new(NewArc);
      NewArc^.NodePtr:=@Self;
      NewArc^.NextArc:=ToNode.Arcs;
      NewArc^.Weight:=NodeWeight;
      NewArc^.Flood:=0;
      NewArc^.Pseudo:=True;
      ToNode.Arcs:=NewArc;
      {$IFDEF Debug}
      writeln('  ...linked ',ToNode.id,' to ',id,' (false arc of weight: ',NodeWeight,')');
      {$ENDIF}
      end else begin
      {$IFDEF Debug}
      writeln('  ...link ',ToNode.id,' to ',id,' already exists.');
      {$ENDIF}
      end;
   end;


function TGraph.HasArc(var ToNode:TGraph):boolean;
var MyArc:PArc;
begin
   {$IFDEF Debug}writeln('Looking in ',Id,' for ',ToNode.id);{$ENDIF}
   MyArc:=Arcs;
   while MyArc<>nil do begin
      {$IFDEF Debug}
         write(id,' has a ');
         if MyArc^.Pseudo=False then write('true') else write('false');
         writeln(' arc to: ',MyArc^.NodePtr^.id);{$ENDIF}
      if MyArc^.NodePtr=@ToNode then begin
         HasArc:=true;
         exit;
         end;
      MyArc:=MyArc^.NextArc;
      end;
      HasArc:=False;
   end;


procedure TGraph.TraceRoute(EndWith:integer;Table:PNodes);
var
    Stack:TStack;
    CurrentNode:PGraph;
    MyArc:PArc;
    Steps:integer;
    CameFromNode:PGraph;
begin
    Steps:=1;
    if (EndWith=Id) then begin
       writeln('Stupid, you''re already there!');
       exit;
       end;
    Stack.Create(FIFO);
    CurrentNode:=Table^.Node(Id);
    CurrentNode^.Visited:=1;
    Stack.Push(CurrentNode);

    while Stack.items>0 do begin

       CurrentNode:=Stack.Pop;
       MyArc:=CurrentNode^.Arcs;
       CameFromNode:=CurrentNode;

       while MyArc<>nil do begin

       if (MyArc^.NodePtr^.Visited=0) and
       {$IFDEF Direc}(MyArc^.Pseudo=True) and {$ENDIF}
          (MyArc^.NodePtr^.Arcs^.NextArc<>nil) then begin
            MyArc^.NodePtr^.Visited:=1;
            MyArc^.NodePtr^.CameFrom:=CameFromNode;
           {$IFDEF Debug}
            writeln('Came to ',MyArc^.NodePtr^.id,' from ',MyArc^.NodePtr^.CameFrom^.id);
            writeln('Set incoming arc on node ',MyArc^.NodePtr^.id,' to ',MyArc^.NodePtr^.CameFrom^.id);
           {$ENDIF}
            Stack.Push(MyArc^.NodePtr);
           {write(' ',MyArc^.NodePtr^.id);}
           end;

       {$IFDEF Direc}if (MyArc^.Pseudo=True) then{$ENDIF}
       if MyArc^.NodePtr^.Id=EndWith then begin
          writeln('Best way from ',EndWith,' to ',id,' is:');
          write(EndWith);
          while (CameFromNode<>nil) and (CameFromNode<>@Self) do begin
             Steps:=Steps+1;
             write(' -> ',CameFromNode^.id);
             CameFromNode:=CameFromNode^.CameFrom;
             end;
          if (steps>0) then
             writeln(' => ',id,' (in ',Steps,' step(s)...and 400 lines of code)')
             else writeln(' => ',id,' (that was fast!)');
          exit;
          end;

       MyArc:=MyArc^.NextArc;
       end;

    end;
    writeln('Bee*?eep...Ce raccordement n''est pas valable...((c)PTT).');
    end;

procedure TGraph.OptimalFlood(EndWith:integer;Table:PNodes);
var
    Stack:TStack;
    MyArc:PArc;
    EventualRaise:integer;
begin
    if (EndWith=Id) then begin
       writeln('Stupid, you''re already there!');
       exit;
       end;

    Stack.Create(LIFO);



   end;

var
   OrigMode:word;
   DataFile:Text;
   ItemRead:integer;
   AnyNode:PGraph;
   i:integer;
   Table:TNodes;
   ToTable:PNodes;
   FirstNode:TGraph;
   FromNode:PGraph;
   ToNode:PGraph;
   StartWith,EndWith:integer;

begin
   clrscr;
   OrigMode:=LastMode;
   TextMode(Lo(LastMode)+Font8x8);      { use 43 or 50 lines on EGA/VGA }
   writeln('Daniel Doubrovkine - dblock@infomaniak.ch / doubrov5@cui.unige.ch');
   writeln('(c) Stolen Technologies Inc. - University of Geneva - All Rights Reserved');
   {$I-}
   Assign(DataFile,'TPEC.DAT');
   Reset(DataFile);
   if IOResult<>0 then begin
      writeln('Ooops. Error opening TPEC.DAT (must be in the same dir)...');
      exit;
      end;

   {number of nodes to create}
   Table.Create('Pointers to nodes.');
   ToTable:=@Table;

   {Read(DataFile,ItemRead);
   writeln('Total of ',ItemRead,' nodes to create...(i really don't care for this number...');}
   {for i:=1 to ItemRead do begin
      New(AnyNode,Create(i,ToTable));
      end;}

   {Table.Show;}
   while not(eof(DataFile)) do begin
      Read(DataFile,ItemRead);
      if ItemRead<>0 then begin

      FromNode:=Table.Node(ItemRead);
      if FromNode=nil then begin
         New(AnyNode,Create(ItemRead,ToTable));
         FromNode:=AnyNode;
         {writeln('General protection fault at 1234:!*?: (hmmm...sounds familiar)');
         exit;}
         end;
      Read(DataFile,ItemRead);
      ToNode:=Table.Node(ItemRead);
      if ToNode=nil then begin
         New(AnyNode,Create(ItemRead,ToTable));
         ToNode:=AnyNode;
         {writeln('General protection fault at 1234:!*?: (hmmm...sounds familiar)');
         exit;}
         end;

      {reading node weight...simply remove the line if you don't want it...:)}
      Read(DataFile,ItemRead);

      FromNode^.LinkNode(ToNode^,ItemRead);
      if IOResult<>0 then begin
         writeln('Ooops. Error reading TP9.DAT.');
         exit;
         end;
      end;
      end;

    write('What''s the node id to start with? ');
    readln(StartWith);
    if StartWith<=0 then begin
       writeln('Did you really think this would hang my prog?');
       exit;
       end;
    write('Where do you want to go today ((c) MiRCosoft)? ');
    readln(EndWith);
    if EndWith<=0 then begin
       writeln('Did you really think this would hang my prog?');
       exit;
       end;

    if Table.Node(StartWith)=nil then begin
       writeln('Hmmmm, node ',StartWith,' does not exist.');
       exit;
       end;
    if Table.Node(EndWith)=nil then begin
       writeln('Hmmmm, node ',EndWith,' does not exist.');
       exit;
       end;

    {BFS}
    Table.Node(EndWith)^.TraceRoute(StartWith,@Table);
    Table.Node(StartWith)^.OptimalFlood(EndWith,@Table);

    writeln('(hit a key)');
    readkey;
    TextMode(OrigMode);      { use 43 or 50 lines on EGA/VGA }
end.