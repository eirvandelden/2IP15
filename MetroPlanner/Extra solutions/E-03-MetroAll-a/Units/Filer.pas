unit Filer;

interface

uses
  Classes, IniFiles, Graphics, Dialogs,
  MetroBase, MetroVisCom, StringValidators;

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

  //----------------------------------------------------------------------------
  // TMapFiler is a class with some routines for reading/writing
  // a map from/to a .map file
  //----------------------------------------------------------------------------
  TMapFiler = class(TObject)
  protected
    FIniFile: TMemIniFile;
    FFileSections: TStringList;
    procedure ReadStations(var AMap: TMetroMap);
    // pre: FIniFile contains the description of a map (N, B, SS, LS, LaS, TS),
    //      where N is the mapname, B is the filename of the background,
    //      SS is the set of stations, LS is the set of lines,
    //      LaS is the set of landmarks and TS is the set of texts
    // post: AMap.AbstrStations = SS
    procedure ReadLines(var AMap: TMetroMap);
    // pre: FIniFile contains the description of a map (N, B, SS, LS, LaS, TS),
    //      where N is the mapname, B is the filename of the background,
    //      SS is the set of stations, LS is the set of lines,
    //      LaS is the set of landmarks and TS is the set of texts
    // post: AMap.AbstrStations = LS
    procedure ReadLandmarks(var AMap: TMetroMap);
    // pre: FIniFile contains the description of a map (N, B, SS, LS, LaS, TS),
    //      where N is the mapname, B is the filename of the background,
    //      SS is the set of stations, LS is the set of lines,
    //      LaS is the set of landmarks and TS is the set of texts
    // post: AMap.AbstrStations = LaS
    procedure ReadTexts(var AMap: TMetroMap);
    // pre: FIniFile contains the description of a map (N, B, SS, LS, LaS, TS),
    //      where N is the mapname, B is the filename of the background,
    //      SS is the set of stations, LS is the set of lines,
    //      LaS is the set of landmarks and TS is the set of texts
    // post: AMap.AbstrStations = TS
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
    function  LoadMap: TMetroMap;
    // pre: FIniFile contains the description of a map (N, B, SS, LS, LaS, TS),
    //      where N is the mapname, B is the filename of the background,
    //      SS is the set of stations, LS is the set of lines,
    //      LaS is the set of landmarks and TS is the set of texts
    // ret: the map (N, B, SS, LS, LaS, TS)
    procedure WriteMap(AMap: TMetroMap);
    // pre: FIniFile contains the description of a map (N, B, SS, LS, LaS, TS),
    //      where N is the mapname, B is the filename of the background,
    //      SS is the set of stations, LS is the set of lines,
    //      LaS is the set of landmarks and TS is the set of texts
    // post: The internal representation of AMap in FIniFile is written to disk
  end;

  //----------------------------------------------------------------------------
  // TFiler is a class with some routines for reading/writing
  // a map from/to a .map file and a network from/to a .nwk file
  //----------------------------------------------------------------------------
  TFiler = class(TObject)
  protected
    FMapFiler: TMapFiler;
    FNetworkFiler: TNetworkFiler;
  public
    // construction/destruction ------------------------------------------------
    constructor Create(AMapFileName: String; ANetworkFileName: String);
    // pre: True
    // post: FMapFiler.Create(AMapFile).post
    //       and
    //       FNetworkFiler.Create(ANetworkFileName).post
    destructor  Destroy; override;
    // pre: True
    // effect: FMapFiler and FNetworkFiler are freed

    // derived queries ---------------------------------------------------------
    function  LoadNetwork: TNetwork;
    // pre: True
    // ret: FNetworkFiler.LoadNetwork
    function LoadMap: TMetroMap;
    // pre: True
    // ret: FMapFiler.LoadMap

    // commands ----------------------------------------------------------------
    procedure WriteNetwork(ANetwork: TNetwork);
    // pre: True
    // post: FNetworkFiler.WriteNetwork(ANetwork).post
    procedure WriteMap(AMap: TMetroMap);
    // pre: True
    // post: FMapFiler.WriteMap(AMap).post    
  end;

implementation

uses
  SysUtils, StrUtils,
  Auxiliary;

{ TFiler }

constructor TFiler.Create(AMapFileName: String; ANetworkFileName: String);
begin
  FNetworkFiler := TNetworkFiler.Create(ANetworkFileName);
  FMapFiler := TMapFiler.Create(AMapFileName)
end;

destructor TFiler.Destroy;
begin
  FMapFiler.Free;
  FNetworkFiler.Free;
  inherited
end;

function TFiler.LoadMap: TMetroMap;
begin
  Result := FMapFiler.LoadMap
end;

function TFiler.LoadNetwork: TNetwork;
begin
  Result := FNetworkFiler.LoadNetwork
end;

procedure TFiler.WriteMap(AMap: TMetroMap);
begin
  FMapFiler.WriteMap(AMap)
end;

procedure TFiler.WriteNetwork(ANetwork: TNetwork);
begin
  FNetworkFiler.WriteNetwork(ANetwork)
end;

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

{ TMapFiler }

constructor TMapFiler.Create(const AFileName: string);
begin
  FIniFile := TMemIniFile.Create(AFileName);
  FFileSections := TStringList.Create;
  FIniFile.ReadSections(FFileSections)
end;

destructor TMapFiler.Destroy;
begin
  FFileSections.Free;
  FIniFile.Free;
  inherited
end;

function TMapFiler.LoadMap: TMetroMap;
var
  VMap: TMetroMap;
  VBlankPicture, VBackgroundPicture: TBitmap;
  VBackgroundName, VBackgroundFilename: String;
  VName: String;
begin
  VName := FIniFile.ReadString('#Main', 'name', '<unknown>');
  // Load background picture
  VBackgroundName := FIniFile.ReadString('#Main', 'background', '<unknown>');
  if VBackgroundName = '<unknown>' then begin
    VBackgroundPicture := TBitmap.Create;
    VBlankPicture := TBitmap.Create;
  end
  else begin
    VBackgroundFileName :=
      Format('../Images/Backgrounds/%s', [VBackgroundName]);
    VBackgroundPicture := TBitmap.Create;
    if FileExists(VBackgroundFileName) then begin
      VBackgroundPicture.LoadFromFile(VBackgroundFileName)
    end
    else begin
      MessageDlg('The image that should be used as the background of ' +
        'this map does not exist in the directory "Images\Backgrounds".',
        mtError, [mbOK], 0)
    end;

    VBlankPicture := TBitmap.Create;
    VBlankPicture.Height := VBackgroundPicture.Height;
    VBlankPicture.Width := VBackgroundPicture.Width;
    VBlankPicture.Canvas.Pen.Color := clWhite;
    VBlankPicture.Canvas.Brush.Color := clWhite;
    VBlankPicture.Canvas.Rectangle(0, 0, VBackGroundPicture.Width,
      VBackGroundPicture.Height)
  end;

  VMap := TMetroMap.Create(VName, nil, VBlankPicture, VBackgroundPicture,
    VBackgroundName);
  ReadStations(VMap);
  ReadLines(VMap);
  ReadLandmarks(VMap);
  ReadTexts(VMap);

  Result := VMap;
end;

procedure TMapFiler.ReadLandmarks(var AMap: TMetroMap);
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
  for I := 0 to FFileSections.Count - 1 do begin
    VSectionName := FFileSections.Strings[I];
    if AnSiStartsStr('M_', VSectionName) then begin
      VLandmarkCode := AnsiRightStr(VSectionName, Length(VSectionName) - 2);
      VBitmapName := FIniFile.ReadString(VSectionName, 'bitmap', '<unknown>');
      VX := FIniFile.ReadInteger(VSectionName, 'x', -1);
      VY := FIniFile.ReadInteger(VSectionName, 'y', -1);
      if (VX <> -1) and (VY <> -1) and
        (VBitmapName <> '<unknown>') then begin
        VBitmap := TBitmap.Create;
        VBitmapFileName :=
          Format('../Images/Landmarks/%s', [VBitmapName]);
        if FileExists(VBitmapFileName) then begin
          VBitmap.LoadFromFile(VBitmapFileName)
        end
        else begin
          MessageDlg('The image used to depict the landmark with code "' +
            VLandmarkCode + '" can not be found in the directory ' +
            '"Images\Landmarks".', mtError, [mbOK], 0);
          VBitmap.LoadFromFile('../Images/Bitmaps/NoImage.bmp')
        end;
        AMap.Add(TVisLandmark.Create(VLandmarkCode, nil, VX, VY, VBitmap,
          VBitmapName))
      end
      else if (VX <> -1) and (VY <> -1) and
        (VBitmapName = '<unknown') then begin
        VBitmap := TBitmap.Create;
        AMap.Add(TVisLandmark.Create(VLandmarkCode, nil, VX, VY, VBitmap,
          VBitmapName))
      end
    end
  end
end;

procedure TMapFiler.ReadLines(var AMap: TMetroMap);
var
  E, I, J: Integer;
  VSectionName: String;
  VLineName, VLineCode: String;
  VLineColorName: String;
  VLineColor: TColor;
  VStation: TVisStation;
  VLine: TVisLine;
  VStopCode: String;
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

      // read line color
      VLineColorName :=
        FIniFile.ReadString(VSectionName, 'color', 'clBlack');
      VLineColor := ColorNameToColor(VLineColorName);

      // create line (with empty stationlist)
      VLine := TVisLine.Create(VLineCode, nil, VLineColor);

      // read stops from corresponding 'P_' section and add them to line
      VStops := TStringList.Create;
      FIniFile.ReadSectionValues('P_' + VLineCode, VStops);
      for J := 0 to VStops.Count - 1 do begin
        E := Pos('=', VStops.Strings[J]);
        VStopCode := RightStr(VStops.Strings[J],
          Length(VStops.Strings[J]) - E);
        if ValidStationCode(VStopCode) then begin
          VStation := AMap.GetStation(VStopCode);
          VLine.AddStation(VStation);
        end
      end;
      AMap.Add(VLine);
      VStops.Free
    end
  end
end;


procedure TMapFiler.ReadStations(var AMap: TMetroMap);
var
  I: Integer;
  VSectionName: String;
  VStationCode: String;
  VStationKind: String;
  VX, VY: Integer;
begin
  // filter out station sections (beginning with 'S_') and read their name
  for I := 0 to FFileSections.Count - 1 do begin
    VSectionName := FFileSections.Strings[I];
    if AnSiStartsStr('S_', VSectionName) then begin
      VStationCode := AnsiRightStr(VSectionName, Length(VSectionName) - 2);
      VStationKind := FIniFile.ReadString(VSectionName, 'kind', '<unknown>');
      VX := FIniFile.ReadInteger(VSectionName, 'x', -1);
      VY := FIniFile.ReadInteger(VSectionName, 'y', -1);
      if (VX <> -1) and (VY <> -1) then begin
        if VStationKind = 'stop' then begin
          AMap.Add(TVisStationStop.Create(VStationCode, nil, VX, VY))
        end
        else if VStationKind = 'transfer' then begin
          AMap.Add(TVisStationTransfer.Create(VStationCode, nil, VX, VY))
        end
        else if VStationKind = 'dummy' then begin
          AMap.Add(TvisStationDummy.Create(VStationCode, VX, VY))
        end
        else
          Assert(False, 'Unknown station kind in TMetroFiler.LoadMap')
      end
    end
  end
end;

procedure TMapFiler.ReadTexts(var AMap: TMetroMap);
var
  I: Integer;
  VSectionName: String;
  VTextCode: String;
  VX, VY: Integer;
  VText: String;
  VTextPosString: String;
begin
  // filter out text sections (beginning with 'T_') and read their props
  for I := 0 to FFileSections.Count - 1 do begin
    VSectionName := FFileSections.Strings[I];
    if AnSiStartsStr('T_', VSectionName) then begin
      VTextCode := AnsiRightStr(VSectionName, Length(VSectionName) - 2);
      VX := FIniFile.ReadInteger(VSectionName, 'x', -1);
      VY := FIniFile.ReadInteger(VSectionName, 'y', -1);
      VText := FIniFile.ReadString(VSectionName, 'text', '<unknown>');
      VTextPosString := FIniFile.ReadString(VSectionName, 'pos', '<unknown>');
      if (VX <> -1) and (VY <> -1) and (VTextPosString <> '<unknown>') then begin
        AMap.Add(TVisText.Create(VTextCode, nil, VX, VY, VText,
          StringToTextPos(VTextPosString)))
      end
    end
  end
end;

procedure TMapFiler.WriteMap(AMap: TMetroMap);
var
  I, J: Integer;
begin
  FIniFile.Clear;
  FIniFile.WriteString('#Main', 'name', AMap.GetMapName);
  FIniFile.WriteString('#Main', 'background', AMap.GetBackgroundFileName);
  with AMap do begin
    for I := 0 to VisComCount - 1 do begin
      if GetVisCom(I) is TVisStationStop then begin
        FIniFile.WriteString('S_' + GetVisCom(I).GetCode,
          'kind', 'stop');
        FIniFile.WriteString('S_' + GetVisCom(I).GetCode,
          'x', IntToStr(TVisStationStop(GetVisCom(I)).X));
        FIniFile.WriteString('S_' + GetVisCom(I).GetCode,
          'y', IntToStr(TVisStationStop(GetVisCom(I)).Y))
      end;
      if GetVisCom(I) is TVisStationTransfer then begin
        FIniFile.WriteString('S_' + GetVisCom(I).GetCode,
          'kind', 'transfer');
        FIniFile.WriteString('S_' + GetVisCom(I).GetCode,
          'x', IntToStr(TVisStationTransfer(GetVisCom(I)).X));
        FIniFile.WriteString('S_' + GetVisCom(I).GetCode,
          'y', IntToStr(TVisStationTransfer(GetVisCom(I)).Y))
      end;
      if GetVisCom(I) is TVisStationDummy then begin
        FIniFile.WriteString('S_' + GetVisCom(I).GetCode,
          'kind', 'dummy');
        FIniFile.WriteString('S_' + GetVisCom(I).GetCode,
          'x', IntToStr(TVisStationDummy(GetVisCom(I)).X));
        FIniFile.WriteString('S_' + GetVisCom(I).GetCode,
          'y', IntToStr(TVisStationDummy(GetVisCom(I)).Y))
      end
    end
  end;
  with AMap do begin
    for I := 0 to VisComCount - 1 do begin
      if GetVisCom(I) is TVisLine then begin
        FIniFile.WriteString('L_' + GetVisCom(I).GetCode, 'color',
          ColorToColorName(TVisLine(GetVisCom(I)).GetColor));
        for J := 0 to TVisLine(GetVisCom(I)).StationCount - 1 do begin
          FIniFile.WriteString('P_' + GetVisCom(I).GetCode,
            'S' + IntToStr(J),
            TVisLine(GetVisCom(I)).GetStation(J).GetCode)
        end
      end
    end
  end;
  with AMap do begin
    for I := 0 to VisComCount - 1 do begin
      if GetVisCom(I) is TVisLandmark then begin
        FIniFile.WriteString('M_' + GetVisCom(I).GetCode,
          'x', IntToStr(TVisLandmark(GetVisCom(I)).X));
        FIniFile.WriteString('M_' + GetVisCom(I).GetCode,
          'y', IntToStr(TVisLandmark(GetVisCom(I)).Y));
        FIniFile.WriteString('M_' + GetVisCom(I).GetCode,
          'bitmap', TVisLandmark(GetVisCom(I)).GetBitmapFileName)
      end
    end
  end;
  with AMap do begin
    for I := 0 to VisComCount - 1 do begin
      if GetVisCom(I) is TVisText then begin
        FIniFile.WriteString('T_' + GetVisCom(I).GetCode,
          'x', IntToStr(TVisText(GetVisCom(I)).X));
        FIniFile.WriteString('T_' + GetVisCom(I).GetCode,
          'y', IntToStr(TVisText(GetVisCom(I)).Y));
        FIniFile.WriteString('T_' + GetVisCom(I).GetCode,
          'text', TVisText(GetVisCom(I)).GetText);
        FIniFile.WriteString('T_' + GetVisCom(I).GetCode,
          'pos', TextPosToString(TVisText(GetVisCom(I)).GetTextPos));
      end
    end
  end;
  FIniFile.UpdateFile;
end;

end.
