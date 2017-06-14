unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TobyPascal, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Button1: TButton;
    Button2: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  toby : TToby;

implementation

{$R *.dfm}

procedure LOG(line: String);
begin
  Form1.Memo2.Lines.Add(line);
end;

procedure tobyOnLoad(isolate: Pointer); cdecl;
begin
  LOG('host :: tobyOnLoad called');
end;
procedure tobyOnUnload(isolate: Pointer; exitCode: Integer); cdecl;
begin
  LOG('host :: tobyOnUnload called. ' + IntToStr(exitCode));
end;
function tobyHostCall(key,value: PAnsiChar):PAnsiChar; cdecl;
begin
  LOG('host :: tobyHostCall called. ' + key + ' : ' + value);
  exit(PAnsiChar('from tobyHostCall'));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  toby.start(PAnsiChar('toby'), PAnsiChar(AnsiString(Memo1.Text)));
  Timer1.Enabled := true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  toby.emit(PAnsiChar('test'), PAnsiChar('hi toby'));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  // start Toby
  toby := TToby.Create;
  toby.onLoad := @tobyOnLoad;
  toby.onUnLoad := @tobyOnUnload;
  toby.onHostCall := @tobyHostCall;
end;

// FIXME : workaround. should be async
procedure TForm1.Timer1Timer(Sender: TObject);
var
  TextBuffer: array[1..32767] of AnsiChar;
  TextString: String;
  BytesRead: DWord;
  PipeSize: Integer;
  BytesRem: DWord;
begin
  PipeSize := Sizeof(TextBuffer);

  PeekNamedPipe(Toby.OutputPipeRead, nil, PipeSize, @BytesRead, @PipeSize, @BytesRem);
  if BytesRead > 0 then
  begin
    ReadFile(Toby.OutputPipeRead, TextBuffer, PipeSize, BytesRead, nil);
    OemToChar(@TextBuffer, @TextBuffer);
    TextString := String(TextBuffer);
    SetLength(TextString, BytesRead);
    LOG(TextString);
  end;

end;

end.
