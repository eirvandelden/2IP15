unit MetroBase;

{ TODO :
Code of TNetwork.CreateFromFile}

interface

uses
  Contnrs, IniFiles;

//==============================================================================
// Station
// A station has:
// - a code: a short key that serves to identify the station uniquely within
//   the system, e.g. 'CDG'
// - a name: the name of the station as it appears on maps etc., e.g.
//   'Charles de Gaulle - Etoile'.
//
// The class TStationR is an abstract class providing read-only access to the
// data of a station.
// The class TStationRW is a descendant of TStationR; it provides a concrete
// representation and read/write access to the data of a station.
//==============================================================================

type
  TStationR =
  class(TObject)
  public
    // scratch data field for use by planners etc. -----------------------------
    Data: TObject;

    // primitive queries -------------------------------------------------------
    function GetCode: String; virtual; abstract;
    function GetName: String; virtual; abstract;

    // invariants --------------------------------------------------------------
    // I0: ValidStationCode(GetCode) and ValidStationName(GetName)
  end;



  TStationRW =
  class(TStationR)
  private
    FCode: String;
    FName: String;
  public
    // construction ------------------------------------------------------------
    constructor Create(ACode: String; AName: String);
    // pre: ValidStationCode(ACode) and ValidStationName(AName)
    // post: (GetCode = ACode) and (GetName = AName)

    // TStationR overrides =====================================================
    // primitive queries -------------------------------------------------------
    function GetCode: String; override;
    function GetName: String; override;

    // new methods =============================================================
    // commands ----------------------------------------------------------------
    procedure Rename(AName: String);
    // pre: ValidStationName(AName)
    // post: GetName = AName
  end;



//==============================================================================
// StationSet
//
// A stationset is a finite enumerable set of stations.
//
// The class TStationSetR is an abstract class providing read-only access to the
// data of a stationset.
// The class TStationSetRW is a descendant of TStationR; it provides a concrete
// representation and read/write access to a stationset.
//
//==============================================================================

  TStationSetR =
  class(TObject)
    // primitive queries -------------------------------------------------------
    function Count: Integer; virtual; abstract;
    // pre: true
    // ret: |Abstr|

    function GetStation(I: Integer): TStationR; virtual; abstract;
    // pre: 0 <= I < Count
    // ret: Abstr[I]

    // derived queries ---------------------------------------------------------
    function IsEmpty: Boolean;
    // pre: true
    // ret: Count = 0

    function HasStation(AStation: TStationR): Boolean;
    // pre: true
    // ret: (exists I: 0 <= I < Count: GetStation(I) = AStation)

    function HasCode(ACode: String): Boolean;
    // pre: true
    // ret: IndexOfCode(ACode) <> -1

    function HasName(AName: String): Boolean;
    // pre: true
    // ret: IndexOfName(AName) <> -1

    function IndexOfCode(ACode: String): Integer;
    // pre: true
    // ret: I such that GetStation(I).GetCode = ACode, or else -1

    function IndexOfName(AName: String): Integer;
    // pre: true
    // ret: I such that GetStation(I).GetName = AName, or else -1


    // model variables ---------------------------------------------------------
    // Abstr: set of TStationRW

    // invariants --------------------------------------------------------------
    // Unique:
    //   (forall I,J: 0<=I<J<Count:
    //      - GetStation(I) <> GetStation(J)
    //      - GetStation(I).GetCode <> GetStation(J).GetCode
    //      - GetStation(I).GetName <> GetStation(J).GetName
    //   )
  end;


  TStationSetRW =
  class(TStationSetR)
  protected
    // fields ------------------------------------------------------------------
    FList: TObjectList;

    // invariants --------------------------------------------------------------
    // Abstr = {FList[I] as TStationR| 0<=I<FList.Count}
  public
    // construction/destruction ------------------------------------------------
    constructor Create;
    // pre: true
    // post: Abstr = {}

    destructor Destroy; override;

    // TStationSetR overrides ==================================================

    // primitive queries -------------------------------------
    function Count: Integer; override;
    // pre: true
    // ret: |Abstr|

    function GetStation(I: Integer): TStationR; override;
    // pre: 0 <= I < Count
    // ret: Abstr[I]

    // new methods =============================================================

    // preconditions for commands ----------------------------------------------
    function CanAddStation(ACode: String; AName: String): Boolean; virtual;
    // pre: true
    // ret: ValidStationCode(ACode), ValidStationName(AName),
    //   not HasCode(ACode), not HasName(AName)

    function CanDeleteStation(AStation: TStationR): Boolean; virtual;
    // pre: true
    // ret: true (may be overridden in subclasses)

    function CanDeleteAll: Boolean; virtual;
    // pre: true
    // ret: true (may be overridden in subclasses)

    // commands ----------------------------------------------------------------
    procedure AddStation(ACode: String; AName: String);
    // pre: CanAddStation(ACode, AName)
    // post: Abstr = old Abstr U {(ACode, AName)}  (abuse of notation)

    procedure DeleteStation(AStation: TStationR);
    // pre: CanDeleteStation(AStation)
    // post: Abstr = old Abstr - {(ACode, AName)}  (abuse of notation)

    procedure DeleteAll;
    // pre: CanDeleteAll
    // post: Abstr = {}
  end;


//==============================================================================
// Line
//
// A line has:
// - a code: a short key that serves to identify the line uniquely within
//   the system, e.g. 'ERM'.
// - a name: the name of the line as it appears on maps etc., e.g.
//   'Erasmuslijn' or '7bis'.
// - a sequence of stops; each stop is a station.
// - a set of options, e.g.: oneway, circular.
//
// The class TLineR is an abstract class providing read-only access to the
// data of a line.
// The class TLineRW is a descendant of TLineR; it provides a concrete
// representation and read/write access to the data of a line.
//==============================================================================

type
  TLineOption = (loOneWay, loCircular);
  TLineOptions = set of TLineOption;


  TLineR =
  class(TObject)
  public
    // scratch data field, used by planners etc. -------------------------------
    Data: TObject;

    // primitive queries -------------------------------------------------------
    function GetCode: String; virtual; abstract;
    function GetName: String; virtual; abstract;
    function GetOptions: TLineOptions; virtual; abstract;
    function Count: Integer; virtual; abstract;
    // ret: |Abstr|
    function IndexOf(AStation: TStationR): Integer; virtual; abstract;
    // pre: true
    // ret: I such that Abstr[I] = AStation, or else -1
    function Stop(I: Integer): TStationR; virtual; abstract;
    // pre: 0 <= I < Count
    // ret: Abstr[I]

    // derived queries ---------------------------------------------------------
    function TerminalA: TStationR;
    // pre: Count > 0
    // ret: Stop(0)
    function TerminalB: TStationR;
    // pre: Count > 0
    // ret: Stop(Count-1)
    function IsOneWay: Boolean;
    // pre: true
    // ret: loOneWay in GetOptions
    function IsCircular: Boolean;
    // pre: true
    // ret: loCircular in GetOptions
    function HasStop(AStation: TStationR): Boolean;
    // pre: true
    // ret: (exists I: 0 <= I < Count: Stop(I) = AStation )

    // model variables ---------------------------------------------------------
    // Abstr: row of TStationR

    // invariants --------------------------------------------------------------
    // I0: ValidLineCode(GetCode) and ValidLineName(GetName)
    // Stops_Unique:
    //   (forall I,J: 0<=I<J<Count: Stop(I) <> Stop(J))
  end;



  TLineRW =
  class(TLineR)
  protected
    FCode: String;
    FName: String;
    FOptions: TLineOptions;
    FList: TObjectList;

  public
    // construction/destruction ------------------------------------------------
    constructor Create(ACode: String; AName: String; AOptions: TLineOptions);
    // pre: ValidLineCode(ACode), ValidLineName(AName)
    // post: GetCode = ACode, GetName = AName, GetOptions = AOptions

    destructor Destroy; override;

    // TLineR overrides ========================================================
    // primitive queries -------------------------------------------------------
    function GetCode: String; override;
    function GetName: String; override;
    function GetOptions: TLineOptions; override;
    function Count: Integer; override;
    // ret: |Abstr|
    function IndexOf(AStation: TStationR): Integer; override;
    // pre: true
    // ret: I such that Abstr[I] = AStation, or else -1
    function Stop(I: Integer): TStationR; override;
    // pre: 0 <= I < Count
    // ret: Abstr[I]

    // new methods =============================================================
    // preconditions for commands ----------------------------------------------
    function CanAddStop(AStation: TStationR): Boolean;
    // pre: true
    // ret: not HasStop(AStation)

    function CanInsertStop(I: Integer; AStation: TStationR): Boolean;
    // pre: true
    // ret: (0 <= I <= Count) and not HasStop(AStation)

    function CanSwapStops(I, J: Integer): Boolean; virtual;
    // pre: true
    // ret: (0 <= I <= Count) and (0 <= J <= Count)

    function CanDeleteStop(I: Integer): Boolean; virtual;
    // pre: true
    // ret: 0 <= I < Count

    function CanDeleteAll: Boolean; virtual;
    // pre: true
    // ret: true

    // commands ----------------------------------------------------------------
    procedure AddStop(AStation: TStationR);
    // pre: CanAddStop(AStation)
    // post: Abstr = old Abstr ++ [AStation]

    procedure InsertStop(I: Integer; AStation: TStationR);
    // pre: CanInsertStop(I, AStation)
    // post: Abstr = (old Abstr[0..I) ++ [AStation] ++ (old Abstr[I..Count))

    procedure SwapStops(I, J: Integer);
    // pre: CanSwapStops(I,J)
    // post:
    //   let X = old Abstr[I], Y = old Abstr[J},
    //      S0 = old Abstr[0..I), S1 = old Abstr[I+1..J),
    //      S2 = old Abstr[J+1..Count)
    //   in Abstr = S0 ++ [Y] ++ S1 ++ [X] ++ S2

    procedure DeleteStop(I: Integer);
    // pre: CanDeleteStop(I)
    // post: Abstr = old Abstr[0..I) ++ old Abstr[I+1..Count)

    procedure DeleteAll;
    // pre: CanDeleteAll
    // post: Abstr = []
  end;


//==============================================================================
// LineSet
//
// A lineset is a finite enumerable set of lines.
//
// The class TLineSetR is an abstract class providing read-only access to the
// data of a lineset.
// The class TLineSetRW is a descendant of TLineSetR; it provides a concrete
// representation and read/write access to a lineset.
//
//
// NOTE: The organization of the LineSet classes is almost the same as that of
// the Stationset classes. What is really needed here is a parameterized class
// Set[T] which can be instantiated for stations and lines respectively.
// Currently, Delphi does not provide such a notion.
//==============================================================================

  TLineSetR =
  class(TObject)
  public
    // primitive queries -------------------------------------------------------
    function Count: Integer; virtual; abstract;
    // pre: true
    // ret: |Abstr|

    function GetLine(I: Integer): TLineR; virtual; abstract;
    // pre: 0 <= I < Count
    // ret: Abstr[I]

    // derived queries ---------------------------------------------------------
    function IsEmpty: Boolean;
    // pre: true
    // ret: Count = 0

    function HasLine(ALine: TLineR): Boolean;
    // pre: true
    // ret: (exists I: 0 <= I < Count: GetLine(I) = ALine )

    function HasCode(ACode: String): Boolean;
    // pre: true
    // ret: (exists I: 0 <= I < Count: GetLine(I).GetCode = ACode )

    function HasName(AName: String): Boolean;
    // pre: true
    // ret: (exists I: 0 <= I < Count: GetLine(I).GetName = AName )

    function HasStop(AStation: TStationR): Boolean;
    // pre: true
    // ret: (exists I: 0 <= I < Count: GetLine(I).HasStop(AStation))

    function IndexOfCode(ACode: String): Integer;
    // pre: true
    // ret: I such that GetLine(I).GetCode = ACode, or else -1

    function IndexOfName(AName: String): Integer;
    // pre: true
    // ret: I such that GetLine(I).GetName = AName, or else -1

    // model variables ---------------------------------------------------------
    // Abstr: set of TLineR

    // invariants --------------------------------------------------------------
    // Unique:
    //   (forall I,J: 0<=I<J<Count:
    //      - GetLine(I) <> GetLine(J)
    //      - GetLine(I).GetCode <> GetLine(J).GetCode
    //      - GetLine(I).GetName <> GetLine(J).GetName
    //   )
  end;

  TLineSetRW =
  class(TLineSetR)
  protected
    // fields ------------------------------------------------------------------
    FList: TObjectList;

    // invariants --------------------------------------------------------------
    // Abstr = {FList[I] as TLineR| 0<=I<FList.Count}
  public
    // construction/destruction ------------------------------------------------
    constructor Create;
    // pre: true
    // post: Abstr = {}

    destructor Destroy; override;

    // TLineSetR overrides =====================================================

    // primitive queries -------------------------------------
    function Count: Integer; override;
    // pre: true
    // ret: |Abstr|

    function GetLine(I: Integer): TLineR; override;
    // pre: 0 <= I < Count
    // ret: Abstr[I]

    // new methods =============================================================

    // preconditions for commands ----------------------------------------------
    function CanAddLine(ALine: TLineR): Boolean; virtual;
    // pre: true
    // ret: not HasLine(ALine) and not HasCode(ALine.GetCode) and
    //        not HasName(ALine.GetName)

    function CanDeleteLine(ALine: TLineR): Boolean; virtual;
    // pre: true
    // ret: true (may be overridden in subclasses)

    function CanDeleteAll: Boolean; virtual;
    // pre: true
    // ret: true (may be overridden in subclasses)

    // commands ----------------------------------------------------------------
    procedure AddLine(ALine: TLineR);
    // pre: CanAddLine(ALine)
    // post: Abstr = old Abstr U {ALine}

    procedure DeleteLine(ALine: TLineR);
    // pre: CanDeleteLine(ALine)
    // post: Abstr = old Abstr - {ALine}

    procedure DeleteAll;
    // pre: CanDeleteAll
    // post: Abstr = {}
  end;



//==============================================================================
// Network
//
// A network has:
// - a name
// - a stationset S
// - a lineset L
// Consistency invariant
// - every station occurring in a line of L should also occur in S
//
// A network can be read from and written to a .INI file
//
// A network can be edited by adding or deleting a station or a line.
// The preconditions of the editing operations guarantee that the consistency
// invariant is preserved.
//==============================================================================
  
  TNetwork =
  class(TObject)
  protected
    FName: String;
    FStationSet: TStationSetRW;
    FLineSet: TLineSetRW;

  public
    // construction/destruction ------------------------------------------------
    constructor Create(
                  AName: String;
                  AStationSet: TStationSetRW;
                  ALineSet: TLineSetRW);
    // pre: ValidNetworkName(AName), IsConsistent(AStationset, ALineSet)
    // post: GetName = AName, GetStationset = AStationset, GetLineset = ALineSet

    constructor CreateEmpty(AName: String);
    // pre: true
    // post: GetName = AName, GetStationSet.Count = 0, GetLineSet.Count = 0

    constructor CreateFromFile(AFile: TMemIniFile);
    // pre: file AFileName contains a description of a network (N, SS LS);
    //        IsConsistent(SS,LS)
    // post: GetName = N, GetStationSet = SS, GetLineSet = LS

    destructor Destroy; override;

    // persistence -------------------------------------------------------------
    procedure WriteToFile(AFile: TMemIniFile);
    // pre: true
    // post: file AFileName contains a description of network
    //        (GetName, GetStationSet, GetLineSet)

    // basic queries -----------------------------------------------------------
    function GetName: string;
    function GetStationSet: TStationSetR;
    function GetLineSet: TLineSetR;

    // derived queries ---------------------------------------------------------
    function IsConsistentLine(ALine: TLineR; AStationSet: TStationSetR): Boolean;
    // pre: true
    // ret: (forall J: 0<=J<ALine.Count: AStationSet.HasStation(ALine.Stop(J))

    function IsConsistentNetwork(
               AStationSet: TStationSetR; ALineSet: TLineSetR): Boolean;
    // pre: true
    // ret:
    //   let SS = AStationSet, LS = ALineSet
    //     (forall I: 0<=I<LS.Count: IsConsistentLine(LS.GetLine(I), SS)

    // preconditions for commands ----------------------------------------------
    function CanAddStation(ACode: String; AName: String): Boolean; virtual;
    // pre: true
    // ret: GetStationSet.CanAddStation(ACode, AName)

    function CanDeleteStation(AStation: TStationR): Boolean; virtual;
    // pre: true
    // ret: not GetLineSet.HasStop(AStation)

    function CanAddLine(ALine: TLineR): Boolean; virtual;
    // pre: true
    // ret: IsConsistentLine(ALine, GetStationSet) and
    //        (GetLineSet as TLineSetRW).CanAddLine(ALine)

    function CanDeleteLine(ALine: TLineR): Boolean; virtual;
    // pre: true
    // ret: (GetLineSet as TLineSetRW).CanDeleteLine(ALine)

    function CanDeleteAll: Boolean; virtual;
    // pre: true
    // ret: true

    // commands ----------------------------------------------------------------
    procedure AddStation(ACode: String; AName: String); virtual;
    // pre: CanAddStation(ACode, AName)
    // effect: (GetStationSet as TStationSetRW).AddStation(ACode, AName)

    procedure DeleteStation(AStation: TStationR); virtual;
    // pre: CanDeleteStation(AStation)
    // effect: (GetStationSet as TStationSetRW).DeleteStation(AStation)

    procedure AddLine(ALine: TLineR); virtual;
    // pre: CanAddLine(ALine)
    // effect: (GetLineSet as TLineSetRW).AddLine(ALine)

    procedure DeleteLine(ALine: TLineR); virtual;
    // pre: CanDeleteLine(ALine)
    // effect: (GetLineSet as TLineSetRW).DeleteLine(ALine)

    procedure DeleteAll; virtual;
    // pre: CanDeleteAll
    // post: GetStationSet.Count = 0, GetLineSet.Count = 0

    // invariants --------------------------------------------------------------
    // Consistent:
    //   IsConsistentNetwork(GetStationSet, GetLineSet);
    // Connected:
    //   (not yet necessary)
  end;


// String validators -----------------------------------------------------------
const
  csSpecial = ['-', ' ', '''', '.'];
  csDigit   = ['0'..'9'];
  csLetterU = ['A'..'Z'];
  csLetterL = ['a'..'z'];
  csAccentedL = ['á', 'à', 'â', 'ä', 'é', 'è', 'ê', 'ë', 'í', 'ì', 'î', 'ï',
                 'ó', 'ò', 'ô', 'ö', 'ú', 'ù', 'û', 'ü', 'ç'];
  csAccentedU = ['Á', 'À', 'Â', 'Ä', 'É', 'È', 'Ê', 'Ë', 'Í', 'Ì', 'Î', 'Ï',
                 'Ó', 'Ò', 'Ô', 'Ö', 'Ú', 'Ù', 'Û', 'Ü', 'Ç'];
  csLetter  = csLetterU + csLetterL + csAccentedU + csAccentedL;
  csCodeSet = csLetter + csDigit;
  csNameSet = csLetter + csDigit + csSpecial;

function ValidStationCode(AString: String): Boolean;
// ret: AString in csCodeSet+
function ValidStationName(AString: String): Boolean;
// ret: AString in csNameSet+
function ValidLineCode(AString: String): Boolean;
// ret: AString in csCodeSet+
function ValidLineName(AString: String): Boolean;
// ret: AString in csNameSet+
function ValidNetworkName(AString: String): Boolean;
// ret: Astring in csNameSet+



implementation //===============================================================

uses
  Classes, StrUtils, SysUtils;

{ TStationRW ------------------------------------------------------------------}

constructor TStationRW.Create(ACode, AName: String);
begin
  Assert(ValidStationCode(ACode),
    Format('TStationRW.Create.pre: ValidStationCode: %s', [ACode]));
  Assert(ValidStationName(AName),
    Format('TStationRW.Create.pre: ValidStationName: %s', [AName]));
  inherited Create;
  FCode := ACode;
  FName := AName;
end;

function TStationRW.GetCode: String;
begin
  Result := FCode;
end;

function TStationRW.GetName: String;
begin
  Result := FName;
end;

procedure TStationRW.Rename(AName: String);
begin
  Assert(ValidStationName(AName),
    Format('TStationRW.Rename.pre: ValidStationName: %s', [AName]));
end;

{ TStationSetR ----------------------------------------------------------------}

function TStationSetR.HasCode(ACode: String): Boolean;
begin
  Result := IndexOfCode(ACode) <> -1;
end;

function TStationSetR.HasName(AName: String): Boolean;
begin
  Result := IndexOfName(AName) <> -1;
end;

function TStationSetR.HasStation(AStation: TStationR): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I := 0 to Count - 1 do
    if GetStation(I) = AStation
    then Result := true;
end;

function TStationSetR.IndexOfCode(ACode: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
    if GetStation(I).GetCode = ACode
    then Result := I;
end;

function TStationSetR.IndexOfName(AName: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
    if GetStation(I).GetName = AName
    then Result := I;
end;

function TStationSetR.IsEmpty: Boolean;
begin
  Result := Count = 0;
end;

{ TStationSetRW ---------------------------------------------------------------}

procedure TStationSetRW.AddStation(ACode, AName: String);
begin
  Assert(CanAddStation(ACode, AName),
    Format('TStationSetRW.AddStation.pre: %s, %s', [ACode, AName]));
  FList.Add(TStationRW.Create(ACode, AName));
end;

function TStationSetRW.CanAddStation(ACode, AName: String): Boolean;
begin
  Result :=
    ValidStationCode(ACode) and
    ValidStationName(AName) and
    not HasCode(ACode) and
    not HasName(AName);
end;

function TStationSetRW.CanDeleteAll: Boolean;
begin
  Result := true;
end;

function TStationSetRW.CanDeleteStation(AStation: TStationR): Boolean;
begin
  Result := true;
end;

function TStationSetRW.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TStationSetRW.Create;
begin
  inherited Create;
  FList := TObjectList.Create;
end;

procedure TStationSetRW.DeleteAll;
begin
  FList.Clear;
end;

procedure TStationSetRW.DeleteStation(AStation: TStationR);
begin
  FList.Remove(AStation);
end;

destructor TStationSetRW.Destroy;
begin
  FList.Free;
  inherited;
end;

function TStationSetRW.GetStation(I: Integer): TStationR;
begin
  Assert((0 <= I) and (I < Count),
    Format('TStationSetRW.GetStation.pre: I = %d', [I]));
  Result := FList.Items[I] as TStationR;
end;

{ TLineR ----------------------------------------------------------------------}

function TLineR.HasStop(AStation: TStationR): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I := 0 to Count - 1 do
    if Stop(I) = AStation
    then Result := true;
end;

function TLineR.IsCircular: Boolean;
begin
  Result := loCircular in GetOptions;
end;

function TLineR.IsOneWay: Boolean;
begin
  Result := loOneWay in GetOptions;
end;

function TLineR.TerminalA: TStationR;
begin
  Assert(Count > 0, 'TLineR.TerminalA.pre');
  Result := Stop(0);
end;

function TLineR.TerminalB: TStationR;
begin
  Assert(Count > 0, 'TLineR.TerminalB.pre');
  Result := Stop(Count - 1);
end;

{ TLineRW ---------------------------------------------------------------------}

procedure TLineRW.AddStop(AStation: TStationR);
begin
  Assert(CanAddStop(AStation),
    Format('TLineRW.AddStop.pre: %s', [AStation.GetCode]));
  FList.Add(AStation);
end;

function TLineRW.CanAddStop(AStation: TStationR): Boolean;
begin
  Result := not HasStop(AStation);
end;

function TLineRW.CanDeleteAll: Boolean;
begin
  Result := true;
end;

function TLineRW.CanDeleteStop(I: Integer): Boolean;
begin
  Result := (0 <= I) and (I < Count);
end;

function TLineRW.CanInsertStop(I: Integer; AStation: TStationR): Boolean;
begin
  Result := (0 <= I) and (I <= Count) and not HasStop(AStation);
end;

function TLineRW.CanSwapStops(I, J: Integer): Boolean;
begin
  Result := (0 <= I) and (I <= Count) and (0 <= J) and (J <= Count);
end;

function TLineRW.Count: Integer;
begin
  Result := Flist.Count;
end;

constructor TLineRW.Create(ACode, AName: String; AOptions: TLineOptions);
begin
  Assert(ValidLineCode(ACode),
    Format('TLineRW.Create.pre: ACode = %s', [ACode]));
  Assert(ValidLineName(AName),
    Format('TLineRW.Create.pre: AName = %s', [AName]));
  inherited Create;
  FCode := ACode;
  FName := AName;
  FOptions := AOptions;
  FList := TObjectList.Create(false);
end;

procedure TLineRW.DeleteAll;
begin
  Assert(CanDeleteAll, 'TLineRW.DeleteAll.pre');
  FList.Clear;
end;

procedure TLineRW.DeleteStop(I: Integer);
begin
  Assert(CanDeleteStop(I), 'TLineRW.DeleteStop.pre');
  FList.Delete(I);
end;

destructor TLineRW.Destroy;
begin
  FList.Free;
  inherited;
end;

function TLineRW.GetCode: String;
begin
  Result := FCode;
end;

function TLineRW.GetName: String;
begin
  Result := FName;
end;

function TLineRW.GetOptions: TLineOptions;
begin
  Result := FOptions;
end;

function TLineRW.IndexOf(AStation: TStationR): Integer;
begin
  Result := FList.IndexOf(AStation);
end;

procedure TLineRW.InsertStop(I: Integer; AStation: TStationR);
begin
  Assert(CanInsertStop(I, AStation),
    Format('TLineRW.InsertStop.pre: I = %d, AStation = %s',
      [I, AStation.GetCode]));
  FList.Insert(I, AStation);
end;

function TLineRW.Stop(I: Integer): TStationR;
begin
  Assert((0 <= I) and (I < Count), Format('TLineRW.Stop.pre: I = %d', [I]));
  Result := FList.Items[I] as TStationR;
end;

procedure TLineRW.SwapStops(I, J: Integer);
begin
  Assert(CanSwapStops(I,J),
    Format('TLineRW.SwapStops.pre: I = %d, J = %d', [I, J]));
  FList.Exchange(I, J);
end;

{ TLineSetR -------------------------------------------------------------------}

function TLineSetR.HasCode(ACode: String): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I := 0 to Count - 1 do
    if GetLine(I).GetCode = ACode
    then Result := true;
end;

function TLineSetR.HasLine(ALine: TLineR): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I := 0 to Count - 1 do
    if GetLine(I) = ALine
    then Result := true;
end;

function TLineSetR.HasName(AName: String): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I := 0 to Count - 1 do
    if GetLine(I).GetName = AName
    then Result := true;
end;

function TLineSetR.HasStop(AStation: TStationR): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I := 0 to Count - 1 do
    if GetLine(I).HasStop(AStation)
    then Result := true;
end;

function TLineSetR.IndexOfCode(ACode: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
    if GetLine(I).GetCode = ACode
    then Result := I;
end;

function TLineSetR.IndexOfName(AName: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
    if GetLine(I).GetName = AName
    then Result := I;
end;

function TLineSetR.IsEmpty: Boolean;
begin
  Result := Count = 0;
end;

{ TLineSetRW ------------------------------------------------------------------}

procedure TLineSetRW.AddLine(ALine: TLineR);
begin
  Assert(CanAddLine(ALine),
    Format('TLineSetRW.AddLine.pre: ALine = %s', [ALine.GetCode]));
  FList.Add(ALine);
end;

function TLineSetRW.CanAddLine(ALine: TLineR): Boolean;
begin
  Result :=
    not HasLine(ALine) and
    not HasCode(ALine.GetCode) and
    not HasName(ALine.GetName)
end;

function TLineSetRW.CanDeleteAll: Boolean;
begin
  Result := true;
end;

function TLineSetRW.CanDeleteLine(ALine: TLineR): Boolean;
begin
  Result := true;
end;

function TLineSetRW.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TLineSetRW.Create;
begin
  inherited Create;
  FList := TObjectList.Create;
end;

procedure TLineSetRW.DeleteAll;
begin
  Assert(CanDeleteAll, 'TLineSetRW.DeleteAll.pre');
  FList.Clear;
end;

procedure TLineSetRW.DeleteLine(ALine: TLineR);
begin
  Assert(CanDeleteLine(ALine),
    Format('TLineSetRW.DeleteLine.pre: ALine = %s', [ALine.GetCode]));
  FList.Remove(ALine);
end;

destructor TLineSetRW.Destroy;
begin
  FList.Free;
  inherited;
end;

function TLineSetRW.GetLine(I: Integer): TLineR;
begin
  Assert((0 <= I) and (I < Count),
    Format('TLineSetRW.GetLine.pre: I = %d', [I]));
  Result := FList.Items[I] as TLineR;
end;

{ TNetwork --------------------------------------------------------------------}

procedure TNetwork.AddLine(ALine: TLineR);
begin
  Assert(CanAddLine(ALine),
    Format('TNetwork.AddLine.pre: ALine = %s', [ALine.GetCode]));
  FLineSet.AddLine(ALine);
end;

procedure TNetwork.AddStation(ACode, AName: String);
begin
  Assert(CanAddStation(ACode, AName),
    Format('TNetwork.AddStation.pre: ACode = %s, AName = %s', [ACode, AName]));
  FStationSet.AddStation(ACode, AName);
end;

function TNetwork.CanAddLine(ALine: TLineR): Boolean;
begin
  Result :=
    IsConsistentLine(ALine, GetStationSet) and
    FLineSet.CanAddLine(ALine)
end;

function TNetwork.CanAddStation(ACode, AName: String): Boolean;
begin
  Result := FStationSet.CanAddStation(ACode, AName);
end;

function TNetwork.CanDeleteAll: Boolean;
begin
  Result := true;
end;

function TNetwork.CanDeleteLine(ALine: TLineR): Boolean;
begin
  Result := FLineSet.CanDeleteLine(ALine);
end;

function TNetwork.CanDeleteStation(AStation: TStationR): Boolean;
begin
  Result := not FLineSet.HasStop(AStation);
end;

constructor TNetwork.Create(
              AName: String;
              AStationSet: TStationSetRW;
              ALineSet: TLineSetRW);
begin
  Assert(ValidNetworkName(AName), 'TNetwork.Create.pre: ValidNetworkName');
  Assert(IsConsistentNetwork(AStationset, ALineSet),
    'TNetwork.Create.pre: IsConsistent');
  inherited Create;
  FName := Aname;
  FStationSet := AStationSet;
  FLineSet := ALineSet;
end;

constructor TNetwork.CreateEmpty(AName: String);
begin
  inherited Create;
  FName := AName;
  FStationSet := TStationSetRW.Create;
  FLineSet := TLineSetRW.Create;
end;

constructor TNetwork.CreateFromFile(AFile: TMemIniFile);
var
  VSections: TStringList;
  VSectionName: String;
  VStationCode, VStationName: String;
  VLineCode, VLineName: String;
  VStation: TStationR;
  VLine: TLineRW;
  VCircular, VOneWay: Boolean;
  VLineOptions: TLineOptions;
  VStops: TStringList;
  VStopCode: String;
  I, J: Integer;
begin
  inherited Create;
  FStationSet := TStationSetRW.Create;
  FLineSet := TLineSetRW.Create;

  // read name
  FName := AFile.ReadString('#Main', 'name', '???');

  // read all sections
  VSections:= TStringList.Create;
  AFile.ReadSections(VSections);


  // filter out station sections (beginning with 'S_') and read their name
  for I := 0 to VSections.Count - 1 do
  begin
    VSectionName := VSections.Strings[I];
    if AnSiStartsStr('S_', VSectionName) then
    begin
      VStationCode := AnsiRightStr(VSectionName, Length(VSectionName) - 2);
      VStationName := AFile.ReadString(VSectionName, 'name', '???????');
      FStationSet.AddStation(VStationCode, VStationName);
    end;
  end;

  // filter out line sections (beginning with 'L_') and read their attributes
  // and corresponding station lists
  for I := 0 to VSections.Count - 1 do
  begin
    VSectionName := VSections.Strings[I];
    if AnSiStartsStr('L_', VSectionName) then
    begin
      VLineCode := AnsiRightStr(VSectionName, Length(VSectionName) - 2);
      // read line name
      VLineName := AFile.ReadString(VSectionName, 'name', '????');
      // read line options
      VLineOptions := [];
      VOneWay := AFile.ReadBool(VSectionName, 'oneway', false);
      if VOneWay then VLineOptions := VLineOptions + [loOneWay];
      VCircular := AFile.ReadBool(VSectionName, 'circular', false);
      if VCircular then VLineOptions := VLineOptions + [loCircular];
      // create line (with empty stationlist)
      VLine := TLineRW.Create(VLineCode, VLineName, VLineOptions);

      // read stops from corresponding 'P_' section and and them to line
      VStops := TStringList.Create;
      AFile.ReadSectionValues('P_' + VLineCode, VStops);
      for J := 0 to VStops.Count - 1 do
      begin
        VStopCode := VStops.Strings[J];
        if ValidStationCode(VStopCode) then
          with FStationSet do
          begin
            VStation := GetStation(IndexOfCode(VStopCode));
            VLine.AddStop(VStation);
          end{with};
      end{for};
      FLineSet.AddLine(VLine);
      VStops.Free;
    end;
  end;
  VSections.Free;

end;

procedure TNetwork.DeleteAll;
begin
  Assert(CanDeleteAll, 'TNetwork.DeleteAll.pre');
  FStationSet.DeleteAll;
end;

procedure TNetwork.DeleteLine(ALine: TLineR);
begin
  Assert(CanDeleteLine(ALine), 'TNetwork.DeleteLine.pre');
  FLineSet.DeleteLine(ALine);
end;

procedure TNetwork.DeleteStation(AStation: TStationR);
begin
  Assert(CanDeleteStation(AStation), 'TNetwork.DeleteStation.pre');
  FStationSet.DeleteStation(AStation);
end;

destructor TNetwork.Destroy;
begin
  FLineSet.Free;
  FStationSet.Free;
  inherited;
end;

function TNetwork.GetLineSet: TLineSetR;
begin
  Result := FLineset;
end;

function TNetwork.GetName: string;
begin
  Result := FName;
end;

function TNetwork.GetStationSet: TStationSetR;
begin
  Result := FStationSet;
end;

function TNetwork.IsConsistentLine(
           ALine: TLineR;
           AStationSet: TStationSetR): Boolean;
var
  J: integer;
begin
  Result := true;
  for J := 0 to ALine.Count - 1 do
    if not AStationSet.HasStation(ALine.Stop(J))
    then Result := false;
end;

function TNetwork.IsConsistentNetwork(
           AStationSet: TStationSetR;
           ALineSet: TLineSetR): Boolean;
    // ret:
    //   let SS = AStationSet, LS = ALineSet
    //     (forall I: 0<=I<LS.Count: IsConsistentLine(LS.GetLine(I), SS)
var
  I: Integer;
begin
  Result := true;
  for I := 0 to ALineSet.Count - 1 do
    if not IsConsistentLine(ALineset.GetLine(I), AStationSet)
    then Result := false;
end;

procedure TNetwork.WriteToFile(AFile: TMemIniFile);
var
  I, J: Integer;
  LineCode: String;
begin
  AFile.Clear;
  AFile.WriteString('#Main', 'name', FName);

  // write station names and codes
  with FStationSet do
    for I := 0 to Count - 1 do
      with GetStation(I) do
        AFile.WriteString('S_' + GetCode, 'name', GetName);

  // write lines
  with FLineSet do
    for I := 0 to Count - 1 do
      with GetLine(I) do
      begin
        // write name, oneway, circular
        LineCode := GetCode;
        AFile.WriteString('L_' + LineCode, 'name'    , GetName );
        AFile.WriteBool  ('L_' + LineCode, 'oneway'  , IsOneWay);
        AFile.WriteBool  ('L_' + LineCode, 'circular', IsCircular);
        // write codes of stops
        for J := 1 to Count - 1 do
          AFile.WriteString('P_' + LineCode, Stop(J).GetCode, '');
      end;
end;


// String validators -----------------------------------------------------------

type
  TCharSet = set of Char;

function AuxValid(AString: String; ACharSet: TCharSet): Boolean;
// ret: AString in ACharSet+
var
  I: Integer;
begin
  Result := Length(AString) > 0;
  for I := 1 to Length(AString) do
    if not (AString[I] in ACharSet)
    then Result := false;
end;

function ValidStationCode(AString: String): Boolean;
// ret: AString in csCodeSet+
begin
  Result := AuxValid(AString, csCodeSet);
end;

function ValidStationName(AString: String): Boolean;
// ret: AString in csNameSet+
begin
  Result := AuxValid(AString, csNameSet);
end;

function ValidLineCode(AString: String): Boolean;
// ret: AString in csCodeSet+
begin
  Result := AuxValid(AString, csCodeSet);
end;

function ValidLineName(AString: String): Boolean;
// ret: AString in csNameSet+
begin
  Result := AuxValid(AString, csNameSet);
end;

function ValidNetworkName(AString: String): Boolean;
// ret: Astring in csNameSet+
begin
  Result := AuxValid(AString, csNameSet);
end;



end.
