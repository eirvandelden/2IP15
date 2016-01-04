unit MinTransfersplanner;

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
var
  VRoute: TRouteRW;
  VSegment: TRouteSegmentR;
  VQueue: TObjectList;
  VTargetLine: TLineR;
  VL, VH: TLineR;
  VS, VQ, VDirection : TStationR;
  I, J: Integer;
begin
  // initialization
  VQueue := TObjectList.Create(false);
  VTargetLine := nil;
  with FNetwork.GetLineSet do
    for I := 0 to Count - 1 do
    begin
      VL := GetLine(I);
      VL.Data := TLineData.Create;
      with VL.Data as TLineData do
      begin
        FParent := nil;
        if VL.HasStop(A)
        then
          begin
            FState := lsGrey;
            FEntry := A;
            VQueue.Add(VL);
            if VL.HasStop(B)
            then VTargetLine := VL;
          end
        else
          begin
            FState := lsWhite;
            FEntry := nil;
          end;
      end{with};
    end{for};

  // main loop
  while (VQueue.Count > 0) and (VTargetLine = nil) do
  begin
    VL := VQueue.Items[0] as TLineR;
    VQueue.Delete(0);
    for I := 0 to VL.Count - 1 do
    begin
      VS := VL.Stop(I);
      with FNetwork.GetLineSet do
        for J := 0 to Count - 1 do
        begin
          VH := GetLine(J);
          if VH.HasStop(VS) and ((VH.Data as TLineData).FState = lsWhite)
          then
            with VH.Data as TLineData do
            begin
              FParent := VL;
              FEntry := VS;
              FState := lsGrey;
              VQueue.Add(VH);
              if VH.HasStop(B)
              then VTargetLine := VH
            end{with}
        end{for};
    end{for};
    (VL.Data as TLineData).FState := lsBlack;
  end{while};

  // construct route
  VRoute := TRouteRW.Create;
  if VTargetLine <> nil then
  begin
    VL := VTargetLine;
    VQ := B;
    while VL <> nil do
    begin
      VS := (VL.Data as TLineData).FEntry;
      with VL do
      begin
        if IndexOf(VS) <= IndexOf(VQ)
        then VDirection := Stop(Count - 1)
        else VDirection := Stop(0);
      end;
      VSegment := TRouteSegmentR.Create(VS, VL, VDirection, VQ);
      VRoute.Insert(0, VSegment);
      VQ := VS;
      VL := (VL.Data as TLineData).FParent;
    end{while};

  end{if};

  // finalization
  with FNetwork.GetLineSet do
    for I := 0 to Count - 1 do
      GetLine(I).Data.Free;
  VQueue.Free;

  Result := VRoute;
end;



function TMinTransfersPlanner.FindRoutes(A, B: TStationR;
            AOption: TSearchOption): TRouteSet;
begin
  Result := TRouteSet.Create;
  Result.Add(FindRoute(A, B, AOption));
end;

end.
