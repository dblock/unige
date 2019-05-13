(*  DANIEL DOUBROVKINE - 1st year computer Science - University of Geneva   *)
(*       e-mail welcome : dblock@infomaniak.ch /doubrov5@cui.unige.ch       *)
(*                 LABO of 04.04.96 Simple Calculator                       *)
(*
Accepts:
            integer and float, positive and negative extended number in the
            interval of 3.4e-4932..1.1e4932
Performs:
            û                                   tanh
            sinh                                coth
            cosh
            /                                   pi      : 3.14...
            *                                   E       : exp(1.0)
            -                                   random
            +                                   frac
            |           : integer division      abs
            !           : factor                int
            ^           : power (any power!)    round
            e           : * 10^                 trunc
            %           : x % of rightside      exp
            sqr         : ^2                    ln
            sqrt                                csc     : = 1/sin
            sin                                 sec     : = 1/cos
            cos                                 cot
            tan                                 arctan
            arcsin                              m       : = .. mod ..
            arccos                              log
            'A'..'Z'|'E','a'..'z'|'e','m' variables can be defined, 'A'<>'a'!
Calculation notes:
            - Parenthesis aware
            - calculation order:
              !,e,^,%,(*,/),(+,-)
              predefined functions are immediate
            - ! is performed BEFORE ^, thus 2^3!=64.00 and not 40320.00
            - e is performed BEFORE ^, thus 2!^2e1=2!^(2*10) and not (2!^2)*10
            - % is the latest operation performed after !,e,^.
            - trigonometric function work in radians
Copyright notes:
            - TreeView unit (v.1.0 - 18.04.96) is (c) D.D.
            - TNode & TTree objects (v.1.0 - 18.04.96) are (c) D.D.
              may use and modify freely, but please put an ack if you do so
            - TTree is a pointer to the top TNode, both allow to construct
              virtually infinite multilevel trees, sort of Delphi TreeView
            - Pascal is (c) of a swiss guy
*)

{$N+,E+}
program TP040496;                               {use input for key entries}
uses crt,dos,strings,memory,treeview;           {standard lib & treeview}
const
   NPrec:integer=16;
   DPrec:integer=10;
var
   OrigMode:word;
   KbdIntVec : Procedure;
   CalcTree:PTree;
   CharRead:char;
   TempNode:PNode;
   VariableTree:PTree;
   NodeError:boolean;
   CalcNode:PNode;
   CalcString:string;
   CalcPos:integer;
   NextInteger:integer;
   OldExitProc:pointer;


procedure ErrorHandler;
begin
     ExitProc:=OldExitProc;
     writeln('MyErrorHandler');
end;

{new keyboard interrupt}
procedure KeyHook; interrupt;
begin
   if Port[$60]<$80 then
    if (Port[$60]-1)=0 then begin
        asm pushf end; {asm}
        KbdIntVec;
        SetIntVec($9,Addr(KbdIntVec));
        Dispose(CalcTree,Destroy);
        TextMode(OrigMode);      { use 43 or 50 lines on EGA/VGA }
        halt(0);
        end; {if}
    asm pushf end;{asm}
   KbdIntVec;
   end;{KeyHook}

{compares two string type elements}
function StrICompare(String1:string;String2:string):Integer;
var
   String1Pas:PChar;
   String2Pas:PChar;
begin
   String1Pas:=MemAlloc(Length(String1));
   String2Pas:=MemAlloc(Length(String2));
   StrPCopy(String1Pas,String1);
   StrPCopy(String2Pas,String2);
   StrICompare:=StrIComp(String1Pas,String2Pas);
   FreeMem(String1Pas,Length(String1));
   FreeMem(String2Pas,Length(String2));
   end; {StrICompare}

{updates the next integer sign in the analysed string}
procedure UpdateNextInteger;
begin
   NextInteger:=0;
   if CalcString[CalcPos]='-' then NextInteger:=-1;
   if CalcString[CalcPos]='+' then NextInteger:=1;
   If NextInteger<>0 then CalcPos:=CalcPos+1;
   end;

{reads the next valid item from input}
procedure ReadItem(var SymbolNode:PNode);
   procedure ReadCh; {gets the next char}
   begin
      if CalcPos>Length(CalcString) then
         CharRead := Chr(255)
      else begin
         CharRead:=CalcString[CalcPos];
         CalcPos:=CalcPos+1;
         end; {else}
      end; {ReadCh}
   function ReadNumber:extended;
   var
      MyNumber:extended;
      dCounter:longint;
   begin
      MyNumber:=0;
      while CharRead in ['0'..'9'] do begin
         MyNumber := MyNumber * 10 + (ord(CharRead)-ord('0'));
         ReadCh;
      end;{while}
      dCounter:=1;
      if (CharRead='.') or (CharRead=',') then begin
         ReadCh;
         while CharRead in ['0'..'9'] do begin
            MyNumber:=MyNumber*10 + (ord(CharRead)-ord('0'));
            DCounter:=DCounter*10;
            ReadCh;
            end;{while}
         end;{if}
      MyNumber:=MyNumber/DCounter;
      if NextInteger<>0 then begin
         MyNumber:=MyNumber*NextInteger;
         NextInteger:=0;
         end;{if}
      ReadNumber:=MyNumber;
      end;{ReadNumber}

   {check variable table for a variable, returns a pointer if node found}
   function CheckVariableTable(variable:string):PNode;
   begin
      CheckVariableTable:=VariableTree^.FindItem(NodeVariable,variable);
      end; {CheckVariableTable}

var {ReadItem}
   SymbolProc:string;
begin {ReadItem}
   while CharRead=' ' do ReadCh;
   with SymbolNode^ do begin
      case CharRead of
         '0'..'9' : begin
         {read an unsigned integer}
                       NodeType:=NodeValue;
                       NodeContents^.MyValue:=ReadNumber;
                       end;{'0'..'9'}
         'A'..'Z', 'a'..'z' : begin
                                 SymbolProc:='';
                                 while CharRead in ['A'..'Z','a'..'z'] do begin
                                       SymbolProc:=SymbolProc+CharRead;
                                       ReadCh;
                                       end;{while}
                                 if (SymbolProc='û') or
                                    (SymbolProc='m') or
                                    (SymbolProc='e') then begin
                                     UpdateNextInteger;
                                     NodeType:=NodeOperator;
                                     NodeContents^.MyOperator:=SymbolProc;
                                 end else
                                 if (SymbolProc<>'E') and
                                    (Length(SymbolProc)=1) then begin
                                     NodeType:=NodeVariable;
                                     NodeContents^.MyVariable := SymbolProc;
                                     if (CheckVariableTable(SymbolProc)=nil) and
                                        (CheckVariableTable('-'+SymbolProc)=nil) then
                                         if NextInteger=-1 then
                                            VariableTree^.AddChild(NodeVariable,'-'+SymbolProc)
                                         else VariableTree^.AddChild(NodeVariable,SymbolProc);
                                     end{<>'E'}
                                 else begin
                                         If (StrICompare(SymbolProc,'pi')=0) then begin
                                             NodeType:=NodeValue;
                                             NodeContents^.MyValue:=Pi;
                                             end{if}
                                         else
                                             if SymbolProc='E' then begin
                                                NodeType:=NodeValue;
                                                NodeContents^.MyValue:=Exp(1.0);
                                                end{='E'}
                                             else begin
                                                NodeType:=NodeSingle;
                                                NodeContents^.MySingle:=SymbolProc;
                                             end;
                                         end;{else begin}
                                 end;{'A'..'z'}
         '(','+','-','*','/','^','|','%','û' : begin
                 UpdateNextInteger;
                 NodeType:=NodeOperator;
                 NodeContents^.MyOperator:=CharRead;
                 ReadCh;
                 end;
         '!',')',Chr(255) : begin
                 NodeType:=NodeOperator;
                 NodeContents^.MyOperator:=CharRead;
                 ReadCh;
                 end;
         else begin {else case}
                 writeln('  ERROR: char ', CharRead, ' is invalid.');
                 NodeType:=NodeOperator;
                 NodeContents^.MyOperator:=Chr(255);
                 NodeError := true;
                 end;{else}
         end;{case}
      end;{with}
   end;{ReadItem}

{analyses the expression, constructs the calculation tree               }
procedure AnalyseExpression(Expression:PNode; var MyReadItem:PNode);
  procedure Term(Expression:PNode);
   procedure Percentage(Expression:PNode);
    procedure AnyRoot(Expression:PNode);
     procedure Power(Expression:PNode);
      procedure TenPower(Expression:PNode);
       procedure Factor(Expression:PNode);
        procedure Operator(Expression:PNode);
          begin
             if (MyReadItem^.NodeType=NodeSingle) then begin
                 Expression^.NodeType:=NodeSingle;
                 Expression^.NodeContents^.MySingle:=MyReadItem^.NodeContents^.MySingle;
                 ReadItem(MyReadItem);
               if (MyReadItem^.NodeType<>NodeOperator) or
                  (MyReadItem^.NodeContents^.MyOperator<>'(') then begin
                   writeln('  Function ',Expression^.Contents,' requires "("!');
                   NodeError:=true;
                   end;{'('}
                   ReadItem(MyReadItem);
                   Expression^.AddChild(NodeValue,'0');
                   AnalyseExpression(Expression^.Child(0),MyReadItem);
               if (MyReadItem^.NodeType<>NodeOperator) or
                  (MyReadItem^.NodeContents^.MyOperator<>')') then begin
                   writeln('  ERROR: ")" expected.');
                   NodeError:=true;
                   end;{')'}
                ReadItem(MyReadItem);
                end {NodeSingle} else
            if (MyReadItem^.NodeType=NodeValue) then begin
                Expression^.NodeType:=NodeValue;
                Expression^.NodeContents^.MyValue:=MyReadItem^.NodeContents^.MyValue;
                ReadItem(MyReadItem);
                end{NodeValue} else
            if (MyReadItem^.NodeType=NodeVariable) then begin
                Expression^.NodeType:=NodeVariable;
                Expression^.NodeContents^.MyVariable:=MyReadItem^.NodeContents^.MyVariable;
                ReadItem(MyReadItem);
                end {variable} else
            if (MyReadItem^.NodeType=NodeOperator) and
               (MyReadItem^.NodeContents^.MyOperator='(') then begin
                ReadItem(MyReadItem);
                AnalyseExpression(Expression^.Parent^.Child(1),MyReadItem);
                if (MyReadItem^.NodeType<>NodeOperator) or
                   (MyReadItem^.NodeContents^.MyOperator<>')') then begin
                    writeln('  ERROR: ")" expected.');
                    NodeError:=true;
                    end;{')'}
                ReadItem(MyReadItem);
                end {'('}
            else begin
                 writeln('  ERROR: unexpected sign, number, variable or function');
                 NodeError:=true;
                 end; {else}
            end;{Operator}
        begin {Factor}
           Operator(Expression);
           while (MyReadItem^.NodeType=NodeOperator) and
                 (MyReadItem^.NodeContents^.MyOperator='!') do begin
                  Expression:=Expression^.InsertLevel(MyReadItem);
                  MyReadItem^.NodeType:=NodeValue;
                  MyReadItem^.NodeContents^.MyValue:=1;
                  Operator(Expression^.Parent^.Child(1));
                  Expression:=Expression^.Parent;
                  end;{while}
           end; {Factor}
      begin {TenPower}
         Factor(Expression);
         while (MyReadItem^.NodeType=NodeOperator) and
               (MyReadItem^.NodeContents^.MyOperator='e') do begin
                MyReadItem^.NodeContents^.MyOperator:='*';
                Expression:=Expression^.InsertLevel(MyReadItem);
                Expression^.NodeType:=NodeOperator;
                Expression^.NodeContents^.MyOperator:='^';
                Expression^.AddChild(NodeValue,'10');
                Expression:=Expression^.AddChild(NodeValue,'0');
                MyReadItem^.NodeType:=NodeValue;
                MyReadItem^.NodeContents^.MyValue:=0;
                ReadItem(MyReadItem);
                Factor(Expression^.Parent^.Child(1));
                Expression:=Expression^.Parent;
                end;{while}
        end;{TenPower}
      begin {Power}
         TenPower(Expression);
         while (MyReadItem^.NodeType=NodeOperator) and
               (MyReadItem^.NodeContents^.MyOperator='^') do begin
                Expression:=Expression^.InsertLevel(MyReadItem);
                ReadItem(MyReadItem);
                TenPower(Expression^.Parent^.Child(1));
                Expression:=Expression^.Parent;
                end;{while}
         end;{Power}
      begin{AnyRoot}
         Power(Expression);
         while(MyReadItem^.NodeType=NodeOperator) and
              (MyReadItem^.NodeContents^.MyOperator='û') do begin
              Expression:=Expression^.InsertLevel(MyReadItem);
              ReadItem(MyReadItem);
              Power(Expression^.Parent^.Child(1));
              Expression:=Expression^.Parent;
              end;
         end;{AnyRoot}
   begin {Percentage}
        AnyRoot(Expression);
        while (MyReadItem^.NodeType=NodeOperator) and
              (MyReadItem^.NodeContents^.MyOperator='%') do begin
               Expression:=Expression^.InsertLevel(MyReadItem);
               ReadItem(MyReadItem);
               AnyRoot(Expression^.Parent^.Child(1));
               Expression:=Expression^.Parent;
               end;{while}
        end;{Percentage}
   begin {Term}
      Percentage(Expression);
      while (MyReadItem^.NodeType=NodeOperator) and
            ((MyReadItem^.NodeContents^.MyOperator='*') or
             (MyReadItem^.NodeContents^.MyOperator='/') or
             (MyReadItem^.NodeContents^.MyOperator='m') or
             (MyReadItem^.NodeContents^.MyOperator='|')) do begin
              Expression:=Expression^.InsertLevel(MyReadItem);
              ReadItem(MyReadItem);
              Percentage(Expression^.Parent^.Child(1));
              Expression:=Expression^.Parent;
              end;{while}
      end; {Term}
  begin {Expression}
     Term(Expression);
     while (MyReadItem^.NodeType=NodeOperator) and
           ((MyReadItem^.NodeContents^.MyOperator='+') or
            (MyReadItem^.NodeContents^.MyOperator='-')) do begin
             Expression:=Expression^.InsertLevel(MyReadItem);
             ReadItem(MyReadItem);
             Term(Expression^.Parent^.Child(1));
             Expression:=Expression^.Parent;
             end;{while}
     end; {Expression}

{read an signed numeric value...ReadNumber name is rather obsolete}
function ReadNumber:extended;
var
   MyString:string;
   I:extended;
   Code: Integer;
begin
   code:=1;
   write(' > ');
   while (code<>0) do begin
      readln(MyString);
      Val(MyString, I, Code);
      if Length(MyString)=0 then begin
         I:=0;
         code:=0;
         end;{if}
      if code <> 0 then Write('   Ooops, error...please retry > ')
      end;{while}
      ReadNumber:=I;
   end;{ReadNumber}

function IntToStr(I: extended): String;
var
   S: string[11];
begin
   Str(I:NPrec:DPrec, S);
   IntToStr := S;
   end;{IntToStr}

{evaluate the calculation tree, calculates ^,!,+,-,/,*,|}
function Evaluation(Expression:PNode):extended;
   {look for a variable in the var table}
   function VariableValue(Variable:string):extended;
   begin
      VariableValue:=VariableTree^.FindItem(NodeVariable,Variable)^.Child(0)^.NodeContents^.MyValue;
      if VariableTree^.FindItem(NodeVariable,Variable)=nil then
         VariableValue:=VariableTree^.FindItem(NodeVariable,'-'+Variable)^.Child(0)^.NodeContents^.MyValue;
      end;{VariableValue}
   function Factor(Item:extended):extended; {!}
   var
      Result:extended;
   begin
      if (Item<0) or (Trunc(Item)<>Item) then begin
          writeln('  ERROR : unable to calculate a factor of ',Item:NPrec:DPrec);
          NodeError:=true;
          exit;
          end;{if}
      Result:=1;
      while Item>0 do begin
         Result:=Result*Item;
         Item:=Item-1;
         end;{while}
      Factor:=Result;
      end;{Factor}
   function Power(Item,MyPower:extended):extended;
   var
      ThePower:extended;
      Sign:integer;
   begin
      Sign:=1;
      if Item<0 then begin
         Item:=-Item;
         Sign:=-1;
         end;{if}
      Power:=Sign*exp(MyPower*ln(Item));
   end;
var
   g, d, Result : extended;
begin
   if NodeError=true then exit;
   if Expression^.Contents='=' then
      Evaluation:=Evaluation(Expression^.Child(0))
      else
   if Expression^.NodeType = NodeValue then
      Evaluation := Expression^.NodeContents^.MyValue
   else if Expression^.NodeType = NodeVariable then
      Evaluation := VariableValue(Expression^.NodeContents^.MyVariable)
   else if Expression^.NodeType = NodeSingle then begin
       g := Evaluation(Expression^.Child(0));
       if StrICompare(Expression^.NodeContents^.MySingle,'sinh')=0 then Evaluation:= (exp(g)-exp(-g))/2 else
       if StrICompare(Expression^.NodeContents^.MySingle,'cosh')=0 then Evaluation:= (exp(g)+exp(-g))/2 else
       if StrICompare(Expression^.NodeContents^.MySingle,'tanh')=0 then begin
             Evaluation:=(exp(g)-exp(-g))/(exp(g)+exp(-g)); {tanh has R for domain}
             end else
       if StrICompare(Expression^.NodeContents^.MySingle,'coth')=0 then begin
             if exp(g)=exp(-g) then begin
                writeln('  ERROR : division by zero at Coth() expression!');
                NodeError:=true;
                exit;
                end;
             Evaluation:=(exp(g)+exp(-g))/(exp(g)-exp(-g));
             end else
       if StrICompare(Expression^.NodeContents^.MySingle,'random')=0 then begin
             if g<=0 then begin
                writeln('  Senseless random number requested, but it will still be calculated.');
                end;
                Evaluation:= Random(trunc(g));
             end else
       if (StrICompare(Expression^.NodeContents^.MySingle,'sqr')=0) or
          (StrICompare(Expression^.NodeContents^.MySingle,'ý')=0) then Evaluation:= sqr(g) else
       if StrICompare(Expression^.NodeContents^.MySingle,'sqrt')=0 then begin
             if g<0 then begin
                writeln('  ERROR: square root of a negative value!');
                NodeError:=true;
                exit;
                end;
             Evaluation:= sqrt(g)
             end else
       if StrICompare(Expression^.NodeContents^.MySingle,'sin')=0 then Evaluation:= Sin(g) else
       if StrICompare(Expression^.NodeContents^.MySingle,'cos')=0 then Evaluation:= Cos(g) else
       if StrICompare(Expression^.NodeContents^.MySingle,'tan')=0 then begin
             if Cos(g)=0 then begin
                writeln('  ERROR : division by zero at Tan() expression!');
                NodeError:=true;
                exit;
                end;
             Evaluation:= Sin(g)/Cos(g);
             end else
       if StrICompare(Expression^.NodeContents^.MySingle,'arcsin')=0 then begin
             if (1-sqr(g))<0 then begin
                writeln('  ERROR : square root of negative value at ArcSin() expression!');
                NodeError:=true;
                exit;
                end;
             if sqrt(1-sqr(g))=0 then begin
                writeln('  ERROR : division by zero at ArcSin() expression!');
                NodeError:=true;
                exit;
                end;
             Evaluation:= ArcTan (g/sqrt(1-sqr (g)));
          end else
       if StrICompare(Expression^.NodeContents^.MySingle,'arccos')=0 then begin
             if g=0 then begin
                writeln('  ERROR : division by zero at ArcCos() expression!');
                NodeError:=true;
                exit;
                end;
             if (1-sqr(g))<0 then begin
                writeln('  ERROR : square root of negative value at ArcCos() expression!');
                NodeError:=true;
                exit;
                end;
             Evaluation:= ArcTan (sqrt (1-sqr (g)) /g);
             end else
       if StrICompare(Expression^.NodeContents^.MySingle,'arctan')=0 then Evaluation:= ArcTan(g) else
       if StrICompare(Expression^.NodeContents^.MySingle,'cot')=0 then begin
             if Sin(g)=0 then begin
                writeln('  ERROR : division by zero at Cot() expression!');
                NodeError:=true;
                exit;
                end;
             Evaluation:= Cos(g)/Sin(g);
             end else
       if StrICompare(Expression^.NodeContents^.MySingle,'sec')=0 then begin
             if cos(g)=0 then begin
                writeln('  ERROR : division by zero at Sec() expression!');
                NodeError:=true;
                exit;
                end;
             Evaluation:= 1/cos(g);
             end else
       if StrICompare(Expression^.NodeContents^.MySingle,'csc')=0 then begin
             if sin(g)=0 then begin
                writeln('  ERROR : division by zero at Csc() expression!');
                NodeError:=true;
                exit;
                end;
             Evaluation:= 1/sin(g)
             end else
       if StrICompare(Expression^.NodeContents^.MySingle,'ln')=0 then begin
             if g<=0 then begin
                writeln('  ERROR : unable to calculate a natural logarithm of a zero or negative value!');
                NodeError:=true;
                exit;
                end;
             Evaluation:= ln(g);
             end else
       if StrICompare(Expression^.NodeContents^.MySingle,'exp')=0 then Evaluation:= exp(g) else
       if StrICompare(Expression^.NodeContents^.MySingle,'log')=0 then begin
             if g<=0 then begin
                writeln('  ERROR : unable to calculate a logarithm of a zero or negative value!');
                NodeError:=true;
                exit;
                end;
          Evaluation:= ln(g)/ln(10);
          end else
       if StrICompare(Expression^.NodeContents^.MySingle,'trunc')=0 then Evaluation:= trunc(g) else
       if StrICompare(Expression^.NodeContents^.MySingle,'round')=0 then Evaluation:= round(g) else
       if StrICompare(Expression^.NodeContents^.MySingle,'int')=0 then Evaluation:= int(g) else
       if StrICompare(Expression^.NodeContents^.MySingle,'abs')=0 then Evaluation:= abs(g) else
       if StrICompare(Expression^.NodeContents^.MySingle,'frac')=0 then Evaluation:= g-trunc(g) else
       begin {else}
          writeln('  ERROR : unknown function ',Expression^.NodeContents^.MySingle,'.');
          NodeError:=true;
          exit;
          end;{else}
   end{else}
   else begin
      g := Evaluation(Expression^.Child(0));
      if NodeError=true then exit;
      d := Evaluation(Expression^.Child(1));
      if NodeError=true then exit;
      case Expression^.NodeContents^.MyOperator[1] of
         'm'   : Result:=trunc(g) mod trunc(d);
         '%'   : Result := (d/100)*g;
         '+'   : Result := g + d;
         '-'   : Result := g - d;
         '*'   : Result := g * d;
         '|'   : begin {detects zero divisions!!!}
                 if d=0 then begin
                    writeln('  ERROR : division by zero at integer division!');
                    NodeError:=true;
                    exit;
                    end;
                 Result := trunc(g/d);
                 end;
         '/'   : begin {detects zero divisions!!!}
                 if d=0 then begin
                    writeln('  ERROR : division by zero at non integer division!');
                    NodeError:=true;
                    exit;
                    end;
                 Result := g / d;
                 end;
         '^'   : begin
                 Result := Power(g,d);
                 if NodeError=true then exit;
                 end;
         '!'   : begin
                 Result := Factor(g);
                 If NodeError=true then exit;
                 end;
         'û'   : begin
                 if g=0 then begin
                    writeln('  ERROR : division by zero at root operation!');
                    NodeError:=true;
                    exit;
                    end;
                 Result:=Power(d,1/g);
                 end;
         end;{case}
     Evaluation:=Result;
   end;{else}
   end;{evaluation}


var {main routine}
   i:integer;
   Result:extended;
   TempString:string;
   NewTree:TNode;
begin
   OldExitProc:=ExitProc;
   ExitProc:=@ErrorHandler;
   OrigMode:=LastMode;
   TextMode(Lo(LastMode)+Font8x8);      { use 43 or 50 lines on EGA/VGA }
   writeln('extended Calculator, v.1.00 (c) D.D. - University of Geneva - 1996');
   writeln('Valid ops,fncts are: /,*,-,+,|(trunc(../..)),!,^,e(=*10^),sqr(^2),sqrt,exp,');
   writeln('                     sin,cos,tan,arcsin,arccos,arctan,cot,ln,int,abs,round,');
   writeln('                     sec(=1/cos),csc(=1/sin),trunc,frac,random,E(=exp(1.0),');
   writeln('                     %(=x % of ..),m(=..mod..),sinh,cosh,tanh,coth,û.');
   writeln('Numbers            : positive, negative integer or float.');
   writeln('Variables          : ''A''..''Z'',''a''..''z'' except ''E''(=exp(1.0)) and ''e'',''A''<>''a''.');
   writeln('Setting Int9 ISR - ESCAPE aborts calculation at any time.');
   GetIntVec($9,@KbdIntVec);
   SetIntVec($9,Addr(KeyHook));
   Randomize;
   repeat
      textcolor(15);
      write('> ');
      textcolor(7);
      NodeError:=False;
      CharRead:=' ';
      UpdateNextInteger;
      new(CalcTree,Create('Calculating tree:'));
      New(TempNode,Create(NodeVariable,'?'));
      new(VariableTree,Create('Variable occurences.'));
      {this is just for convenience of tree manipulation}
      CalcNode:=CalcTree^.AddChild(NodeVariable,'Extended Calculator');
      CalcNode:=CalcNode^.AddChild(NodeVariable,'(c) Daniel Doubrovkine');
      CalcNode^.AddChild(NodeVariable,'University of Geneva - 1996');
      CalcNode:=CalcNode^.AddChild(NodeValue,'0');
      {construct the calculation tree}
      readln(calcstring);
      CalcPos:=1;
      UpdateNextInteger;
      ReadItem(TempNode);
      AnalyseExpression(CalcNode,TempNode);
      {remove comment to see the tree}
      {CalcTree^.Show;}
      if TempNode^.NodeContents^.MyVariable <> 'ÿ' then begin
         writeln('  ERROR: missing operator.');
         NodeError:=true;
         end;
      if not NodeError then begin
         for i:=0 to VariableTree^.ChildCount-1 do begin
            TempString:=VariableTree^.Child(i)^.Contents;
            if  TempString[1]='-' then begin
               write('   ',TempString[2],':= (ENTER=0)');
               VariableTree^.Child(i)^.AddChild(NodeValue,IntToStr(-ReadNumber));
               end {if}
            else begin
               write('   ',TempString[1],':= (ENTER=0)');
               VariableTree^.Child(i)^.AddChild(NodeValue,IntToStr(ReadNumber));
               end;{else}
            end;{for}
      {remove comments to see the variables' tree}
      {variableTree^.Show;}
      Result:=Evaluation(CalcNode);
      TextColor(LightRed);
      if NodeError=false then writeln('=',Result:nPrec:dPrec);
      TextColor(7);
      end;
   {CleanUp}
   Dispose(CalcTree,Destroy);
   until 1=0; {pascal will even compare...}
   end.



