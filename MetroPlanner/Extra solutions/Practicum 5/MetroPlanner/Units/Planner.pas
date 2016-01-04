unit Planner;

interface
uses
  Contnrs,
  MetroBase;

type

  //----------------------------------------------------------------------------
  // A route segment is a 4 tuple (from, line, dir, to), where
  // - from is a station
  // - line is a line
  // - direction is a station (one of the end points of the line)
  // - to is a station
  //----------------------------------------------------------------------------
  TRouteSegmentR =
  class(TObject)
  protected
    FFrom: TStationR;
    FLine: TLineR;
    FDirection: TStationR;
    FTo: TStationR;
  public
    // construction/destruction ---------------------------
    constructor Create(AFrom: TStationR; ALine: TLineR; ADirection: TStationR;
                  ATo: TStationR);

    // basic queries --------------------------------------
    function FromStation: TStationR; virtual;
    function Line: TLineR; virtual;
    function Direction: TStationR; virtual;
    function ToStation: TStationR; virtual;
    function StopCount: Integer; virtual;
  end;


  //----------------------------------------------------------------------------
  // A route is a sequence of route segments [s_0,...,s_(n-1)], where
  // - 1 <= N
  // - (forall i: 1<=i<n: s_(i-1).to = s_i.from )
  // - SegmentCount is the number of segments
  // - GetSegment returns the I-th segment
  // A route can also be seen as a sequence of stops:
  // - StopCount is the number of stops
  // - GetStop returns the I-th stop
  //----------------------------------------------------------------------------
  TRouteR =
  class(TObject)
  public
    // basic queries --------------------------------------
    function SegmentCount: Integer; virtual; abstract;
    function GetSegment(I: Integer): TRouteSegmentR; virtual; abstract;

    // derived queries ------------------------------------
    function TransferCount: Integer; virtual;
    // pre: true
    // ret: (SegmentCount - 1) max 0
    function StopCount: Integer; virtual;
    // pre: true
    // ret: (sum: 0 <= I < SegmentCount: GetSegment(I).StopCount)
    //         - (SegmentCount - 1)
//    function GetStop(I: Integer): TStationR; virtual;
    // pre: 0 <= I < StopCount
    // ret: "I-th stop in sequence obtained by concatenating segments,
    //         excluding duplicates at segment borders"

    // invariants -----------------------------------------
    // I0: 1 <= SegmentCount
    // I1: (forall I: 1 <= I < SegmentCount:
    //         GetSegment(I-1).FromStation = GetSegment(I).FromStation )

  end;

  TRouteRW =
  class(TRouteR)
  protected
    FList: TObjectList;
  public
    // construction/destruction
    constructor Create;
    destructor  Destroy; override;

    // basic queries --------------------------------------
    function SegmentCount: Integer; override;
    function GetSegment(I: Integer): TRouteSegmentR; override;

    // preconditions --------------------------------------
    function CanAdd(ASegment: TRouteSegmentR): Boolean;
    // pre: true
    // ret: (SegmentCount = 0) orelse
    //         (GetSegment(SegmentCount - 1).ToStation = ASegment. FromStation)

    // commands -------------------------------------------
    procedure Clear; virtual;
    procedure Add(ASegment: TRouteSegmentR); virtual;
    procedure Insert(I: Integer; ASegment: TRouteSegmentR);
    { etc., as needed}

  end;


  //----------------------------------------------------------------------------
  // Perhaps it might be useful to also have a notion of a _set_ of routes and
  // one or more _filters_ to filter out subsets.
  // E.g.:
  //   first, find the set S of all routes from A to B with a minimal number
  //     of transfers;
  //   second, filter from S those routes with a minimal (or almost minimal)
  //     number of stops;
  //----------------------------------------------------------------------------
  TRouteSet =
  class(TObject)
  protected
    FList: TObjectList;
  public
    // construction/destruction
    constructor Create;
    // pre: true
    // post: Abstr = empty
    destructor Destroy; override;

    // basic queries --------------------------------------
    function RouteCount: Integer;
    // pre: true
    // ret: |Abstr|
    function GetRoute(I: Integer): TRouteR;
    // pre: 0 <= I < RouteCount
    // ret: Abstr[I]

    // derived queries ------------------------------------
    function MinStops: Integer;
    // pre: true
    // ret: (min I: 0 <= I < RouteCount: GetRoute(I).StopCount
    function MinTransfers: Integer;
    // pre: true
    // ret: (min I: 0 <= I < RouteCount: GetRoute(I).TransferCount

    // commands -------------------------------------------
    procedure Add(ARoute: TRouteR);
    // pre: true
    // effect: Abstr := Abstr union {ARoute}
    procedure Delete(ARoute: TRouteR);
    // pre: true
    // effect: Abstr ;= Abstr - {ARoute}
    procedure Clear;
    // pre: true
    // post: Abstr = empty
    procedure FilterMinStops; virtual;
    // pre: true
    // post: Abstr =
    //         {I: (0 <= I < RouteCount) and GetRoute(I).StopCount = MinStops:
    //           GetRoute(I)}
    procedure FilterMinTransfers; virtual;
    // pre: true
    // post: Abstr =
    //   {I: (0 <= I < RouteCount) and GetRoute(I).TransferCount = MinTransfers:
    //           GetRoute(I)}

    // model variables ------------------------------------
    // Abstr: set of TRouteR objects represented by an object of this class
  end;

  //----------------------------------------------------------------------------
  // Search options:
  // - soTransfer    : minimal number of transfers
  // - soTransferStop: minimal number of transfers, then minimal number of stops
  // - soStop        : minimal number of stops
  // - soStopTransfer: minimal number of stops, then minimal number of transfers
  //----------------------------------------------------------------------------
  TSearchOption = (soAny, soTransfer, soTransferStop, soStop, soStopTransfer);

  TPlanner =
  class(TObject)
  public
    // queries --------------------------------------------
    function FindRoutes(A, B: TStationR; AOption: TSearchOption): TRouteSet;
               virtual; abstract;
    // pre: true
    // ret: set of optimal (according to AOption) routes from A to B
    function FindRoute(A, B: TStationR; AOption: TSearchOption): TRouteR;
               virtual; abstract;
    // pre: true
    // ret: an optimal (According to AOption) route from A to B
  end;


implementation //===============================================================

uses
  Math, SysUtils;

{ TRouteSegmentR }

constructor TRouteSegmentR.Create(AFrom: TStationR; ALine: TLineR; ADirection,
              ATo: TStationR);
begin
  inherited Create;
  FFrom := Afrom;
  FLine := ALine;
  FDirection := ADirection;
  FTo := ATo;
end;

function TRouteSegmentR.Direction: TStationR;
begin
  Result := FDirection;
end;

function TRouteSegmentR.FromStation: TStationR;
begin
  Result := FFrom;
end;

function TRouteSegmentR.Line: TLineR;
begin
  Result := FLine;
end;

function TRouteSegmentR.StopCount: Integer;
begin
  Result := Abs(FLine.IndexOf(FFrom) - FLine.IndexOf(FTo)) + 1;
end;

function TRouteSegmentR.ToStation: TStationR;
begin
  Result := FTo;
end;

{ TRouteR }

//function TRouteR.GetStop(I: Integer): TStationR;
//begin
//  Assert( (0 <= I) and (I < StopCount),
//    Format('Illegal index in TRouter.GetStop: %s', [I]) );
//  {TODO}
//end;

function TRouteR.StopCount: Integer;
var
  I: Integer;
begin
  Result := - (SegmentCount - 1);
  for I := 0 to SegmentCount - 1 do
    Result := Result + GetSegment(I).StopCount;
end;

function TRouteR.TransferCount: Integer;
begin
  Result := Max(SegmentCount - 1, 0);
end;

{ TRouteRW }

procedure TRouteRW.Add(ASegment: TRouteSegmentR);
begin
  Assert(CanAdd(ASegment), 'TRouteRW.Add.pre');
  Flist.Add(ASegment);
end;

function TRouteRW.CanAdd(ASegment: TRouteSegmentR): Boolean;
begin
  if SegmentCount = 0
  then Result := true
  else Result :=(GetSegment(SegmentCount - 1).ToStation = ASegment.FromStation);
end;

procedure TRouteRW.Clear;
begin
  FList.Clear;
end;

constructor TRouteRW.Create;
begin
  inherited Create;
  FList := TObjectList.Create(true);
end;

destructor TRouteRW.Destroy;
begin
  FList.Free;
  inherited;
end;

function TRouteRW.GetSegment(I: Integer): TRouteSegmentR;
begin
  Result := FList.Items[I] as TRouteSegmentR;
end;

procedure TRouteRW.Insert(I: Integer; ASegment: TRouteSegmentR);
begin
  FList.Insert(I, ASegment);
end;

function TRouteRW.SegmentCount: Integer;
begin
  Result := FList.Count;
end;

{ TRouteSet }

procedure TRouteSet.Add(ARoute: TRouteR);
begin
  FList.Add(ARoute);
end;

procedure TRouteSet.Clear;
begin
  FList.Clear;
end;

constructor TRouteSet.Create;
begin
  inherited Create;
  FList := TObjectList.Create(true);
end;

procedure TRouteSet.Delete(ARoute: TRouteR);
begin
  FList.Remove(ARoute);
end;

destructor TRouteSet.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TRouteSet.FilterMinStops;
var
  I, M: Integer;
begin
  M := MinStops;
  for I := RouteCount -1 downto 0 do  // N.B. downward direction important
    if GetRoute(I).StopCount > M
    then Delete(GetRoute(I));
end;

procedure TRouteSet.FilterMinTransfers;
var
  I, M: Integer;
begin
  M := MinTransfers;
  for I := RouteCount -1 downto 0 do  // N.B. downward direction important
    if GetRoute(I).TransferCount > M
    then Delete(GetRoute(I));
end;

function TRouteSet.GetRoute(I: Integer): TRouteR;
begin
  Assert( (0 <= I) and (I < RouteCount),
    Format('Illegal index in TRouteSet.GetRoute: %s', [I]) );
  Result := FList.Items[I] as TRouteR;
end;

function TRouteSet.MinStops: Integer;
var
  I: Integer;
begin
  Result := MaxInt;
  for I := 0 to RouteCount - 1 do
    Result := Min(Result, GetRoute(I).StopCount);
end;

function TRouteSet.MinTransfers: Integer;
var
  I: Integer;
begin
  Result := MaxInt;
  for I := 0 to RouteCount - 1 do
    Result := Min(Result, GetRoute(I).TransferCount);
end;

function TRouteSet.RouteCount: Integer;
begin
  Result := FList.Count;
end;


end.
 