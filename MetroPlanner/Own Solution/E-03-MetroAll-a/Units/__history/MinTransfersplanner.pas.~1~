unit MinTransfersplanner;
//# BEGIN TODO  Completed by: author name, id.nr., date
  { Replace this line by your text }
//# END TODO

interface

uses
  Contnrs,
  MetroBase, Planner;

type
  TMinTransfersPlanner =
  class(TPlanner)
  protected
    FNetwork: TNetwork;
  public
    // construction/destruction
    constructor Create(ANetwork: TNetwork);

    // queries --------------------------------------------
    function FindRoutes(A, B: TStationR; AOption: TSearchOption): TRouteSet;
               override;
    // pre: true
    // ret: set of optimal (according to AOption) routes from A to B
    function FindRoute(A, B: TStationR; AOption: TSearchOption): TRouteR;
               override;
    // pre: true
    // ret: a route from A to B with minimal number of transfers
  end;


implementation //===============================================================

// Auxiliary types
type
  TLineState = (lsWhite, lsGrey, lsBlack);

  TLineData =
  class(TObject)
    FState: TLineState;
    FParent: TLineR;
    FEntry: TStationR;
  end;

{ TBFSPlanner }

constructor TMinTransfersPlanner.Create(ANetwork: TNetwork);
begin
  inherited Create;
  FNetwork := ANetwork;
end;

function TMinTransfersPlanner.FindRoute(A, B: TStationR;
           AOption: TSearchOption): TRouteR;
//# BEGIN TODO
// Replace this by your own declarations
//# END TODO
begin
//# BEGIN TODO
// Replace the following code by an algorithm which finds a route with a
// minimal number of TRANSFERS from station A to station B.
// The parameter AOption may be ignored.
// An abstract code scheme for this algorithm can be found in the document
// Metro_Planner_Algorithms.htm .

  Result := TRouteRW.Create;

//# END TODO
end;



function TMinTransfersPlanner.FindRoutes(A, B: TStationR;
            AOption: TSearchOption): TRouteSet;
begin
  Result := TRouteSet.Create;
  Result.Add(FindRoute(A, B, AOption));
end;

end.
