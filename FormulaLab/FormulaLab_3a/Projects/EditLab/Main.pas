unit Main;
//# BEGIN TODO  Completed by: author name, id.nr., date
  { E.I.R. van Delden, 0618959, 29-06-2008 }
//# END TODO

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Grids,
  Nodes, NodeOutline, MyTreeView, MyRichEdit, PanelTree, TreeEditor, Repr,
  RE, RERepr, Prop, PropRepr, MyMath, MathRepr, Menus, TreeEditorCommands, UndoRedo;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    InfixText: TLabeledEdit;
    Panel2: TPanel;
    Splitter1: TSplitter;
    ScrollBox1: TScrollBox;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    ScrollBox2: TScrollBox;
    Panel3: TPanel;
    PopupMenuProp: TPopupMenu;
    true1: TMenuItem;
    false1: TMenuItem;
    Not1: TMenuItem;
    And1: TMenuItem;
    Or1: TMenuItem;
    Implies1: TMenuItem;
    Equivalent1: TMenuItem;
    N1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    N2: TMenuItem;
    Clear1: TMenuItem;
    PopupMenuRE: TPopupMenu;
    Eps1: TMenuItem;
    Id1: TMenuItem;
    Seq1: TMenuItem;
    Dot1: TMenuItem;
    Stick1: TMenuItem;
    Range1: TMenuItem;
    Star1: TMenuItem;
    Plus1: TMenuItem;
    N3: TMenuItem;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    Delete2: TMenuItem;
    N4: TMenuItem;
    Clear2: TMenuItem;
    PopupMenuMath: TPopupMenu;
    Const1: TMenuItem;
    Var1: TMenuItem;
    Unary1: TMenuItem;
    Binary1: TMenuItem;
    FuncAppl1: TMenuItem;
    Minus1: TMenuItem;
    Plus2: TMenuItem;
    Minus2: TMenuItem;
    Times1: TMenuItem;
    Divides1: TMenuItem;
    N5: TMenuItem;
    Cut3: TMenuItem;
    Copy3: TMenuItem;
    Paste3: TMenuItem;
    Delete3: TMenuItem;
    N6: TMenuItem;
    Clear3: TMenuItem;
    Var2: TMenuItem;
    Sin1: TMenuItem;
    Cos1: TMenuItem;
    Exp1: TMenuItem;
    Ln1: TMenuItem;
    Panel4: TPanel;
    DataEdit: TLabeledEdit;
    DataOKButton: TButton;
    Tautology1: TMenuItem;
    AndElim1: TMenuItem;
    OrIntro1: TMenuItem;
    DeMorgan1: TMenuItem;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure PopupMenuMathPopup(Sender: TObject);
    procedure PopupMenuPropPopup(Sender: TObject);
    procedure PopupMenuREPopup(Sender: TObject);
    procedure true1Click(Sender: TObject);
    procedure false1Click(Sender: TObject);
    procedure Var2Click(Sender: TObject);
    procedure Not1Click(Sender: TObject);
    procedure And1Click(Sender: TObject);
    procedure Or1Click(Sender: TObject);
    procedure Implies1Click(Sender: TObject);
    procedure Equivalent1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Eps1Click(Sender: TObject);
    procedure Id1Click(Sender: TObject);
    procedure Dot1Click(Sender: TObject);
    procedure Stick1Click(Sender: TObject);
    procedure Star1Click(Sender: TObject);
    procedure Plus1Click(Sender: TObject);
    procedure Cut2Click(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure Paste2Click(Sender: TObject);
    procedure Delete2Click(Sender: TObject);
    procedure Clear2Click(Sender: TObject);
    procedure Const1Click(Sender: TObject);
    procedure Var1Click(Sender: TObject);
    procedure Minus1Click(Sender: TObject);
    procedure Plus2Click(Sender: TObject);
    procedure Minus2Click(Sender: TObject);
    procedure Times1Click(Sender: TObject);
    procedure Divides1Click(Sender: TObject);
    procedure Sin1Click(Sender: TObject);
    procedure Cos1Click(Sender: TObject);
    procedure Exp1Click(Sender: TObject);
    procedure Ln1Click(Sender: TObject);
    procedure Cut3Click(Sender: TObject);
    procedure Copy3Click(Sender: TObject);
    procedure Paste3Click(Sender: TObject);
    procedure Delete3Click(Sender: TObject);
    procedure Clear3Click(Sender: TObject);
    procedure DataEditChange(Sender: TObject);
    procedure DataOKButtonClick(Sender: TObject);
    procedure AndElim1Click(Sender: TObject);
    procedure OrIntro1Click(Sender: TObject);
    procedure DeMorgan1Click(Sender: TObject);
    procedure DataEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FUpdating: Boolean;
    FTreeView: TMyTreeView;
    FRichEdit: TMyRichEdit;
    FPanelTree: TPanelTree_Graph;
    FTreeEditor: TTreeEditor;
    FFactory: TNodeFactory;
    FClip: TNode;
    FRepr: TRepr;
    FController: TController;
    procedure FTreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure FPanelTreePanelSelect(Sender: TObject; APanelNode: TPanelNode);
    function  InitRE: TRE;
    function  InitProp: TProp;
    function  InitMath: TMath;
    procedure UpdateTree;
    procedure UpdateFocus;
    procedure SetMenuItems(AList: array of TMenuItem; AValue: Boolean);

    procedure DoExpand(ANew: TNode);
    // pre: - FTreeEditor.Focus verwijst naar een gat
    //      - ANew is wortel van goedgevormde boom
    // effect: - in FTreeEditor.Tree wordt het door FFocus aangegeven gat
    //           vervangen door boom met wortel ANew
    //         - FTreeEditor.Focus wijst naar Anew

    procedure DoCut;
    // pre: - FTreeEditor.Focus <> nil
    //      - FTreeEditor.Focus verwijst niet naar een gat
    // effect: - de door FTreeEditor.Focus aangewezen boom wordt vervangen door
    //           een gat
    //         - FTreeEditor.Focus verwijst naar dat gat
    //         - verwijderde boom wordt op clipboard geplaatst

    procedure DoCopy;
    // pre: - FTreeEditor.Focus <> nil
    //      - FTreeEditor.Focus verwijst niet naar een gat
    // effect: - een kopie van de door FTreeEditor.Focus aangewezen deelboom
    //           wordt op clipboard geplaatst
    //         - FTreeEditor.Focus ongewijzigd

    procedure DoPaste;
    // pre: - FTreeEditor.Focus <> nil
    //      - FTreeEditor.Focus verwijst naar een gat
    //      - clipboard <> nil
    // effect: - vervang het door FTreeEditor.Focus aangewezen gat door een
    //           kopie van de door het clipboard aangewezen boom
    //         - FTreeEditor.Focus verwijst naar wortel van de nieuwe deelboom

    procedure DoDelete;
    // pre: - FTreeEditor.Focus <> nil
    // effect: - de door FTreeEditor.Focus aangewezen deelboom wordt vervangen
    //           door een gat
    //         - FTreeEditor.Focus verwijst naar dat gat

    procedure DoClear;
    // pre: true
    // effect: - FTreeEditor.Tree wordt opgeruimd en vevangen door een gat
    //         - FTreeEditor.Focus verwijst naar dat gat

    function  ValidData(AString: String): Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  NlCr =#13#10;

//De onderstaande lines worden gebruikt bij de initialisatie van de
//RichEdit view (vanwege probleem met WordWrap vs. Scrollbars).
  Line1 = 'De onder deze tekst voorkomende regels geven een tekstuele weergave van de formule die hierboven als boom wordt weergegeven.';
  Line1a= 'Een hierboven geselecteerde deelboom wordt hieronder vet weergegeven.';
  Line2 = 'Wanneer hierboven voor de geselecteerde deelboom het popupmenu wordt geactiveerd (rechter muisknop) kan de formuleboom bewerkt worden.';
  Line3 = 'In het bijzonder kan een "hole" (aangegeven met ??) vervangen worden door een niet-lege deelboom.';
  Line4 = 'Als een knoop data bevat, kan die in de Node Data edit box bewerkt worden.';

{ TForm1 }

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
      TRE_Hole.Create,
      TRE_Hole.Create));
end;

function TForm1.InitProp: TProp;
// Hard-coded expression
begin
  Result :=
  TProp_And.Create(
    TProp_Not.Create(
      TProp_Or.Create(
        TProp_Hole.Create,
        TProp_Const.Create(vkFalse))),
    TProp_Or.Create(
      TProp_Hole.Create,
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
        TMath_Hole.Create,
        TMath_BinOp.Create(boTimes),
        TMath_Var.Create('y'))),
    TMath_BinOp.Create(boMinus),
    TMath_FuncApp.Create(
      TMath_Func.Create(fkLn),
      TMath_Hole.Create));
end;

procedure TForm1.UpdateTree;
begin
  InfixText.Text := FRepr.TreeToString(FTreeEditor.Tree);
  FRichEdit.SetRepr(FRepr);
  FRichEdit.AddTree(FTreeEditor.Tree);
  FTreeView.Show(FTreeEditor.Tree);
  FPanelTree.ShowTree(FTreeEditor.Tree);
end;

procedure TForm1.UpdateFocus;
begin
  FUpdating := true;
  FRichEdit.ChangeFocus(FTreeEditor.Focus);
  FPanelTree.SelectData(FTreeEditor.Focus);
  FTreeView.SelectNode(FTreeEditor.Focus);
  if FTreeEditor.Focus.HasData then
  begin
    DataEdit.Text := FTreeEditor.Focus.GetData;
    DataEdit.Enabled := true;
  end
  else
    DataEdit.Enabled := false;
  FUpdating := false;
end;

procedure TForm1.SetMenuItems(AList: array of TMenuItem; AValue: Boolean);
var
  I: Integer;
begin
  for I := 0 to High(AList) do
    AList[I].Enabled := AValue;
end;

procedure TForm1.DoClear;
var

  Command: TCommand;
begin
//# BEGIN TODO
  //*** Old Implementation ***********
 {
    // pre: true
    // effect: - FTreeEditor.Tree wordt opgeruimd en vevangen door een gat
    //         - FTreeEditor.Focus verwijst naar dat gat


     if FTreeEditor.Tree is TRE then
     begin
       VNew := TRE_Hole.Create;
     end
     else if FTreeEditor.Tree is TProp then
     begin
      VNew := TProp_Hole.Create;
     end
     else if FTreeEditor.Tree is TMath then
     begin
      VNew := TMath_Hole.Create;
     end;

    FTReeEditor.Replace( VNew, FTreeEditor.Tree );
  }

  //*** New Implementation *********

  Command := TCommand_DoClear.Create(FTreeEditor);
  FController.DoCommand(Command);



     UpdateTree;
//# END TODO
end;

procedure TForm1.DoCopy;
begin
//# BEGIN TODO
    // pre: - FTreeEditor.Focus <> nil
    //      - FTreeEditor.Focus verwijst niet naar een gat
    // effect: - een kopie van de door FTreeEditor.Focus aangewezen deelboom
    //           wordt op clipboard geplaatst
    //         - FTreeEditor.Focus ongewijzigd

    Assert( (FTreeEditor.Focus <> nil) and
            (not FTReeEditor.Focus.IsHole), 'TForm1.DoCopy.pre failed');


    FCLip := FTreeEditor.Focus.Clone;

    UpdateTree;
//# END TODO
end;

procedure TForm1.DoCut;
var
  VOld, VNew: TNode;
  I, Son: Integer;
  Command: TCommand;

begin
//# BEGIN TODO

{
    // pre: - FTreeEditor.Focus <> nil
    //      - FTreeEditor.Focus verwijst niet naar een gat
    // effect: - de door FTreeEditor.Focus aangewezen boom wordt vervangen door
    //           een gat
    //         - FTreeEditor.Focus verwijst naar dat gat
    //         - verwijderde boom wordt op clipboard geplaatst

  Assert( (FTreeEditor.Focus <> nil) and
    (not (FTreeEditor.Focus.IsHole)), 'TForm1.DoCopy.pre failed'
         );


  // Copy to ClipBoard (Replace later with DoCopy?)
  FClip := FTreeEditor.Focus.Clone;


  // Set the New to empty
  if FTreeEditor.Tree is TRE then
     begin
       VNew := TRE_Hole.Create;
     end
     else if FTreeEditor.Tree is TProp then
     begin
      VNew := TProp_Hole.Create;
     end
     else if FTreeEditor.Tree is TMath then
     begin
      VNew := TMath_Hole.Create;
     end;


  FTreeEditor.Replace( VNew, FTreeEditor.Focus );
  FTreeEditor.Focus := VNew;
}

  //** NEw implementation
    Assert( (FTreeEditor.Focus <> nil) and
    (not (FTreeEditor.Focus.IsHole)), 'TForm1.DoCopy.pre failed'
         );

  // Copy to ClipBoard
  FClip := FTreeEditor.Focus.Clone;

  Command := TCommand_DoCut.Create( FTreeEditor);
  FController.DoCommand(Command);

  UpdateTree;
//# END TODO
end;

procedure TForm1.DoDelete;
var
  VOld, VNew: TNode;
begin
//# BEGIN TODO
    // pre: - FTreeEditor.Focus <> nil
    // effect: - de door FTreeEditor.Focus aangewezen deelboom wordt vervangen
    //           door een gat
    //         - FTreeEditor.Focus verwijst naar dat gat

    Assert( FTreeEditor.Focus <> nil, 'TForm1.DoDelete.pre failed');

  // Set the New to empty
  if FTreeEditor.Tree is TRE then
     begin
       VNew := TRE_Hole.Create;
     end
     else if FTreeEditor.Tree is TProp then
     begin
      VNew := TProp_Hole.Create;
     end
     else if FTreeEditor.Tree is TMath then
     begin
      VNew := TMath_Hole.Create;
     end;


  FTreeEditor.Replace( VNew, FTreeEditor.Focus );
  FTreeEditor.Focus := VNew;

  UpdateTree;//# END TODO
end;

procedure TForm1.DoExpand(ANew: TNode);
var
  VOld: TNode;
  Command: TCommand;
begin
//# BEGIN TODO
    // pre: - FTreeEditor.Focus verwijst naar een gat
    //      - ANew is wortel van goedgevormde boom
    // effect: - in FTreeEditor.Tree wordt het door FFocus aangegeven gat
    //           vervangen door boom met wortel ANew
    //         - FTreeEditor.Focus wijst naar Anew

  Assert( FTreeEditor.Focus.IsHole, 'TForm1.DoExpand.pre failed');
 {
  FTreeEditor.Replace(ANew, FTreeEditor.Focus);
  FTreeEditor.Focus := ANew;
  }

  Command := TCommand_DoExpand.Create(FTreeEditor, ANew);
  FController.DoCommand(Command);

  UpdateTree;

//# END TODO
end;

procedure TForm1.DoPaste;
var
  VOld, VNew: TNode;
  Command: TCommand;
begin
//# BEGIN TODO


    // pre: - FTreeEditor.Focus <> nil
    //      - FTreeEditor.Focus verwijst naar een gat
    //      - clipboard <> nil
    // effect: - vervang het door FTreeEditor.Focus aangewezen gat door een
    //           kopie van de door het clipboard aangewezen boom
    //         - FTreeEditor.Focus verwijst naar wortel van de nieuwe deelboom

    Assert( ((FTreeEditor.Focus <> nil) and
             (FTreeEditor.Focus.IsHole) and
             ( FClip <> nil)), 'TForm1.DoPaste.pre failed');
{
  VNew := FClip;
  VOld := FTreeEditor.Focus;

  FTreeEditor.Replace(VNew, VOld);
  FTreeEditor.Focus := VNew;
}


  Command := TCommand_DoPaste.Create(FTreeEditor, FClip);
     FController.DoCommand(Command);

     UpdateTree;
//# END TODO
end;

function ValidName(AString: String): Boolean;
var
  I: Integer;
begin
  // Result := AString in Letter+
  Result := Length(AString) > 0;
  for I := 1 to Length(AString) do
    if not (AString[I] in ['A'..'Z', 'a'..'z'])
    then Result := false;
end;

function ValidBool(AString: String): Boolean;
var
  VString: String;
begin
  VString := UpperCase(AString);
  Result := (VString = 'TRUE') or (VString = 'FALSE');
end;

function ValidBinOp(AString: String): Boolean;
begin
  Result :=
    (AString = '+') or
    (AString = '-') or
    (AString = '*') or
    (AString = '/');
end;

function ValidFunc(AString: String): Boolean;
var
  VString: String;
begin
  VString := UpperCase(AString);
  Result :=
    (VString = 'SIN') or
    (VString = 'COS') or
    (VString = 'EXP') or
    (VString = 'LN');
end;

function ValidReal(AString: String): Boolean;
begin
  Result := true;
  try
    StrToFloat(AString)
  except
    on EConvertError do Result := false
  end;
end;

function TForm1.ValidData(AString: String): Boolean;
var
  VNode: TNode;
begin
// Ad-hoc oplossing. Moet algemener opgelost worden.
  VNode := FTreeEditor.Focus;
  if (VNode is TRE_Id) or (VNode is TProp_Var) or (VNode is TMath_Var)
  then Result := ValidName(AString)
  else if VNode is TProp_Const
  then Result := ValidBool(AString)
  else if VNode is TMath_BinOp
  then Result := ValidBinOp(AString)
  else if VNode is TMath_Func
  then Result := ValidFunc(AString)
  else if VNode is TMath_Const
  then Result := ValidReal(AString)
  else Result := false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FTreeEditor := TTreeEditor.Create;
  FTreeEditor.TreeClass := TRE;
  FTreeEditor.Tree := InitRE;
  FTreeEditor.Focus := FTreeEditor.Tree;
  FFactory := VREFactory;
  FRepr := VREReprInfix;

  FTreeView := TMyTreeView.Create(Self);
  FTreeView.Parent := ScrollBox1;
  FTreeView.Align := alClient;
  FTreeView.ReadOnly := true;
  FTreeView.OnChange := FTreeViewChange;// <<< Assign event handler

  FRichEdit := TMyRichEdit.Create(Self);
  FRichEdit.Parent := Panel3;
  FRichEdit.Align := alClient;
  FRichEdit.ReadOnly := true;
  FRichEdit.ScrollBars := ssBoth;
  FRichEdit.WordWrap := false;
  FRichEdit.SetRepr(FRepr);
  FRichEdit.Lines.Add(Line1);
  FRichEdit.Lines.Add(Line1a);
  FRichEdit.Lines.Add(Line2);
  FRichEdit.Lines.Add(Line3);
  FRichEdit.Lines.Add(Line4);
  FRichEdit.Lines.Add(' ');

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


  //*** Added ***************
  FController := TController.Create;

  UpdateTree;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  with Sender as TRadioGroup do
    case ItemIndex of
      0:
        begin
          FTreeEditor.TreeClass := TRE;
          FTreeEditor.Tree := InitRE;
          FRepr := VREReprInfix;
          FFactory := VREFactory;
          Form1.PopupMenu := PopupMenuRe;
        end;
      1:
        begin
          FTreeEditor.TreeClass := TProp;
          FTreeEditor.Tree := InitProp;
          FRepr := VPropReprInfix;
          FFactory := VPropFactory;
          Form1.PopupMenu := PopupMenuProp;
        end;
      2:
        begin
          FTreeEditor.TreeClass := TMath;
          FTreeEditor.Tree := InitMath;
          FRepr := VMathReprInfix;
          FFactory := VMathfactory;
          Form1.PopupMenu := PopupMenuMath;
        end;
    else

    end;
    FTreeEditor.Focus := FTreeEditor.Tree;
    UpdateTree;
end;

procedure TForm1.DataEditChange(Sender: TObject);
begin
  DataOKButton.Enabled := ValidData(DataEdit.Text);
end;

procedure TForm1.DataOKButtonClick(Sender: TObject);
begin
  FTreeEditor.Focus.SetData(DataEdit.Text);
  UpdateTree;
end;

procedure TForm1.DataEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and ValidData(DataEdit.Text) then
  begin
    FTreeEditor.Focus.SetData(DataEdit.Text);
    UpdateTree;
  end;
end;


procedure TForm1.PopupMenuPropPopup(Sender: TObject);
var
  I: Integer;
begin
  with PopupMenuProp do
    for I := 0 to Items.Count - 1 do
      Items[I].Enabled := false;
  SetMenuItems([true1, false1, Var2, Not1, And1, Or1, Implies1, Equivalent1,
    Tautology1, AndElim1, OrIntro1, DeMorgan1], FTreeEditor.Focus.IsHole);
  SetMenuItems([Cut1, Copy1, Delete1], not FTreeEditor.Focus.IsHole);
  SetMenuItems([Paste1], FClip <> nil);
  SetMenuItems([Clear1], not FTreeEditor.Tree.IsHole);
end;

{ Events for Regular Expression menu --------------------------------------}

procedure TForm1.PopupMenuREPopup(Sender: TObject);
var
  I: Integer;
// Enabling/Disabling of menu items :
begin
  with PopupMenuRE do
    for I := 0 to Items.Count - 1 do
      Items[I].Enabled := false;
  SetMenuItems([Eps1, Id1, {Seq1,} Dot1, Stick1, {Range1,} Star1, Plus1],
    FTreeEditor.Focus.IsHole);
  SetMenuItems([Cut2, Copy2, Delete2], not FTreeEditor.Focus.IsHole);
  SetMenuItems([Paste2], FClip <> nil);
  SetMenuItems([Clear2], not FTreeEditor.Tree.IsHole);
end;

procedure TForm1.Eps1Click(Sender: TObject);
var
  VNew: TNode;
begin
  VNew := FFactory.MakeNodeWithHoles('Eps', '');
  DoExpand(VNew);
end;

procedure TForm1.Id1Click(Sender: TObject);
var
  VNew: TNode;
begin
  VNew := FFactory.MakeNodeWithHoles('Id', 'NewName');
  DoExpand(VNew);
  FocusControl(DataEdit);
end;

procedure TForm1.Dot1Click(Sender: TObject);
var
  VNew: TNode;
begin
  VNew := FFactory.MakeNodeWithHoles('Dot', '');
  DoExpand(VNew);
end;

procedure TForm1.Stick1Click(Sender: TObject);
var
  VNew: TNode;
begin
  VNew := FFactory.MakeNodeWithHoles('Stick', '');
  DoExpand(VNew);
end;

procedure TForm1.Star1Click(Sender: TObject);
var
  VNew: TNode;
begin
  VNew := FFactory.MakeNodeWithHoles('Star', '');
  DoExpand(VNew);
end;

procedure TForm1.Plus1Click(Sender: TObject);
var
  VNew: TNode;
begin
  VNew := FFactory.MakeNodeWithHoles('Plus', '');
  DoExpand(VNew);
end;

procedure TForm1.Cut2Click(Sender: TObject);
begin
  DoCut;
end;

procedure TForm1.Copy2Click(Sender: TObject);
begin
  DoCopy;
end;

procedure TForm1.Paste2Click(Sender: TObject);
begin
  DoPaste;
end;

procedure TForm1.Delete2Click(Sender: TObject);
begin
  DoDelete;
end;

procedure TForm1.Clear2Click(Sender: TObject);
begin
  DoClear;
end;

{ Events for Math menu -----------------------------------------------------}

procedure TForm1.PopupMenuMathPopup(Sender: TObject);
var
  I: Integer;
begin
  with PopupMenuMath do
    for I := 0 to Items.Count - 1 do
      Items[I].Enabled := false;
  SetMenuItems([{Const1,} Var1, Unary1, Minus1, Binary1, Plus2, Minus2, Times1,
    Divides1, FuncAppl1], FTreeEditor.Focus.IsHole);
  SetMenuItems([Cut3, Copy3, Delete3], not FTreeEditor.Focus.IsHole);
  SetMenuItems([Paste3], FClip <> nil);
  SetMenuItems([Clear3], not FTreeEditor.Tree.IsHole);
end;

procedure TForm1.Const1Click(Sender: TObject);
var
  VNew: TNode;
begin
  with FFactory as TMathfactory do
    VNew := MakeConst(0);
  DoExpand(Vnew);
  FocusControl(DataEdit);
end;

procedure TForm1.Var1Click(Sender: TObject);
var
  VNew: TNode;
begin
  with FFactory as TMathFactory do
    VNew := MakeVar('NewName');
  DoExpand(Vnew);
  FocusControl(DataEdit);
end;

procedure TForm1.Minus1Click(Sender: TObject);
var
  VNew: TNode;
begin
  with FFactory as TMathFactory do
    VNew := MakeUMinus(MakeHole);
  DoExpand(Vnew);
end;

procedure TForm1.Plus2Click(Sender: TObject);
var
  VNew: TNode;
begin
  with FFactory as TMathFactory do
    VNew := MakeBinExp(MakeHole, MakeBinOp(boPlus), MakeHole);
  DoExpand(Vnew);
end;

procedure TForm1.Minus2Click(Sender: TObject);
var
  VNew: TNode;
begin
  with FFactory as TMathFactory do
    VNew := MakeBinExp(MakeHole, MakeBinOp(boMinus), MakeHole);
  DoExpand(Vnew);
end;

procedure TForm1.Times1Click(Sender: TObject);
var
  VNew: TNode;
begin
  with FFactory as TMathFactory do
    VNew := MakeBinExp(MakeHole, MakeBinOp(boTimes), MakeHole);
  DoExpand(Vnew);
end;

procedure TForm1.Divides1Click(Sender: TObject);
var
  VNew: TNode;
begin
  with FFactory as TMathFactory do
    VNew := MakeBinExp(MakeHole, MakeBinOp(boDivide), MakeHole);
  DoExpand(Vnew);
end;

procedure TForm1.Sin1Click(Sender: TObject);
var
  VNew: TNode;
begin
  with FFactory as TMathFactory do
    VNew := MakeFuncApp(MakeFunc(fkSin), MakeHole);
  DoExpand(Vnew);
end;

procedure TForm1.Cos1Click(Sender: TObject);
var
  VNew: TNode;
begin
  with FFactory as TMathFactory do
    VNew := MakeFuncApp(MakeFunc(fkCos), MakeHole);
  DoExpand(Vnew);
end;

procedure TForm1.Exp1Click(Sender: TObject);
var
  VNew: TNode;
begin
  with FFactory as TMathFactory do
    VNew := MakeFuncApp(MakeFunc(fkExp), MakeHole);
  DoExpand(Vnew);
end;

procedure TForm1.Ln1Click(Sender: TObject);
var
  VNew: TNode;
begin
  with FFactory as TMathFactory do
    VNew := MakeFuncApp(MakeFunc(fkLn), MakeHole);
  DoExpand(Vnew);
end;

procedure TForm1.Cut3Click(Sender: TObject);
begin
  DoCut;
end;

procedure TForm1.Copy3Click(Sender: TObject);
begin
  DoCopy;
end;

procedure TForm1.Paste3Click(Sender: TObject);
begin
  DoPaste;
end;

procedure TForm1.Delete3Click(Sender: TObject);
begin
  DoDelete;
end;

procedure TForm1.Clear3Click(Sender: TObject);
begin
  DoClear;
end;


{ Events for Prop menu ------------------------------------------------------}

procedure TForm1.true1Click(Sender: TObject);
var
  VNew: TNode;
begin
  VNew := FFactory.MakeNodeWithHoles('Const', 'true');
  DoExpand(VNew);
end;

procedure TForm1.false1Click(Sender: TObject);
var
  VNew: TNode;
begin
  VNew := FFactory.MakeNodeWithHoles('Const', 'false');
  DoExpand(VNew);
end;

procedure TForm1.Var2Click(Sender: TObject);
var
  VNew: TNode;
begin
  VNew := FFactory.MakeNodeWithHoles('Var', 'NewName');
  DoExpand(VNew);
  FocusControl(DataEdit);
end;

procedure TForm1.Not1Click(Sender: TObject);
var
  VNew: TNode;
begin
  VNew := FFactory.MakeNodeWithHoles('Not', '');
  DoExpand(VNew);
end;

procedure TForm1.And1Click(Sender: TObject);
var
  VNew: TNode;
begin
  VNew := FFactory.MakeNodeWithHoles('And', '');
  DoExpand(VNew);
end;

procedure TForm1.Or1Click(Sender: TObject);
var
  VNew: TNode;
begin
  VNew := FFactory.MakeNodeWithHoles('Or', '');
  DoExpand(VNew);
end;

procedure TForm1.Implies1Click(Sender: TObject);
var
  VNew: TNode;
begin
  VNew := FFactory.MakeNodeWithHoles('Imp', '');
  DoExpand(VNew);
end;

procedure TForm1.Equivalent1Click(Sender: TObject);
var
  VNew: TNode;
begin
  VNew := FFactory.MakeNodeWithHoles('Equiv', '');
  DoExpand(VNew);
end;

procedure TForm1.Cut1Click(Sender: TObject);
begin
  DoCut;
end;

procedure TForm1.Copy1Click(Sender: TObject);
begin
  DoCopy;
end;

procedure TForm1.Paste1Click(Sender: TObject);
begin
  DoPaste;
end;

procedure TForm1.Delete1Click(Sender: TObject);
begin
  DoDelete;
end;

procedure TForm1.Clear1Click(Sender: TObject);
begin
  DoClear;
end;

procedure TForm1.AndElim1Click(Sender: TObject);
var
  VNew: TNode;
begin
  with FFactory as TPropFactory do
  VNew := MakeImp(MakeAnd(MakeVar('P'), MakeVar('Q')), MakeVar('P'));
  DoExpand(VNew);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 if FController.CanUndo then
 begin
   FController.Undo;
 UpdateTree;
 end
 else
 begin
   ShowMessage('Nothing to Undo');
 end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 if FController.CanRedo then
 begin
   FController.Redo;
 UpdateTree;
 end
 else
 begin
   ShowMessage('Nothing to Redo');
 end;
end;

procedure TForm1.OrIntro1Click(Sender: TObject);
var
  VNew: TNode;
begin
  with FFactory as TPropFactory do
  VNew := MakeImp(MakeVar('P'), MakeOr(MakeVar('P'), MakeVar('Q')));
  DoExpand(VNew);
end;

procedure TForm1.DeMorgan1Click(Sender: TObject);
var
  VNew: TNode;
begin
  with FFactory as TPropFactory do
  VNew := MakeEquiv(
            MakeNot(MakeAnd(MakeVar('P'), MakeVar('Q'))),
            MakeOr(MakeNot(MakeVar('P')), MakeNot(MakeVar('Q'))));
  DoExpand(VNew);
end;

end.
