unit MinStopsPlanner;

interface

uses
  Contnrs,
  MetroBase, Planner;

type
  TMinStopsPlanner =
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
    // ret: a route from A to B with minimal number of stops
  end;


implementation //===============================================================

// Auxiliary types
type
  TStationState = (ssWhite, ssGrey, ssBlack);

  TStationData =
  class(TObject)
    FState: TStationState;
    FParent: TStationR;
    FLine: TLineR;
    FDir: TStationR;
    FDist: Integer;
  end;

{ TMinStopsPlanner }

constructor TMinStopsPlanner.Create(ANetwork: TNetwork);
begin
  inherited Create;
  FNetwork := ANetwork;
end;

function TMinStopsPlanner.FindRoute(A, B: TStationR;
           AOption: TSearchOption): TRouteR;
var
  VRoute: TRouteRW;
  VSegment: TRouteSegmentR;
  VQueue: TObjectList;
  VL: TLineR;
  VS, VR, VP, VH: TStationR;
  I, J: Integer;
begin
  // initialization
  with FNetwork.GetStationSet do
    for I := 0 to Count - 1 do
    begin
      VS := GetStation(I);
      VS.Data := TStationData.Create;
      with VS.Data as TStationData do
      begin
        FState := ssWhite;
        FParent := nil;
        FLine := nil;
        FDir := nil;
        FDist := Maxint;
      end{with};
    end{for};

  with A.Data as TStationData do
  begin
    FState := ssGrey;
    FParent := nil;
    FLine := nil;
    FDir := nil;
    FDist := 0;
  end;
  VQueue := TObjectList.Create(false);
  VQueue.Add(A);

  // main loop
  while (VQueue.Count > 0) and ((B.Data as TStationData).FState <> ssGrey) do
  begin
    VS := VQueue.Items[0] as TStationR;
    VQueue.Delete(0);
    with FNetwork.GetLineSet do
      for I := 0 to Count - 1 do
      begin
        VL := GetLine(I);
        J := VL.IndexOf(VS);
        if J <> -1 then
        begin {station VS occurs on line VL; trace its successors on VL}
          if J < VL.Count - 1 then
          begin {trace following stop on line}
            VR := VL.Stop(J + 1);
            with VR.Data as TStationData do
              if FState = ssWhite then
              begin
                FState := ssGrey;
                FParent := VS;
                FLine := VL;
                FDir := VL.Stop(VL.Count - 1);
                FDist := (VS.Data as TStationData).FDist + 1;
                VQueue.Add(VR)
              end{if};
          end{if};
          if 0 < J then
          begin {trace preceding stop on line}
            VR := VL.Stop(J - 1);
            with VR.Data as TStationData do
              if FState = ssWhite then
              begin
                FState := ssGrey;
                FParent := VS;
                FLine := VL;
                FDir := VL.Stop(0);
                FDist := (VS.Data as TStationData).FDist + 1;
                VQueue.Add(VR)
              end{if};
          end{if};
        end{if};
      end{for};
    (VS.Data as TStationData).FState := ssBlack;
  end{while};

  // construct route
  VRoute := TRouteRW.Create;
  if (B.Data as TStationData).FState = ssGrey then
  begin {B is reachable; add route segments to VRoute}
    VP := B;
    while VP <> nil do
    begin
      VH := (VP.Data as TStationData).FParent;
      while (VH <> nil) and
            ((VH.Data as TStationData).FLine = (VP.Data as TStationData).FLine)
      do VH := (VH.Data as TStationData).FParent;
      if VH <> nil then
      begin
        VSegment :=
        TRouteSegmentR.Create(
          VH,
          (VP.Data as TStationData).FLine,
          (VP.Data as TStationData).FDir,
          VP);
        VRoute.Insert(0, VSegment);
      end{if};
      VP := VH
    end{while};
  end{if};

  // finalization
  with FNetwork.GetStationSet do
    for I := 0 to Count - 1 do
      GetStation(I).Data.Free;
  VQueue.Free;

  Result := VRoute;
end;



function TMinStopsPlanner.FindRoutes(A, B: TStationR;
            AOption: TSearchOption): TRouteSet;
begin
  Result := TRouteSet.Create;
  Result.Add(FindRoute(A, B, AOption));
end;

end.
