unit TreeEditorCommands;

interface

uses
  UndoRedo, Nodes, TreeEditor, Repr, Dialogs, SysUtils,
  RE, RERepr, Prop, PropRepr, MyMath, MathRepr;



type
  // ===== DoClear ===================================================
  TCommand_DoClear =
  class(TCommand)
  protected
    // command parameters
    FTreeEditor: TTreeEditor;

    // additional data for reverse
    FDeletedTree: TNode;

  public
    constructor Create(ATreeEditor: TTreeEditor);
    procedure   Execute; override;
    procedure   Reverse; override;
    function    Reversible: Boolean; override;
  end;

  // ===== DoCut ===================================================
  TCommand_DoCut =
  class(TCommand)
  protected
    // command parameters
    FTreeEditor: TTreeEditor;

    // additional data for reverse
    FDeletedTree: TNode;
  public
    constructor Create(ATreeEditor: TTreeEditor);
    procedure   Execute; override;
    procedure   Reverse; override;
    function    Reversible: Boolean; override;
  end;

  // ===== DoDelete ===================================================
  TCommand_DoDelete =
  class(TCommand)
  protected
    // command parameters
    FTreeEditor: TTreeEditor;

    // additional data for reverse
    FDeletedTree: TNode;
  public
    constructor Create;
    procedure   Execute; override;
    procedure   Reverse; override;
    function    Reversible: Boolean; override;
  end;

  // ===== DoExpand ===================================================
    TCommand_DoExpand =
  class(TCommand)
  protected
    // command parameters
    FNew: TNode;
    FTreeEditor: TTreeEditor;

    // additional data for reverse
    FDeletedTree: TNode;
    // geen FDeletedTree, want Expand word alleen gebruikt op holes
  public
    constructor Create(ATreeEditor: TTreeEditor; ANew: TNode);
    procedure   Execute; override;
    procedure   Reverse; override;
    function    Reversible: Boolean; override;
  end;
  // ===== DoPaste ===================================================
    TCommand_DoPaste =
  class(TCommand)
  protected
    // command parameters
    FTreeEditor: TTreeEditor;
    FClip: TNode;

    // additional data for reverse
    FDeletedTree: TNode;

  public
    constructor Create(ATreeEditor: TTreeEditor; AClip: TNode);
    procedure   Execute; override;
    procedure   Reverse; override;
    function    Reversible: Boolean; override;
  end;



  //****************************************************************
  //***                        Implementation                    ***
  //****************************************************************

implementation

  // ===== DoClear ===================================================

constructor TCommand_DoClear.Create(ATreeEditor: TTReeEditor);
begin
  inherited Create;

  FTreeEditor := ATreeEditor;
end;

procedure TCommand_DoClear.Execute;
var
  VNew: TNode;
begin
  // remember tree to be deleted
   FDeletedTree := FTreeEditor.Tree.Clone;

  // *** DoClear  *****************

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


end;

procedure TCommand_DoClear.Reverse;
begin
  // FTRee := FDelete tree

  FTreeEditor.Replace( FDeletedTree, FTreeEditor.Tree);

end;

function TCommand_DoClear.Reversible: Boolean;
begin
  Result := true;
end;



  // ===== DoCut ===================================================

constructor TCommand_DoCut.Create(ATreeEditor:TTReeEditor);
begin
  inherited Create;
  FTreeEditor := ATreeEditor;
end;


procedure TCommand_DoCut.Execute;
var VNew: TNode;
begin
  // Save Deleted tree
  FDeletedTree := FTreeEditor.Tree.Clone;

  //*** DoCut ******************************

  // replace with hole
    // pre: - FTreeEditor.Focus <> nil
    //      - FTreeEditor.Focus verwijst niet naar een gat
    // effect: - de door FTreeEditor.Focus aangewezen boom wordt vervangen door
    //           een gat
    //         - FTreeEditor.Focus verwijst naar dat gat
    //         - verwijderde boom wordt op clipboard geplaatst


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

end;

procedure TCommand_DoCut.Reverse;
begin
  FTreeEditor.Replace(FDeletedTree, FTreeEditor.Tree);

end;

function TCommand_DoCut.Reversible: Boolean;
begin
  Result := true;
end;

// ===== DoDelete ===================================================

constructor TCommand_DoDelete.Create;
begin
  inherited Create;
end;


procedure TCommand_DoDelete.Execute;
begin
  // Save Deleted tree

  // replace with hole
end;

procedure TCommand_DoDelete.Reverse;
begin
  // Vervang Gat met FDeletedTree

end;

function TCommand_DoDelete.Reversible: Boolean;
begin
  Result := true;
end;


   // ===== DoExpand ===================================================
constructor TCommand_DoExpand.Create(ATreeEditor: TTreeEditor; ANew: TNode);
begin
  inherited Create;
  FNew := ANew;
      FTreeEditor:= ATreeEditor;
end;


procedure TCommand_DoExpand.Execute;
begin
  // Save father of deleted node
  FDeletedTree := FTreeEditor.Tree.Clone;

  //# BEGIN TODO
    // pre: - FTreeEditor.Focus verwijst naar een gat
    //      - ANew is wortel van goedgevormde boom
    // effect: - in FTreeEditor.Tree wordt het door FFocus aangegeven gat
    //           vervangen door boom met wortel ANew
    //         - FTreeEditor.Focus wijst naar Anew



  FTreeEditor.Replace(FNew, FTreeEditor.Focus);
  FTreeEditor.Focus := FNew;


  // replace with ANew
end;

procedure TCommand_DoExpand.Reverse;
begin
  // Replace ANew with hole
  FTreeEditor.Replace(FDeletedTree, FTreeEditor.Tree);

end;

function TCommand_DoExpand.Reversible: Boolean;
begin
  Result := true;
end;

  // ===== DoPaste ===================================================
constructor TCommand_DoPaste.Create(ATreeEditor:TTreeEditor; AClip:TNode);
begin
  inherited Create;
  FTreeEditor:= ATreeEditor;
  FClip := AClip;
end;


procedure TCommand_DoPaste.Execute;
var VNew,VOld: TNode;

begin
  FDeletedTree := FTreeEditor.Tree.Clone;

  // Save father of holy

 VNew := FClip;
  VOld := FTreeEditor.Focus;

  FTreeEditor.Replace(VNew, VOld);
  FTreeEditor.Focus := VNew;


  // replace hole with tree in clipboard
end;

procedure TCommand_DoPaste.Reverse;
begin
  // Replace son of saven father with hole


end;

function TCommand_DoPaste.Reversible: Boolean;
begin
  Result := true;
end;




end.
