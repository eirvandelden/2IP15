program PlannerFramework;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  MetroVisCom in '..\Units\MetroVisCom.pas',
  VisCom in '..\Units\VisCom.pas',
  MetroBase in '..\Units\MetroBase.pas',
  Auxiliary in '..\Units\Auxiliary.pas',
  Planner in '..\Units\Planner.pas',
  MinStopsPlanner in '..\Units\MinStopsPlanner.pas',
  MinTransfersplanner in '..\Units\MinTransfersplanner.pas',
  StringValidators in '..\Units\StringValidators.pas',
  Filer in '..\Units\Filer.pas',
  MatchChecker in '..\Units\MatchChecker.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
