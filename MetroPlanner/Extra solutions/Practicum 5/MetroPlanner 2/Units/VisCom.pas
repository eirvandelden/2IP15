unit VisCom;

interface

uses
  ExtCtrls, Contnrs, Graphics, Classes;

type

  TMap = class; // forward

//==============================================================================
// VisCom
// Viscoms are components for visualization of map elements.
// TVisCom is the base class for VisComs. A TVisCom object has the following
// features:
// - code/key: a short string used for identification purposes
// - data: a reference to an object whose data is represented by this VisCom
// - state: ?????
// - selection: facilities for selection of this VisCom
// - marking: facilities for marking this VisCom
// - drawing: facilities for drawing this VisCom on a Map
//==============================================================================
  TVisCom =
  class(TObject)
  protected
    // fields ------------------------------------------------------------------
    FCode: String;
    FData: TObject; // shared
    FSelected: Boolean;
    FMark: String;

    // invariants --------------------------------------------------------------
    // none
  public
    // construction/destruction ------------------------------------------------
    constructor Create(ACode: String; AData: TObject);
    // pre: true
    // post: GetCode = ACode, GetData = AData, IsSelected = false, GetMark =''

    // primitive queries -------------------------------------------------------
    function GetCode: String; virtual;
    function GetData: TObject; virtual;
    function CanSelect: Boolean; virtual;
    // pre: true
    // ret: false (may be overridden in descendants)
    function CanMark(AMark:String): Boolean; virtual;
    // pre: true
    // ret: false (may be overriden in descendants)
    function IsSelected: Boolean; virtual;
    function GetMark: String;
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; virtual; abstract;
    // pre: true
    // ret: "the image of this object drawn on map AMap contains point (AX, AY)"

    // derived queries ---------------------------------------------------------
    function IsMarked: Boolean; virtual;
    // pre: true
    // ret: GetMark <> ''

    // commands ----------------------------------------------------------------
    procedure Select; virtual;
    // pre: CanSelect
    // post: IsSelected
    procedure UnSelect; virtual;
    // pre: true
    // post: CanSelect = false
    procedure Mark(AMark: String); virtual;
    // pre: Canmark(AMark)
    // post: GetMark = AMark
    procedure UnMark; virtual;
    // pre: true
    // post: GetMark = ''
    procedure Draw(AMap: TMap); virtual; abstract;
    // pre: AMap <> nil
    // post: this VisCom has been drawn on AMap

    // invariants --------------------------------------------------------------
    // none
  end;


  TMap =
  class(TImage)
  protected
    FBlankPicture: TBitmap;
    FBackgroundPicture: TBitmap;
    FBackgroundShown: Boolean;
    FMultiSelect: Boolean;
    FViscoms: TObjectList;  // owner
    FMarked: TObjectList;   // shared
    FSelected: TObjectList; // shared

    // protected invariants
    // FBlankPicture <> nil; refers to all blank bitmap
    // FBackgroundPicture <> nil
  public
    // construction/destruction
    constructor Create(AOwner: TComponent;
                  ABlankPicture, ABackgroundPicture: TBitmap);
    // pre: true
    // post: inherited.Create.post,
    //       MultiSelect = false,
    //       AbstrVisCom = [], AbstrMarked = [], AbstrSelected = [],
    //       BackgroundShown, BackgroundPicture = ABackgroundPicture
    destructor Destroy; override;

    // primitive queries -------------------------------------------------------
    function BackgroundPicture: TBitmap;
    function BackgroundShown: Boolean;
    // pre: true
    // ret: Image.Picture = Background
    function MultiSelect: Boolean;
    function VisComCount: Integer;
    // pre: true
    // ret: |AbstrVisCom|
    function GetVisCom(I: Integer): TVisCom;
    // pre: 0 <= I < VisComCount
    // ret: AbstrVisCom[I]
    function MarkedCount: Integer;
    // pre: true
    // ret: |AbstrMarked|
    function GetMarked(I: Integer): TVisCom;
    // pre: 0 <= I < MarkedCount
    // ret: AbstrMarked[I]
    function SelectedCount: Integer;
    // pre: true
    // ret: |AbstrSelected|
    function GetSelected(I: Integer): TVisCom;
    // pre: true
    // ret: AbstrSelected[I]

    // derived queries ---------------------------------------------------------
    function Has(AVisCom: TVisCom): Boolean;
    // pre: true
    // ret: (exists I: 0 <= I < VisComCount: GetVisCom(I) = AVisCom)

    // preconditions -----------------------------------------------------------
    function CanAdd(AVisCom: TVisCom): Boolean; virtual;
    // pre: true
    // ret: not Has(AVisCom)
    function CanDelete(AVisCom: TVisCom): Boolean; virtual;
    // pre: true
    // ret: Has(AVisCom)
    function CanSelect(AVisCom: TVisCom): Boolean; virtual;
    // pre: true
    // ret: Has(AVisCom) and AVisCom.CanSelect
    function CanUnselect(AVisCom: TVisCom): Boolean; virtual;
    // pre: true
    // ret: Has(AVisCom)
    function CanMark(AVisCom: TVisCom; AMark: String): Boolean; virtual;
    // pre: true
    // ret: Has(AVisCom) and AVisCom.CanMark(AMark)
    function CanUnmark(AVisCom: TVisCom): Boolean; virtual;
    // pre: true
    // ret: Has(AVisCom)

    // commands ----------------------------------------------------------------
    procedure SetBackgroundPicture(ABackgroundPicture: TBitmap); virtual;
    // pre: ABackgroundPicture <> nil
    // post: BackgroundPicture = ABackgroundPicture
    procedure ShowBackground;
    // pre: true
    // post: BackgroundShown
    procedure HideBackground;
    // pre: true
    // post: not BackgroundShown
    procedure SetMultiSelect(AMultiSelect: Boolean); virtual;
    // pre: true
    // post: MultiSelect = AMultiSelect
    procedure ClearSelected;
    // pre: true
    // post: SelectedCount = 0
    procedure ClearMarked;
    // pre: true
    // post: MarkedCount = 0
    procedure HideAll; virtual;
    // pre: true
    // post: Image.Picture = Background
    procedure ShowAll; virtual;
    // effect: draw all VisComs on the map

    procedure Add(AVisCom: TVisCom);
    // pre: CanAdd(AVisCom)
    // post: AbstrVisCom = AbstrVisCom ++ [AVisCom]
    procedure Delete(AVisCom: TVisCom);
    // pre: CanDelete(AVisCom)
    // post: AbstrVisCom = AbstrVisCom - [AVisCom]
    procedure Select(AVisCom: TVisCom);
    // pre: CanSelect(AVisCom)
    // post: AVisCom.IsSelected
    procedure UnSelect(AVisCom: TVisCom);
    // pre: CanUnselect(AVisCom)
    // post: not AVisCom.IsSelected
    procedure Mark(AVisCom: TVisCom; AMark: String);
    // pre: CanMark(AVisCom, AMark)
    // post: AVisCom.IsMarked
    procedure Unmark(AVisCom: TVisCom);
    // pre: CanUnmark(AVisCom)
    // post: not AVisCom.IsMarked

    // model variables ---------------------------------------------------------
    // AbstrVisCom: seq of TVisCom
    // AbstrSelected: seq of TVisCom
    // AbstrMarked: seq of TVisCom

    // public invariants -------------------------------------------------------
    // Unique:
    //   (forall I,J: 0<=I<J<VisComCount:
    //      - GetVisCom(I) <> GetVisCom(J)
    //   )
    // SelectedExists: (forall I: 0<=I<SelectedCount: Has(GetSelected(I)))
    // MarkedExists: (forall I: 0<=I<MarkedCount: Has(GetMarked(I)))
    // MultiSelction:  not MultiSelect implies (SelectedCount <= 1)
    //
    // WellformedPicture:
    //  (Image.Picture = Blank) or (Image.Picture = Background)
    //
    //  BackgroundShown <=> Image.Picture = Background
  end;


implementation //===============================================================

{ TVisCom }

function TVisCom.CanMark(AMark: String): Boolean;
begin
  Result := false;
end;

function TVisCom.CanSelect: Boolean;
begin
  Result := false;
end;

constructor TVisCom.Create(ACode: String; AData: TObject);
begin
  inherited Create;
  FCode := ACode;
  FData := AData;
  FSelected := false;
  FMark := '';
end;

function TVisCom.GetCode: String;
begin
  Result := FCode;
end;

function TVisCom.GetData: TObject;
begin
  Result := FData;
end;

function TVisCom.GetMark: String;
begin
  Result := FMark;
end;

function TVisCom.IsMarked: Boolean;
begin
  Result := GetMark = '';
end;

function TVisCom.IsSelected: Boolean;
begin
  Result := FSelected;
end;

procedure TVisCom.Mark(AMark: String);
begin
  Assert(CanMark(AMark), '');  // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  FMark := AMark;
end;

procedure TVisCom.Select;
begin
  Assert(CanSelect, ''); // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  FSelected := true;
end;

procedure TVisCom.UnMark;
begin
  FMark := '';
end;

procedure TVisCom.UnSelect;
begin
  FSelected := false;
end;

{ TMap }

procedure TMap.Add(AVisCom: TVisCom);
begin
  Assert(CanAdd(AVisCom), ''); //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  FVisComs.Add(AVisCom);
end;

function TMap.BackgroundPicture: TBitmap;
begin
  Result := FBackgroundPicture;
end;

function TMap.BackgroundShown: Boolean;
begin
  Result := FBackgroundShown;
end;

function TMap.CanAdd(AVisCom: TVisCom): Boolean;
begin
  Result := not Has(AVisCom);
end;

function TMap.CanDelete(AVisCom: TVisCom): Boolean;
begin
  Result := not Has(AVisCom);
end;

function TMap.CanMark(AVisCom: TVisCom; AMark: String): Boolean;
begin
  Result := Has(AVisCom) and AVisCom.CanMark(AMark);
end;

function TMap.CanSelect(AVisCom: TVisCom): Boolean;
begin
  Result := Has(AVisCom) and AVisCom.CanSelect;
end;

function TMap.CanUnmark(AVisCom: TVisCom): Boolean;
begin
  Result := Has(AVisCom);
end;

function TMap.CanUnselect(AVisCom: TVisCom): Boolean;
begin
  Result := Has(AVisCom);
end;

procedure TMap.ClearMarked;
var
  I: Integer;
begin
  with FMarked do
  begin
    for I := Count - 1 downto 0 do //N.B. direction important
    begin
      (Items[I] as TVisCom).UnMark;
      Delete(I);
    end;{for}
  end;{with}
end;

procedure TMap.ClearSelected;
var
  I: Integer;
begin
  with FSelected do
  begin
    for I := Count - 1 downto 0 do //N.B. direction important
    begin
      (Items[I] as TVisCom).UnSelect;
      Delete(I);
    end;{for}
  end;{with}
end;

constructor TMap.Create(AOwner: TComponent;
              ABlankPicture, ABackgroundPicture: TBitmap);
begin
  inherited Create(AOwner);
  FBlankPicture := ABlankPicture;
  FBackgroundPicture := ABackgroundPicture;
  ShowBackground;
  FMultiSelect:= false;
  FViscoms := TObjectList.Create(true);   // owner
  FMarked := TObjectList.Create(false);   // shared
  FSelected := TObjectList.Create(false); // shared
end;

procedure TMap.Delete(AVisCom: TVisCom);
begin
  Assert(CanDelete(AVisCom), ''); //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  // N.B.: Order is important
  FSelected.Remove(AVisCom);
  FMarked.Remove(AVisCom);
  FVisComs.Remove(AVisCom); // and freed
end;

destructor TMap.Destroy;
begin
  // N.B.: Order is important
  FSelected.Free; // shares
  FMarked.Free;   // shares
  FVisComs.Free;  // owns, hence frees all objects
  FBlankPicture.Free;
  FBackgroundPicture.Free;
  inherited;
end;

function TMap.GetMarked(I: Integer): TVisCom;
begin
  Assert( (0 <= I) and (I < MarkedCount), ''); //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Result := FMarked.Items[I] as TVisCom;
end;

function TMap.GetSelected(I: Integer): TVisCom;
begin
  Assert( (0 <= I) and (I < SelectedCount), ''); //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Result := FSelected.Items[I] as TVisCom;
end;

function TMap.GetVisCom(I: Integer): TVisCom;
begin
  Assert( (0 <= I) and (I < VisComCount), ''); //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Result := FVisComs.Items[I] as TVisCom;
end;

function TMap.Has(AVisCom: TVisCom): Boolean;
begin
  Result := FVisComs.IndexOf(AVisCom) <> -1;
end;

procedure TMap.HideAll;
begin
  Picture.Assign(FBackgroundPicture);
  Repaint; // <<<<<<<<<<<<<<<<<<<<<<<<<< Necessary?
end;

procedure TMap.HideBackground;
begin
  Picture.Assign(FBlankPicture);
  FBackgroundShown := false;
end;

procedure TMap.Mark(AVisCom: TVisCom; AMark: String);
begin
  Assert(CanMark(AVisCom, AMark), ''); //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  AVisCom.Mark(AMark);
end;

function TMap.MarkedCount: Integer;
begin
  Result := FMarked.Count;
end;

function TMap.MultiSelect: Boolean;
begin
  Result := FMultiSelect;
end;

procedure TMap.Select(AVisCom: TVisCom);
begin
  Assert(CanSelect(AVisCom), ''); //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  AVisCom.Select;
end;

function TMap.SelectedCount: Integer;
begin
  Result := FSelected.Count;
end;

procedure TMap.SetBackgroundPicture(ABackgroundPicture: TBitmap);
begin
  FBackgroundPicture := ABackgroundPicture;
end;

procedure TMap.SetMultiSelect(AMultiSelect: Boolean);
begin
  FMultiSelect := AMultiSelect;
  if not AMultiSelect then
  begin
    ClearSelected;
    ClearMarked;
  end;
end;

procedure TMap.ShowAll;
var
  I: integer;
begin
  for I := 0 to VisComCount - 1 do
  begin
    GetVisCom(I).Draw(Self);
  end;
end;

procedure TMap.ShowBackground;
begin
  Picture.Assign(FBackgroundPicture);
  FBackgroundShown := true;
end;

procedure TMap.Unmark(AVisCom: TVisCom);
begin
  Assert(CanUnmark(AVisCom), ''); //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  AVisCom.UnMark;
end;

procedure TMap.UnSelect(AVisCom: TVisCom);
begin
  Assert(CanUnselect(AVisCom), ''); //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  AVisCom.UnSelect;
end;

function TMap.VisComCount: Integer;
begin
  Result := FVisComs.Count;
end;

end.
 