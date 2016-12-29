unit TobyPascal;

interface

uses
  Classes, SysUtils;

type
  TobyOnloadCB = procedure (isolate: Pointer); cdecl;
  TobyHostcallCB = function (name, value: PChar):PChar; cdecl;

  TToby = class
    private
      started : boolean;
      constructor Init;
    public
      onLoad : TobyOnloadCB;
      onHostCall : TobyHostcallCB;

      function start(processName, userScript: PChar) : boolean;
      function run(source: PChar) : PChar;
      procedure emit(name, value: PChar);
      class function Create: TToby;
  end;

{
typedef void  (*TobyOnloadCB)(void* isolate);
typedef char* (*TobyHostcallCB)(const char* name, const char* value);

extern "C" void  tobyInit(const char* processName,
                          const char* userScript,
                          TobyOnloadCB,
                          TobyHostcallCB);
extern "C" char* tobyJSCompile(const char* source);
extern "C" char* tobyJSCall(const char* name, const char* value);
extern "C" bool  tobyJSEmit(const char* name, const char* value);
}
procedure _tobyRegister(); cdecl; external 'tobynode.dll';

procedure tobyInit(processName, userScript: PChar; tobyOnLoad:TobyOnloadCB; tobyHostCall:TobyHostcallCB); cdecl; external 'tobynode.dll';
function tobyJSCompile(source: PChar):PChar; cdecl; external 'tobynode.dll';
function tobyJSCall(name, value: PChar):PChar; cdecl; external 'tobynode.dll';
function tobyJSEmit(name, value: PChar):PChar; cdecl; external 'tobynode.dll';

implementation
var
  Singleton : TToby = nil;


procedure _OnLoad(isolate: Pointer); cdecl;
begin
  //writeln(':: default tobyOnLoad called');
end;
function _OnHostCall(key,value: PChar):PChar; cdecl;
begin
  //writeln(':: default tobyHostCall called. ', key, ' : ',value);
  exit('');
end;

constructor TToby.Init;
begin
  started := false;

  // set default.
  onLoad := @_OnLoad;
  onHostCall := @_OnHostCall;
//  _tobyRegister;
  inherited Create;
end;

class function TToby.Create: TToby;
begin
  if Singleton = nil then
    Singleton := TToby.Init;
  Result := Singleton;
end;

function TToby.start(processName, userScript: PChar) : boolean;
begin
  if started = false then
  begin
    started := true;
    tobyInit(processName, userScript, @_OnLoad, @_OnHostCall);
    exit(true);
  end;
  exit(false);
end;


procedure TToby.emit(name, value: PChar);
begin
  tobyJSEmit(name, value);
end;

function TToby.run(source: PChar) : PChar;
begin
  exit(tobyJSCompile(source));
end;

end.
