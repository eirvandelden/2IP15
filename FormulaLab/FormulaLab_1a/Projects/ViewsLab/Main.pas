unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Grids, Outline,
  Nodes, NodeOutline, MyTreeView, PanelTree, TreeEditor, Repr,
  RE, RERepr, Prop, PropRepr, MyMath, MathRepr;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    InfixText: TLabeledEdit;
    PrefixText: TLabeledEdit;
    Panel2: TPanel;
    Splitter1: TSplitter;
    ScrollBox1: TScrollBox;
    Memo1: TMemo;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    PanelOutline: TPanel;
    ScrollBox2: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
    FUpdating: Boolean;
    FNodeOutline: TNodeOutline;
    FTreeView: TMyTreeView;
    FPanelTree: TPanelTree_Graph;
    FTreeEditor: TTreeEditor;
    FRepr: TRepr;
    procedure FNodeOutlineClick(Sender: TObject);
    procedure FTreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure FPanelTreePanelSelect(Sender: TObject; APanelNode: TPanelNode);
    function  InitRE: TRE;
    function  InitProp: TProp;
    function  InitMath: TMath;
    procedure UpdateTree;
    procedure UpdateFocus;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.FNodeOutlineClick(Sender: TObject);
begin
  if not FUpdating then
  begin
    with FNodeOutline do
      FTreeEditor.Focus := TNode(Items[SelectedItem].Data);
    UpdateFocus;
  end;
end;

procedure TForm1.FTreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  if not FUpdating then
  begin
    with FTreeView do
      FTreeEditor.Focus := TNode(Selected.Data);
    UpdateFocus;
  end;
end;

procedure TForm1.FPanelTreePanelSelect(Sender: TObject; APanelNode: TPanelNode);
begin
  if not FUpdating then
  begin
    FTreeEditor.Focus := TNode(APanelNode.Data);
    UpdateFocus;
  end;
end;

function TForm1.InitRE: TRE;
// Hard-coded expression
begin
  Result :=
  TRE_Dot.Create(
    TRE_Star.Create(
      TRE_Stick.Create(
        TRE_Id.Create('a'),
        TRE_Id.Create('b'))),
    TRE_Stick.Create(
      TRE_Id.Create('c'),
      TRE_Eps.Create));
 
end;

function TForm1.InitProp: TProp;
// Hard-coded expression
begin
  Result :=
  TProp_And.Create(
    TProp_Not.Create(
      TProp_Or.Create(
        TProp_Var.Create('a'),
        TProp_Const.Create(vkFalse))),
    TProp_Or.Create(
      TProp_Var.Create('c'),
      TProp_Var.Create('d')));
end;

function TForm1.InitMath: TMath;
// hard-coded expression
begin
  Result :=
  TMath_BinExp.Create(
    TMath_FuncApp.Create(
      TMath_Func.Create(fkSin),
      TMath_BinExp.Create(
        TMath_Const.Create(3.14),
        TMath_BinOp.Create(boTimes),
        TMath_Var.Create('y'))),
    TMath_BinOp.Create(boMinus),
    TMath_FuncApp.Create(
      TMath_Func.Create(fkLn),
      TMath_BinExp.Create(
        TMath_Var.Create('x'),
        TMath_BinOp.Create(boDivide),
        TMath_Const.Create(2))));
end;

procedure TForm1.UpdateTree;
begin
  PrefixText.Text := NodesToPrefix(FTreeEditor.Tree);
  InfixText.Text := FRepr.TreeToString(FTreeEditor.Tree);
  Memo1.Lines := NodesToStringList(FTreeEditor.Tree);
  FNodeOutline.Show(FTreeEditor.Tree);
  FTreeView.Show(FTreeEditor.Tree);
  FPanelTree.ShowTree(FTreeEditor.Tree);
end;

procedure TForm1.UpdateFocus;
begin
  FUpdating := true;
  FNodeOutline.SelectNode(FTreeEditor.Focus);
  FPanelTree.SelectData(FTreeEditor.Focus);
  FTreeView.SelectNode(FTreeEditor.Focus);
  FUpdating := false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FTreeEditor := TTreeEditor.Create;
  FTreeEditor.Tree := InitRE;
  FTreeEditor.Focus := FTreeEditor.Tree;
  FRepr := VREReprInfix;

  FNodeOutline := TNodeOutline.Create(Self);
  FNodeOutline.Parent := PanelOutline;
  FNodeOutline.Align := alClient;
  FNodeOutline.OnClick := FNodeOutlineClick;// <<< Assign event handler

  FTreeView := TMyTreeView.Create(Self);
  FTreeView.Parent := ScrollBox1;
  FTreeView.Align := alClient;
  FTreeView.ReadOnly := true;
  FTreeView.OnChange := FTreeViewChange;// <<< Assign event handler

  FPanelTree := TPanelTree_Graph.Create(Self);
  FPanelTree.Parent := ScrollBox2;
  FPanelTree.Align := alNone;
  FPanelTree.Bevelouter := bvLowered;
  FPanelTree.BevelSelect := bvRaised;
  FPanelTree.Left := 0;
  FPanelTree.Top := 0;
  FPanelTree.Color := clWhite;
  FPanelTree.Repr := VREReprInfix;
  FPanelTree.Font := InfixText.Font;
  FPanelTree.NodeWidth := 20;
  FPanelTree.NodeHorizontalMargin := 5; // margin between label and rectangle
  FPaneltree.NodeHeight := 20;
  FPanelTree.NodeColor := clYellow;
  FPanelTree.HorSep := 20;
  FPanelTree.VerSep := 20;
  FPanelTree.OnPanelSelect := FPanelTreePanelSelect; // <<< Assign event handler

  UpdateTree;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  with Sender as TRadioGroup do
    case ItemIndex of
      0:
        begin
          FTreeEditor.Tree := InitRE;
          FRepr := VREReprInfix;
        end;
      1:
        begin
          FTreeEditor.Tree := InitProp;
          FRepr := VPropReprInfix;
        end;
      2:
        begin
          FTreeEditor.Tree := InitMath;
          FRepr := VMathReprInfix;   
        end;
    else

    end;
    FTreeEditor.Focus := FTreeEditor.Tree;
    UpdateTree;
end;

end.
