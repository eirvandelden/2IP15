unit MetroFiler;

interface

uses
  Classes, IniFiles, Graphics,
  MetroBase, MetroVisCom;

type
  //----------------------------------------------------------------------------
  // TMetroFiler is a class with some helper routines for reading/writing
  // a network and map from/to  a .nwk file
  //----------------------------------------------------------------------------
  TMetroFiler =
  class(TObject)
  protected
    FFileName: String;
    FIniFile: TMemIniFile;
    FNetworkName: String;
    FFileSections: TStringList;
    // auxiliary methods
  public
    // construction/Destruction
    constructor Create(const AfileName: string);
    destructor  Destroy; override;
    function  LoadNetwork: TNetwork;
    procedure WriteMapAndNetwork(AMap: TMetroMap; ANetwork: TNetwork);
    function  LoadMap: TMetroMap;
  end;

implementation

uses
  SysUtils, StrUtils,
  Auxiliary;

{ TMetroFiler }

constructor TMetroFiler.Create(const AfileName: string);
begin
  inherited Create;
  FIniFile := TMemIniFile.Create(AFileName);
  FNetworkName := FIniFile.ReadString('#Main', 'name', '???');
  FFileSections := TStringList.Create;
  FIniFile.ReadSections(FFileSections);

end;

destructor TMetroFiler.Destroy;
begin
  FFileSections.Free;
  FIniFile.Free;
  inherited;
end;

function TMetroFiler.LoadMap: TMetroMap;
var
  VMap: TMetroMap;
  VBlankPicture, VBackgroundPicture: TBitmap;
  VBackgroundName, VBackgroundFilename: String;

  procedure ReadLines;
  var
    I, J, M: Integer;
    VSectionName: String;
    VLineName, VLineCode: String;
    VLineColorName: String;
    VLineColor: TColor;
    VStation: TVisStation;
    VLine: TVisLine;
    VStopCode: String;
    VStops: TStringList;
    VLeft, VRight: String;
    VX, VY: Integer;
  begin
    // filter out line sections (beginning with 'L_') and read their attributes
    // and corresponding station lists
    for I := 0 to FFileSections.Count - 1 do
    begin
      VSectionName := FFileSections.Strings[I];
      if AnSiStartsStr('L_', VSectionName) then
      begin
        VLineCode := AnsiRightStr(VSectionName, Length(VSectionName) - 2);

        // read line name
        VLineName := FIniFile.ReadString(VSectionName, 'name', '????');

        // read line color
        VLineColorName :=
          FIniFile.ReadString(VSectionName, 'color', 'clBlack');
        VLineColor := ColorNameToColor(VLineColorName);

        // create line (with empty stationlist)
        VLine := TVisLine.Create(VLineCode, nil, VLineColor);

        // read stops from corresponding 'P_' section and and them to line
        VStops := TStringList.Create;
        FIniFile.ReadSectionValues('P_' + VLineCode, VStops);
        for J := 0 to VStops.Count - 1 do
        begin
          VStopCode := VStops.Strings[J];
          if ValidStationCode(VStopCode) then
          begin
            VStation := VMap.GetStation(VStopCode);
            VLine.Add(VStation);
          end
          else
          begin
            // VStopCode should be of the form nnnn,nnnn ;
            M := Pos(',', VStopCode);
            if M <> 0 then
            begin
              VLeft := LeftStr(VStopCode, M - 1);
              VRight := RightStr(VStopCode, Length(VStopCode) - M);
              VX := StrToIntDef(VLeft, -1);
              VY := StrToIntDef(VRight, -1);
              if (VX <> -1) and (VX <> -1)
              then VLine.Add(TVisStationDummy.Create(VX, VY))
              else Assert(false,
               'Ill-formed coordinates in TMetroFiler.Readlines: ' + VStopCode);
            end;
          end;
        end{for J};
        VMap.Add(VLine);
        VStops.Free;
      end{if};
    end{for I};

  end;

  procedure ReadStations;
  var
    I: Integer;
    VSectionName: String;
    VStationName, VStationCode: String;
    VStationKind: String;
    VX, VY: Integer;
  begin
    // filter out station sections (beginning with 'S_') and read their name
    for I := 0 to FFileSections.Count - 1 do
    begin
      VSectionName := FFileSections.Strings[I];
      if AnSiStartsStr('S_', VSectionName) then
      begin
        VStationCode := AnsiRightStr(VSectionName, Length(VSectionName) - 2);
        VStationName := FIniFile.ReadString(VSectionName, 'name', '???????');
        VStationKind := FIniFile.ReadString(VSectionName, 'kind', '???');
        VX := FIniFile.ReadInteger(VSectionName, 'x', -1);
        VY := FIniFile.ReadInteger(VSectionName, 'y', -1);
        if (VX <> -1) and (VY <> -1) then
        begin
          if VStationKind = 'stop'
          then VMap.Add(TVisStationStop.Create(VStationCode, nil, VX, VY))
          else if VStationKind = 'transfer'
          then VMap.Add(TVisStationTransfer.Create(VStationCode, nil, VX, VY))
          else Assert(false, 'Unknown station kind in TMetroFiler.LoadMap');
        end{if};
      end{if};
    end{for};
  end;

  procedure ReadLandmarks;
  var
    I: Integer;
    VSectionName: String;
    VLandmarkCode: String;
    VBitMapName: String;
    VBitmapFileName: String;
    VBitmap: TBitmap;
    VX, VY: Integer;
  begin
    // filter out landmark sections (beginning with 'M_') and read their props
    for I := 0 to FFileSections.Count - 1 do
    begin
      VSectionName := FFileSections.Strings[I];
      if AnSiStartsStr('M_', VSectionName) then
      begin
        VLandmarkCode := AnsiRightStr(VSectionName, Length(VSectionName) - 2);
        VBitmapName := FIniFile.ReadString(VSectionName, 'bitmap', '???');
        VX := FIniFile.ReadInteger(VSectionName, 'x', -1);
        VY := FIniFile.ReadInteger(VSectionName, 'y', -1);
        if (VX <> -1) and (VY <> -1) and (VBitmapName <> '???') then
        begin
          VBitmap := TBitmap.Create;
          VBitmapFileName :=
            Format('../Images/Landmarks/%s.bmp', [VBitmapName]);
          VBitmap.LoadFromFile(VBitmapFileName);
          VMap.Add(TVisLandmark.Create(VLandmarkCode, nil, VX, VY, VBitmap))
        end{if};
      end{if};
    end{for};
  end;

  procedure ReadTexts;
  begin

  end;
begin{Loadmap}
  // Load blank picture
  VBlankPicture := TBitmap.Create;
  VBlankPicture.LoadFromFile('../Images/Backgrounds/blank.bmp');
  // Load background picture
  VBackgroundName := FIniFile.ReadString('#Main', 'background', 'blank');
  VBackgroundFileName :=
    Format('../Images/Backgrounds/%s.bmp', [VBackgroundName]);
  VBackgroundPicture := TBitmap.Create;
  VBackgroundPicture.LoadFromFile(VBackgroundFileName);

  VMap := TMetroMap.Create(nil, VBlankPicture, VBackgroundPicture);
  ReadStations;
  ReadLines;
  ReadLandmarks;
  ReadTexts;

  Result := VMap;
end{LoadMap};

function TMetroFiler.LoadNetwork: TNetwork;
var
  VNetwork: TNetwork;

  procedure ReadStations;
  var
    I: Integer;
    VSectionName: String;
    VStationName, VStationCode: String;
  begin
    // filter out station sections (beginning with 'S_') and read their name
    for I := 0 to FFileSections.Count - 1 do
    begin
      VSectionName := FFileSections.Strings[I];
      if AnSiStartsStr('S_', VSectionName) then
      begin
        VStationCode := AnsiRightStr(VSectionName, Length(VSectionName) - 2);
        VStationName := FIniFile.ReadString(VSectionName, 'name', '???????');
        VNetwork.AddStation(VStationCode, VStationName);
      end{if};
    end{for};
  end;

  procedure Readlines;
  var
    I, J, H: Integer;
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
    for I := 0 to FFileSections.Count - 1 do
    begin
      VSectionName := FFileSections.Strings[I];
      if AnSiStartsStr('L_', VSectionName) then
      begin
        VLineCode := AnsiRightStr(VSectionName, Length(VSectionName) - 2);

        // read line name
        VLineName := FIniFile.ReadString(VSectionName, 'name', '????');

        // read line options
        VLineOptions := [];
        VOneWay := FIniFile.ReadBool(VSectionName, 'oneway', false);
        if VOneWay then VLineOptions := VLineOptions + [loOneWay];
        VCircular := FIniFile.ReadBool(VSectionName, 'circular', false);
        if VCircular then VLineOptions := VLineOptions + [loCircular];

        // create line (with empty stationlist)
        VLine := TLineRW.Create(VLineCode, VLineName, VLineOptions);

        // read stops from corresponding 'P_' section and and them to line
        VStops := TStringList.Create;
        FIniFile.ReadSectionValues('P_' + VLineCode, VStops);
        for J := 0 to VStops.Count - 1 do
        begin
          VStopCode := VStops.Strings[J];
          if ValidStationCode(VStopCode) then
            with VNetwork.GetStationSet do
              begin
                H := IndexOfCode(VStopCode);
                Assert( H <> -1,
                  Format('TMetroFiler.Readlines: Unknown stop code: %s',
                    [VStopCode]));
                VStop := GetStation(H);
                VLine.AddStop(VStop);
              end
          else
            {skip};
        end{for J};
        VNetwork.AddLine(VLine);
        VStops.Free;
      end{if};
    end{for I};

  end;
begin{Loadnetwork}
  VNetwork := TNetwork.CreateEmpty(FNetworkName);

  ReadStations;
  ReadLines;
  
  Result := VNetwork;
end{LoadNetwork};

procedure TMetroFiler.WriteMapAndNetwork(AMap: TMetroMap;
            ANetwork: TNetwork);
begin
  Assert(false, 'TMetroFiler.WriteMapAndNetwork not yet implemented');
end;

end.
