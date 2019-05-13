unit treeview;

{$N+,E+}

interface
type
    {type definitions for TNode object}
    Variable=string;
    Operator=string;
    Single=string;
    Number=extended;
    ContentsType=(NodeVariable,NodeOperator,NodeSingle,NodeValue);
    ContentsPtr=^Contents;
    Contents=record
        case ContentsValue : ContentsType of
              NodeVariable:(MyVariable:Variable);
              NodeOperator:(MyOperator:Operator);
              NodeSingle:(MySingle:Single);
              NodeValue:(MyValue:Number);
              end;{contents record}
    {PNode is the pointer to the TNode object}
    PNode= ^TNode;
    {TNode object itself, assembly of TNodes make a non-circular tree with }
    {any number of children & brothers                                     }
    TNode=object
        {field definitions}
        NodeContents:ContentsPtr;       {Node contents, variable, op or value}
        NodeType:ContentsType;          {Node type, variable, op or value}
        ParentNodePtr:PNode;            {pointer to parent TNode:PNode}
        BrotherNodePtr:PNode;           {pointer to next brother TNode:PNode}
        ChildNodePtr:PNode;             {pointer to first child TNode:PNode}
        {methods definitions, see later for deeper discussion}
        constructor Create(ContentsType:ContentsType;Value:string);
        destructor  Destroy;
        function    AddChild(ContentsType:ContentsType;Value:string):PNode;
        function    AddBrother(ContentsType:ContentsType;Value:string):PNode;
        function    RemoveChild(ItemPosition:integer):boolean;
        function    RemoveBrother(ItemPosition:integer):Boolean;
        function    Child(ItemCount:integer):Pnode;
        function    Brother(ItemCount:integer):Pnode;
        function    Contents:string;
        function    Parent:PNode;
        procedure   Show(level:integer);
        function    ChildCount:integer;
        function    Index:integer;
        function    BrothersCount:integer;
        function    Remove:Boolean;
        function    FindItem(MyContentsType:ContentsType;MyValue:string):PNode;
        function    InsertLevel(BItem:PNode):PNode;
        end;{TNode object ends here}
    PTree=^TTree;  {Pointer to TTree object}
    {TTree is the top node of TNode with only two fields, but convenient}
    {methods}
    TTree=object
        Name:string;            {Tree name}
        ChildNodePtr:PNode;     {Pointer to first child:TNode:PNode}
        constructor Create(ConstructName:string);
        destructor  Destroy;
        function    AddChild(ContentsType:ContentsType;Value:string):PNode;
        function    Child(ChildPosition:integer):PNode;
        procedure   Show;
        function    ChildCount:integer;
        procedure   RemoveChild(ItemsCount:integer);
        function    FindItem(MyContentsType:ContentsType;MyValue:string):PNode;
        end;{TTree ends here}

implementation
uses crt;

{TNode object methods definitions}
{
 NAME:          TNode.FindItem
 INPUT:         Node Type:ContentsType, Node Contents:String
 OUTPUT:        PNode
 PURPOSE:       Parses the whole tree and returns an item matching the request
                returns nil if no such item has been found
}
function TNode.FindItem(MyContentsType:ContentsType;MyValue:string):PNode;
var
   FoundItem:PNode;
begin
     FoundItem:=nil;

     if (NodeType=MyContentsType) and (Contents=MyValue) then begin
        FindItem:=@Self;
        exit;
        end;

     if ChildNodePtr<>nil then FoundItem:=ChildNodePtr^.FindItem(MyContentsType,MyValue);
     if FoundItem<>nil then begin
        FindItem:=FoundItem;
        exit;
        end;

     if BrotherNodePtr<>nil then FoundItem:=BrotherNodePtr^.FindItem(MyContentsType,MyValue);
     if FoundItem<>nil then begin
        FindItem:=FoundItem;
        exit;
        end;

        FindItem:=FoundItem;
end;

{
 NAME:          TNode.Remove
 INPUT:         void
 OUTPUT:        Boolean (True=operation successful)
 PURPOSE:       Attempts to remove the whole TNode, needs to have a parent
                pointer, all top tree items don't have any
}
function TNode.Remove:Boolean;
begin
     Remove:=False;
     If ParentNodePtr=nil then exit;
     Remove:=ParentNodePtr^.RemoveChild(Index);
end;

{
 NAME:          TNode.Brother
 INPUT:         Brother Index : integer
 OUTPUT:        PNode
 PURPOSE:       Returns the pointer to a brother
                0 returns it's own pointer
                nil is returned if brother does not exist
}
function TNode.Brother(ItemCount:integer):PNode;
var  i:integer;
     MyBrotherPtr:PNode;
begin
     If ItemCount=0 then begin
        Brother:=@Self;
        exit;
        end;
     MyBrotherPtr:=BrotherNodePtr;
     If BrotherNodePtr=nil then begin
        Brother:=nil;
        exit;
        end;
     for i:=0 to ItemCount-1 do begin
         MyBrotherPtr:=MyBrotherPtr^.BrotherNodePtr;
         if MyBrotherPtr^.BrotherNodePtr=nil then
          if i<ItemCount-1 then begin
             Brother:=nil;
             exit;
          end
          else break;
     end;
     Brother:=MyBrotherPtr;
     end; {TNode.Brother}

{
 NAME:          TNode.Child
 INPUT:         Child Index : integer
 OUTPUT:        PNode
 PURPOSE:       returns a pointer to ItemCount 'th child
                nil of none or no such child
}
function TNode.Child(ItemCount:integer):PNode;
var i:integer;
     MyBrotherPtr:PNode;
begin
     MyBrotherPtr:=ChildNodePtr;
     If ChildNodePtr=nil then begin
        Child:=nil;
        exit;
        end;
     for i:=0 to ItemCount-1 do begin
         MyBrotherPtr:=MyBrotherPtr^.BrotherNodePtr;
         if MyBrotherPtr^.BrotherNodePtr=nil then begin
            if i<ItemCount-1 then begin
            Child:=nil;
            exit;
            end
            else break;
         end;
     end;
     Child:=MyBrotherPtr;
     end;{TNode.Child}

{
 NAME:          TNode.RemoveBrother
 INPUT:         Brother Index : integer
 OUTPUT:        Boolean (True means operation successfull)
 PURPOSE:       remove a brother of a node indexed by input
}
function TNode.RemoveBrother(ItemPosition:integer):boolean;
var
     i:integer;
     LinkPrevious:PNode;
     LinkForward:PNode;
     CurrentNode:PNode;
begin
     If ItemPosition=0 then begin
      if BrotherNodePtr<>nil then begin
         LinkForward:=BrotherNodePtr^.BrotherNodePtr;
         BrotherNodePtr^.BrotherNodePtr:=nil;
         Dispose(BrotherNodePtr,Destroy);
         BrotherNodePtr:=LinkForward;
         RemoveBrother:=True
         end
         else RemoveBrother:=False;
     end
     else begin
      if BrotherNodePtr^.BrotherNodePtr=nil then begin
         RemoveBrother:=False;
         exit;
         end;
      LinkPrevious:=BrotherNodePtr;
      CurrentNode:=BrotherNodePtr;
      for i:=0 To ItemPosition-1 do begin
        if CurrentNode^.BrotherNodePtr=nil then break;
        LinkPrevious:=CurrentNode;
        CurrentNode:=CurrentNode^.BrotherNodePtr;
      end;
      if i=ItemPosition-1 then begin
       LinkForward:=CurrentNode^.BrotherNodePtr;
       CurrentNode^.BrotherNodePtr:=nil;
       Dispose(CurrentNode,Destroy);
       LinkPrevious^.BrotherNodePtr:=LinkForward;
       RemoveBrother:=True;
       end else
       RemoveBrother:=False;
     end;
     end;{TNode.RemoveBrother}

{
 NAME:          TNode.RemoveChild
 INPUT:         Child Index : integer
 OUTPUT:        Boolean
 PURPOSE:       Remove Indexed child from TNode
}
function TNode.RemoveChild(ItemPosition:integer):boolean;
var
    i:integer;
    LinkPrevious:PNode;
    LinkForward:PNode;
    CurrentNode:PNode;
begin
    If ItemPosition=0 then begin
       If ChildNodePtr<>nil then begin
          LinkForward:=ChildNodePtr^.BrotherNodePtr;
          ChildNodePtr^.BrotherNodePtr:=nil;
          Dispose(ChildNodePtr,Destroy);
          ChildNodePtr:=LinkForward;
          RemoveChild:=True;
       end
       else RemoveChild:=False;
    end
    else begin
          RemoveChild:=ChildNodePtr^.RemoveBrother(ItemPosition-1);
    end;
    end;{TNode.RemoveChild}

{
 NAME:          TNode.AddBrother
 INPUT:         NodeType : ContentsType, NodeValue : string
 OUTPUT:        PNode
 PURPOSE:       Adds a brother with input contents and returns pointer to it
}
function TNode.AddBrother(ContentsType:ContentsType;Value:string):PNode;
var
    LastNodeBrother:PNode;
    ANode:PNode;
begin
    New(ANode,Create(ContentsType,Value));
    AddBrother:=ANode;
    if BrotherNodePtr=nil then begin
       BrotherNodePtr:=ANode;
       Anode^.ParentNodePtr:=ParentNodePtr;
    end
    else begin
    LastNodeBrother:=BrotherNodePtr;
    while LastNodeBrother^.BrotherNodePtr<>nil do begin
          LastNodeBrother:=LastNodeBrother^.BrotherNodePtr;
    end;
    LastNodeBrother^.BrotherNodePtr:=ANode;
    Anode^.ParentNodePtr:=LastNodeBrother^.ParentNodePtr;
    end;
    end;{TNode.AddBrother}

{
 NAME:          TNode.AddChild
 INPUT:         NodeType : ContentsType, NodeValue : string
 OUTPUT:        PNode
 PURPOSE:       Adds a Child with input contents and returns a pointer to it
}
function TNode.AddChild(ContentsType:ContentsType;Value:string):PNode;
var
    LastNodeChild:PNode;
    ANode:PNode;
begin
    New(ANode,Create(ContentsType,Value));
    ANode^.ParentNodePtr:=@Self;
    AddChild:=ANode;
    if ChildNodePtr=nil then begin
       ChildNodePtr:=ANode;
    end
    else begin
    LastNodeChild:=ChildNodePtr;
    while LastNodeChild^.BrotherNodePtr<>nil do begin
          LastNodeChild:=LastNodeChild^.BrotherNodePtr;
    end;
    LastNodeChild^.BrotherNodePtr:=ANode;
    end;
    end;{TNode.AddChild}

{
 NAME:          TNode.Create : constructor
 INPUT:         NodeType : ContentsType, NodeValue: string
 OUTPUT:        void
 PURPOSE        Creates a new node by initializing field values and
                allocating contents record
}
constructor TNode.Create(ContentsType:ContentsType;Value:string);
var
    Code:integer;
    i:extended;
begin
    New(NodeContents);
    NodeType:=ContentsType;
    Case ContentsType of
         NodeVariable: NodeContents^.MyVariable:=Value;
         NodeOperator: NodeContents^.MyOperator:=Value;
         NodeValue:    begin
                       Val(Value,I,Code);
                       NodeContents^.MyValue:=I;
                       end;
         end;
    ChildNodePtr:=nil;
    BrotherNodePtr:=nil;
    ParentNodePtr:=nil;
    end;{TNode constructor}

{
 NAME:          TNode.Destroy : destructor
 INPUT:         void
 OUTPUT:        void
 PURPOSE:       Disposes the node with it's children and brothers
                use Remove to link brothers without removing them
}
destructor TNode.Destroy;
begin
     If ChildNodePtr<>nil then Dispose(ChildNodePtr,Destroy);
     If BrotherNodePtr<>nil then Dispose(BrotherNodePtr,Destroy);
     Dispose(NodeContents);
     end;{TNode destructor}

{
 NAME:          TNode.Contents
 INPUT:         void
 OUTPUT:        string
 PURPOSE:       returns string type for node contents
}
function TNode.Contents:string;
var
   NeedConvert:string;
begin
   case NodeType of
     NodeVariable: Contents:=NodeContents^.MyVariable;
     NodeOperator: Contents:=NodeContents^.MyOperator;
     NodeValue:    begin
                   Str(NodeContents^.MyValue:16:3,NeedConvert);
                   Contents:=NeedConvert;
                   end;
     NodeSingle:   Contents:=NodeContents^.MySingle;
     end;
     end;{TNode.Contents}

{
 NAME:          TNode.Show
 INPUT:         level : integer , 0 is top level of a tree
 OUTPUT:        standard output
 PURPOSE:       writes the tree to standard output
}
procedure TNode.Show(level:integer);
var
   i:integer;
begin
     for i:=0 to level do write('  ');
     writeln(Contents);
     if ChildNodePtr<>nil then begin
        ChildNodePtr^.Show(level+1);
        end;
     if BrotherNodePtr<>nil then begin
        BrotherNodePtr^.Show(level);
        end;
     end;{TNode.Show}

{
 NAME:          TNode.ChildCount
 INPUT:         void
 OUTPUT:        integer
 PURPOSE:       counts the children of a node
}
function TNode.ChildCount:integer;
var
   ChildNode:PNode;
   ChildCounter:integer;
begin
     ChildCounter:=0;
     ChildNode:=ChildNodePtr;
     while ChildNode<>nil do begin
           ChildNode:=ChildNode^.BrotherNodePtr;
           ChildCounter:=ChildCounter+1;
           end;
     ChildCount:=ChildCounter;
     end;

{
 NAME:          TNode.Parent
 INPUT:         void
 OUTPUT:        PNode
 PURPOSE:       returns the pointer to parent node (if possible)
}
function TNode.Parent:PNode;
begin
     Parent:=@Self.ParentNodePtr^;
     end;

{
 NAME:          TNode.BrothersCount
 INPUT:         void
 OUTPUT:        integer
 PURPOSE:       counts all brothers (self included)
                -2 means at top of tree and ParentNode inexistant
}
function TNode.BrothersCount:integer;
var
   CurrentIndex:integer;
   CurrentNode:PNode;
begin
     if ParentNodePtr<>nil then
     BrothersCount:=ParentNodePtr^.ChildCount
     else BrothersCount:=-2;
end;

{
 NAME:          TNode.Index
 INPUT:         void
 OUTPUT:        integer
 PURPOSE:       returns the position of the node under the ParentNode
                -2 means no parent node
                -1 means the tree is corrupt
}
function TNode.Index:integer;
var CurrentNode:PNode;
    CurrentIndex:integer;
begin
     CurrentIndex:=0;
     If ParentNodePtr=nil then begin
        Index:=-2;        {returns -2 if first level of tree}
        exit;
        end;
     CurrentNode:=ParentNodePtr^.ChildNodePtr;
     if CurrentNode=@Self then begin
        Index:=0;         {if first element, then zero position}
        exit;
        end;
     while CurrentNode<>nil do begin
           CurrentIndex:=CurrentIndex+1;
           CurrentNode:=CurrentNode^.BrotherNodePtr;
           if CurrentNode=nil then break;
           if CurrentNode=@Self then begin
              Index:=CurrentIndex;
              exit;
              end;
           end;
           Index:=-1;
     end;

{
 NAME:          TNode.InsertLevel
 INPUT:         Node : PNode
 OUTPUT:        PNode
 PURPOSE:       - inserts a node into the tree that has no brothers,
                i.e. adds a whole vertical level to the tree
                - adds an item to the new node and returns pointer to it
                This is equal to push the node to the left and add a new
                right item on a binary tree
 note:          pointers have shitty behavior, this seems to work...
                this routine has been rewritten at least 20 times...
}
function TNode.InsertLevel(BItem:PNode):PNode;
var
   NewNode:PNode;
begin
   New(NewNode,Create(NodeType,Contents));
      NewNode^.NodeType:=NodeType;
      NewNode^.NodeContents^:=NodeContents^;
      NewNode^.ChildNodePtr:=ChildNodePtr;
      NewNode^.BrotherNodePtr:=BrotherNodePtr;
      NewNode^.ParentNodePtr:=@Self;
   NodeType:=BItem^.NodeType;
   NodeContents^:=BItem^.NodeContents^;
   ChildNodePtr:=NewNode;
   BrotherNodePtr:=nil;
   InsertLevel:=AddChild(NodeValue,'0');
end;

{TNode ends here}

{TTree starts here}
{
 NAME:          TTree.FindItem
 INPUT:         Node Type :  ContentsType, Item Value : string
 OUTPUT:        PNode
 PURPOSE:       finds a node designated by contents in the tree
                nil means nothing has been found
}
function TTree.FindItem(MyContentsType:ContentsType;MyValue:string):PNode;
begin
          if ChildNodePtr=nil then FindItem:=nil else
          FindItem:=ChildNodePtr^.FindItem(MyContentsType,MyValue);
end;

{
 NAME:          TTree.RemoveChild
 INPUT:         Index : integer
 OUTPUT:        void
 PURPOSE:       removes a child at position index if exists
}
procedure TTree.RemoveChild(ItemsCount:integer);
begin
     if ItemsCount=0 then begin
        if ChildNodePtr<>nil then ChildNodePtr:=ChildNodePtr^.BrotherNodePtr;
     end
     else begin
        ChildNodePtr^.RemoveBrother(ItemsCount-1);
     end;
end;

{
 NAME:          TTree.AddChild
 INPUT:         Node Type : ContentsType, Node Value : string
 OUTPUT:        PNode
 PURPOSE:       adds a child and returns a pointer to it
}
function TTree.AddChild(ContentsType:ContentsType;Value:string):PNode;
var
   ANode:PNode;
begin
     if ChildNodePtr=nil then begin
        New(ANode,Create(ContentsType,Value));
        ChildNodePtr:=ANode;
        ANode^.ParentNodePtr:=nil;
        Addchild:=ANode;
     end
     else AddChild:=ChildNodePtr^.AddBrother(ContentsType,Value);
     end;

{
 NAME:          TTree.Show
 INPUT:         void
 OUTPUT:        standard output
 PURPOSE:       writes the tree structure to standard output
}
procedure TTree.Show;
begin
     writeln(Name);
     if ChildNodePtr<>nil then ChildNodePtr^.Show(0);
     end;

{
 NAME:          TTree.ChildCount
 INPUT:         void
 OUTPUT:        integer
 PURPOSE:       counts the number of children of TTree
}
function TTree.ChildCount:integer;
var      MyCounter:integer;
         MyPointer:PNode;
begin
     MyCounter:=0;
     if ChildNodePtr=nil then
        ChildCount:=0
        else begin
        MyPointer:=ChildNodePtr;
        while(MyPointer<>nil) do begin
         MyPointer:=MyPointer^.BrotherNodePtr;
         MyCounter:=MyCounter+1;
        end;
        ChildCount:=MyCounter;
        end;

     end;

{
 NAME:          TTree.Child
 INPUT:         Index : integer
 OUTPUT:        PNode
 PURPOSE:       returns a pointer to child indexed by index
}
function TTree.Child(ChildPosition:integer):PNode;
var
   MyPointer:PNode;
begin
     if ChildNodePtr=nil then
        Child:=nil
        else begin
        MyPointer:=ChildNodePtr;
        while(MyPointer<>nil)and(ChildPosition>0) do begin
         ChildPosition:=ChildPosition-1;
         MyPointer:=MyPointer^.BrotherNodePtr;
        end;
        Child:=MyPointer;
        end;
        end;

{
 NAME:          TTree.Create : constructor
 INPUT:         Name : string
 OUTPUT:        void
 PURPOSE:       initializes new tree fields
}
constructor TTree.Create(ConstructName:string);
begin
     ChildNodePtr:=nil;
     Name:=ConstructName;
     end;

{
 NAME:          TTree.Destroy : destructor
 INPUT:         void
 OUTPUT:        void
 PURPOSE:       disposes the tree with nodes
}
destructor TTree.Destroy;
begin
     if ChildNodePtr<>nil then Dispose(ChildNodePtr, Destroy);
end;
{TTree ends here}

begin
     clrscr;
     writeln('อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ');
     writeln('       Initializing Object Pascal TreeView unit, version 1.01 (27.04.96).      ');
     writeln('     (c) Daniel Doubrovkine - University of Geneva - dblock@infomaniak.ch      ');
     writeln('อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ');
end.