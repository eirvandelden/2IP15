unit NetworkFiler;

interface

uses
  Classes, IniFiles, Graphics, Dialogs,
  MetroBase, StringValidators;

type
  //----------------------------------------------------------------------------
  // TNetworkFiler is a class with some routines for reading/writing
  // a network from/to a .nwk file
  //----------------------------------------------------------------------------
  TNetworkFiler = class(TObject)
  protected
    FIniFile: TMemIniFile;
    FFileSections: TStringList;
    procedure ReadStations(var ANetwork: TNetwork);
    // pre: FIniFile contains the description of a network (N, SS, LS), where
    //      N is the networkname, SS is the stationset and LS is the lineset
    // post: ANetwork.GetStationSet = SS
    procedure ReadLines(var ANetwork: TNetwork);
    // pre: FIniFile contains the description of a network (N, SS, LS), where
    //      N is the networkname, SS is the stationset and LS is the lineset
    // post: ANetwork.GetLineSet = LS
  public
    // construction/destruction ------------------------------------------------
    constructor Create(const AFileName: String);
    // pre: True
    // post: FIniFile is a copy in the internal memory of the ini-file AFileName
    //       and
    //       FFileSections contains the filesections of AFileName
    destructor  Destroy; override;
    // pre: True
    // effect: FIniFile and FFileSections are freed

    // commands ----------------------------------------------------------------
    function  LoadNetwork: TNetwork;
    // pre: FIniFile contains the description of a network (N, SS, LS), where
    //      N is the networkname, SS is the stationset and LS is the lineset
    // ret: the network (N, SS, LS)
    procedure WriteNetwork(ANetwork: TNetwork);
    // pre: ANetwork is the network (N, SS, LS), where
    //      N is the networkname, SS is the stationset and LS is the lineset
    // post: The internal representation of ANetwork in FIniFile is written to
    //       disk
  end;


implementation

uses
  SysUtils, StrUtils;


{ TNetworkFiler }

constructor TNetworkFiler.Create(const AFileName: string);
begin
  FIniFile := TMemIniFile.Create(AFileName);
  FFileSections := TStringList.Create;
  FIniFile.ReadSections(FFileSections)
end;

destructor TNetworkFiler.Destroy;
begin
  FFileSections.Free;
  FIniFile.Free;
  inherited
end;

function TNetworkFiler.LoadNetwork: TNetwork;
var
  VNetwork: TNetwork;
  VNetworkName: String;
begin
  VNetworkName := FIniFile.ReadString('#Main', 'name', '<unknown>');
  VNetwork := TNetwork.CreateEmpty(VNetworkName);

  ReadStations(VNetwork);
  ReadLines(VNetwork);

  Result := VNetwork
end;

procedure TNetworkFiler.ReadLines(var ANetwork: TNetwork);
var
  E, I, J, H: Integer;
  VSectionName: String;
  VLineName, VLineCode: String;
  VLine: TLineRW;
  VOneWay: Boolean;
  VCircular: Boolean;
  VLineOptions: TLineOptionS;
  VStopCode: String;
  VStop: TStationR;
  VStops: TStringList;
begin
  // filter out line sections (beginning with 'L_') and read their attributes
  // and corresponding station lists
  for I := 0 to FFileSections.Count - 1 do begin
    VSectionName := FFileSections.Strings[I];
    if AnSiStartsStr('L_', VSectionName) then begin
      VLineCode := AnsiRightStr(VSectionName, Length(VSectionName) - 2);

      // read line name
      VLineName := FIniFile.ReadString(VSectionName, 'name', '<unknown>');

      // read line options
      VLineOptions := [];
      VOneWay := FIniFile.ReadBool(VSectionName, 'oneway', False);
      if VOneWay then VLineOptions := VLineOptions + [loOneWay];
      VCircular := FIniFile.ReadBool(VSectionName, 'circular', False);
      if VCircular then VLineOptions := VLineOptions + [loCircular];

      // create line (with empty stationlist)
      VLine := TLineRW.Create(VLineCode, VLineName, VLineOptions);

      // read stops from corresponding 'P_' section and add them to line
      VStops := TStringList.Create;
      FIniFile.ReadSectionValues('P_' + VLineCode, VStops);
      for J := 0 to VStops.Count - 1 do begin
        E := Pos('=', VStops.Strings[J]);
        VStopCode := RightStr(VStops.Strings[J], Length(VStops.Strings[J]) - E);
        if ValidStationCode(VStopCode) then begin
          with ANetwork.GetStationSet do begin
            H := IndexOfCode(VStopCode);
            Assert( H <> -1,
              Format('TMetroFiler.Readlines: Unknown stop code: %s',
                [VStopCode]));
            VStop := GetStation(H);
            VLine.AddStop(VStop)
          end
        end
        else begin
          {skip}
        end
      end;
      ANetwork.AddLine(VLine);
      VStops.Free
    end
  end
end;


procedure TNetworkFiler.ReadStations(var ANetwork: TNetwork);
var
  I: Integer;
  VSectionName: String;
  VStationName, VStationCode: String;
begin
  // filter out station sections (beginning with 'S_') and read their name
  for I := 0 to FFileSections.Count - 1 do begin
    VSectionName := FFileSections.Strings[I];
    if AnSiStartsStr('S_', VSectionName) then begin
      VStationCode := AnsiRightStr(VSectionName, Length(VSectionName) - 2);
      VStationName := FIniFile.ReadString(VSectionName, 'name', '<unknown>');
      ANetwork.AddStation(TStationRW.Create(VStationCode, VStationName))
    end
  end
end;

procedure TNetworkFiler.WriteNetwork(ANetwork: TNetwork);
var
  I, J: Integer;
  VStation: TStationR;
  VLine: TLineR;
begin
  FIniFile.Clear;
  FIniFile.WriteString('#Main', 'name', ANetwork.GetName);

  with ANetwork.GetStationSet do begin
    for I := 0 to Count - 1 do begin
      VStation := GetStation(I);
      FIniFile.WriteString('S_' + VStation.GetCode, 'name',
        VStation.GetName)
    end
  end;

  with ANetwork.GetLineSet do begin
    for I := 0 to Count - 1 do begin
      VLine := GetLine(I);
      FIniFile.WriteString('L_' + VLine.GetCode, 'name',
        VLine.GetName);
      FIniFile.WriteBool('L_' + VLine.GetCode, 'oneway',
        VLine.IsOneWay);
      FIniFile.WriteBool('L_' + VLine.GetCode, 'circular',
        VLine.IsCircular);
      for J := 0 to VLine.Count - 1 do begin
        FIniFile.WriteString('P_' + VLine.GetCode,
          'S' + IntToStr(J),
            VLine.Stop(J).GetCode)
      end
    end
  end;

  FIniFile.UpdateFile;
end;


end.
