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
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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

  toby.run('console.log("node :: hi~");');
end;
function tobyHostCall(key,value: PChar):PChar; cdecl;
begin
  Form1.Memo2.Lines.Add(key);
  writeln('host :: tobyHostCall called. ', key, ' : ',value);
  exit('from tobyHostCall');
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  toby.start('toby', 'console.log(42);');
  //writeln('............');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // start Toby
  toby := TToby.Create;
  toby.onLoad := @tobyOnLoad;
  toby.onHostCall := @tobyHostCall;
//  toby.start(PChar(ParamStr(0)), Memo1.Lines.GetText);
end;

end.
