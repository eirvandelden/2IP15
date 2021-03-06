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
  VRoute                : TRouteRW;
  VSegment              : TRouteSegmentR;
  VQueue                : TObjectList;
  VS                    : TStationR;
  VL                    : TLineR;
  I, J                  : Integer;
  IndexOfNext           : Integer;
  IndexOfPrev           : Integer;
  Index                 : Integer;
  Repetitions           : Integer;
  VDirection            : TStationR;
  SearchTransferStation : TStationR;
begin

  // initialization-------------------------------------------------------------

  (*
    forall U in SS - {S} do
        U.color := white; U.parent := nil; U.line := nil; U.dist := +�
    od;
  *)
  with FNetwork.GetStationSet do begin
    for I := 0 to Count - 1 do begin
      VS := GetStation(I);
      VS.Data := TStationData.Create;
      with VS.Data as TStationData do begin
        FState  := ssWhite;
        FParent := nil;
        FLine   := nil;
        FDist   := MaxInt;
      end;{with}
    end;{for}
  end;{with}

  (*
    S.color := grey; S.parent := nil; S.line := nil; S.dist := 0;
  *)
  with A.Data as TStationData do begin
    FState := ssGrey;
    FDist  := 0;
  end;

  (*
    Q := <S>;
  *)
  VQueue := TObjectList.Create(false);
  VQueue.Add(A);

  // main loop------------------------------------------------------------------

  (*
    while (Q ? <>) and (T.color ? grey) do
        U, Q := first(Q), rest(Q);
  *)
  while (VQueue.Count <> 0) and ((B.Data as TStationData).FState <> ssGrey) do begin
    VS := VQueue.Items[0] as TStationR;
    VQueue.Delete(0);

  (*
        forall L in LL do
            if U occurs on L at some position I then
  *)
    with FNetwork.GetLineSet do begin
      for J := 0 to Count - 1 do begin
        VL := GetLine(J);
        if VL.HasStop(VS) then begin
          I := VL.IndexOf(VS);
  (*
                for possible successors V of U on L do
                    V.color := grey; V.parent := U; V.line := L;
                    V.dist := U.dist + 1; Q := Q ++ <V>;
                od;
  *)
          { Kijk of er een opvolger is }
          IndexOfNext := -1;
          if (I <> VL.Count - 1) then begin // I is niet het eind, er is een volgende
            IndexOfNext := I + 1;
          end
          else if VL.IsCircular then begin // I is wel het eind, maar circular, dus wel een volgende
            IndexOfNext := 0;
          end;

          { Kijk of er een voorganger is }
          IndexOfPrev := -1;
          if (VL.IsOneWay = False) then begin
            if (I <> 0) then begin // I is niet het begin, er is een vorige
              IndexOfPrev := I - 1;
            end
            else if VL.IsCircular then begin // I is wel het begin, maar circular, dus wel een vorige
              IndexOfPrev := VL.Count - 1;
            end;{if}
          end;{if}

          { Handel Voorganger en Opvolger van I af }
          Repetitions := 0;
          while Repetitions <> 2 do begin
            case Repetitions of
            0: Index := IndexOfPrev;                        // for x := 1,2 do
            1: Index := IndexOfNext;
            else
              Break;
            end;{case}

            if Index <> -1 then begin
              with ((VL.Stop(Index) as TStationR).Data as TStationData) do begin
                if (FState = ssWhite) then begin
                  FState  := ssGrey;
                  FParent := VS;
                  FLine   := VL;
                  FDist   := (VS.Data as TStationData).FDist + 1;
                  VQueue.Add(VL.Stop(Index));
                end;{if}
              end;{with}
            end;{if}

            Inc(Repetitions);
          end;{while}
        end;{if}
      end;{for}
    end;{with}

  (*
        U.color := black
  *)
    (VS.Data as TStationData).FState := ssBlack;
  end;{while}

  (*
  {(Q = <>) or (T.color = grey)}
  *)
  { VQueue.Count = 0  or  (B.Data as TStationData).FState = ssGrey }

  // construct route
  VRoute := TRouteRW.Create;

  (*
    if T.color <> grey
    then {T is not reachable from S} path := <>
    else {construct path by following parent pointers}
  *)
  if (B.Data as TStationData).FState = ssGrey then begin
    VS := B;
    while (VS <> A) do begin
      VL := (VS.Data as TStationData).FLine;
      SearchTransferStation := VS;

      { Zoek overstapstation }
      while (VL = (SearchTransferStation.Data as TStationData).FLine) do begin
        SearchTransferStation := (SearchTransferStation.Data as TStationData).FParent;
      end;{while}
      { SearchTransferStation.Data.FLine <> VL, overstapstation gevonden
        ALS = nil, beginstation gevonden }

      { Vind richting }
      with VL do begin
        if IndexOf(VS) <= IndexOf(SearchTransferStation) then
          VDirection := Stop(Count - 1)
        else
          VDirection := Stop(0);
      end;{with}

      { Maak route-segment }
      VSegment := TRouteSegmentR.Create(SearchTransferStation, VL, VDirection, VS);
      VRoute.Insert(0, VSegment);

      { Volgende }
      VS := SearchTransferStation;
    end;{while}

  end;{if}

  {TODO}

  // finalization
  with FNetwork.GetStationSet do
    for I := 0 to Count - 1 do
      GetStation(I).Data.Free;
  VQueue.Free;


  Result := VRoute;

(*
    {initialization}
    forall g in N - {s} do g.color := white; g.parent := nil; g.dist := +� od;
    s.color := grey; s.parent := nil; s.dist := 0;
    Q := <s>;
    {main loop}
    while (Q ? <>) and (T.color ? grey) do
        U, Q := first(Q), rest(Q);
        "process U";
        forall L in LL do
            if U occurs on L at some position I then
                for possible successors V of U on L do
                    V.color := grey; V.parent := U; V.line := L;
                    V.dist := U.dist + 1; Q := Q ++ <V>;
                od;
            fi;
            "process (U,V)";
        od;
        U.color := black
    od;
    {(Q = <>) or (T.color = grey)}
    if T.color ? grey
    then {T is not reachable from S} path := <>
    else {construct path by following parent pointers}
        P := T; path := <T>;
        while P ? nil do
            path := <P.parent,P.line> ++ path;
            P := P.parent
        od
    fi
    {path is a shortest path from S to T}
*)
end;



function TMinStopsPlanner.FindRoutes(A, B: TStationR;
            AOption: TSearchOption): TRouteSet;
begin
  Result := TRouteSet.Create;
  Result.Add(FindRoute(A, B, AOption));
end;

end.
