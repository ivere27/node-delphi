unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TobyPascal, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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

procedure tobyOnLoad(isolate: Pointer); cdecl;
begin
  writeln('host :: tobyOnLoad called');
  Form1.Memo2.Lines.Add('host :: tobyOnLoad called');
  toby.run(PAnsiChar('setInterval(function(){toby.hostCall("dory", num++);},1000);'));
  toby.run(PAnsiChar('console.log("node :: hi~");'));
end;
procedure tobyOnUnload(isolate: Pointer; exitCode: Integer); cdecl;
begin
  writeln('host :: tobyOnUnload called. ', exitCode);
  Form1.Memo2.Lines.Add('host :: tobyOnUnLoad called ' + IntToStr(exitCode));
end;
function tobyHostCall(key,value: PAnsiChar):PAnsiChar; cdecl;
begin
  writeln('host :: tobyHostCall called. ', key, ' : ',value);
  Form1.Memo2.Lines.Add('host :: tobyHostCall called. ' + key + ' : ' + value);
  exit(PAnsiChar('from tobyHostCall'));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  toby.start(PAnsiChar('toby'), PAnsiChar(Memo1.Text));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  toby.emit(PAnsiChar('test'), PAnsiChar('hi toby'));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // for test purpose
  AllocConsole;

  // start Toby
  toby := TToby.Create;
  toby.onLoad := @tobyOnLoad;
  toby.onUnLoad := @tobyOnUnload;
  toby.onHostCall := @tobyHostCall;
end;

end.
