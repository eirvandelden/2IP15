program Network;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  MetroBase in 'Units\MetroBase.pas',
  StringValidators in 'Units\StringValidators.pas',
  NetworkFiler in 'Units\NetworkFiler.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
