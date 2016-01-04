unit MetroVisCom;

interface

uses
  Classes, Contnrs, Graphics, IniFiles,
  Planner, VisCom;

type

  TVisLine = class; // forward



  //============================================================================
  // TVisStation is an abstract base class for visualization of stations.
  // It has:
  // - X, Y coordinates
  // - more ???
  //============================================================================
  TVisStation =
  class(TVisCom)
  protected
    FX: Integer;
    FY: Integer;
  public
    // construction/destruction-------------------------------------------------
    constructor Create(ACode: String; AData: TObject; AX, AY: Integer);

    // primitive queries--------------------------------------------------------
    function X: Integer;
    function Y: Integer;
  end;



  //============================================================================
  // TVisStationStop visualizes a normal stop on a line. It has:
  // - a reference to the line on which it occurs.
  //============================================================================
  TVisStationStop =
  class(TVisStation)
  protected
    FLine: TVisLine; // shared
  public
    // construction/destruction-------------------------------------------------
    constructor Create(ACode: String; AData: TObject; AX, AY: Integer);

    // primitive queries
    function CanSelect: Boolean; override;
    // pre: true
    // ret: true
    function CanMark(AMark:String): Boolean; override;
    // pre: true
    // ret: AMark in {'mkStart', 'mkVia', 'mkFinish'}
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; override;
    // pre: true
    // ret: "the image of this object drawn on map AMap contains point (AX, AY)"

    // commands ----------------------------------------------------------------
    procedure SetLine(ALine: TVisLine);
    // pre: true
    // effect: FLine = ALine
    procedure Draw(AMap: TMap); override;
    // effect: draws a stop in a style that depends on the line
  end;



  //============================================================================
  // TVisStationTransfer visualizes a transfer station.
  //============================================================================
  TVisStationTransfer =
  class(TVisStation)
    // primitive queries
    function CanSelect: Boolean; override;
    // pre: true
    // ret: true
    function CanMark(AMark:String): Boolean; override;
    // pre: true
    // ret: AMark in {mkStart, mkVia, mkFinish}
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; override;
    // pre: true
    // ret: "the image of this object drawn on map AMap contains point (AX, AY)"

    // commands ----------------------------------------------------------------
    procedure Draw(AMap: TMap); override;
    // effect: draws a transfer station on the map
  end;



  //============================================================================
  // TVisStationDummy is not really a visualisation of a station. It only serves
  // to force a line to pass through a particular position on the map.
  //============================================================================
  TVisStationDummy =
  class(TVisStation)
    // construction/destruction
    constructor Create(AX, AY: Integer);

    // primitive queries
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; override;
    // pre: true
    // ret: false

    // commands ----------------------------------------------------------------
    procedure Draw(AMap: TMap); override;
    // effect: skip
  end;



  //============================================================================
  // TVisLine visualizes a metro line. It has:
  // - a list of TVisStations
  // - a color
  //============================================================================
  TVisLine =
  class(TVisCom)
  protected
    FColor: TColor;
    FList: TObjectList; // shared references to VisStations
  public
    // construction/destruction
    constructor Create(ACode: String; AData: TObject; AColor: TColor);
    // effect: inherited Create;
    // post: AbstrStationList = [], GetColor = AColor
    destructor Destroy; override;

    // primitive queries
    function CanSelect: Boolean; override;
    // pre: true
    // ret: true
    function CanMark(AMark: String): Boolean; override;
    // pre: true
    // ret: (AMark = 'mkLine')
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; override;
    // pre: true
    // ret: "the image of this object drawn on map AMap contains point (AX, AY)"
    function GetColor: TColor;
    function StationCount: Integer;
    // pre: true
    // ret: |AbstrStationList|
    function GetStation(I: Integer): TVisStation;
    // pre: 0 <= I < StationCount
    // ret: AbstrStationList[I]

    // commands ----------------------------------------------------------------
    procedure Add(AStation: TVisStation);
    // pre: true
    // post: AbstrStationlist = old AbstrStationList ++ [AStation]
    // if AStation is TVisStationStop, then set its line to self
    procedure Delete(AStation: TVisStation);
    procedure Draw(AMap: TMap); override;
    procedure DrawFromTo(AMap: TMap; AFrom, ATo: TVisStation);

    // model variables ---------------------------------------------------------
    // AbstrStationList: seq of TVisStation
  end;



  //============================================================================
  // TVisLandmark
  //============================================================================

  TVisLandmark =
  class(TVisCom)
  protected
    FX: Integer;
    FY: Integer;
    FBitmap: TBitmap;
  public
    // construction/destruction-------------------------------------------------
    constructor Create(ACode: String; AData: TObject; AX, AY: Integer;
                  ABitmap: TBitmap);

    // primitive queries -------------------------------------------------------
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; override;
    // pre: true
    // ret: "the image of this object drawn on map AMap contains point (AX, AY)"
    function X: Integer;
    function Y: Integer;

    // commands ----------------------------------------------------------------
    procedure Draw(AMap: TMap); override;
    // effect: draws the bitmap on AMap
  end;

  //============================================================================
  // TVisLandmark
  //============================================================================

  TVisFlag =
  class(TVisCom)
  protected
    FX: Integer;
    FY: Integer;
    FVisible: Boolean;
    FBitmap: TBitmap;
  public
    // construction/destruction-------------------------------------------------
    constructor Create(ACode: String; AData: TObject; AX, AY: Integer;
                  ABitmap: TBitmap);

    // primitive queries -------------------------------------------------------
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; override;
    // pre: true
    // ret: false
    function X: Integer;
    function Y: Integer;
    function Visible: Boolean;

    // commands ----------------------------------------------------------------
    procedure Draw(AMap: TMap); override;
    // effect: draws the bitmap on AMap
    procedure MoveTo(AX, AY: Integer);
    procedure Show;
    procedure Hide;
  end;



  //============================================================================
  // TVisText visualizes a text on the map.
  // It has at least the following features:
  // - X, Y coordinates
  // - the text to be visualized
  // - a TextPos value indicating the relative positions of the (X,Y) point
  //   and the text
  //============================================================================

  TTextPos = (tpNorth, tpNorthEast, tpEast, tpSouthEast, tpSouth, tpSouthWest,
    tpWest, tpNorthWest);

  TVisText =
  class(TVisCom)
  protected
    FX: Integer;
    FY: Integer;
    FText: String;
    FTextPos: TTextPos;
  public
    // construction/destruction
    constructor Create(ACode: String; AData: TObject; AX, AY: Integer;
                  AText: String; ATextPos: TTextPos);
    // primitive queries -------------------------------------------------------
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; override;
    // pre: true
    // ret: "the image of this object drawn on map AMap contains point (AX, AY)"
    function X: Integer;
    function Y: Integer;
    function Text: String;
    function TextPos: TTextPos;

    // commands ----------------------------------------------------------------
    procedure Draw(AMap: TMap); override;
    // effect: draws Text on AMap;
    //         position of (X,Y) w.r.t. Text is determined by TextPos
  end;




  //============================================================================
  // TMetroMap is a specialization of TMap.
  // It serves to visualize a metro network.
  //
  //============================================================================
  TMetroMap =
  class(TMap)
  protected
    FStartFlag: TVisFlag;
    FStopFlag: TVisFlag;
    procedure SetStartFlag(AFlag: TVisFlag); virtual;
    procedure SetStopFlag(AFlag: TVisFlag); virtual;
  public
    // construction/destruction

    // primitive queries -------------------------------------------------------

    // derived queries ---------------------------------------------------------
    function GetStation(ACode: String): TVisStation;
    // pre: HasStation(ACode: String)
    // ret: S such that (S.GetCode = ACode) and (S is TVisStation)

    function GetLine(ACode: String): TVisLine;
    // pre: HasLine(ACode: String)
    // ret: S such that (S.GetCode = ACode) and (S is TVisLine)

    function StationContaining(AX, AY: Integer): String;
    // pre: true
    // ret: code of TVisstation containing (AX, AY), '' otherwise

    // preconditions -----------------------------------------------------------
    function HasStation(ACode: String): Boolean;
    // pre: true
    // ret: (exists I: 0 <= I < VisComCount:
    //        (GetVisCom(I).GetCode = ACode) and (GetVisCom(I) is TVisStation) )

    function HasLine(ACode: String): Boolean;
    // pre: true
    // ret: (exists I: 0 <= I < VisComCount:
    //        (GetVisCom(I).GetCode = ACode) and (GetVisCom(I) is TVisLine) )

    // commands ----------------------------------------------------------------
    procedure HideAll; override;
    procedure ShowAll; override;
    procedure MarkStartStation(AStationCode: String);
    procedure MarkStopStation(AStationCode: String);
    procedure ClearFlags;
    procedure ClearSelectedLines;
    procedure ShowFlags;
    procedure ShowStations;
    procedure ShowLines;
    procedure ShowSelectedLines;
    procedure ShowLandmarks;
    procedure ShowTexts;
    procedure ShowRoute(ARoute: TRouteR);
    property  StartFlag: TVisFlag read FStartFlag write SetStartFlag;
    property  StopFlag: TVisFlag  read FStopFlag  write SetStopFlag;

    // public invariants -------------------------------------------------------

  end;

implementation //===============================================================

uses Math, SysUtils;

{ TVisStation }

constructor TVisStation.Create(ACode: String; AData: TObject;
              AX, AY: Integer);
begin
  inherited Create(ACode, AData);
  FX := AX;
  FY := AY;
end;

function TVisStation.X: Integer;
begin
  Result := FX;
end;

function TVisStation.Y: Integer;
begin
  Result := FY;
end;





{ TVisStationStop }

function TVisStationStop.CanMark(AMark: String): Boolean;
begin
  Result := (AMark = 'mkStart') or (AMark = 'mkVia') or (AMark = 'mkFinish');
end;

function TVisStationStop.CanSelect: Boolean;
begin
  Result := true;
end;

function TVisStationStop.Contains(AMap: TMap; AX, AY: Integer): Boolean;
begin
// Hardcoded and sloppy <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Result := (X - 6 <= AX) and (AX <= X + 6) and (Y - 6 <= AY) and (AY <= Y + 6);
end;

constructor TVisStationStop.Create(ACode: String; AData: TObject;
              AX, AY: Integer);
begin
  inherited Create(ACode, AData, AX, AY);
  FLine := nil;
end;

procedure TVisStationStop.Draw(AMap: TMap);
var
  VR: Integer;
begin
  Assert(FLine <> nil,
    Format('TVisStationStop.Draw.pre: station code = %s', [FCode]));
  VR := 4; //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< should not be hardcoded
  with AMap.Picture.Bitmap.Canvas do
  begin
    Pen.Width := 0;
    Brush.Color := FLine.GetColor;
    Ellipse(X - VR, Y - VR, X + VR, Y + VR);
  end;
end;

procedure TVisStationStop.SetLine(ALine: TVisLine);
begin
  Fline := ALine;
end;

{ TVisStationTransfer }

function TVisStationTransfer.CanMark(AMark: String): Boolean;
begin
  Result := (AMark = 'mkStart') or (AMark = 'mkVia') or (AMark = 'mkFinish');
end;

function TVisStationTransfer.CanSelect: Boolean;
begin
  Result := true;
end;

function TVisStationTransfer.Contains(AMap: TMap; AX, AY: Integer): Boolean;
begin
// Hardcoded and sloppy <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Result := (X - 6 <= AX) and (AX <= X + 6) and (Y - 6 <= AY) and (AY <= Y + 6);
end;

procedure TVisStationTransfer.Draw(AMap: TMap);
var
  VR: Integer;
begin
  VR := 6; //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< should not be hardcoded
  with AMap.Picture.Bitmap.Canvas do
  begin
    Pen.Width := 1;
    Pen.Color := clBlack;
    Brush.Color := clWhite;
    Ellipse(X - VR, Y - VR, X + VR, Y + VR);
  end;
end;

{ TVisStationDummy }

function TVisStationDummy.Contains(AMap: TMap; AX, AY: Integer): Boolean;
begin
  Result := false;
end;

constructor TVisStationDummy.Create(AX, AY: Integer);
begin
  inherited Create('', nil, AX, AY);
end;

procedure TVisStationDummy.Draw(AMap: TMap);
begin
  {skip}
end;

{ TVisLine }

procedure TVisLine.Add(AStation: TVisStation);
begin
  FList.Add(AStation);
  if AStation is TVisStationStop
  then (AStation as TVisStationStop).SetLine(Self);
end;

function TVisLine.CanMark(AMark: String): Boolean;
begin
  Result := AMark = 'mkLine';
end;

function TVisLine.CanSelect: Boolean;
begin
  Result := true;
end;

function TVisLine.Contains(AMap: TMap; AX, AY: Integer): Boolean;
  function OnSegment(AX,AY: Integer; AStation1,AStation2: TVisStation): Boolean;
  var
    X1, Y1, X2, Y2: Integer;
    VA, VB, VC: Integer;
    D: Real;
  begin
    X1 := AStation1.X;
    Y1 := AStation1.Y;
    X2 := AStation2.X;
    Y2 := AStation2.Y;
    if (Min(X1,X2) <= AX) and (AX <= Max(X1,X2)) and
       (Min(Y1,Y2) <= AY) and (AY <= Max(Y1,Y2))
    then
      begin
        // compute distance D from (AX,AY) to straight line through the two
        // stations:
        VA := (Y2 - Y1);
        VB := (X1 - X2);
        VC := Y1 * (X2 - X1) - X1 * (Y2 - Y1);
        D := (VA*AX + VB*AY +VC)/ Sqrt(Sqr(VA)+Sqr(VB));
        Result := (-1 <= D) and (D <= 1); // "close enough"
      end
    else
      Result := false;
  end;
var
  I: Integer;
begin
  Result := false;
  if StationCount > 1 then
    for I := 1 to StationCount - 1 do
      if OnSegment(AX, AY, GetStation(I-1), GetStation(I))
      then
        begin
          Result := true;
          Exit
        end;
end;

constructor TVisLine.Create(ACode: String; AData: TObject; AColor: TColor);
begin
  inherited Create(ACode, AData);
  FColor := AColor;
  FList := TObjectlist.Create(false);
end;

procedure TVisLine.Delete(AStation: TVisStation);
begin
  FList.Remove(AStation);
end;

destructor TVisLine.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TVisLine.Draw(AMap: TMap);
var
  I: Integer;
begin
  if StationCount > 0 then
  begin
    with AMap.Picture.Bitmap.Canvas do
    begin
      Pen.Color := GetColor;
      Pen.Width := 5;
      MoveTo(GetStation(0).X, GetStation(0).Y);
      for I := 1 to StationCount - 1 do
        LineTo(GetStation(I).X, GetStation(I).Y);
    end;
  end;
end;

procedure TVisLine.DrawFromTo(AMap: TMap; AFrom, ATo: TVisStation);
var
  I, L, H, M: Integer;
begin
  L := FList.IndexOf(AFrom);
  H := FList.IndexOf(ATo);
  if H < L then
  begin {swap}
    M := L; L := H; H := M;
  end;
  with AMap.Picture.Bitmap.Canvas do
  begin
    Pen.Color := GetColor;
    Pen.Width := 5;
    MoveTo(GetStation(L).X, GetStation(L).Y);
    for I := L + 1 to H do
      LineTo(GetStation(I).X, GetStation(I).Y);
  end;
end;

function TVisLine.GetColor: TColor;
begin
  Result := FColor;
end;

function TVisLine.GetStation(I: Integer): TVisStation;
begin
  Assert((0 <= I) and (I < StationCount), ''); //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Result := FList.Items[I] as TVisStation;
end;

function TVisLine.StationCount: Integer;
begin
  Result := FList.Count;
end;

{ TVisLandmark }

function TVisLandmark.Contains(AMap: TMap; AX, AY: Integer): Boolean;
begin
  Result := (X <= AX) and (AX <= X + FBitmap.Width) and
            (Y <= AY) and (AY <= Y + FBitmap.Height);
end;

constructor TVisLandmark.Create(ACode: String; AData: TObject; AX,
  AY: Integer; ABitmap: TBitmap);
begin
  inherited Create(ACode, Adata);
  FX := AX;
  FY := AY;
  FBitmap := ABitmap;
end;

procedure TVisLandmark.Draw(AMap: TMap);
begin
  AMap.Picture.Bitmap.Canvas.Draw(FX, FY, FBitmap);
end;

function TVisLandmark.X: Integer;
begin
  Result := FX;
end;

function TVisLandmark.Y: Integer;
begin
  Result := FY;
end;


{ TVisText }

function TVisText.Contains(AMap: TMap; AX, AY: Integer): Boolean;
var
  H, W: Integer;
  VLeft, VTop: Integer;
begin
  with AMap.Picture.Bitmap.Canvas do
  begin
    H := TextHeight(Text);
    W := TextWidth(Text);
    case TextPos of
      tpNorth:
        begin
          VLeft := X - W div 2;
          VTop := Y + 3;
        end;
      tpNorthEast:
        begin
          VLeft := X - W - 3;
          VTop := Y + 3;
        end;
      tpEast:
        begin
          VLeft := X - W - 3;
          VTop := Y - H div 2;
        end;
      tpSouthEast:
        begin
          VLeft := X - W - 3;
          VTop := Y - H - 3;
        end;
      tpSouth:
        begin
          VLeft := X - W div 2;
          VTop := Y - H - 3;
        end;
      tpSouthWest:
        begin
          VLeft := X + 3;
          VTop := Y - H - 3;
        end;
      tpWest:
        begin
          VLeft := X + 3;
          VTop := Y - H div 2;
        end;
      tpNorthWest:
        begin
          VLeft := X + 3;
          VTop := Y + 3;
        end;
    end{case};
  end{with};

  Result := (VLeft <= AX) and (AX <= VLeft + W) and
            (VTop <= AY) and (AY <= VTop + H);
end;

constructor TVisText.Create(ACode: String; AData: TObject; AX, AY: Integer;
                            AText: String; ATextPos: TTextPos);
begin
  inherited Create(ACode, AData);
  FX := AX;
  FY := AY;
  FText := AText;
  FTextPos := ATextPos;
end;

procedure TVisText.Draw(AMap: TMap);
var
  H, W: Integer;
  VLeft, VTop: Integer;
begin
  with AMap.Picture.Bitmap.Canvas do
  begin
    H := TextHeight(Text);
    W := TextWidth(Text);
    case TextPos of
      tpNorth:
        begin
          VLeft := X - W div 2;
          VTop := Y + 3;
        end;
      tpNorthEast:
        begin
          VLeft := X - W - 3;
          VTop := Y + 3;
        end;
      tpEast:
        begin
          VLeft := X - W - 3;
          VTop := Y - H div 2;
        end;
      tpSouthEast:
        begin
          VLeft := X - W - 3;
          VTop := Y - H - 3;
        end;
      tpSouth:
        begin
          VLeft := X - W div 2;
          VTop := Y - H - 3;
        end;
      tpSouthWest:
        begin
          VLeft := X + 3;
          VTop := Y - H - 3;
        end;
      tpWest:
        begin
          VLeft := X + 3;
          VTop := Y - H div 2;
        end;
      tpNorthWest:
        begin
          VLeft := X + 3;
          VTop := Y + 3;
        end;
    end{case};
    Brush.Color := clYellow;
    TextOut(VLeft, VTop, Text);
  end{with}
end;

function TVisText.Text: String;
begin
  Result := FText;
end;

function TVisText.TextPos: TTextPos;
begin
  Result := FTextPos;
end;

function TVisText.X: Integer;
begin
  Result := FX;
end;

function TVisText.Y: Integer;
begin
  Result := FY;
end;


{ TMetroMap }

procedure TMetroMap.ClearFlags;
begin
  FStartFlag.Hide;
  FStopFlag.Hide;
end;

procedure TMetroMap.ClearSelectedLines;
var
  I: Integer;
  VVisCom: TVisCom;
begin
  for I := 0 to VisComCount - 1 do
  begin
    VVisCom := GetVisCom(I);
    if VVisCom is TVisLine
    then VVisCom.UnSelect;
  end;
end;

function TMetroMap.GetLine(ACode: String): TVisLine;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to VisComCount - 1 do
    if (GetVisCom(I) is TVisLine) and (GetVisCom(I).GetCode = ACode)
    then Result := GetVisCom(I) as TVisLine;
end;

function TMetroMap.GetStation(ACode: String): TVisStation;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to VisComCount - 1 do
    if (GetVisCom(I) is TVisStation) and (GetVisCom(I).GetCode = ACode)
    then Result := GetVisCom(I) as TVisStation;
end;

function TMetroMap.HasLine(ACode: String): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I := 0 to VisComCount - 1 do
    if (GetVisCom(I) is TVisLine) and (GetVisCom(I).GetCode = ACode)
    then Result := true;
end;

function TMetroMap.HasStation(ACode: String): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I := 0 to VisComCount - 1 do
    if (GetVisCom(I) is TVisStation) and (GetVisCom(I).GetCode = ACode)
    then Result := true;
end;

procedure TMetroMap.HideAll;
begin
  if BackgroundShown
  then Picture.Assign(FBackgroundPicture)
  else Picture.Assign(FBlankPicture);
end;

procedure TMetroMap.MarkStartStation(AStationCode: String);
var
  VStation: TVisStation;
begin
  VStation := GetStation(AStationCode);
  if VStation <> nil then
  begin
    FStartFlag.MoveTo(VStation.X, VStation.Y);
    FStartFlag.Show;
  end;
end;

procedure TMetroMap.MarkStopStation(AStationCode: String);
var
  VStation: TVisStation;
begin
  VStation := GetStation(AStationCode);
  if VStation <> nil then
  begin
    FStopFlag.MoveTo(VStation.X, VStation.Y);
    FStopFlag.Show;
  end;
end;

procedure TMetroMap.SetStartFlag(AFlag: TVisFlag);
begin
  FStartFlag := AFlag;
end;

procedure TMetroMap.SetStopFlag(AFlag: TVisFlag);
begin
  FStopFlag := AFlag;
end;

procedure TMetroMap.ShowAll;
begin
  // N.B.: order is important
  ShowLines;
  ShowStations;
  ShowLandmarks;
  ShowFlags;
end;

procedure TMetroMap.ShowFlags;
begin
  if FStartFlag.Visible then FStartFlag.Draw(Self);
  if FStopFlag.Visible then FStopFlag.Draw(Self);
end;

procedure TMetroMap.ShowLandmarks;
var
  I: Integer;
begin
  for I := 0 to VisComCount - 1 do
    if GetVisCom(I) is TVisLandmark
    then GetVisCom(I).Draw(Self);
end;

procedure TMetroMap.ShowLines;
var
  I: Integer;
begin
  for I := 0 to VisComCount - 1 do
    if GetVisCom(I) is TVisLine
    then GetVisCom(I).Draw(Self);
end;

procedure TMetroMap.ShowRoute(ARoute: TRouteR);
var
  I: Integer;
  VVisLine: TVisLine;
  VFromStation, VToStation: TVisStation;
begin
  with ARoute do
    for I := 0 to SegmentCount - 1 do
      with GetSegment(I) do
      begin
        VVisLine := GetLine(Line.GetCode);
        VFromStation := GetStation(FromStation.GetCode);
        VToStation := GetStation(ToStation.GetCode);
        VVisLine.DrawFromTo(Self, VFromStation, VToStation);
      end;
end;

procedure TMetroMap.ShowSelectedLines;
var
  I: Integer;
  VVisCom: TVisCom;
begin
  for I := 0 to VisComCount - 1 do
  begin
    VVisCom := GetVisCom(I);
    if (VVisCom is TVisLine) and (VVisCom.IsSelected)
    then VVisCom.Draw(Self);
  end;
end;

procedure TMetroMap.ShowStations;
var
  I: Integer;
begin
  for I := 0 to VisComCount - 1 do
    if GetVisCom(I) is TVisStation
    then GetVisCom(I).Draw(Self);
end;

procedure TMetroMap.ShowTexts;
var
  I: Integer;
begin
  for I := 0 to VisComCount - 1 do
    if GetVisCom(I) is TVisText
    then GetVisCom(I).Draw(Self);
end;


function TMetroMap.StationContaining(AX, AY: Integer): String;
var
  I: Integer;
  VVisCom: TVisCom;
begin
  Result := '';
  for I := 0 to VisComCount - 1 do
  begin
    VVisCom := GetVisCom(I);
    if (VVisCom is TVisStation) and VVisCom.CanSelect and
        VVisCom.Contains(Self, AX, AY)
    then
      Result := VVisCom.GetCode;
  end{for};
end;

{ TVisFlag }

function TVisFlag.Contains(AMap: TMap; AX, AY: Integer): Boolean;
begin
  Result := false;
end;

constructor TVisFlag.Create(ACode: String; AData: TObject; AX, AY: Integer;
              ABitmap: TBitmap);
begin
  inherited Create(ACode, AData);
  FX := AX;
  FY := AY;
  FVisible := false;
  FBitmap := ABitmap;
end;

procedure TVisFlag.Draw(AMap: TMap);
begin
  AMap.Picture.Bitmap.Canvas.Draw(FX - 24, FY - 32, FBitmap);
end;

procedure TVisFlag.Hide;
begin
  FVisible := false;
end;

procedure TVisFlag.MoveTo(AX, AY: Integer);
begin
  FX := AX;
  FY := AY;
end;

procedure TVisFlag.Show;
begin
  FVisible := true;
end;

function TVisFlag.Visible: Boolean;
begin
  Result := FVisible;
end;

function TVisFlag.X: Integer;
begin
  Result := FX;
end;

function TVisFlag.Y: Integer;
begin
  Result := FY;
end;

end.
