program Pr_Solitaire_UI;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  CardDeck in '..\Units\CardDeck.pas',
  Game in '..\Units\Game.pas',
  CardPiles in '..\Units\CardPiles.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
