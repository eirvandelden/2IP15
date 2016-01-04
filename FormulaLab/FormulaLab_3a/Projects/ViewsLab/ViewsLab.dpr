program ViewsLab;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  Nodes in '..\..\Components\Base\Nodes.pas',
  TreeVisitor in '..\..\Components\Base\TreeVisitor.pas',
  Repr in '..\..\Components\Base\Repr.pas',
  NodeOutline in '..\..\Components\Views\NodeOutline.pas',
  TreeEditor in '..\..\Components\Base\TreeEditor.pas',
  PanelTree in '..\..\Components\Views\PanelTree.pas',
  ColorShades in '..\..\Components\Views\ColorShades.pas',
  MyTreeView in '..\..\Components\Views\MyTreeView.pas',
  Prop in '..\..\Languages\Prop\Prop.pas',
  PropRepr in '..\..\Languages\Prop\PropRepr.pas',
  RERepr in '..\..\Languages\RegExp\RERepr.pas',
  RE in '..\..\Languages\RegExp\RE.pas',
  MathRepr in '..\..\Languages\Math\MathRepr.pas',
  MyMath in '..\..\Languages\Math\MyMath.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
