unit TobyPascal;

interface

uses
  Classes, SysUtils, math, Windows;

type
  TobyOnloadCB = procedure (isolate: Pointer); cdecl;
  TobyOnunloadCB = procedure (isolate: Pointer; exitCode: integer); cdecl;
  TobyHostcallCB = function (name, value: PAnsiChar):PAnsiChar; cdecl;

  TToby = class
    private
      started : boolean;
      H: HINST;
      constructor Init;
    public
      onLoad : TobyOnloadCB;
      onUnload : TobyOnunloadCB;
      onHostCall : TobyHostcallCB;

      InputPipeRead  : THandle;
      InputPipeWrite : THandle;
      OutputPipeRead  : THandle;
      OutputPipeWrite : THandle;
      ErrorPipeRead  : THandle;
      ErrorPipeWrite : THandle;

      function start(processName, userScript: PAnsiChar) : boolean;
      function run(source: PAnsiChar) : PAnsiChar;
      procedure emit(name, value: PAnsiChar);
      class function Create: TToby;
  end;

implementation
var
  Singleton : TToby = nil;
  security : TSecurityAttributes;
  tobyInit:procedure (processName, userScript: PAnsiChar;
                     tobyOnLoad: TobyOnloadCB;
                     tobyOnUnload: TobyOnunloadCB;
                     tobyHostCall: TobyHostcallCB); cdecl;
  tobyJSCompile:function (source, dest: PAnsiChar; n: integer):integer; cdecl;
  tobyJSCall:function (name, value, dest: PAnsiChar; n: integer):integer; cdecl;
  tobyJSEmit: function(name, value: PAnsiChar):integer; cdecl;


procedure _OnLoad(isolate: Pointer); cdecl;
begin
  //writeln(':: default tobyOnLoad called');
end;
procedure _OnUnload(isolate: Pointer; exitCode: integer); cdecl;
begin
  //writeln(':: default _OnUnload called');
end;
function _OnHostCall(key,value: PAnsiChar):PAnsiChar; cdecl;
begin
  //writeln(':: default tobyHostCall called. ', key, ' : ',value);
  exit('');
end;

constructor TToby.Init;
var
  stdout: THandle;
begin
  // in case of 'git bash'(mingw) in windows
  stdout := GetStdHandle(Std_Output_Handle);
  Win32Check(stdout <> Invalid_Handle_Value);

  if (stdout = 0) then
  begin

    With security do
    begin
      nlength := SizeOf(TSecurityAttributes) ;
      binherithandle := true;
      lpsecuritydescriptor := nil;
    end;

    // FIXME : check returns
    CreatePipe(InputPipeRead, InputPipeWrite, @security, 0);
    CreatePipe(OutputPipeRead,OutputPipeWrite, @security, 0);
    CreatePipe(ErrorPipeRead, ErrorPipeWrite, @security, 0);
    SetStdHandle(Std_Input_Handle, InputPipeRead);
    SetStdHandle(Std_Output_Handle, OutputPipeWrite);
    SetStdHandle(Std_Error_Handle, ErrorPipeWrite);
  end;

  // dynamically load the dll.
  H := LoadLibrary('tobynode.dll');

  if H<=0 then
  begin
    raise Exception.Create('tobynode.dll error!');
    exit;
  end;

  @tobyInit := GetProcAddress(H, Pchar('tobyInit'));
  @tobyJSCompile := GetProcAddress(H, Pchar('tobyJSCompile'));
  @tobyJSCall := GetProcAddress(H, Pchar('tobyJSCall'));
  @tobyJSEmit := GetProcAddress(H, Pchar('tobyJSEmit'));

  started := false;

  // set default.
  onLoad := @_OnLoad;
  onUnload := @_OnUnload;
  onHostCall := @_OnHostCall;

  inherited Create;
end;

class function TToby.Create: TToby;
begin
  if Singleton = nil then
    Singleton := TToby.Init;
  Result := Singleton;
end;

function TToby.start(processName, userScript: PAnsiChar) : boolean;
begin
  if started = false then
  begin
    started := true;
    tobyInit(processName, userScript, onLoad, onUnload, onHostCall);
    exit(true);
  end;
  exit(false);
end;


procedure TToby.emit(name, value: PAnsiChar);
begin
  tobyJSEmit(name, value);
end;

function TToby.run(source: PAnsiChar) : PAnsiChar;
var
  dest: Array[0..1024] of AnsiChar;
  ret: integer;
begin
  ret := tobyJSCompile(source, dest, Length(dest));

  if (ret < 0) then
    writeln('** Error ', ret, ' ', dest);

  exit(dest);
end;

end.
