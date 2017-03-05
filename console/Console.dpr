program Console;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  math,
  Classes,
  TobyPascal in '..\TobyPascal.pas';

var
  toby : TToby;

procedure tobyOnLoad(isolate: Pointer); cdecl;
begin
  writeln('host :: tobyOnLoad called');

  toby.run('console.log("node :: hi~");');
end;
procedure tobyOnUnload(isolate: Pointer; exitCode: Integer); cdecl;
begin
  writeln('host :: tobyOnUnload called. ', exitCode);
end;
function tobyHostCall(key,value: PAnsiChar):PAnsiChar; cdecl;
begin
  writeln('host :: tobyHostCall called. ', key, ' : ',value);
  exit('from tobyHostCall');
end;

var
i : integer = 0;
begin
  try
    // start Toby
    toby := TToby.Create;
    toby.onLoad := @tobyOnLoad;
    toby.onUnload := @tobyOnUnload;
    toby.onHostCall := @tobyHostCall;

    //FIXME : replace the userScript with yours
    toby.start(PAnsiChar('toby'), PAnsiChar('require("../../../app.js")') );

    while true do
    begin
      i:= i+1;
      toby.emit('test', PAnsiChar(IntToStr(i)));
      Sleep(1000);
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
