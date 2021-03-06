unit MetroVisCom;
//# BEGIN TODO  Completed by: author name, id.nr., date
  { Etienne van Delden,  0618959, 09-05-2008}
//# END TODO

interface

uses
  Classes, Contnrs, Graphics, IniFiles,
  Planner, VisCom, StringValidators;

type
  TVisLine = class; // forward

  //============================================================================
  // TVisStation is an abstract base class for visualization of stations.
  // It has:
  // - X, Y coordinates
  //============================================================================
  TVisStation =
  class(TVisCom)
  protected
    FX: Integer;
    FY: Integer;
  public
    // construction/destruction-------------------------------------------------
    constructor Create(ACode: String; AData: TObject; AX, AY: Integer);
    // pre: True
    // post: inherited Create.post

    // primitive queries--------------------------------------------------------
    function X: Integer;
    // pre: True
    // ret: FX
    function Y: Integer;
    // pre: True
    // ret: FY

    // commands-----------------------------------------------------------------
    procedure Relocate(AX, AY: Integer);
    // pre: True
    // post: FX = AX and FY = AY

    // invariants --------------------------------------------------------------
    // I0: ValidStationCode(ACode)
  end;



  //============================================================================
  // TVisStationStop visualizes a normal stop on a line. 
  //============================================================================
  TVisStationStop =
  class(TVisStation)
  public
    // construction/destruction-------------------------------------------------
    constructor Create(ACode: String; AData: TObject; AX, AY: Integer);
    // pre: True
    // post: inherited Create.post

    // primitive queries--------------------------------------------------------
    function CanSelect: Boolean; override;
    // pre: True
    // ret: True
    function CanMark(AMark: String): Boolean; override;
    // pre: True
    // ret: AMark in {'mkStart', 'mkVia', 'mkFinish'}
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; override;
    // pre: True
    // ret: "the image of this object drawn on map AMap contains point (AX, AY)"

    // commands ----------------------------------------------------------------
    procedure Draw(AMap: TMap); override;
    // pre: True
    // effect: draws a stop on AMap
  end;



  //============================================================================
  // TVisStationTransfer visualizes a transfer station.
  //============================================================================
  TVisStationTransfer =
  class(TVisStation)
    // construction/destruction-------------------------------------------------
    constructor Create(ACode: String; AData: TObject; AX, AY: Integer);
    // pre: True
    // post: inherited Create.post

    // primitive queries--------------------------------------------------------
    function CanSelect: Boolean; override;
    // pre: True
    // ret: True
    function CanMark(AMark: String): Boolean; override;
    // pre: True
    // ret: AMark in {mkStart, mkVia, mkFinish}
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; override;
    // pre: True
    // ret: "the image of this object drawn on map AMap contains point (AX, AY)"

    // commands ----------------------------------------------------------------
    procedure Draw(AMap: TMap); override;
    // pre: True
    // effect: draws a transfer station on AMap
  end;



  //============================================================================
  // TVisStationDummy is not really a visualisation of a station. It only serves
  // to force a line to pass through a particular position on the map.
  //============================================================================
  TVisStationDummy =
  class(TVisStation)
    // construction/destruction-------------------------------------------------
    constructor Create(ACode: String; AX, AY: Integer);
    // pre: True
    // post: inherited Create.post

    // primitive queries--------------------------------------------------------
    function CanSelect: Boolean; override;
    // pre: True
    // ret: True
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; override;
    // pre: True
    // ret: "the image of this object drawn on map AMap contains point (AX, AY)"

    // commands ----------------------------------------------------------------
    procedure Draw(AMap: TMap); override;
    // pre: True
    // effect: draws a station dummy on AMap
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
    FList: TObjectList; // shared references to TVisStations
  public
    // construction/destruction-------------------------------------------------
    constructor Create(ACode: String; AData: TObject; AColor: TColor);
    // pre: True
    // post: inherited Create.post and Abstr = [] and GetColor = AColor
    destructor Destroy; override;
    // pre: True
    // effect: FList is freed

    // primitive queries--------------------------------------------------------
    function CanSelect: Boolean; override;
    // pre: True
    // ret: True
    function CanMark(AMark: String): Boolean; override;
    // pre: True
    // ret: (AMark = 'mkLine')
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; override;
    // pre: True
    // ret: "the image of this object drawn on map AMap contains point (AX, AY)"
    function GetColor: TColor;
    // pre: True
    // ret: FColor
    function StationCount: Integer;
    // pre: True
    // ret: |Abstr|
    function GetIndexOfStation(AStation: TVisStation): Integer;
    // pre: True
    // ret: I, such that GetStation(I) = AStation
    function GetStation(I: Integer): TVisStation;
    // pre: 0 <= I < StationCount
    // ret: Abstr[I]
    function HasStation(AStation: TVisStation): Boolean;
    // pre: True
    // ret: AStation in Abstr

    // commands ----------------------------------------------------------------
    procedure AddStation(AStation: TVisStation);
    // pre: not(HasStation(AStation))
    // post: Abstr = old Abstr ++ [AStation]
    procedure DeleteStation(AStation: TVisStation);
    // pre: HasStation(AStation)
    // post: Abstr = old Abstr - [AStation]
    procedure InsertStation(AIndex: Integer; AStation: TVisStation);
    // pre: True
    // post: let X1 = old Abstr[0..AIndex)
    //           X2 = old Abstr[AIndex..Count)
    //       in Abstr = X1 ++ [AStation] ++ X2
    procedure ReplaceStation(AOldStation: TVisStation; ANewStation: TVisStation);
    // pre: True
    // post: let old Abstr[I] = AOldStation
    //       in let X1 = old Abstr[0..I)
    //              X2 = old Abstr(I..Count)
    //          in Abstr = X1 ++ [ANewStation] ++ X2
    procedure SetColor(AColor: TColor);
    // pre: True
    // post: FColor = AColor
    procedure Draw(AMap: TMap); override;
    // pre: True
    // effect: The line is drawn on AMap
    procedure DrawFromTo(AMap: TMap; AFrom, ATo: TVisStation);
    // pre: True
    // effect: The linesegment from AFrom to ATo is drawn on AMap

    // model variables ---------------------------------------------------------
    // Abstr: seq of TVisStation

    // invariants --------------------------------------------------------------
    // I0: ValidLineCode(GetCode)
    //
    // A0: Abstr = (seq I: 0 <= I < StationCount: GetStation(I))
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
    FBitmapFileName: String;
  public
    // construction/destruction-------------------------------------------------
    constructor Create(ACode: String; AData: TObject; AX, AY: Integer;
                  ABitmap: TBitmap; ABitmapFileName: String);
    // pre: True
    // post: inherited Create.post and FX = AX and FY = AY and
    //       FBitmap = ABitmap and FBitmapFileName = ABitmapFileName
    destructor Destroy; override;
    // pre: True
    // effect: FBitmap is freed

    // primitive queries -------------------------------------------------------
    function CanSelect: Boolean; override;
    // pre: True
    // ret: True
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; override;
    // pre: True
    // ret: "the image of this object drawn on map AMap contains point (AX, AY)"
    function X: Integer;
    // pre: True
    // ret: FX
    function Y: Integer;
    // pre: True
    // ret: FY
    function GetBitmap: TBitmap;
    // pre: True
    // ret: FBitmap
    function GetBitmapFileName: String;
    // pre: True
    // ret: FBitmapFileName

    // commands ----------------------------------------------------------------
    procedure Draw(AMap: TMap); override;
    // pre: True
    // effect: draws the bitmap on AMap
    procedure SetBitmap(ABitmap: TBitmap);
    // pre: FBitmap <> nil
    // post: FBitmap = ABitmap
    procedure SetBitmapFileName(AFileName: String);
    // pre: True
    // post: FBitmapFileName = AFileName
    procedure Relocate(AX, AY: Integer);
    // pre: True
    // post: FX = AX and FY = AY

    // invariants --------------------------------------------------------------
    // I0: ValidLandmarkCode(GetCode)
  end;

  //============================================================================
  // TVisFlag
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
    // pre: True
    // effect: inherited Create
    // post: FX = AX and FY = AY and FBitmap = ABitmap and FVisible = False

    // primitive queries -------------------------------------------------------
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; override;
    // pre: True
    // ret: False
    function X: Integer;
    // pre: True
    // ret: FX
    function Y: Integer;
    // pre: True
    // ret: FY
    function Visible: Boolean;
    // pre: True
    // ret: FVisible

    // commands ----------------------------------------------------------------
    procedure Draw(AMap: TMap); override;
    // effect: draws the bitmap on AMap
    procedure MoveTo(AX, AY: Integer);
    // pre: True
    // post: FX = AX and FY = AY
    procedure Show;
    // pre: True
    // post: FVisible = True
    procedure Hide;
    // pre: True
    // post: FVisible = False
  end;



  //============================================================================
  // TVisText visualizes text on the map.
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
    // pre: True
    // effect: inherited Create
    // post: FX = AX and FY = AY and FText = AText and FTextPos = ATextPos

    // primitive queries -------------------------------------------------------
    function CanSelect: Boolean; override;
    // pre: True
    // ret: True
    function Contains(AMap: TMap; AX, AY: Integer): Boolean; override;
    // pre: True
    // ret: "the image of this object drawn on map AMap contains point (AX, AY)"
    function X: Integer;
    // pre: True
    // ret: FX
    function Y: Integer;
    // pre: True
    // ret: FY
    function GetText: String;
    // pre: True
    // ret: FText
    function GetTextPos: TTextPos;
    // pre: True
    // ret: FTextPos

    // commands ----------------------------------------------------------------
    procedure Draw(AMap: TMap); override;
    // effect: draws Text on AMap;
    //         position of (X,Y) w.r.t. Text is determined by TextPos
    procedure SetText(AText: String);
    // pre: True
    // post: FText = AText
    procedure SetTextPos(ATextPos: TTextPos);
    // pre: True
    // post: FTextPos = ATextPos
    procedure Relocate(AX, AY: Integer);
    // pre: True
    // post: FX = AX and FY = AY

    // invariants --------------------------------------------------------------
    // I0: ValidTextCode(GetCode)
  end;




  //============================================================================
  // TMetroMap is a specialization of TMap.
  // It serves to visualize a metro network.
  //============================================================================
  TMetroMap =
  class(TMap)
  protected
    FStartFlag: TVisFlag;
    FStopFlag: TVisFlag;
    procedure SetStartFlag(AFlag: TVisFlag); virtual;
    // pre: True
    // post: FStartFlag = AFlag
    procedure SetStopFlag(AFlag: TVisFlag); virtual;
    // pre: True
    // post: FStopFlag = AFlag
  public
    // derived queries ---------------------------------------------------------
    function GetStation(ACode: String): TVisStation;
    // pre: True
    // ret: S in AbstrStations such that (S.GetCode = ACode),
    //      nil if such an S does not exist.
    function GetLine(ACode: String): TVisLine;
    // pre: True
    // ret: L in AbstrLines such that (L.GetCode = ACode),
    //      nil if such an L does not exist.
    function GetLandmark(ACode: String): TVisLandmark;
    // pre: True
    // ret: L in AbstrLandmarks such that (L.GetCode = ACode),
    //      nil if such an L does not exist.
    function GetText(ACode: String): TVisText;
    // pre: True
    // ret: T in AbstrTexts such that (T.GetCode = ACode),
    //      nil is such a T does not exist.
    function LandmarkContaining(AX, AY: Integer): TVisLandmark;
    // pre: True
    // ret: L in AbstrLandmarks containing (AX, AY), nil if there is
    //      no such L
    function LineContaining(AX, AY: Integer): TVisLine;
    // pre: True
    // ret: L in AbstrLines containing (AX, AY), nil if there is no such L
    function StationContaining(AX, AY: Integer): TVisStation;
    // pre: True
    // ret: S in AbstrStations containing (AX, AY), nil if there is no
    //      such S
    function TextContaining(AX, AY: Integer): TVisText;
    // pre: True
    // ret: T in AbstrTexts containing (AX, AY), nil if there is no such T

    // preconditions -----------------------------------------------------------
    function CanSetLandmarkCode(ALandmark: TVisLandmark; ACode: String): Boolean;
    // pre: True
    // ret: not(HasLandmark(ACode)) and ValidLandmarkCode(ACode) and
    //      HasLandmark(ALandmark.GetCode)
    function CanSetLineCode(ALine: TVisLine; ACode: String): Boolean;
    // pre: True
    // ret: not(HasLine(ACode)) and ValidLineCode(ACode) and
    //      HasLine(ALine.GetCode)
    function CanSetStationCode(AStation: TVisStation; ACode: String): Boolean;
    // pre: True
    // ret: not(HasStation(ACode)) and ValidStationCode(ACode) and
    //      HasStation(AStation.GetCode)
    function CanSetTextCode(AText: TVisText; ACode: String): Boolean;
    // pre: True
    // ret: not(HasText(ACode)) and ValidTextCode(ACode) and
    //      HasText(AText.GetCode)
    function HasStation(ACode: String): Boolean;
    // pre: True
    // ret: (exists S: S in AbstrStations: S.GetCode = ACode)
    function HasLine(ACode: String): Boolean;
    // pre: True
    // ret: (exists L: L in AbstrLines: L.GetCode = ACode)
    function HasLandmark(ACode: String): Boolean;
    // pre: True
    // ret: (exists L: L in AbstrLandmarks: L.GetCode = ACode)
    function HasText(ACode: String): Boolean;
    // pre: True
    // ret: (exists T: T in AbstrTexts: T.GetCode = ACode)

    // commands ----------------------------------------------------------------
    procedure SetBackground(ABitmap: TBitmap);
    // pre: True
    // post: FBackgroundBitmap = ABitmap
    //         and
    //       FBlankBitmap is a blank bitmap with the same size and
    //       height as FBackgroundBitmap
    procedure HideAll; override;
    // pre: True
    // effect: only the background picture is shown, if BackgroundShown
    //         only the blank background is shown, if not BackgroundShown
    procedure ShowAll; override;
    // pre: True
    // effect: Stations, Lines, Landmarks, Texts and Flags are drawn
    procedure MarkStartStation(AStationCode: String);
    // pre: True
    // effect: The S in AbstrStations with S.GetCode = AStationCode is
    //         marked with the startflag, if this S exists
    procedure MarkStopStation(AStationCode: String);
    // pre: True
    // effect: The S in AbstrStations with S.GetCode = AStationCode is
    //         marked with the stopflag, if this S exists
    procedure ClearFlags;
    // pre: True
    // post: not(FStartFlag.Visible or FStopFlag.Visible)
    procedure ClearSelectedLines;
    // pre: True
    // post: (forall L: L in AbstrLines: not(I.Selected))
    procedure DeleteStation(AStation: TVisStation);
    // pre: True
    // post: AbstrStations = old AbstrStations \ {AStation} and
    //       (forall L: L in AbstrLines: L.Abstr = old L.Abstr \ {AStation})
    procedure DeleteStationFromLine(AStation: TVisStation; ALine: TVisLine);
    // pre: AStation in ALine.Abstr
    // post: ALine.Abstr = old ALine.Abstr \ {AStation}
    procedure ReplaceStation(AOldStation: TVisStation; ANewStation: TVisStation);
    // pre: True
    // post: (forall L:
    //          L in AbstrLines and AOldStation in old L.Abstr:
    //           let old L.Abstr = X ++ [OldStation] ++ Y
    //           in L.Abstr = X ++ [ANewStation] ++ Y)
    //       and
    //       AbstrStations = (old AbstrStations \ {AOldStation}) U {ANewStation}
    procedure SetStationCode(AStation: TVisStation; ACode: String);
    // pre: CanSetStationCode(AStation, ACode)
    // post: AStation.GetCode = ACode
    procedure SetLandmarkCode(ALandmark: TVisLandmark; ACode: String);
    // pre: CanSetLandmarkCode(ALandmark, ACode)
    // post: ALandmark.GetCode = ACode
    procedure SetLineCode(ALine: TVisLine; ACode: String);
    // pre: CanSetLineCode(ALine, ACode)
    // post: ALine.GetCode = ACode
    procedure SetTextCode(AText: TVisText; ACode: String);
    // pre: CanSetTextCode(AText, ACode)
    // post: AText.GetCode = ACode
    procedure ShowFlags;
    // pre: True
    // effect: Flags are drawn on the map, provided their Visible property is
    //         True
    procedure ShowStations;
    // pre: True
    // post: The stop and transfer stations are drawn on the map
    procedure ShowStationDummies;
    // pre: True
    // post: The station dummies are drawn on the map
    procedure ShowLines;
    // pre: True
    // post: The lines are drawn on the map
    procedure ShowSelectedLines;
    // pre: True
    // post: The selected lines are drawn on the map
    procedure ShowLandmarks;
    // pre: True
    // post: The landmarks are drawn on the map
    procedure ShowTexts;
    // pre: True
    // post: The Texts are drawn on the map
    procedure ShowRoute(ARoute: TRouteR);
    // pre: True
    // post: The route ARoute is drawn on the map
    property  StartFlag: TVisFlag read FStartFlag write SetStartFlag;
    property  StopFlag: TVisFlag  read FStopFlag  write SetStopFlag;

    // model variables ---------------------------------------------------------
    // AbstrStations: set of TVisStation
    // AbstrLines: set of TVisLine
    // AbstrLandmarks: set of TVisLandmark
    // AbstrTexts: set of TVisText

    // invariants --------------------------------------------------------------
    // A0: AbstrStations =
    //   (set S: 0 <= S < VisComCount and GetVisCom(S) is TVisStation:
    //     GetVisCom(S) as TVisStation)
    // A1: AbstrLines =
    //   (set L: 0 <= L < VisComCount and GetVisCom(L) is TVisLine:
    //     GetVisCom(L) as TVisLine)
    // A2: AbstrLandmarks =
    //   (set L: 0 <= L < VisComCount and GetVisCom(L) is TVisLandmark:
    //     GetVisCom(L) as TVisLandmark)
    // A3: AbstrTexts =
    //   (set T: 0 <= T < VisComCount and GetVisCom(T) is TVisText:
    //     GetVisCom(T) as TVisText)
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

procedure TVisStation.Relocate(AX, AY: Integer);
begin
  FX := AX;
  FY := AY
end;

{ TVisStationStop }

function TVisStationStop.CanMark(AMark: String): Boolean;
begin
  Result := (AMark = 'mkStart') or (AMark = 'mkVia') or (AMark = 'mkFinish');
end;

function TVisStationStop.CanSelect: Boolean;
begin
  Result := True;
end;

function TVisStationStop.Contains(AMap: TMap; AX, AY: Integer): Boolean;
begin
// Hardcoded and sloppy <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Result := (X - 3 <= AX) and (AX <= X + 3) and (Y - 3 <= AY) and (AY <= Y + 3);
end;

constructor TVisStationStop.Create(ACode: String; AData: TObject;
              AX, AY: Integer);
begin
  inherited Create(ACode, AData, AX, AY);
end;

procedure TVisStationStop.Draw(AMap: TMap);
var
  VR: Integer;
begin
  VR := 4; //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< should not be hardcoded
  with AMap.Picture.Bitmap.Canvas do begin
    if IsSelected then begin
      Pen.Width := 2;
      Pen.Color := clRed;
      Brush.Color := clBlack;
      Ellipse(X - VR - 2, Y - VR - 2, X + VR + 2, Y + VR + 2)
    end;
    Pen.Width := 0;
    Pen.Color := clBlack;
    Brush.Color := clWhite;
    Ellipse(X - VR, Y - VR, X + VR, Y + VR)
  end
end;

{ TVisStationTransfer }

function TVisStationTransfer.CanMark(AMark: String): Boolean;
begin
  Result := (AMark = 'mkStart') or (AMark = 'mkVia') or (AMark = 'mkFinish');
end;

function TVisStationTransfer.CanSelect: Boolean;
begin
  Result := True;
end;

function TVisStationTransfer.Contains(AMap: TMap; AX, AY: Integer): Boolean;
begin
// Hardcoded and sloppy <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Result := (X - 6 <= AX) and (AX <= X + 6) and (Y - 6 <= AY) and (AY <= Y + 6);
end;

constructor TVisStationTransfer.Create(ACode: String; AData: TObject; AX,
  AY: Integer);
begin
  inherited Create(ACode, AData, AX, AY);
end;

procedure TVisStationTransfer.Draw(AMap: TMap);
var
  VR: Integer;
begin
  VR := 6; //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< should not be hardcoded
  with AMap.Picture.Bitmap.Canvas do begin
    if IsSelected then begin
      Pen.Width := 2;
      Pen.Color := clRed;
      Brush.Color := clBlack;
      Ellipse(X - VR - 2, Y - VR - 2, X + VR + 2, Y + VR + 2)
    end;  
    Pen.Width := 1;
    Pen.Color := clBlack;
    Brush.Color := clWhite;
    Ellipse(X - VR, Y - VR, X + VR, Y + VR);
  end;
end;

{ TVisStationDummy }

function TVisStationDummy.CanSelect;
begin
  Result := True
end;

function TVisStationDummy.Contains(AMap: TMap; AX, AY: Integer): Boolean;
begin
// Hardcoded and sloppy <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Result := (X - 3 <= AX) and (AX <= X + 3) and (Y - 3 <= AY) and (AY <= Y + 3);
end;

constructor TVisStationDummy.Create(ACode: String; AX, AY: Integer);
begin
  inherited Create(ACode, nil, AX, AY);
end;

procedure TVisStationDummy.Draw(AMap: TMap);
var
  VR: Integer;
begin
  VR := 2; //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< should not be hardcoded
  with AMap.Picture.Bitmap.Canvas do begin
    if IsSelected then begin
      Pen.Width := 2;
      Pen.Color := clRed;
      Brush.Color := clBlack;
      Ellipse(X - VR - 2, Y - VR - 2, X + VR + 2, Y + VR + 2);
    end;
    Pen.Width := 0;
    Pen.Color := clBlack;
    Brush.Color := clBlack;
    Ellipse(X - VR, Y - VR, X + VR, Y + VR)
  end
end;

{ TVisLine }

procedure TVisLine.AddStation(AStation: TVisStation);
begin
  Assert(not(HasStation(AStation)),
    'TVisLine.AddStation.Pre: not(HasStation(AStation))');
  FList.Add(AStation)
end;

function TVisLine.CanMark(AMark: String): Boolean;
begin
  Result := AMark = 'mkLine';
end;

function TVisLine.CanSelect: Boolean;
begin
  Result := True;
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
    if (Min(X1,X2) - 2 <= AX) and (AX <= Max(X1,X2) + 2) and
       (Min(Y1,Y2) - 2 <= AY) and (AY <= Max(Y1,Y2) + 2)
    then
      begin
        // compute distance D from (AX,AY) to straight line through the two
        // stations:
        VA := (Y2 - Y1);
        VB := (X1 - X2);
        VC := Y1 * (X2 - X1) - X1 * (Y2 - Y1);
        D := (VA*AX + VB*AY + VC) / Sqrt(Sqr(VA) + Sqr(VB));
        Result := (-3 <= D) and (D <= 3); // "close enough"
      end
    else
      Result := False;
  end;
var
  I: Integer;
begin
  Result := False;
  if StationCount > 1 then
    for I := 1 to StationCount - 1 do
      if OnSegment(AX, AY, GetStation(I-1), GetStation(I))
      then
        begin
          Result := True;
          Exit
        end;
end;

constructor TVisLine.Create(ACode: String; AData: TObject; AColor: TColor);
begin
  inherited Create(ACode, AData);
  FColor := AColor;
  FList := TObjectlist.Create(False);
end;

procedure TVisLine.DeleteStation(AStation: TVisStation);
begin
  FList.Remove(AStation);
end;

procedure TVisLine.ReplaceStation(AOldStation: TVisStation; ANewStation: TVisStation);
begin
  with FList do begin
    Add(ANewStation);
    Exchange(IndexOf(AOldStation), IndexOf(ANewStation));
    Remove(AOldStation)
  end
end;

destructor TVisLine.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TVisLine.SetColor(AColor: TColor);
begin
  FColor := AColor
end;

procedure TVisLine.Draw(AMap: TMap);
//# BEGIN TODO

var I: Integer;

//# END TODO
begin
//# BEGIN TODO
// Replace these lines with code which draws the metro line on the canvas
//   AMap.Picture.Bitmap.Canvas
    // pre: True
    // effect: The line is drawn on AMap

if (StationCount > 0) then
begin
  with AMap.Picture.Bitmap.Canvas do
  begin
    Pen.Color := GetColor;
    Pen.Width := 5;
    MoveTo(GetStation(0).X, GetStation(0).Y );

    for I := 1 to StationCount - 1 do
      begin
        LineTo(GetStation(I).X, GetStation(I).Y);
      end;
  end;
end;

//# END TODO
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

function TVisLine.HasStation(AStation: TVisStation): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to StationCount - 1 do begin
    if GetStation(I) = AStation then begin
      Result := True
    end
  end
end;

function TVisLine.StationCount: Integer;
begin
  Result := FList.Count;
end;

function TVisLine.GetIndexOfStation(AStation: TVisStation): Integer;
begin
  Result := FList.IndexOf(AStation)  
end;

procedure TVisLine.InsertStation(AIndex: Integer; AStation: TVisStation);
begin
  FList.Insert(AIndex, AStation)
end;

{ TVisLandmark }

function TVisLandmark.CanSelect: Boolean;
begin
  Result := True
end;

function TVisLandmark.Contains(AMap: TMap; AX, AY: Integer): Boolean;
begin
  Result := (X <= AX) and (AX <= X + FBitmap.Width) and
            (Y <= AY) and (AY <= Y + FBitmap.Height);
end;

constructor TVisLandmark.Create(ACode: String; AData: TObject; AX,
  AY: Integer; ABitmap: TBitmap; ABitmapFileName: String);
begin
  inherited Create(ACode, Adata);
  FX := AX;
  FY := AY;
  FBitmap := ABitmap;
  FBitmapFileName := ABitmapFileName
end;

procedure TVisLandmark.Draw(AMap: TMap);
begin
//# BEGIN TODO
// Replace these lines which draw the bitmap FBitmap at position (FX,FY) on
// the canvas AMap.Picture.Bitmap.Canvas
    // pre: True
    // effect: draws the bitmap on AMap

    AMap.Picture.Bitmap.Canvas.Draw( FX, FY, FBitmap );

//# END TODO
end;

procedure TVisLandmark.SetBitmap(ABitmap: TBitmap);
begin
  FBitmap.Free;
  FBitmap := ABitmap
end;

procedure TVisLandmark.SetBitmapFileName(AFileName: String);
begin
  FBitmapFileName := AFileName;
end;

procedure TVisLandmark.Relocate(AX, AY: Integer);
begin
  FX := AX;
  FY := AY
end;

function TVisLandmark.X: Integer;
begin
  Result := FX;
end;

function TVisLandmark.Y: Integer;
begin
  Result := FY;
end;

function TVisLandmark.GetBitmap: TBitmap;
begin
  Result := FBitmap
end;

function TVisLandmark.GetBitmapFileName: String;
begin
  Result := FBitmapFileName
end;

destructor TVisLandmark.Destroy;
begin
  FBitmap.Free
end;

{ TVisText }

function TVisText.CanSelect: Boolean;
begin
  Result := True
end;

function TVisText.Contains(AMap: TMap; AX, AY: Integer): Boolean;
var
  H, W: Integer;
  VLeft, VTop: Integer;
begin
  // Eliminating superfluous warnings
  Vleft := 0;
  VTop  := 0;

  with AMap.Picture.Bitmap.Canvas do
  begin
    H := TextHeight(GetText);
    W := TextWidth(GetText);
    case GetTextPos of
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
//# BEGIN TODO
//    Replace this line with your own declarations

    // effect: draws Text on AMap;
    //         position of (X,Y) w.r.t. Text is determined by TextPos

 var
  iHeight, iWidth: Integer;
  VLeft, VTop: Integer;

 //# END TODO
begin
//# BEGIN TODO
// Replace these lines with code which displays a text on a yellow background
// on the canvas AMap.Picture.Bitmap.Canvas .
//
// - The text to be displayed is given by function GetText.
// - The coordinates of the reference point are given by functions X and Y .
// - The relative position of the reference point w.r.t. the text is given by
//   function GettextPos .
//   E.g., when GettextPos returns the value tpSouthEast, the text rectangle
//   should be positioned in such a way that its lower right corner coincides
//   with the reference point * :
//
//      MyText
//            *
//



 with AMap.Picture.Bitmap.Canvas do
 begin
   iHeight := TextHeight( GetText );
   iWidth  := TextWidth( GetText );

   case GetTextPos of
    tpNorth:
      begin
        VLeft := X - (iWidth div 2);
        VTop  := Y + 3;
      end;
    tpNorthEast:
      begin
        VLeft := X - iWidth - 3;
        VTop  := Y + 3;
      end;
    tpEast:
      begin
        VLeft := X - iWidth - 3;
        VTop  := Y - (iHeight div 2);
      end;
    tpSouthEast:
      begin
        VLeft := X - iWidth - 3;
        VTop  := Y - iHeight - 3;
      end;
    tpSouth:
      begin
        VLeft := X - ( iWidth div 2 );
        VTop  := Y -  iHeight - 3;
      end;
    tpSouthWest:
      begin
        VLeft := X + 3;
        VTop  := Y - iHeight - 3;
      end;
    tpWest:
      begin
        VLeft := X + 3;
        VTop  := Y - ( iHeight div 2);
      end;
    tpNorthWest:
      begin
        VLeft := X + 3;
        VTop  := Y + 3;
      end;
   end; // end case

   Brush.Color := clYellow;
   TextOut(VLeft, VTop, GetText);

 end; // end with

//# END TODO
end;

procedure TVisText.SetText(AText: String);
begin
  FText := AText
end;

procedure TVisText.SetTextPos(ATextPos: TTextPos);
begin
  FTextPos := ATextPos
end;

procedure TVisText.Relocate(AX, AY: Integer);
begin
  FX := AX;
  FY := AY
end;

function TVisText.GetText: String;
begin
  Result := FText;
end;

function TVisText.GetTextPos: TTextPos;
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

procedure TMetroMap.ReplaceStation(AOldStation: TVisStation; ANewStation: TVisStation);
var
  I: Integer;
begin
  for I := 0 to FVisComs.Count - 1 do begin
    if (GetVisCom(I) is TVisLine) then begin
      if TVisLine(GetVisCom(I)).HasStation(AOldStation) then begin
        TVisLine(GetVisCom(I)).ReplaceStation(AOldStation, ANewStation)
      end
    end
  end;
  Replace(AOldStation, ANewStation)
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

function TMetroMap.GetLandmark(ACode: String): TVisLandmark;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to VisComCount - 1 do
    if (GetVisCom(I) is TVisLandmark) and (GetVisCom(I).GetCode = ACode)
    then Result := GetVisCom(I) as TVisLandmark;
end;

function TMetroMap.GetText(ACode: String): TVisText;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to VisComCount - 1 do
    if (GetVisCom(I) is TVisText) and (GetVisCom(I).GetCode = ACode)
    then Result := GetVisCom(I) as TVisText;
end;

function TMetroMap.HasLine(ACode: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to VisComCount - 1 do
    if (GetVisCom(I) is TVisLine) and (GetVisCom(I).GetCode = ACode)
    then Result := True;
end;

function TMetroMap.HasStation(ACode: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to VisComCount - 1 do
    if (GetVisCom(I) is TVisStation) and (GetVisCom(I).GetCode = ACode)
    then Result := True;
end;

function TMetroMap.HasLandmark(ACode: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to VisComCount - 1 do
    if (GetVisCom(I) is TVisLandmark) and (GetVisCom(I).GetCode = ACode)
    then Result := True;
end;

function TMetroMap.HasText(ACode: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to VisComCount - 1 do
    if (GetVisCom(I) is TVisText) and (GetVisCom(I).GetCode = ACode)
    then Result := True;
end;

procedure TMetroMap.SetBackground(ABitmap: TBitmap);
var
  VBlankBitmap: TBitmap;
begin
  SetBackgroundBitmap(ABitmap);

  VBlankBitmap := TBitmap.Create;
  VBlankBitmap.Height := ABitmap.Height;
  VBlankBitmap.Width := ABitmap.Width;
  VBlankBitmap.Canvas.Pen.Color := clWhite;
  VBlankBitmap.Canvas.Brush.Color := clWhite;
  VBlankBitmap.Canvas.Rectangle(0, 0, ABitmap.Width, ABitmap.Height);
  SetBlankBitmap(VBlankBitmap)
end;

procedure TMetroMap.HideAll;
begin
  if BackgroundShown
  then Picture.Assign(FBackgroundBitmap)
  else Picture.Assign(FBlankBitmap);
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
  ShowTexts;
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
    if (GetVisCom(I) is TVisStationStop) or
    (GetVisCom(I) is TVisStationTransfer)
    then GetVisCom(I).Draw(Self);
end;

procedure TMetroMap.ShowStationDummies;
var
  I: Integer;
begin
  for I := 0 to VisComCount - 1 do
    if GetVisCom(I) is TVisStationDummy
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

function TMetroMap.LandmarkContaining(AX, AY: Integer): TVisLandmark;
var
  I: Integer;
  VVisCom: TVisCom;
begin
  Result := nil;
  for I := 0 to VisComCount - 1 do
  begin
    VVisCom := GetVisCom(I);
    if (VVisCom is TVisLandmark) and VVisCom.Contains(Self, AX, AY)
    then
      Result := VVisCom as TVisLandmark;
  end{for};
end;

function TMetroMap.LineContaining(AX, AY: Integer): TVisLine;
var
  I: Integer;
  VVisCom: TVisCom;
begin
  Result := nil;
  for I := 0 to VisComCount - 1 do
  begin
    VVisCom := GetVisCom(I);
    if (VVisCom is TVisLine) then begin
      if VVisCom.Contains(Self, AX, AY) then begin
        Result := VVisCom as TVisLine;
      end
    end
  end{for}
end;

function TMetroMap.StationContaining(AX, AY: Integer): TVisStation;
var
  I: Integer;
  VVisCom: TVisCom;
begin
  Result := nil;
  for I := 0 to VisComCount - 1 do
  begin
    VVisCom := GetVisCom(I);
    if (VVisCom is TVisStation) and VVisCom.Contains(Self, AX, AY)
    then
      Result := VVisCom as TVisStation;
  end{for};
end;

function TMetroMap.TextContaining(AX, AY: Integer): TVisText;
var
  I: Integer;
  VVisCom: TVisCom;
begin
  Result := nil;
  for I := 0 to VisComCount - 1 do
  begin
    VVisCom := GetVisCom(I);
    if (VVisCom is TVisText) and VVisCom.Contains(Self, AX, AY)
    then
      Result := VVisCom as TVisText;
  end{for};
end;

procedure TMetroMap.DeleteStation(AStation: TVisStation);
var
  I: Integer;
begin
  for I := 0 to FVisComs.Count - 1 do begin
    if (GetVisCom(I) is TVisLine) then begin
      if TVisLine(GetVisCom(I)).HasStation(AStation) then begin
        TVisLine(GetVisCom(I)).DeleteStation(AStation)
      end
    end
  end;
  Delete(AStation)
end;

procedure TMetroMap.DeleteStationFromLine(AStation: TVisStation;
  ALine: TVisLine);
begin
  Assert(ALine.HasStation(AStation),
    'TMetroMap.DeleteStationFromLine.Pre: ALine.HasStation(AStation)');
  ALine.DeleteStation(AStation)
end;

procedure TMetroMap.SetLandmarkCode(ALandmark: TVisLandmark;
  ACode: String);
begin
  Assert(CanSetLandmarkCode(ALandmark, ACode),
    'TMetroMap.SetLandmarkCode.Pre: CanSetLandmarkCode(ALandmark, ACode)');
  ALandmark.FCode := ACode
end;

procedure TMetroMap.SetLineCode(ALine: TVisLine; ACode: String);
begin
  Assert(CanSetLineCode(ALine, ACode),
    'TMetroMap.SetLineCode.Pre: CanSetLineCode(ALine, ACode)');
  ALine.FCode := ACode
end;

procedure TMetroMap.SetStationCode(AStation: TVisStation; ACode: String);
begin
  Assert(CanSetStationCode(AStation, ACode),
    'TMetroMap.SetStationCode.Pre: CanSetStationCode(AStation, ACode)');
  AStation.FCode := ACode
end;

procedure TMetroMap.SetTextCode(AText: TVisText; ACode: String);
begin
  Assert(CanSetTextCode(AText, ACode),
    'TMetroMap.SetTextCode.Pre: CanSetTextCode(AText, ACode)');
  AText.FCode := ACode
end;

function TMetroMap.CanSetLandmarkCode(ALandmark: TVisLandmark;
  ACode: String): Boolean;
begin
  Result := not(HasLandmark(ACode)) and ValidLandmarkCode(ACode) and
    HasLandmark(ALandmark.GetCode)
end;

function TMetroMap.CanSetLineCode(ALine: TVisLine; ACode: String): Boolean;
begin
  Result := not(HasLine(ACode)) and ValidLineCode(ACode) and
    HasLine(ALine.GetCode)
end;

function TMetroMap.CanSetStationCode(AStation: TVisStation;
  ACode: String): Boolean;
begin
  Result := not(HasStation(ACode)) and ValidStationCode(ACode) and
    HasStation(AStation.GetCode)
end;

function TMetroMap.CanSetTextCode(AText: TVisText; ACode: String): Boolean;
begin
  Result := not(HasText(ACode)) and ValidTextCode(ACode) and
    HasText(AText.GetCode)
end;

{ TVisFlag }

function TVisFlag.Contains(AMap: TMap; AX, AY: Integer): Boolean;
begin
  Result := False;
end;

constructor TVisFlag.Create(ACode: String; AData: TObject; AX, AY: Integer;
              ABitmap: TBitmap);
begin
  inherited Create(ACode, AData);
  FX := AX;
  FY := AY;
  FVisible := False;
  FBitmap := ABitmap;
end;

procedure TVisFlag.Draw(AMap: TMap);
begin
  AMap.Picture.Bitmap.Canvas.Draw(FX - 24, FY - 32, FBitmap);
end;

procedure TVisFlag.Hide;
begin
  FVisible := False;
end;

procedure TVisFlag.MoveTo(AX, AY: Integer);
begin
  FX := AX;
  FY := AY;
end;

procedure TVisFlag.Show;
begin
  FVisible := True;
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
