unit MetroBase;
//# BEGIN TODO  Completed by: author name, id.nr., date
  { E.I.R. van Delden, 0618959, 09-05-08}
//# END TODO

interface

uses
  Contnrs, IniFiles,
  StringValidators;

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
    Data: TObject; // scratch data field for use by planners etc.

    // primitive queries -------------------------------------------------------
    function GetCode: String; virtual; abstract;
    // pre: True
    function GetName: String; virtual; abstract;
    // pre: True

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
    // pre: True
    function GetName: String; override;
    // pre: True

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
  public
    // primitive queries -------------------------------------------------------
    function Count: Integer; virtual; abstract;
    // pre: True
    // ret: |Abstr|
    function GetStation(I: Integer): TStationR; virtual; abstract;
    // pre: 0 <= I < Count
    // ret: Abstr[I]

    // derived queries ---------------------------------------------------------
    function IsEmpty: Boolean;
    // pre: True
    // ret: Count = 0
    function HasStation(AStation: TStationR): Boolean;
    // pre: True
    // ret: (exists I: 0 <= I < Count: GetStation(I) = AStation)
    function HasCode(ACode: String): Boolean;
    // pre: True
    // ret: IndexOfCode(ACode) <> -1
    function HasName(AName: String): Boolean;
    // pre: True
    // ret: IndexOfName(AName) <> -1
    function IndexOfCode(ACode: String): Integer;
    // pre: True
    // ret: I such that GetStation(I).GetCode = ACode, or else -1
    function IndexOfName(AName: String): Integer;
    // pre: True
    // ret: I such that GetStation(I).GetName = AName, or else -1

    // model variables ---------------------------------------------------------
    // Abstr: set of TStationRW

    // invariants --------------------------------------------------------------
    // Unique:
    //   (forall I, J: 0 <= I < J < Count:
    //      - GetStation(I) <> GetStation(J)
    //      - GetStation(I).GetCode <> GetStation(J).GetCode
    //      - GetStation(I).GetName <> GetStation(J).GetName
    //   )
  end;


  TStationSetRW =
  class(TStationSetR)
  protected
    FList: TObjectList; // owner

    // invariants --------------------------------------------------------------
    // Abstr = {set S: 0 <= S < FList.Count: FList[S] as TStationR}    
  public
    // construction/destruction ------------------------------------------------
    constructor Create;
    // pre: True
    // post: Abstr = {}
    destructor Destroy; override;
    // pre: True
    // effect: FList is freed

    // TStationSetR overrides ==================================================
    // primitive queries -------------------------------------
    function Count: Integer; override;
    // pre: True
    // ret: |Abstr|
    function GetStation(I: Integer): TStationR; override;
    // pre: 0 <= I < Count
    // ret: Abstr[I]

    // new methods =============================================================
    // preconditions for commands ----------------------------------------------
    function CanAddStation(AStation: TStationR): Boolean; virtual;
    // pre: True
    // ret: ValidStationCode(AStation.GetCode) and
    //      ValidStationName(AStation.GetName) and
    //      not HasCode(AStation.GetCode) and not HasName(AStation.GetName)
    function CanDeleteStation(AStation: TStationR): Boolean; virtual;
    // pre: True
    // ret: True (may be overridden in subclasses)
    function CanDeleteAll: Boolean; virtual;
    // pre: True
    // ret: True (may be overridden in subclasses)
    function CanSetStationCode(AStation: TStationR; ACode: String): Boolean; virtual;
    // pre: True
    // ret: ValidStationCode(ACode) and HasStation(AStation) and
    //      not(HasCode(ACode))
    function CanSetStationName(AStation: TStationR; AName: String): Boolean; virtual;
    // pre: True
    // ret: ValidStationName(AName) and HasStation(AStation) and
    //      not(HasName(AName))

    // commands ----------------------------------------------------------------
    procedure AddStation(AStation: TStationR);
    // pre: CanAddStation(AStation)
    // post: Abstr = old Abstr U {AStation}
    procedure SetStationCode(AStation: TStationR; ACode: String); virtual;
    // pre: CanSetStationCode(AStation, ACode)
    // post: AStation.GetCode = ACode
    procedure SetStationName(AStation: TStationR; AName: String); virtual;
    // pre: CanSetStationName(AStation, AName)
    // post: AStation.GetName = AName
    procedure DeleteStation(AStation: TStationR);
    // pre: CanDeleteStation(AStation)
    // post: Abstr = old Abstr \ {AStation}
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
    Data: TObject; // scratch data field, used by planners etc.

    // primitive queries -------------------------------------------------------
    function GetCode: String; virtual; abstract;
    // pre: True
    function GetName: String; virtual; abstract;
    // pre: True
    function GetOptions: TLineOptions; virtual; abstract;
    // pre: True
    function Count: Integer; virtual; abstract;
    // pre: True
    // ret: |Abstr|
    function IndexOf(AStation: TStationR): Integer; virtual; abstract;
    // pre: True
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
    // ret: Stop(Count - 1)
    function IsOneWay: Boolean;
    // pre: True
    // ret: loOneWay in GetOptions
    function IsCircular: Boolean;
    // pre: True
    // ret: loCircular in GetOptions
    function HasStop(AStation: TStationR): Boolean;
    // pre: True
    // ret: (exists I: 0 <= I < Count: Stop(I) = AStation )

    // model variables ---------------------------------------------------------
    // Abstr: seq of TStationR

    // invariants --------------------------------------------------------------
    // I0: ValidLineCode(GetCode) and ValidLineName(GetName)
    // Stops_Unique:
    //   (forall I, J: 0 <= I < J < Count: Stop(I) <> Stop(J))
  end;



  TLineRW =
  class(TLineR)
  protected
    FCode: String;
    FName: String;
    FOptions: TLineOptions;
    FList: TObjectList; // shared

    // invariants --------------------------------------------------------------
    // A0: Abstr = (seq S: 0 <= S < FList.Count: FList[S] as TStationR)
  public
    // construction/destruction ------------------------------------------------
    constructor Create(ACode: String; AName: String; AOptions: TLineOptions);
    // pre: ValidLineCode(ACode), ValidLineName(AName)
    // post: GetCode = ACode and GetName = AName and GetOptions = AOptions
    //       and (Count = 0)
    destructor Destroy; override;
    // pre: True
    // effect: FList is freed

    // TLineR overrides ========================================================
    // primitive queries -------------------------------------------------------
    function GetCode: String; override;
    // pre: True
    function GetName: String; override;
    // pre: True
    function GetOptions: TLineOptions; override;
    // pre: True
    function Count: Integer; override;
    // pre: True
    // ret: |Abstr|
    function IndexOf(AStation: TStationR): Integer; override;
    // pre: True
    // ret: I such that Abstr[I] = AStation, or else -1
    function Stop(I: Integer): TStationR; override;
    // pre: 0 <= I < Count
    // ret: Abstr[I]

    // new methods =============================================================
    // preconditions for commands ----------------------------------------------
    function CanAddStop(AStation: TStationR): Boolean;
    // pre: True
    // ret: not HasStop(AStation)
    function CanInsertStop(I: Integer; AStation: TStationR): Boolean;
    // pre: True
    // ret: (0 <= I <= Count) and not HasStop(AStation)
    function CanSwapStops(I, J: Integer): Boolean; virtual;
    // pre: True
    // ret: (0 <= I < Count) and (0 <= J < Count)
    function CanDeleteStop(I: Integer): Boolean; virtual;
    // pre: True
    // ret: 0 <= I < Count
    function CanDeleteAll: Boolean; virtual;
    // pre: True
    // ret: True

    // commands ----------------------------------------------------------------
    procedure AddStop(AStation: TStationR);
    // pre: CanAddStop(AStation)
    // post: Abstr = old Abstr ++ [AStation]
    procedure InsertStop(I: Integer; AStation: TStationR);
    // pre: CanInsertStop(I, AStation)
    // post: Abstr = (old Abstr[0..I) ++ [AStation] ++ (old Abstr[I..Count))
    procedure SetOptions(AOptions: TLineOptions);
    // pre: True
    // post: GetOptions = AOptions
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
    // pre: True
    // ret: |Abstr|
    function GetLine(I: Integer): TLineR; virtual; abstract;
    // pre: 0 <= I < Count
    // ret: Abstr[I]

    // derived queries ---------------------------------------------------------
    function IsEmpty: Boolean;
    // pre: True
    // ret: Count = 0
    function HasLine(ALine: TLineR): Boolean;
    // pre: True
    // ret: (exists I: 0 <= I < Count: GetLine(I) = ALine )
    function HasCode(ACode: String): Boolean;
    // pre: True
    // ret: (exists I: 0 <= I < Count: GetLine(I).GetCode = ACode )
    function HasName(AName: String): Boolean;
    // pre: True
    // ret: (exists I: 0 <= I < Count: GetLine(I).GetName = AName )
    function HasStop(AStation: TStationR): Boolean;
    // pre: True
    // ret: (exists I: 0 <= I < Count: GetLine(I).HasStop(AStation))
    function IndexOfCode(ACode: String): Integer;
    // pre: True
    // ret: I such that GetLine(I).GetCode = ACode, or else -1
    function IndexOfName(AName: String): Integer;
    // pre: True
    // ret: I such that GetLine(I).GetName = AName, or else -1

    // model variables ---------------------------------------------------------
    // Abstr: set of TLineR

    // invariants --------------------------------------------------------------
    // Unique:
    //   (forall I,J: 0 <= I < J < Count:
    //      - GetLine(I) <> GetLine(J)
    //      - GetLine(I).GetCode <> GetLine(J).GetCode
    //      - GetLine(I).GetName <> GetLine(J).GetName
    //   )
  end;

  TLineSetRW =
  class(TLineSetR)
  protected
    FList: TObjectList; // owner

    // invariants --------------------------------------------------------------
    // A0: Abstr = (set L: 0 <= L < FList.Count: FList[L] as TLineR)
  public
    // construction/destruction ------------------------------------------------
    constructor Create;
    // pre: True
    // post: Abstr = {}
    destructor Destroy; override;
    // pre: True
    // effect: FList is freed

    // TLineSetR overrides =====================================================
    // primitive queries -------------------------------------
    function Count: Integer; override;
    // pre: True
    // ret: |Abstr|
    function GetLine(I: Integer): TLineR; override;
    // pre: 0 <= I < Count
    // ret: Abstr[I]

    // new methods =============================================================
    // preconditions for commands ----------------------------------------------
    function CanAddLine(ALine: TLineR): Boolean; virtual;
    // pre: True
    // ret: ValidLineCode(ALine.GetCode) and ValidLineName(ALine.GetName) and
    //      not HasCode(ALine.GetCode) and not HasName(ALine.GetName)
    function CanDeleteLine(ALine: TLineR): Boolean; virtual;
    // pre: True
    // ret: True (may be overridden in subclasses)
    function CanDeleteAll: Boolean; virtual;
    // pre: True
    // ret: True (may be overridden in subclasses)
    function CanSetLineCode(ALine: TLineR; ACode: String): Boolean; virtual;
    // pre: True
    // ret: ValidLineCode(ACode) and HasLine(ALine) and
    //       not(HasCode(ACode))
    function CanSetLineName(ALine: TLineR; AName: String): Boolean; virtual;
    // pre: True
    // ret: ValidLineName(AName) and HasLine(ALine) and
    //       not(HasName(AName))

    // commands ----------------------------------------------------------------
    procedure AddLine(ALine: TLineR);
    // pre: CanAddLine(ALine)
    // post: Abstr = old Abstr U {ALine}
    procedure DeleteStation(AStation: TStationR); virtual;
    // pre: True
    // post: (forall L: L in Abstr: L.Abstr = old L.Abstr \ {AStation})
    procedure DeleteLine(ALine: TLineR);
    // pre: CanDeleteLine(ALine)
    // post: Abstr = old Abstr \ {ALine}
    procedure DeleteAll;
    // pre: CanDeleteAll
    // post: Abstr = {}
    procedure SetLineCode(ALine: TLineR; ACode: String);
    // pre: CanSetLineCode(ALine, ACode)
    // post: ALine.GetCode = ACode
    procedure SetLineName(ALine: TLineR; AName: String);
    // pre: CanSetLineName(ALine, AName)
    // post: ALine.GetName = AName
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
    constructor Create(AName: String; AStationSet: TStationSetRW;
      ALineSet: TLineSetRW);
    // pre: ValidNetworkName(AName), IsConsistent(AStationSet, ALineSet)
    // post: GetName = AName and GetStationset = AStationSet and
    //       GetLineset = ALineSet
    constructor CreateEmpty(AName: String);
    // pre: ValidNetworkName(AName)
    // post: GetName = AName and GetStationSet.Count = 0 and
    //       GetLineSet.Count = 0
    destructor Destroy; override;
    // pre: True
    // effect: FLineSet is freed and FStationSet is freed

    // basic queries -----------------------------------------------------------
    function GetName: String;
    // pre: True
    function GetStationSet: TStationSetR;
    // pre: True
    function GetLineSet: TLineSetR;
    // pre: True

    // derived queries ---------------------------------------------------------
    function IsConsistentLine(ALine: TLineR;
      AStationSet: TStationSetR): Boolean;
    // pre: True
    // ret: (forall J: 0 <= J < ALine.Count:
    //        AStationSet.HasStation(ALine.Stop(J))
    function IsConsistentNetwork(AStationSet: TStationSetR;
      ALineSet: TLineSetR): Boolean;
    // pre: True
    // ret:
    //   let SS = AStationSet, LS = ALineSet
    //   in  (forall I: 0 <= I < LS.Count: IsConsistentLine(LS.GetLine(I), SS)

    // preconditions for commands ----------------------------------------------
    function CanAddStation(AStation: TStationR): Boolean; virtual;
    // pre: True
    // ret: GetStationSet.CanAddStation(AStation)
    function CanDeleteStation(AStation: TStationR): Boolean; virtual;
    // pre: True
    // ret: not GetLineSet.HasStop(AStation)
    function CanSetLineCode(ALine: TLineR; ACode: String): Boolean; virtual;
    // pre: True
    // ret: GetLineSet.CanSetLineCode(ALine, ACode)
    function CanSetLineName(ALine: TLineR; AName: String): Boolean; virtual;
    // pre: True
    // ret: GetLineSet.CanSetLineName(ALine, AName)
    function CanSetStationCode(AStation: TStationR; ACode: String): Boolean; virtual;
    // pre: True
    // ret: GetStationSet.CanSetStationCode(AStation, ACode)
    function CanSetStationName(AStation: TStationR; AName: String): Boolean; virtual;
    // pre: True
    // ret: GetStationSet.CanSetStationName(AStation, AName)
    function CanAddLine(ALine: TLineR): Boolean; virtual;
    // pre: True
    // ret: IsConsistentLine(ALine, GetStationSet) and
    //      GetLineSet.CanAddLine(ALine)
    function CanDeleteLine(ALine: TLineR): Boolean; virtual;
    // pre: True
    // ret: GetLineSet.CanDeleteLine(ALine)
    function CanDeleteAll: Boolean; virtual;
    // pre: True
    // ret: True

    // commands ----------------------------------------------------------------
    procedure SetName(AName: String);
    // pre: ValidNetworkName(AName)
    // post: GetName = AName
    procedure SetStationCode(AStation: TStationR; ACode: String);
    // pre: CanSetStationCode(AStation, ACode)
    // post: AStation.GetCode = ACode
    procedure SetStationName(AStation: TStationR; AName: String);
    // pre: CanSetStationName(AStation, AName)
    // post: AStation.GetName = AName
    procedure SetLineCode(ALine: TLineR; ACode: String);
    // pre: CanSetLineCode(ALine, ACode)
    // post: ALine.GetCode = ACode
    procedure SetLineName(ALine: TLineR; AName: String);
    // pre: CanSetLineName(ALine, AName)
    // post: ALine.GetName = AName
    procedure AddStation(AStation: TStationR);
    // pre: CanAddStation(AStation)
    // post: GetStationSet.Abstr = old GetStationSet.Abstr U {AStation}
    procedure DeleteStation(AStation: TStationR); virtual;
    // pre: True
    // post: GetStationSet.Abstr = old GetStation.Abstr \ {AStation} and
    //         (forall L: L in GetLineSet.Abstr:
    //           L.Abstr = old L.Abstr \ {AStation})
    procedure AddLine(ALine: TLineR); virtual;
    // pre: CanAddLine(ALine)
    // post: GetLineSet.Abstr = old GetLineSet.Abstr U {ALine}
    procedure DeleteLine(ALine: TLineR); virtual;
    // pre: CanDeleteLine(ALine: TLineR)
    // post: GetLineSet.Abstr = old GetLineSet.Abstr \ {ALine}
    procedure DeleteAll; virtual;
    // pre: CanDeleteAll
    // post: GetStationSet.Count = 0 and GetLineSet.Count = 0

    // invariants --------------------------------------------------------------
    // Consistent:
    //   IsConsistentNetwork(GetStationSet, GetLineSet);
    // Connected:
    //   (not yet necessary)
  end;

implementation //===============================================================

uses
  Classes, StrUtils, SysUtils;

{ TStationRW ------------------------------------------------------------------}

constructor TStationRW.Create(ACode, AName: String);
begin
//# BEGIN TODO
    // pre: ValidStationCode(ACode) and ValidStationName(AName)
    // post: (GetCode = ACode) and (GetName = AName)

    Assert( ValidStationCode(ACode) and ValidStationName(AName),
    'TStationRW.Create.pre falied: not a valid station');

  inherited Create;
  FCode := ACode;
  FName := AName;

    //# END TODO
end;

function TStationRW.GetCode: String;
begin
//# BEGIN TODO

  result := FCode;

//# END TODO
end;

function TStationRW.GetName: String;
begin
//# BEGIN TODO

  result := FName;

//# END TODO
end;

{ TStationSetR --------------------------------------------------------------- }

function TStationSetR.HasCode(ACode: String): Boolean;
begin
//# BEGIN TODO
    // pre: True
    // ret: IndexOfCode(ACode) <> -1

    if Count = 0 then
    begin
      result := false;
    end
    else
    begin
    result:= IndexOfCode(Acode) <> -1;
    end;

//# END TODO
end;

function TStationSetR.HasName(AName: String): Boolean;
begin
//# BEGIN TODO
    // pre: True
    // ret: IndexOfName(AName) <> -1

    if Count = 0 then
    begin
      result := false;
    end
    else
    begin
    result:= IndexOfName(AName) <> -1;
    end;

//# END TODO
end;

function TStationSetR.HasStation(AStation: TStationR): Boolean;
var
  I: Integer;
begin
//# BEGIN TODO
    // pre: True
    // ret: (exists I: 0 <= I < Count: GetStation(I) = AStation)
  I := 0;
  result := true;

  while (I < Count) and (GetStation(I) <> ASTation) do
  begin
     Inc(I);
  end;

  if I = Count then
  begin
    result := false;
  end;
  
//# END TODO
end;

function TStationSetR.IndexOfCode(ACode: String): Integer;
var
  I: Integer;
begin
//# BEGIN TODO
    // pre: True
    // ret: I such that GetStation(I).GetCode = ACode, or else -1


I := Count -1;

  while (I > -1) and (GetStation(I).GetCode <> ACode) do
  begin
    Dec(I);
  end;

  result := I;


 {result := -1;
 for I := 0 to Count  do
   begin
     if GetStation(I).GetCode = ACode then
     result := I;
   end; }

//# END TODO
end;

function TStationSetR.IndexOfName(AName: String): Integer;
var
  I: Integer;
begin
//# BEGIN TODO
    // pre: True
    // ret: I such that GetStation(I).GetName = AName, or else -1

  I := Count - 1;

  while (I  > -1) and (GetStation(I).GetName <> AName)  do
  begin
    Dec(I);
  end;

  result := I;


//# END TODO
end;

function TStationSetR.IsEmpty: Boolean;
begin
//# BEGIN TODO
    // pre: True
    // ret: Count = 0

    result := Count = 0;


//# END TODO
end;

{ TStationSetRW -------------------------------------------------------------- }

procedure TStationSetRW.SetStationCode(AStation: TStationR; ACode: String);
var VName: String;

begin
//# BEGIN TODO
    // pre: CanSetStationCode(AStation, ACode)
    // post: AStation.GetCode = ACode

    Assert( CanSetStationCode(AStation, ACode), 'TStationSetRW.SetStationCode.pre failed');

    // because FCode can't be changed, because of private, we delete the station
    //  to be changed and recreate with the new code.


    VName := AStation.GetName;
     DeleteStation(AStation);
     TStationRW.Create(ACode, VName);


//# END TODO
end;

procedure TStationSetRW.SetStationName(AStation: TStationR; AName: String);

var VCode: String;

begin
//# BEGIN TODO

    // pre: CanSetStationName(AStation, AName)
    // post: AStation.GetName = AName

    Assert( CanSetStationName(AStation, AName));

    VCode := AStation.GetCode;

    DeleteStation(AStation);

    FList.Add(TStationRW.Create(VCode, AName));


//# END TODO
end;

procedure TStationSetRW.AddStation(AStation: TStationR);
begin
//# BEGIN TODO
    // pre: CanAddStation(AStation)
    // post: Abstr = old Abstr U {AStation}

    Assert( CanAddStation(AStation), 'TStationSetRW.AddStation.pre failed');

  //  FList.Add( TStationRW.Create(AStation.GetCode, AStation.GetName));
    FList.Add(AStation);

    //TStationRW.Create(AStation.GetCode, AStation.GetName

//# END TODO
end;

function TStationSetRW.CanAddStation(AStation: TStationR): Boolean;
begin
//# BEGIN TODO
    // pre: True
    // ret: ValidStationCode(AStation.GetCode) and
    //      ValidStationName(AStation.GetName) and
    //      not HasCode(AStation.GetCode) and not HasName(AStation.GetName)

    result := ValidStationCode(AStation.GetCode) and
              ValidStationName(AStation.GetName) and
              not HasCode(AStation.GetCode) and
              not HasName(AStation.GetName);

//# END TODO
end;

function TStationSetRW.CanDeleteAll: Boolean;
begin
//# BEGIN TODO
    // pre: True
    // ret: True (may be overridden in subclasses)

result := true;

//# END TODO
end;

function TStationSetRW.CanDeleteStation(AStation: TStationR): Boolean;
begin
//# BEGIN TODO
    // pre: True
    // ret: True (may be overridden in subclasses)

    result := true;

//# END TODO
end;

function TStationSetRW.Count: Integer;
begin
//# BEGIN TODO
    // pre: True
    // ret: |Abstr|

  result := FList.Count;

//# END TODO
end;

constructor TStationSetRW.Create;
begin
//# BEGIN TODO
    // pre: True
    // post: Abstr = {}

    inherited Create;
    FList := TObjectList.Create;

//# END TODO
end;

procedure TStationSetRW.DeleteAll;
begin
//# BEGIN TODO
    // pre: CanDeleteAll
    // post: Abstr = {}

    Assert( CanDeleteAll, 'TStation.SetRW.DeleteAll.pre failed');
        FList.Clear;

//# END TODO
end;

procedure TStationSetRW.DeleteStation(AStation: TStationR);
begin
//# BEGIN TODO

 FList.Remove(AStation); //??

//# END TODO
end;

destructor TStationSetRW.Destroy;
begin
//# BEGIN TODO

 inherited;  // Destroy;
 // FList.Destroy
 FList.Free;

//# END TODO
end;

function TStationSetRW.GetStation(I: Integer): TStationR;
begin
//# BEGIN TODO
    // pre: 0 <= I < Count
    // ret: Abstr[I]

    Assert( (0 <= I) and (I <{=} Count), Format('TStationSetRW.GetStation.pre failed: I= %d', [I]));

    result := FList.Items[I] as TStationR;

//# END TODO
end;

{ TLineR --------------------------------------------------------------------- }

function TLineR.HasStop(AStation: TStationR): Boolean;
var
  I: Integer;
begin
//# BEGIN TODO
// pre: True
    // ret: (exists I: 0 <= I < Count: Stop(I) = AStation )
    I := 0;
    result := true;

    while (I < Count) and (Stop(I) <> AStation) do
    begin
      Inc(I);
    end;

    if I = Count then
    begin
      result := false;
    end;


//# END TODO
end;

function TLineR.IsCircular: Boolean;
begin
//# BEGIN TODO
    // pre: True
    // ret: loCircular in GetOptions

    result := loCircular in GetOptions;
//# END TODO
end;

function TLineR.IsOneWay: Boolean;
begin
//# BEGIN TODO
    // pre: True
    // ret: loOneWay in GetOptions

    result := loOneWay in GetOptions;

//# END TODO
end;

function TLineR.TerminalA: TStationR;
begin
//# BEGIN TODO
    // pre: Count > 0
    // ret: Stop(0)

    Assert( Count > 0, 'TLineR.TerminalA.pre failed');

    result := Stop(0);

//# END TODO
end;

function TLineR.TerminalB: TStationR;
begin
//# BEGIN TODO
    // pre: Count > 0
    // ret: Stop(Count - 1)

    Assert( Count > 0, 'TLineR.TerminalB.pre failed');

    result := Stop(Count - 1);

//# END TODO
end;

{ TLineRW -------------------------------------------------------------------- }

procedure TLineRW.AddStop(AStation: TStationR);
begin
//# BEGIN TODO

    // pre: CanAddStop(AStation)
    // post: Abstr = old Abstr ++ [AStation]
   Assert( CanAddStop(AStation), 'TLineSetRW.AddStop.pre failed');

   FList.Add(AStation);

//# END TODO
end;

function TLineRW.CanAddStop(AStation: TStationR): Boolean;
begin
//# BEGIN TODO
    // pre: True
    // ret: not HasStop(AStation)

    result := not HasStop(AStation);

//# END TODO
end;

function TLineRW.CanDeleteAll: Boolean;
begin
//# BEGIN TODO

result := true;


//# END TODO
end;

function TLineRW.CanDeleteStop(I: Integer): Boolean;
begin
//# BEGIN TODO

    // pre: True
    // ret: 0 <= I < Count

    result := (0 <= I) and (I < Count);

//# END TODO
end;

function TLineRW.CanInsertStop(I: Integer; AStation: TStationR): Boolean;
begin
//# BEGIN TODO

  // pre: True
  // ret: (0 <= I <= Count) and not HasStop(AStation)

  result := ( 0<= I) and (I <= Count) and not HasSTop(ASTation);

//# END TODO
end;

function TLineRW.CanSwapStops(I, J: Integer): Boolean;
begin
//# BEGIN TODO

    // pre: True
    // ret: (0 <= I < Count) and (0 <= J < Count)

    result := ( 0 <= I) and ( I < Count) and
              ( 0 <= J) and ( J < Count);

//# END TODO
end;

function TLineRW.Count: Integer;
begin
//# BEGIN TODO

    // pre: True
    // ret: |Abstr|

  result := FList.Count;


//# END TODO
end;

constructor TLineRW.Create(ACode, AName: String; AOptions: TLineOptions);
begin
//# BEGIN TODO

    // pre: ValidLineCode(ACode), ValidLineName(AName)
    // post: GetCode = ACode and GetName = AName and GetOptions = AOptions
    //       and (Count = 0)

    Assert( ValidLineCode(ACode) and ValidLineName(AName), 'TLineRW.Create.pre falied');

    FCode := ACode;
    FName := AName;
    FOptions := AOptions;
    FList := TObjectList.Create(false);

//# END TODO
end;

procedure TLineRW.DeleteAll;
begin
//# BEGIN TODO

    // pre: CanDeleteAll
    // post: Abstr = []

    Assert( CanDeleteAll, 'TLineRW.DeleteAll.pre failed');

    FList.Clear;

//# END TODO
end;

procedure TLineRW.DeleteStop(I: Integer);
begin
//# BEGIN TODO

    // pre: CanDeleteStop(I)
    // post: Abstr = old Abstr[0..I) ++ old Abstr[I+1..Count)

    Assert( CanDeleteStop(I), 'TLIneRW.DeleteStop.pre failed');

    FList.Delete(I);

//# END TODO
end;

destructor TLineRW.Destroy;
begin
//# BEGIN TODO

    // pre: True
    // effect: FList is freed

    FList.Free;
    inherited;   // ??


//# END TODO
end;

function TLineRW.GetCode: String;
begin
//# BEGIN TODO
    // pre: True

    result := FCode;

//# END TODO
end;

function TLineRW.GetName: String;
begin
//# BEGIN TODO

    // pre: True

    result := FName;


//# END TODO
end;

function TLineRW.GetOptions: TLineOptions;
begin
//# BEGIN TODO

    // pre: True

    Result := FOptions;


//# END TODO
end;

function TLineRW.IndexOf(AStation: TStationR): Integer;
begin
//# BEGIN TODO

    // pre: True
    // ret: I such that Abstr[I] = AStation, or else -1

    result := FList.IndexOf(AStation);

//# END TODO
end;

procedure TLineRW.InsertStop(I: Integer; AStation: TStationR);
begin
//# BEGIN TODO
    // pre: CanInsertStop(I, AStation)
    // post: Abstr = (old Abstr[0..I) ++ [AStation] ++ (old Abstr[I..Count))

    Assert( CanInsertStop( I, AStation), 'TLineRW.InsertSTop.pre falied');

  FList.Insert(I, AStation);

//# END TODO
end;

procedure TLineRW.SetOptions(AOptions: TLineOptions);
begin
//# BEGIN TODO

    // pre: True
    // post: GetOptions = AOptions

    FOptions := AOptions;


//# END TODO
end;

function TLineRW.Stop(I: Integer): TStationR;
begin
//# BEGIN TODO

    // pre: 0 <= I < Count
    // ret: Abstr[I]

    Assert( ( 0<= I) and (I < Count), 'TLineRW.Stop.pre failed');

    Result := FList.Items[I] as TStationR;

//# END TODO
end;

procedure TLineRW.SwapStops(I, J: Integer);
begin
//# BEGIN TODO

    // pre: CanSwapStops(I,J)
    // post:
    //   let X = old Abstr[I], Y = old Abstr[J},
    //      S0 = old Abstr[0..I), S1 = old Abstr[I+1..J),
    //      S2 = old Abstr[J+1..Count)
    //   in Abstr = S0 ++ [Y] ++ S1 ++ [X] ++ S2

    Assert( CanSwapStops( I,J), 'TLineRW.SwapSTops.pre failed');

    FList.Exchange(I, J);

//# END TODO
end;

{ TLineSetR ------------------------------------------------------------------ }

function TLineSetR.HasCode(ACode: String): Boolean;
var
  I: Integer;
begin
//# BEGIN TODO

    // pre: True
    // ret: (exists I: 0 <= I < Count: GetLine(I).GetCode = ACode )

    I:= 0;
    result := true;

    while (I < Count) and (GetLine(I).GetCode <> ACode) do
    begin
      Inc(I);
    end;

    if I = Count then
    begin
      result := false;
    end;

//# END TODO
end;

function TLineSetR.HasLine(ALine: TLineR): Boolean;
var
  I: Integer;
begin
//# BEGIN TODO

    // pre: True
    // ret: (exists I: 0 <= I < Count: GetLine(I) = ALine )

    I := 0;
    result := true;

    while (I < Count) and (GetLine(I) <> ALine) do
    begin
      Inc(I);
    end;

    if I = Count then
    begin
      result := false;
    end;

//# END TODO
end;

function TLineSetR.HasName(AName: String): Boolean;
var
  I: Integer;
begin
//# BEGIN TODO

    // pre: True
    // ret: (exists I: 0 <= I < Count: GetLine(I).GetName = AName )

    I := 0;
    result := true;

    while (I < Count) and (GetLine(I).GetName <> AName) do
    begin
      Inc(I);
    end;

    if I = Count then
    begin
      result := false;
    end;

//# END TODO
end;

function TLineSetR.HasStop(AStation: TStationR): Boolean;
var
  I: Integer;
begin
//# BEGIN TODO

    // pre: True
    // ret: (exists I: 0 <= I < Count: GetLine(I).HasStop(AStation))

    I := 0;
    result := true;

    while (I < Count) and (not GetLine(I).HasStop(AStation)) do
    begin
      Inc(I);
    end;

    if I = Count then
    begin
      result := false;
    end;

//# END TODO
end;

function TLineSetR.IndexOfCode(ACode: String): Integer;
var
  I: Integer;
begin
//# BEGIN TODO

    // pre: True
    // ret: I such that GetLine(I).GetCode = ACode, or else -1

    I := Count;

    while (I > -1) and (GetLine(I).GetCode <> ACode) do
    begin
      Dec(I);
    end;

    result := I;

//# END TODO
end;

function TLineSetR.IndexOfName(AName: String): Integer;
var
  I: Integer;
begin
//# BEGIN TODO

    // pre: True
    // ret: I such that GetLine(I).GetName = AName, or else -1

    I := Count;

    while (I > -1) and (GetLine(I).GetName <> AName) do
    begin
      Dec(I);
    end;

    result := I;


//# END TODO
end;

function TLineSetR.IsEmpty: Boolean;
begin
//# BEGIN TODO

    // pre: True
    // ret: Count = 0

    result := Count = 0;

//# END TODO
end;

{ TLineSetRW ----------------------------------------------------------------- }

procedure TLineSetRW.AddLine(ALine: TLineR);
begin
//# BEGIN TODO

    // pre: CanAddLine(ALine)
    // post: Abstr = old Abstr U {ALine}

    Assert( CanAddLine(ALine), 'TLineSetRW.AddLine.pre failed');

    FList.Add(ALine);

//# END TODO
end;

procedure TLineSetRW.DeleteStation(AStation: TStationR);
var
  I: Integer;
begin
//# BEGIN TODO

    // pre: True
    // post: (forall L: L in Abstr: L.Abstr = old L.Abstr \ {AStation})

    FList.Remove(AStation); // ???

//# END TODO
end;

function TLineSetRW.CanAddLine(ALine: TLineR): Boolean;
begin
//# BEGIN TODO

    // pre: True
    // ret: ValidLineCode(ALine.GetCode) and ValidLineName(ALine.GetName) and
    //      not HasCode(ALine.GetCode) and not HasName(ALine.GetName)

    result := ValidLineCode(ALine.GetCode) and ValidLineName(ALine.GetName) and
              not HasCode(ALine.GetCode) and not HasName(ALine.GetName);

 //# END TODO
end;

function TLineSetRW.CanDeleteAll: Boolean;
begin
//# BEGIN TODO

 result := true;

//# END TODO
end;

function TLineSetRW.CanDeleteLine(ALine: TLineR): Boolean;
begin
//# BEGIN TODO


result := true;

//# END TODO
end;

function TLineSetRW.Count: Integer;
begin
//# BEGIN TODO
    // pre: True
    // ret: |Abstr|

   result := FList.Count;

//# END TODO
end;

constructor TLineSetRW.Create;
begin
//# BEGIN TODO

    // pre: True
    // post: Abstr = {}

    inherited Create;

    FList := TObjectList.Create;


//# END TODO
end;

procedure TLineSetRW.DeleteAll;
begin
//# BEGIN TODO

    // pre: CanDeleteAll
    // post: Abstr = {}

    Assert( CanDeleteAll, 'TLineSetRW.DeleteAll.pre failed');

    FList.Clear;


//# END TODO
end;

procedure TLineSetRW.DeleteLine(ALine: TLineR);
begin
//# BEGIN TODO

    // pre: CanDeleteLine(ALine)
    // post: Abstr = old Abstr \ {ALine}

    Assert( CanDeleteLine(ALine), 'TLineSetRW.DeleteLine.pre failed');

    FList.Remove(ALine);


//# END TODO
end;

destructor TLineSetRW.Destroy;
begin
//# BEGIN TODO

    // pre: True
    // effect: FList is freed


    FList.Free;
    inherited;

//# END TODO
end;

function TLineSetRW.GetLine(I: Integer): TLineR;
begin
//# BEGIN TODO

    // pre: 0 <= I < Count
    // ret: Abstr[I]

    Assert( (0 <= I) and (I < Count), 'TLineSetRW.GetLine.pre failed');

    result := FList.Items[I] as TLineR;

//# END TODO
end;

{ TNetwork ------------------------------------------------------------------- }

procedure TNetwork.AddLine(ALine: TLineR);
begin
//# BEGIN TODO

    // pre: CanAddLine(ALine)
    // post: GetLineSet.Abstr = old GetLineSet.Abstr U {ALine}

    Assert( CanAddLine(ALine), 'TNetwork.AddLine.pre failed');

   FLineSet.AddLine(ALine);

//# END TODO
end;

function TNetwork.CanAddLine(ALine: TLineR): Boolean;
begin
//# BEGIN TODO
    // pre: True
    // ret: IsConsistentLine(ALine, GetStationSet) and
    //      GetLineSet.CanAddLine(ALine)

    result:= IsConsistentLine(ALine, GetStationSet) and
          FLineSet.CanAddLine(ALine);

//# END TODO
end;

function TNetwork.CanAddStation(AStation: TStationR): Boolean;
begin
//# BEGIN TODO

    // pre: True
    // ret: GetStationSet.CanAddStation(AStation)

    result := FStationSet.CanAddStation(AStation);


//# END TODO
end;

function TNetwork.CanDeleteAll: Boolean;
begin
//# BEGIN TODO

result := true;

//# END TODO
end;

function TNetwork.CanDeleteLine(ALine: TLineR): Boolean;
begin
//# BEGIN TODO

    // pre: True
    // ret: GetLineSet.CanDeleteLine(ALine)

    result := FLineSet.CanDeleteLine(ALine);

//# END TODO
end;

function TNetwork.CanDeleteStation(AStation: TStationR): Boolean;
begin
//# BEGIN TODO

    // pre: True
    // ret: not GetLineSet.HasStop(AStation)

    result := not FLineSet.HasStop(AStation);


//# END TODO
end;

constructor TNetwork.Create(AName: String; AStationSet: TStationSetRW;
  ALineSet: TLineSetRW);
begin
//# BEGIN TODO

    // pre: ValidNetworkName(AName), IsConsistent(AStationSet, ALineSet)
    // post: GetName = AName and GetStationset = AStationSet and
    //       GetLineset = ALineSet

  Assert( ValidNetworkName(AName) and IsConsistentNetwork(AStationSet, ALineSet),
  'TNetwork.Create.pre failed');

  inherited Create;

  FName := AName;
  FStationSet := AStationSet;
  FLineSet := ALineSet;

//# END TODO
end;

constructor TNetwork.CreateEmpty(AName: String);
begin
//# BEGIN TODO

    // pre: ValidNetworkName(AName)
    // post: GetName = AName and GetStationSet.Count = 0 and
    //       GetLineSet.Count = 0

    Assert( ValidNetworkName(AName), 'TNetwork.CreateEmpty.pre failed');

    inherited Create;
    FName := AName;
    FStationSet := TStationSetRW.Create;
    FLineSet := TLineSetRW.Create;


//# END TODO
end;

procedure TNetwork.DeleteAll;
begin
//# BEGIN TODO

    // pre: CanDeleteAll
    // post: GetStationSet.Count = 0 and GetLineSet.Count = 0

    Assert( CanDeleteAll, 'TNetwork.DeleteAll.pre failed');

    FStationSet.DeleteAll;

//# END TODO
end;

procedure TNetwork.DeleteLine(ALine: TLineR);
begin
//# BEGIN TODO

    // pre: CanDeleteLine(ALine: TLineR)
    // post: GetLineSet.Abstr = old GetLineSet.Abstr \ {ALine}

    Assert( CanDeleteLine(ALine), 'TNetwork.DeleteLine.pre failed');

    FLineSet.DeleteLine(ALine);


//# END TODO
end;

procedure TNetwork.DeleteStation(AStation: TStationR);
begin
//# BEGIN TODO

    // pre: True
    // post: GetStationSet.Abstr = old GetStation.Abstr \ {AStation} and
    //         (forall L: L in GetLineSet.Abstr:
    //           L.Abstr = old L.Abstr \ {AStation})

    FStationSet.DeleteStation(AStation);

//# END TODO
end;

destructor TNetwork.Destroy;
begin
//# BEGIN TODO

    // pre: True
    // effect: FLineSet is freed and FStationSet is freed

    FLineSet.Free;
    FStationSet.Free;
    inherited;


//# END TODO
end;

function TNetwork.GetLineSet: TLineSetR;
begin
//# BEGIN TODO

    // pre: True

    result := FLineSet;


//# END TODO
end;

function TNetwork.GetName: string;
begin
//# BEGIN TODO

    // pre: True

    result := FName;

//# END TODO
end;

procedure TNetwork.SetName(AName: String);
begin
//# BEGIN TODO
    // pre: ValidNetworkName(AName)
    // post: GetName = AName

    Assert( ValidNetworkName(AName), 'TNetwork.SetName.pre failed');

    FName := AName;

//# END TODO
end;

function TNetwork.GetStationSet: TStationSetR;
begin
//# BEGIN TODO

  // pre: True

  result := FStationSet;

//# END TODO
end;

function TNetwork.IsConsistentLine(ALine: TLineR;
  AStationSet: TStationSetR): Boolean;
var
  I: integer;
begin
//# BEGIN TODO

    // pre: True
    // ret: (forall J: 0 <= J < ALine.Count:
    //        AStationSet.HasStation(ALine.Stop(J))

  I := 0;
  result := false;

  while (I < ALine.Count) and (AStationSet.HasStation(ALine.Stop(I))) do
  begin
    Inc(I);
  end;

  if I = ALine.Count then
  begin
    result := true;
  end;


//# END TODO
end;

function TNetwork.IsConsistentNetwork(AStationSet: TStationSetR;
           ALineSet: TLineSetR): Boolean;
    // ret:
    //   let SS = AStationSet, LS = ALineSet
    //     (forall I: 0<=I<LS.Count: IsConsistentLine(LS.GetLine(I), SS)
var
  I: Integer;
begin
//# BEGIN TODO

    // pre: True
    // ret:
    //   let SS = AStationSet, LS = ALineSet
    //   in  (forall I: 0 <= I < LS.Count: IsConsistentLine(LS.GetLine(I), SS)

  I := 0;
  result := false;

  while (I < ALineSet.Count) and (IsConsistentLine(ALineSet.GetLine(I),AStationSet)) do
  begin
    Inc(I);
  end;

  if I = ALineSet.Count then
  begin
    result := true;
  end;

//# END TODO
end;

procedure TNetwork.AddStation(AStation: TStationR);
begin
//# BEGIN TODO

    // pre: CanAddStation(AStation)
    // post: GetStationSet.Abstr = old GetStationSet.Abstr U {AStation}

    Assert( CanAddStation(AStation), 'TNetwork.AddStation.pre failed');

   FStationSet.AddStation(AStation);

//# END TODO
end;

function TNetwork.CanSetStationCode(AStation: TStationR;
           ACode: String): Boolean;
begin
//# BEGIN TODO

    // pre: True
    // ret: GetStationSet.CanSetStationCode(AStation, ACode)

    result := FStationSet.CanSetStationCode(AStation, ACode);

//# END TODO
end;

function TNetwork.CanSetStationName(AStation: TStationR;
           AName: String): Boolean;
begin
//# BEGIN TODO

    // pre: True
    // ret: GetStationSet.CanSetStationName(AStation, AName)

    result := FStationSet.CanSetStationName(AStation, AName);

//# END TODO
end;

procedure TNetwork.SetStationCode(AStation: TStationR; ACode: String);
begin
//# BEGIN TODO

    // pre: CanSetStationCode(AStation, ACode)
    // post: AStation.GetCode = ACode

    Assert( CanSetStationCode(AStation, ACode), 'TNetwork.SetStationCode.pre failed');

    FStationSet.SetStationCode(AStation, ACode);

//# END TODO
end;

procedure TNetwork.SetStationName(AStation: TStationR; AName: String);
begin
//# BEGIN TODO

    // pre: CanSetStationName(AStation, AName)
    // post: AStation.GetName = AName

    Assert( CanSetStationName(AStation, AName), 'TNetwork.SetStationName.pre failed');

    FStationSet.SetStationName(AStation, AName);

//# END TODO
end;

function TNetwork.CanSetLineCode(ALine: TLineR; ACode: String): Boolean;
begin
//# BEGIN TODO

    // pre: True
    // ret: GetLineSet.CanSetLineCode(ALine, ACode)

    result := FLineSet.CanSetLineCode(ALine, ACode);

//# END TODO
end;

function TNetwork.CanSetLineName(ALine: TLineR; AName: String): Boolean;
begin
//# BEGIN TODO

    // pre: True
    // ret: GetLineSet.CanSetLineName(ALine, AName)

    result := FLineSet.CanSetLineName(ALine, AName);

//# END TODO
end;

procedure TNetwork.SetLineCode(ALine: TLineR; ACode: String);
begin
//# BEGIN TODO

    // pre: CanSetLineCode(ALine, ACode)
    // post: ALine.GetCode = ACode

    Assert( CanSetLineCode(ALine, ACode), 'TNetwork.SetLineCode.pre failed');

    FLineSet.SetLineCode(ALine, ACode);


//# END TODO
end;

procedure TNetwork.SetLineName(ALine: TLineR; AName: String);
begin
//# BEGIN TODO

    // pre: CanSetLineName(ALine, AName)
    // post: ALine.GetName = AName

    Assert( CanSetLineName(ALine, AName), 'TNetwork.SetLineName.pre failed');

    FLineSet.SetLineName(ALine, AName);


//# END TODO
end;

function TStationSetRW.CanSetStationCode(AStation: TStationR;
           ACode: String): Boolean;
begin
//# BEGIN TODO
    // pre: True
    // ret: ValidStationCode(ACode) and HasStation(AStation) and
    //      not(HasCode(ACode))

    result := ValidStationCode(ACode) and
              HasStation(AStation) and
              not (HasCode(ACode));

//# END TODO
end;

function TStationSetRW.CanSetStationName(AStation: TStationR;
           AName: String): Boolean;
begin
//# BEGIN TODO

    // pre: True
    // ret: ValidStationName(AName) and HasStation(AStation) and
    //      not(HasName(AName))

    result := ValidStationName(AName) and HasStation(AStation) and
          not(HasName(AName));

//# END TODO
end;

function TLineSetRW.CanSetLineCode(ALine: TLineR; ACode: String): Boolean;
begin
//# BEGIN TODO

    // pre: True
    // ret: ValidLineCode(ACode) and HasLine(ALine) and
    //       not(HasCode(ACode))

    result := ValidLineCode(ACode) and HasLine(ALine) and
           not(HasCode(ACode));


//# END TODO
end;

function TLineSetRW.CanSetLineName(ALine: TLineR; AName: String): Boolean;
begin
//# BEGIN TODO

    // pre: True
    // ret: ValidLineName(AName) and HasLine(ALine) and
    //       not(HasName(AName))

    result := ValidLineName(AName) and HasLine(ALine) and
           not(HasName(AName));


//# END TODO
end;

procedure TLineSetRW.SetLineCode(ALine: TLineR; ACode: String);

var VName: string;
    VOptions: TLineOptions;

begin
//# BEGIN TODO

    // pre: CanSetLineCode(ALine, ACode)
    // post: ALine.GetCode = ACode

    Assert( CanSetLineCode(ALine, ACode), 'TLineSetRW.SetLineCode.pre failed');

    VName := ALine.GetName;
    VOptions := ALine.GetOptions;

    FList.Remove(ALine);
    FList.Add(TLineRW.Create(ACode, VName, VOptions));

//# END TODO
end;

procedure TLineSetRW.SetLineName(ALine: TLineR; AName: String);
var VCode: string;
    VOptions: TLineOptions;

begin
//# BEGIN TODO

    // pre: CanSetLineName(ALine, AName)
    // post: ALine.GetName = AName

    Assert( CanSetLineName(ALine, AName), 'TLineSetRW.SetLineName.pre failed');

    VCode := ALine.GetCode;
    VOptions := ALine.GetOptions;

    FList.Remove(ALine);
    FList.Add(TLineRW.Create(VCode, AName, VOptions));

//# END TODO
end;


end.
