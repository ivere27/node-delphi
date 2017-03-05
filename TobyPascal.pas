unit TobyPascal;

interface

uses
  Classes, SysUtils, math;

type
  TobyOnloadCB = procedure (isolate: Pointer); cdecl;
  TobyOnunloadCB = procedure (isolate: Pointer; exitCode: integer); cdecl;
  TobyHostcallCB = function (name, value: PAnsiChar):PAnsiChar; cdecl;

  TToby = class
    private
      started : boolean;
      constructor Init;
    public
      onLoad : TobyOnloadCB;
      onUnload : TobyOnunloadCB;
      onHostCall : TobyHostcallCB;

      function start(processName, userScript: PAnsiChar) : boolean;
      function run(source: PAnsiChar) : PAnsiChar;
      procedure emit(name, value: PAnsiChar);
      class function Create: TToby;
  end;

procedure tobyInit(processName, userScript: PAnsiChar;
                   tobyOnLoad: TobyOnloadCB;
                   tobyOnUnload: TobyOnunloadCB;
                   tobyHostCall: TobyHostcallCB); cdecl; external 'tobynode.dll';
function tobyJSCompile(source: PAnsiChar):PAnsiChar; cdecl; external 'tobynode.dll';
function tobyJSCall(name, value: PAnsiChar):PAnsiChar; cdecl; external 'tobynode.dll';
function tobyJSEmit(name, value: PAnsiChar):PAnsiChar; cdecl; external 'tobynode.dll';

implementation
var
  Singleton : TToby = nil;


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
begin
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
begin
  exit(tobyJSCompile(source));
end;

end.
