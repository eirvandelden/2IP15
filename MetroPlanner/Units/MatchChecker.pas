unit MatchChecker;

interface

uses
  MetroBase, MetroVisCom;

//----------------------------------------------------------------------------
// TMatchChecker is a class that determines if a map and a network match.
// Matching maps and networks contain exactly the same stations and lines.
//----------------------------------------------------------------------------
type
  TMatchChecker = class(TObject)
  private
    FNetwork: TNetwork;
    FMap: TMetroMap;
  public
    // construction/deconstruction ---------------------------------------------
    constructor Create(AMap: TMetroMap; ANetwork: TNetwork);
    // pre: True
    // post: FMap = AMap and FNetwork = ANetwork

    // derived queries ---------------------------------------------------------
    function Compatible: Boolean;
    // pre: True
    // ret: (forall S: S in FNetwork.GetStationSet.Abstr:
    //        (exists T: T in FMap.AbstrStations: S.GetCode = T.GetCode))
    //      and
    //      (forall S: S in FMap.AbstrStations:
    //        (exists T: T in FNetwork.GetStationSet.Abstr:
    //          S.GetCode = T.GetCode))
    //      and
    //      (forall L: L in FNetwork.GetLineSet.Abstr:
    //        (exists M: M in FMap.AbstrLines: L.GetCode = M.GetCode))
    //      and
    //      (forall L: L in FMap.AbstrLines:
    //        (exists M: M in FNetwork.GetLineSet.Abstr:
    //          L.GetCode = M.GetCode))
    //      and
    //      (forall L, M: L in FNetwork.GetLineSet.Abstr and
    //        M in FMap.AbstrLines and L.GetCode = M.GetCode:
    //          (forall I: 0 <= I < |L.Abstr|:
    //            (exists J: 0 <= J < |M.Abstr| - I:
    //              L.Abstr[I].GetCode = M.Abstr[I + J].GetCode and
    //                (forall X: 0 <= X < J: M.Abstr[X] is TVisStationDummy))))
  end;

implementation

{ TCompatibilityChecker }

function TMatchChecker.Compatible: Boolean;
var
  I, J, K: Integer;
  VStation: TStationR;
  VLine: TLineR;
  VVisStation: TVisStation;
  VVisLine: TVisLine;
begin
  Result := True;
  // Check if all stations in the network exist on the map.
  for I := 0 to FNetwork.GetStationSet.Count - 1 do begin
    VStation := FNetwork.GetStationSet.GetStation(I);
    if not(FMap.HasStation(VStation.GetCode)) then begin
      Result := False
    end
  end;

  // Check if all lines in the network exist on the map and
  // check if all stations on the lines in the network exist
  // on the corresponding line in the map in the same order.
  for I := 0 to FNetwork.GetLineSet.Count - 1 do begin
    VLine := FNetwork.GetLineSet.GetLine(I);
    if not(FMap.HasLine(VLine.GetCode)) then begin
      Result := False
    end
    else begin
      VVisLine := FMap.GetLine(VLine.GetCode);
      K := 0;
      for J := 0 to VLine.Count - 1 do begin
        while VVisLine.GetStation(K) is TVisStationDummy do begin
          K := K + 1
        end;
        if VVisLine.GetStation(K).GetCode <> VLine.Stop(J).GetCode then begin
          Result := False
        end;
        K := K + 1
      end
    end
  end;

  // Check if all stations on the map exist in the network.
  for I := 0 to FMap.VisComCount - 1 do begin
    if FMap.GetVisCom(I) is TVisStation then begin
      VVisStation := TVisStation(FMap.GetVisCom(I));
      if not(FNetwork.GetStationSet.HasCode(VVisStation.GetCode)) and
        not(VVisStation is TVisStationDummy) then begin
        Result := False
      end
    end
  end;

  // Check if all lines on the map exist in the network
  for I := 0 to FMap.VisComCount - 1 do begin
    if FMap.GetVisCom(I) is TVisLine then begin
      VVisLine := TVisLine(FMap.GetVisCom(I));
      if not(FNetwork.GetLineSet.HasCode(VVisLine.GetCode)) then begin
        Result := False
      end
    end
  end
end;

constructor TMatchChecker.Create(AMap: TMetroMap;
  ANetwork: TNetwork);
begin
  FMap := AMap;
  FNetwork := ANetwork
end;

end.
 