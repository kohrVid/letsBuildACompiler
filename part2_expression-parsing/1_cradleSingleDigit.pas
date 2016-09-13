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

{ Run this app as `./cradle` and then type a single digit number
  This should return some assembly code. This is a translator }
procedure Expression;
begin
  EmitLn('MOVE #' + GetNum + ',D0')
end;

begin
  Init;
  Expression;
end.
