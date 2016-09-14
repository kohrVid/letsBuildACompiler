program Cradle;

const TAB =  ^I;

var Look: char;

procedure GetChar;
begin
  Read(Look);
end;

procedure Error(s: string);
begin
  WriteLn;
  WriteLn(^G, 'Error: ', s, '.');
end;

procedure Abort(s: string);
begin
   Error(s);
   Halt;
end;

procedure Expected(s: string);
begin
   Abort(s + ' Expected');
end;

procedure Match(x: char);
begin
  if Look = x then GetChar
  else Expected('''' + x + '''');
end;

function IsAlpha(c: char): boolean;
begin
  IsAlpha := upcase(c) in ['A'..'Z'];
end;

function IsDigit(c: char): boolean;
begin
  IsDigit := c in ['0'..'9'];
end;

function GetName: char;
begin
  if not IsAlpha(Look) then Expected('Name');
  GetName := UpCase(Look);
  GetChar;
end;

function GetNum: char;
begin
  if not IsDigit(Look) then Expected('Integer');
  GetNum := Look;
  GetChar;
end;

procedure Emit(s: string);
begin
  Write(TAB, s);
end;

procedure EmitLn(s: string);
begin
  Emit(s);
  WriteLn;
end;

procedure Init;
begin
  GetChar;
end;

procedure Expression; Forward;

procedure Factor;
begin
  if Look = '(' then begin
    Match('(');
    Expression;
    Match(')');
    end
{  Compiler can parse variables that are a single character long  }
  else if IsAlpha(Look) then
    EmitLn('MOVE ' + GetName + '(PC),D0')
  else 
    EmitLn('MOVE #' + GetNum + ',D0');
end;

procedure Multiply;
begin
  Match('*');
  Factor;
  EmitLn('MULS (SP)+, D0');
end;

procedure Divide;
begin
  Match('/');
  Factor;
  EmitLn('MOVE (SP)+, D1');
  EmitLn('DIVS D1,D0');
end;

procedure Term;
begin
  Factor;
  while Look in ['*', '/'] do begin
    EmitLn('MOVE D0,-(SP)');
    case Look of
      '*': Multiply;
      '/': Divide;
    else Expected('Mulop');
    end;
  end;
end;

procedure Add;
begin
  Match('+');
  Term;
  EmitLn('ADD (SP)+,D0');
end;

procedure Subtract;
begin
  Match('-');
  Term;
  EmitLn('SUB (SP)+,D0');
  EmitLn('NEG D0');
end;

function IsAddop(c: char): boolean;
begin
  IsAddop := c in ['+', '-'];
end;

procedure Expression;
begin
  if IsAddop(Look) then
    EmitLn('CLR D0')
  else
    Term;
  while IsAddop(Look) do begin
    EmitLn('MOVE D0,-(SP)');
    case Look of
      '+': Add;
      '-': Subtract;
    else Expected('Addop');
    end;
  end;
end;

begin
  Init;
  Expression;
end.
