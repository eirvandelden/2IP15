unit PanelTree;

//{$MODE Delphi}

interface
uses
  Classes, Contnrs, ExtCtrls, Graphics, Math, SysUtils, Controls, {Windows,}
  Nodes, ColorShades, Repr;

type


  TPanelTree = class; //forward

  TPanelList = class; //forward

  TPanelState = (psOuter, psThis, psInner);

  TLevelIndex = 1..4;

  TPanelNode =
  class(TPanel)
  private
    FTree    : TPanelTree;
    FSons    : TPanelList;
    FState   : TPanelState;
    FPreState: TPanelState;
    FLevel   : TLevelIndex;
    FLevelInc: 0..1;
    FSelectable: Boolean;
    FData    : Pointer;
  protected
    procedure   SetState(AState: TPanelState); virtual;
    procedure   SetPreState(AState: TPanelState); virtual;
    procedure   SetSelectable(ASelectable: Boolean);
    procedure   MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer); {<<<}
    procedure   PanelClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; APanelTree: TPanelTree);
    constructor CreateArgs(
                  AOwner: TComponent;
                  APanelTree: TPanelTree;
                  const AArgs: array of TPanelNode);
    constructor CreateList(
                  AOwner: TComponent;
                  APanelTree: TPanelTree;
                  APanelList: TPanelList);
    destructor  Destroy; override;
    procedure   AddSon(APanelNode: TPanelNode);
    procedure   AddSonArgs(const AArgs: array of TPanelNode);
    function    GetSon(I: Integer): TPanelNode;
    function    NrOfSons: Integer;
    property    State: TPanelState read FState write SetState;
    property    PreState: TPanelState read FPreState write SetPreState;
    property    Selectable: Boolean read FSelectable write SetSelectable;
    property    Data: Pointer read FData write FData;
  end;

  TPanelSelectEvent =
  procedure(Sender: TObject; APanelNode: TPanelNode) of object;

  TPanelTree = class(TPanel)
  protected
    { Private declarations }
    FRoot: TPanelNode;
    FSelected: TPanelNode;
    FColorShades: TColorShades;
    FShadeIndex: Integer;
    FDarkening: Boolean;
    FBevelSelect: TBevelCut;

    FPanelSelect: TPanelSelectEvent;
    procedure   RecSetState(ANode: TPanelNode; AState: TPanelState);
    procedure   RecSetPreState(ANode: TPanelNode; APreState: TPanelState);
    procedure   SetShadeIndex(AShadeIndex: Integer);
    procedure   PreSelect(ANode: TPanelNode);
    function    GetBackGroundColor(ALevel: TLevelIndex): TColor; virtual;
    function    GetBevelOuter(APreState, AState: TPanelState): TBevelCut;
                virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override; // <<??
    procedure   Clear;
    procedure   Select(ANode: TPanelNode);
    procedure   SelectData(AData: Pointer); // select panel with Data = AData
    procedure   InsertControl(AControl: TWincontrol);
    procedure   RemoveControl(AControl: TWinControl);
    property    ShadeIndex: Integer read FShadeIndex write SetShadeIndex;
    property    Darkening: Boolean read FDarkening write FDarkening;
    property    BevelSelect: TBevelCut read FBevelSelect write FBevelSelect;
    property    OnPanelSelect: TPanelSelectEvent read FPanelSelect write FPanelSelect;
    property    Selected: TPanelNode read FSelected;
  end;

  TPanelList =
  class(TObjectList)
  end;

  TPanelNode_Graph =
  class(TPanelNode)
  protected
    FNodeLabel: String;
    procedure Paint; override;
  end;

  TPanelTree_Graph =
  class(TPanelTree)
  protected
    FNodeWidth: Integer;
    FNodeHeight: Integer;
    FNodeHorizontalMargin: Integer; // margin between label and rectangle
    FNodeColor: TColor;
    FHorSep: Integer;
    FVerSep: Integer;
    FRepr: TRepr;
    procedure Paint; override;
    function  NodesToPanels(ANode: TNode): TPanelNode_Graph;
    procedure SetNodeWidth (AWidth : Integer); virtual;
    procedure SetNodeHorizontalMargin (AMargin : Integer); virtual;
    procedure SetNodeHeight(AHeight: Integer); virtual;
    procedure SetNodeColor (AColor : TColor); virtual;
    procedure SetHorSep(ASep: Integer); virtual;
    procedure SetVerSep(ASep: Integer); virtual;
    procedure SetRepr(ARepr: TRepr); virtual;
  public
    procedure ShowTree(ANode: TNode);
    property NodeWidth : Integer read FNodeWidth  write SetNodeWidth;
    property NodeHeight: Integer read FNodeHeight write SetNodeHeight;
    property NodeHorizontalMargin: Integer read FNodeHorizontalMargin
      write SetNodeHorizontalMargin;
    property NodeColor : TColor  read FNodeColor  write SetNodeColor;
    property HorSep    : Integer read FHorSep     write SetHorSep;
    property VerSep    : Integer read FVerSep     write SetVerSep;
    property Repr      : TRepr   read FRepr       write SetRepr;
  end;


implementation

{ TPanelNode }

procedure TPanelNode.AddSon(APanelNode: TPanelNode);
begin
  APanelNode.Parent := Self;
  FSons.Add(APanelNode);
end;

procedure TPanelNode.AddSonArgs(const AArgs: array of TPanelNode);
var
  I: Integer;
begin
  for I := 0 to High(AArgs) do AddSon(AArgs[I]);
end;

constructor TPanelNode.Create(AOwner: TComponent; APanelTree: TPanelTree);
begin
  inherited Create(AOwner);
  FTree := APanelTree;
  FSons := TPanelList.Create;
  FState := psOuter;
  FPreState := psOuter;
  FLevel := 1;
  FLevelInc := 0;
  Selectable := false;
  OnMouseMove := MouseMove;
  OnClick := PanelClick;
end;

constructor TPanelNode.CreateArgs(AOwner: TComponent;
  APanelTree: TPanelTree; const AArgs: array of TPanelNode);
begin
  Create(AOwner, APanelTree);
  AddSonArgs(AArgs);
end;

constructor TPanelNode.CreateList(AOwner: TComponent;
  APanelTree: TPanelTree; APanelList: TPanelList);
begin
  Create(AOwner, APanelTree);
  FSons := APanelList;
end;

destructor TPanelNode.Destroy;
begin
  FSons.Clear;
  FSons.Free;
  inherited Destroy;
end;

function TPanelNode.GetSon(I: Integer): TPanelNode;
begin
  if (0 <= I) and (I < FSons.Count)
  then Result := FSons[I] as TPanelNode
  //else raise exception
end;

procedure TPanelNode.MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FPreState <> psThis                
  then FTree.PreSelect(Self);
end;

function TPanelNode.NrOfSons: Integer;
begin
  Result := FSons.Count;
end;

procedure TPanelNode.PanelClick(Sender: TObject);
begin
  FTree.Select(Self);
end;

procedure TPanelNode.SetSelectable(ASelectable: Boolean);
begin
  FSelectable := ASelectable;
  ParentColor := not FSelectable;
end;

procedure TPanelNode.SetPreState(AState: TPanelState);
begin
  FPreState := AState;
  if Selectable then
  begin
    Color := FTree.GetBackgroundColor(FLevel + FLevelInc);
  end;
    BevelOuter := FTree.GetBevelOuter(FPreState, FState);
end;

procedure TPanelNode.SetState(AState: TPanelState);
begin
  FState := AState;
  case FState of
    psOuter:
      FLevel := 1;
    psThis,
    psInner:
      FLevel := 3;
  end;
  if Selectable then
  begin
    Color := FTree.GetBackgroundColor(FLevel + FLevelInc);
  end;
    BevelOuter := FTree.GetBevelOuter(FPreState, FState);
end;

{ TPanelTree }

constructor TPanelTree.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRoot := nil;
  FSelected := nil;
  FColorShades := TColorShades.Create;
  FShadeIndex := sh4LightGray;
  FDarkening := true;
  FBevelSelect := bvNone;
  FColorShades.Standard := FShadeIndex;
  DoubleBuffered := true; //<<<<<<<<<<<< ?????????????????
end;

procedure TPanelTree.Clear;
begin
  if FRoot <> nil then
  begin
    FRoot.Parent := nil;
    FRoot.Free;
  end
end;

procedure SetInc(ANode: TPanelNode);
var
  I: Integer;
begin
  if ANode.FState <> psThis then
  begin
    ANode.FLevelInc := 1;
    with ANode.FSons do
      for I := 0 to Count - 1 do
        SetInc(Items[I] as TPanelNode);
  end
end;

procedure ClearInc(ANode: TPanelNode);
var
  I: Integer;
begin
  ANode.FLevelInc := 0;
  with ANode.FSons do
    for I := 0 to Count - 1 do
      ClearInc(Items[I] as TPanelNode);
end;

procedure TPanelTree.InsertControl(AControl: TWincontrol);
begin
  if FSelected <> nil then
  begin
    AControl.Parent := FSelected;
    AControl.Align := alClient;
  end;
end;

procedure TPanelTree.RemoveControl(AControl: TWinControl);
begin
  AControl.Parent := nil;
end;

procedure TPanelTree.PreSelect(ANode: TPanelNode);
begin
  if ANode.FSelectable then
  begin
    ClearInc(FRoot);
    SetInc(ANode);
    RecSetPreState(FRoot, psOuter);
    RecSetPreState(ANode, psInner);
    ANode.PreState := psThis;
  end
  else if (ANode.Parent <> nil) and (ANode.Parent is TPanelNode)
  then PreSelect(ANode.Parent as TPanelNode);
end;

procedure TPanelTree.RecSetState(ANode: TPanelNode; AState: TPanelState);
var
  I: Integer;
begin
  ANode.State := AState;
  with ANode.FSons do
    for I := 0 to Count - 1 do
      RecSetState(Items[I] as TPanelNode, AState);
end;

procedure TPanelTree.RecSetPreState(ANode: TPanelNode; APreState: TPanelState);
var
  I: Integer;
begin
  ANode.PreState := APreState;
  with ANode.FSons do
    for I := 0 to Count - 1 do
      RecSetPreState(Items[I] as TPanelNode, APreState);
end;

procedure TPanelTree.Select(ANode: TPanelNode);
begin
  if ANode.FSelectable then
  begin
    RecSetState(FRoot, psOuter);
    RecSetState(ANode, psInner);
    ANode.State := psThis;
    FSelected := ANode;
    FPanelSelect(Self, ANode); //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  end
  else if (ANode.Parent <> nil) and (ANode.Parent is TPanelNode)
  then Select(ANode.Parent as TPanelNode)
end;

procedure TPaneltree.SelectData(AData: Pointer);
  procedure AuxSelect(APanelNode: TPanelNode);
  var
    I: Integer;
  begin
    if APanelNode.Data = AData
    then Select(APanelNode)
    else
      with APanelNode do
        for I := 0 to NrOfSons - 1 do
          AuxSelect(GetSon(I));
  end;
begin
  AuxSelect(FRoot);
end;

function TPanelTree.GetBackGroundColor(ALevel: TLevelIndex): TColor;
begin
  if FDarkening
  then Result := FColorShades.Level(5 - ALevel)
  else Result := FColorShades.level(ALevel);
end;

function TPanelTree.GetBevelOuter(APreState, AState: TPanelState): TBevelCut;
begin
  if (APreState = psThis) or (AState = psThis)
  then Result := FBevelSelect
  else Result := bvNone;
end;

procedure TPanelTree.SetShadeIndex(AShadeIndex: Integer);
begin
  FShadeIndex := AShadeIndex;
  FColorShades.Standard := FShadeIndex;
end;

{ TPanelTree_Text }

function TPanelTree_Graph.NodesToPanels(ANode: TNode): TPanelNode_Graph;
var
  VSon: TPanelNode;
  VX, VY, MaxY: Integer;
  I: Integer;
begin
  Result := TPanelNode_Graph.Create(nil, Self);
  Result.Selectable := true;
  Result.FData := ANode;
  if ANode.HasData
  then Result.FNodeLabel := ANode.OpName + '[' + ANode.GetData + ']'
  else Result.FNodeLabel := ANode.OpName;

  VX := 0;
  VY := 0;
  if FBevelSelect <> bvNone then
  begin
    VX := VX + BevelWidth;
    VY := VY + BevelWidth
  end;
  VY := VY + Max(FNodeHeight, Canvas.TextHeight(Result.FNodeLabel) + 2);
  if ANode.GetNrofSons <> 0
  then VY := VY + FVerSep;

//  recursively create and insert panels for sons;
//  calculate sum of widths and max of heights
  MaxY := 0;
  for I := 0 to ANode.GetNrOfSons - 1 do
  begin
    VSon := NodesToPanels(ANode.GetSon(I));
    Result.AddSon(VSon);
    VSon.Left := VX;
    VSon.Top := VY;
    VX := VX + VSon.Width + FHorSep;
    MaxY := Max(MaxY, VSon.Height);
  end;
  if ANode.GetNrofSons <> 0
  then VX := VX - FHorSep;

  Result.Width := Max(VX, Max(FNodeWidth, FNodeHorizontalMargin * 2 +
      Canvas.TextWidth(Result.FNodeLabel) + 2));
  Result.Height := VY + MaxY;
  if FBevelSelect <> bvNone then
  begin
    Result.Width  := Result.Width  + BevelWidth;
    Result.Height := Result.Height + BevelWidth;
  end;

end;



procedure TPanelTree_Graph.Paint;
begin
  inherited Paint;
  if FRoot <> nil
  then FRoot.Paint;
end;

procedure TPanelTree_Graph.SetHorSep(ASep: Integer);
begin
  FHorSep := ASep;
  Invalidate;
end;

procedure TPanelTree_Graph.SetNodeColor(AColor: TColor);
begin
  FNodeColor := AColor;
  Invalidate;
end;

procedure TPanelTree_Graph.SetNodeHeight(AHeight: Integer);
begin
  FNodeHeight := AHeight;
  Invalidate;
end;

procedure TPanelTree_Graph.SetNodeHorizontalMargin(AMargin: Integer);
begin
  FNodeHorizontalMargin := AMargin;
  Invalidate;
end;

procedure TPanelTree_Graph.SetNodeWidth(AWidth: Integer);
begin
  FNodeWidth := AWidth;
  Invalidate;
end;

procedure TPanelTree_Graph.SetRepr(ARepr: TRepr);
begin
  FRepr := ARepr;
  Invalidate;
end;

procedure TPanelTree_Graph.SetVerSep(ASep: Integer);
begin
  FVerSep := ASep;
  Invalidate;
end;

procedure TPanelTree_Graph.ShowTree(ANode: TNode);
begin
  Clear;
  FRoot := NodesToPanels(ANode);
  Height := FRoot.Height;
  Width := FRoot.Width;
  FRoot.Parent := Self;
  FRoot.Align := alLeft;
  RecSetState(FRoot, psOuter);
end;

procedure TPanelNode_Graph.Paint;
var
  VSon: TPanelNode;
  VX, VY, CenterX, CenterY: Integer;
  I: Integer;
  VLeft, VRight, VTop, VBottom: Integer;
  VNodeWidth, VNodeHeight, VNodeHorizontalMargin: Integer;
  NW, NH: Integer;
begin
  inherited Paint;

  // get parameters for node drawing
  with FTree as TPanelTree_Graph do
  begin
    VNodeWidth := FNodeWidth;
    VNodeHeight := FNodeheight;
    VNodeHorizontalMargin := FNodeHorizontalMargin;
  end;

  NW := Max(VNodeWidth,
          Canvas.TextWidth(FNodeLabel) + 2 * VNodeHorizontalMargin + 2);
  NH := Max(VNodeHeight, Canvas.TextHeight(FNodeLabel) + 2);
  if FTree.FBevelSelect <> bvNone
  then VTop := BevelWidth
  else VTop := 0;

  // draw lines from centertop to centertops of sons
  CenterX := Width div 2;
  CenterY := VTop + NH div 2;
  for I := 0 to NrofSons -1 do
  begin
    VSon := GetSon(I);
    VX := VSon.Left + VSon.Width div 2;
    VY := VSon.Top;
    with Canvas do
    begin
      MoveTo(CenterX, CenterY);
      LineTo(VX, VY);
    end;
  end;{for}

  with Canvas do
  begin
    // draw node at centertop
    VLeft := CenterX - NW div 2;
    VRight := CenterX + NW div 2;
    VBottom := VTop + NH;
    Brush.Color := (FTree as TPanelTree_Graph).FNodeColor;
    Rectangle(VLeft, VTop, VRight, VBottom);

    // draw node label
    TextOut(VLeft + VNodeHorizontalmargin, VTop + 1, FNodeLabel);
  end
end;


end.
