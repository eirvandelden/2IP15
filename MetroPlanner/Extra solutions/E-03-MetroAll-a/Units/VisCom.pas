unit VisCom;

interface

uses
  ExtCtrls, Contnrs, Graphics, Classes, StringValidators;

type

  TMap = class; // forward

//==============================================================================
// VisCom
// Viscoms are components for visualization of map elements.
// TVisCom is the base class for VisComs. A TVisCom object has the following
// features:
// - code: a short string used for identification purposes
// - data: a reference to an object whose data is represented by this VisCom
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
  public
    // construction/destruction ------------------------------------------------
    constructor Create(ACode: String; AData: TObject);
    // pre: True
    // post: (GetCode = ACode) and (GetData = AData) and (IsSelected = False)
    //       and (GetMark ='')

    // primitive queries -------------------------------------------------------
    function GetCode: String; virtual;
    function GetData: TObject; virtual;
    function CanSelect: Boolean; virtual;
    // ret: False (may be overridden in descendants)
    function CanMark(AMark:String): Boolean; virtual;
    // ret: False (may be overridden in descendants)
    function IsSelected: Boolean; virtual;
    function GetMark: String;
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; virtual; abstract;
    // pre: True
    // ret: "the image of this object drawn on map AMap contains point (AX, AY)"

    // derived queries ---------------------------------------------------------
    function IsMarked: Boolean; virtual;
    // pre: True
    // ret: GetMark <> ''

    // commands ----------------------------------------------------------------
    procedure Select; virtual;
    // pre: CanSelect
    // post: IsSelected
    procedure UnSelect; virtual;
    // pre: True
    // post: not(IsSelected)
    procedure Mark(AMark: String); virtual;
    // pre: Canmark(AMark)
    // post: GetMark = AMark
    procedure UnMark; virtual;
    // pre: True
    // post: GetMark = ''
    procedure Draw(AMap: TMap); virtual; abstract;
    // pre: AMap <> nil
    // post: this VisCom has been drawn on AMap
  end;

  TMap =
  class(TImage)
  protected
    FName: String;
    FBlankBitmap: TBitmap;
    FBackgroundBitmap: TBitmap;
    FBackgroundFileName: String;
    FBackgroundShown: Boolean;
    FMultiSelect: Boolean;
    FViscoms: TObjectList;  // shared
    FMarked: TObjectList;   // shared
    FSelected: TObjectList; // owner

    // protected invariants ----------------------------------------------------
    // FBlankPicture <> nil; refers to an all blank bitmap
    // FBackgroundPicture <> nil
  public
    // construction/destruction
    constructor Create(AName: String; AOwner: TComponent;
      ABlankBitmap, ABackgroundBitmap: TBitmap; AFileName: String);
    // pre: True
    // post: (inherited.Create.post) and
    //       (MultiSelect = False) and
    //       (AbstrVisCom = {} ) and (AbstrMarked = {} ) and
    //       (AbstrSelected = {} )and
    //       BackgroundShown and (BackgroundBitmap = ABackgroundBitmap) and
    //       BlankBitmap = ABlankBitmap and
    //       FBackgroundFileName = AFileName
    constructor CreateEmpty(AName: String; AOwner: TComponent);
    // pre: True
    // post: (inherited.Create.post) and
    //       (MultiSelect = False) and
    //       (AbstrVisCom = {} ) and (AbstrMarked = {} )and
    //       (AbstrSelected = {} ) and
    //       BackgroundShown and
    //       BackgroundBitmap is an instantiated bitmap object and
    //       BlankBitmap is an instatiated bitmap object and
    //       (GetBackgroundFileName = '<unknown>' )
    destructor Destroy; override;

    // primitive queries -------------------------------------------------------
    function GetMapName: String;
    function GetBackgroundBitmap: TBitmap;
    function GetBackgroundFileName: String;
    function BackgroundShown: Boolean;
    function MultiSelect: Boolean;

    function VisComCount: Integer;
    // pre: True
    // ret: |AbstrVisCom|
    function GetVisCom(I: Integer): TVisCom;
    // pre: 0 <= I < VisComCount
    // ret: AbstrVisCom[I]
    function MarkedCount: Integer;
    // pre: True
    // ret: |AbstrMarked|
    function GetMarked(I: Integer): TVisCom;
    // pre: 0 <= I < MarkedCount
    // ret: AbstrMarked[I]
    function SelectedCount: Integer;
    // pre: True
    // ret: |AbstrSelected|
    function GetSelected(I: Integer): TVisCom;
    // pre: True
    // ret: AbstrSelected[I]

    // derived queries ---------------------------------------------------------
    function Has(AVisCom: TVisCom): Boolean;
    // pre: True
    // ret: (exists I: 0 <= I < VisComCount: GetVisCom(I) = AVisCom)

    // preconditions -----------------------------------------------------------
    function CanAdd(AVisCom: TVisCom): Boolean; virtual;
    // pre: True
    // ret: not Has(AVisCom)
    function CanDelete(AVisCom: TVisCom): Boolean; virtual;
    // pre: True
    // ret: Has(AVisCom)
    function CanSelect(AVisCom: TVisCom): Boolean; virtual;
    // pre: True
    // ret: Has(AVisCom) and AVisCom.CanSelect
    function CanUnselect(AVisCom: TVisCom): Boolean; virtual;
    // pre: True
    // ret: Has(AVisCom)
    function CanMark(AVisCom: TVisCom; AMark: String): Boolean; virtual;
    // pre: True
    // ret: Has(AVisCom) and AVisCom.CanMark(AMark)
    function CanUnmark(AVisCom: TVisCom): Boolean; virtual;
    // pre: True
    // ret: Has(AVisCom)

    // commands ----------------------------------------------------------------
    procedure SetMapName(AName: String);
    // pre: ValidMapName(AName)
    // post: GetMapName = AName
    procedure SetBackgroundBitmap(ABackgroundBitmap: TBitmap); virtual;
    // pre: ABackgroundBitmap <> nil
    // post: GetBackgroundBitmap = ABackgroundBitmap
    procedure SetBlankBitmap(ABlankBitmap: TBitmap); virtual;
    // pre: ABlankBitmap <> nil
    // post: FBlankBitmap = ABlankBitmap
    procedure SetBackgroundFileName(AString: String);
    // pre: True
    // post: GetBackgroundFileName = AString
    procedure ShowBackground;
    // pre: True
    // post: BackgroundShown
    procedure HideBackground;
    // pre: True
    // post: not BackgroundShown
    procedure SetMultiSelect(AMultiSelect: Boolean); virtual;
    // pre: True
    // post: MultiSelect = AMultiSelect
    procedure ClearSelected;
    // pre: True
    // post: SelectedCount = 0
    procedure ClearMarked;
    // pre: True
    // post: MarkedCount = 0
    procedure HideAll; virtual;
    // pre: True
    // post: clear all Viscoms on the map
    procedure ShowAll; virtual;
    // pre: True
    // effect: draw all VisComs on the map
    procedure Add(AVisCom: TVisCom);
    // pre: CanAdd(AVisCom)
    // post: AbstrVisCom = AbstrVisCom U {AVisCom}
    procedure Replace(AOldVisCom: TVisCom; ANewVisCom: TVisCom);
    // pre: Has(AOldVisCom)
    // post: AbstrVisCom = (AbstrVisCom \ {AOldVisCom}) U {ANewVisCom}
    procedure Delete(AVisCom: TVisCom);
    // pre: CanDelete(AVisCom)
    // post: AbstrVisCom = AbstrVisCom \ {AVisCom}
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
    // AbstrVisCom: set of TVisCom
    // AbstrSelected: set of TVisCom
    // AbstrMarked: set of TVisCom

    // public invariants -------------------------------------------------------
    // A0: AbstrVisCom =
    //   (set I: 0 <= I < FVisComs.Count: FVisComs[I] as TVisCom)
    // A1: AbstrSelected =
    //  (set I: 0 <= I < FSelected.Count: FSelected[I] as TVisCom)
    // A2: AbstrMarked =
    //   (set I: 0 <= I < FMarked.Count: FMarked[I] as TVisCom)
    //
    // Unique:
    //   (forall I, J: 0 <= I < J < VisComCount: GetVisCom(I) <> GetVisCom(J))
    // SelectedExists: (forall I: 0 <= I < SelectedCount: Has(GetSelected(I)))
    // MarkedExists: (forall I: 0 <= I < MarkedCount: Has(GetMarked(I)))
    // MultiSelection:  not MultiSelect implies (SelectedCount <= 1)
    //
    // WellformedPicture:
    //  (Image.Picture = FBlankBitmap) or (Image.Picture = FBackgroundBitmap)
    //
    //  BackgroundShown <=> Image.Picture = FBackgroundBitmap
  end;


implementation //===============================================================

{ TVisCom }

function TVisCom.CanMark(AMark: String): Boolean;
begin
  Result := False;
end;

function TVisCom.CanSelect: Boolean;
begin
  Result := False;
end;

constructor TVisCom.Create(ACode: String; AData: TObject);
begin
  inherited Create;
  FCode := ACode;
  FData := AData;
  FSelected := False;
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
  FSelected := True;
end;

procedure TVisCom.UnMark;
begin
  FMark := '';
end;

procedure TVisCom.UnSelect;
begin
  FSelected := False;
end;

{ TMap }

procedure TMap.Add(AVisCom: TVisCom);
begin
  Assert(CanAdd(AVisCom), ''); //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  FVisComs.Add(AVisCom);
end;

procedure TMap.Replace(AOldVisCom: TVisCom; ANewVisCom: TVisCom);
begin
  with FVisComs do begin
    Add(ANewVisCom);
    Exchange(IndexOf(AOldVisCom), IndexOf(ANewVisCom));
    Remove(AOldVisCom)
  end
end;

function TMap.GetBackgroundBitmap: TBitmap;
begin
  Result := FBackgroundBitmap;
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
  Result := Has(AVisCom);
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

constructor TMap.Create(AName: String; AOwner: TComponent;
              ABlankBitmap, ABackgroundBitmap: TBitmap;
              AFileName: String);
begin
  inherited Create(AOwner);
  FName := AName;
  FBlankBitmap := ABlankBitmap;
  FBackgroundBitmap := ABackgroundBitmap;
  FBackgroundFileName := AFileName;
  ShowBackground;
  FMultiSelect := True;
  FViscoms := TObjectList.Create(False);   // shared
  FMarked := TObjectList.Create(False);   // shared
  FSelected := TObjectList.Create(True); // owner
end;

constructor TMap.CreateEmpty(AName: String; AOwner: TComponent);
begin
  inherited Create(AOwner);
  FName := AName;
  FBlankBitmap := TBitmap.Create;
  FBackgroundBitmap := TBitmap.Create;
  FBackgroundFileName := '<unknown>';
  ShowBackground;
  FMultiSelect := True;
  FViscoms := TObjectList.Create(False); // shared
  FMarked := TObjectList.Create(False);  // shared
  FSelected := TObjectList.Create(True); // owner
end;

procedure TMap.Delete(AVisCom: TVisCom);
begin
  Assert(CanDelete(AVisCom), ''); //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  FSelected.Remove(AVisCom);
  FMarked.Remove(AVisCom);
  FVisComs.Remove(AVisCom);
end;

destructor TMap.Destroy;
begin
  // N.B.: Order is important
  FSelected.Free; // shares
  FMarked.Free;   // shares
  FVisComs.Free;  // owns
  FBlankBitmap.Free;
  FBackgroundBitmap.Free;
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
  Picture.Assign(FBackgroundBitmap);
  Repaint; // <<<<<<<<<<<<<<<<<<<<<<<<<< Necessary?
end;

procedure TMap.HideBackground;
begin
  Picture.Assign(FBlankBitmap);
  FBackgroundShown := False;
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

procedure TMap.SetBackgroundBitmap(ABackgroundBitmap: TBitmap);
begin
  FBackgroundBitmap.Free;
  FBackgroundBitmap := ABackgroundBitmap
end;

procedure TMap.SetBlankBitmap(ABlankBitmap: TBitmap);
begin
  FBlankBitmap.Free;
  FBlankBitmap := ABlankBitmap
end;

procedure TMap.SetBackgroundFileName(AString: String);
begin
  FBackgroundFileName := AString;
end;

function TMap.GetBackgroundFileName: String;
begin
  Result := FBackgroundFileName;
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
  Picture.Assign(FBackgroundBitmap);
  FBackgroundShown := True;
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

function TMap.GetMapName: String;
begin
  Result := FName
end;

procedure TMap.SetMapName(AName: String);
begin
  Assert(ValidMapName(AName),
    'TMap.SetName.Pre: ValidMapName(AName)');
  FName := AName
end;

end.
 