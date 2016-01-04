unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus, IniFiles, Contnrs, Math,
  MetroBase, MetroVisCom, Filer, Grids, Planner, MatchChecker,
  MinStopsPlanner, MinTransfersPLanner;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    N2: TMenuItem;
    SaveAs1: TMenuItem;
    Save1: TMenuItem;
    Open1: TMenuItem;
    New1: TMenuItem;
    Panel1: TPanel;
    FromComboBox: TComboBox;
    Label2: TLabel;
    ToComboBox: TComboBox;
    Label3: TLabel;
    PageControl1: TPageControl;
    TabSheetList: TTabSheet;
    TabSheetMap: TTabSheet;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    LineCheckBox: TCheckBox;
    StationCheckBox: TCheckBox;
    LandmarkCheckBox: TCheckBox;
    RadioGroup1: TRadioGroup;
    StationGrid: TStringGrid;
    Label4: TLabel;
    CircularCheckBox: TCheckBox;
    OneWayCheckBox: TCheckBox;
    StopsStringGrid: TStringGrid;
    Label6: TLabel;
    FindButton: TButton;
    Panel3: TPanel;
    LinesListBox: TListBox;
    Label5: TLabel;
    Splitter1: TSplitter;
    RouteStringGrid: TStringGrid;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    MarkasStart1: TMenuItem;
    MarkasFinish1: TMenuItem;
    ClearMarks1: TMenuItem;
    RadioGroup2: TRadioGroup;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    TextCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure LineCheckBoxClick(Sender: TObject);
    procedure StationCheckBoxClick(Sender: TObject);
    procedure LandmarkCheckBoxClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure LinesListBoxClick(Sender: TObject);
    procedure FromComboBoxChange(Sender: TObject);
    procedure ToComboBoxChange(Sender: TObject);
    procedure FindButtonClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure MarkasStart1Click(Sender: TObject);
    procedure MarkasFinish1Click(Sender: TObject);
    procedure ClearMarks1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure TextCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
    FStationClicked: TVisStation;
    FStartFlag: TBitmap;
    FStopFlag: TBitmap;
    procedure ClearCheckboxes;
    procedure ShowMap;
    procedure ShowStationList;
    procedure ShowLineList;
    procedure UpdateComboBoxes;
    procedure UpdateButtons;
  public
    { Public declarations }
    FNetwork: TNetwork;
    FMap: TMetroMap;
    FMinStopsPlanner: TPlanner;
    FMinTransfersPlanner: TPlanner;
    FPreviousMouseClick: TPoint;
    procedure UpdateViews;
    procedure MapMouseDown(Sender: TObject; Button: TMouseButton;
                Shift: TShiftState; X, Y: Integer);
    // Event handler for mousedown on map object. This one is treated
    // differently from other event handlers because TMetroMap is not yet a
    // VCL component conforming to Delphi conventions. This handler is assigned
    // manually in FormCreate
    procedure MapMouseMove(Sender: TObject; Shift: TShiftState;
                             X, Y: Integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ClearCheckboxes;
begin
    LineCheckBox.Checked := false;
    StationCheckBox.Checked := false;
    LandmarkCheckBox.Checked := false;
end;

procedure TForm1.ShowLineList;
var
  I: Integer;
begin
  LinesListBox.Items.Clear;
  with FNetwork.GetLineSet do
    for I := 0 to Count - 1 do
      LinesListBox.Items.Add(GetLine(I).GetName);
end;

procedure TForm1.ShowStationList;
var
  I: Integer;
begin
  with Stationgrid do
  begin
    RowCount := 1;

    with FNetwork.GetStationSet do
      for I := 0 to Count - 1 do
      begin
        RowCount := RowCount + 1;
        Cells[0, I] := GetStation(I).GetCode;
        Cells[1, I] := GetStation(I).GetName;
      end;
  end;

end;

procedure TForm1.ShowMap;
begin
  FMap.HideAll;
  FMap.ShowSelectedLines;
  if LineCheckBox.Checked then FMap.ShowLines;
  if StationCheckBox.Checked then FMap.ShowStations;
  if LandmarkCheckBox.Checked then FMap.ShowLandmarks;
  if TextCheckBox.Checked then FMap.ShowTexts;
  FMap.ShowFlags;
end;

procedure TForm1.UpdateComboBoxes;
begin
  FromComboBox.Items := StationGrid.Cols[1];
  ToComboBox.Items := StationGrid.Cols[1];
end;

procedure TForm1.UpdateButtons;
begin
  FindButton.Enabled :=
    (FromComboBox.ItemIndex <> -1) and (ToComboBox.ItemIndex <> -1) and
    (FromComboBox.ItemIndex <> ToComboBox.ItemIndex);
end;

procedure TForm1.UpdateViews;
begin
  ShowStationList;
  ShowLineList;
  ShowMap;
  UpdateButtons;
end;

procedure TForm1.MapMouseDown(Sender: TObject; Button: TMouseButton;
                                Shift: TShiftState; X, Y: Integer);
begin
  FStationClicked := FMap.StationContaining(X, Y);
  if Button = mbLeft then begin
    FPreviousMouseClick := Point( X, Y );
  end
end;

procedure TForm1.MapMouseMove(Sender: TObject; Shift: TShiftState;
                                X, Y: Integer);
var
  VDX, VDY: Integer;
begin
  if ssLeft in Shift then begin
    VDX := X - FPreviousMouseClick.X;
    VDY := Y - FPreviousMouseClick.Y;
    ScrollBox1.HorzScrollBar.Position :=
      Max( 0, ScrollBox1.HorzScrollBar.Position - VDX );
    ScrollBox1.VertScrollBar.Position :=
      Max( 0, ScrollBox1.VertScrollBar.Position - VDY )
  end
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  VIniFile: TMemIniFile;
  VDefault, VNetworkFileName, VMapFileName: String;
  VFiler: TFiler;
begin
  // Read some auxiliary bitmaps
  FStartFlag := TBitmap.Create;
  FStartFlag.LoadFromFile('..\Images\Bitmaps\GreenFlag.bmp');
  FStartFlag.Transparent := true;
  FStopFlag := TBitmap.Create;
  FStopFlag.LoadFromFile('..\Images\Bitmaps\RedFlag.bmp');
  FStopFlag.Transparent := true;

  // Read default settings from .ini file
  VIniFile := TMemIniFile.Create('PlannerFramework.ini');
  VDefault := VIniFile.ReadString('Settings', 'defaultnetwork', 'Empty');
  VNetworkFileName := Format('../Networks and Maps/%s.nwk', [VDefault]);
  VDefault := VIniFile.ReadString('Settings', 'defaultmap', 'Empty');
  VMapFileName := Format('../Networks and Maps/%s.map', [VDefault]);
  VIniFile.Free;

  // Read network and map from .nwk file
  VFiler := TFiler.Create(VMapFileName, VNetworkFileName);
  FNetwork := VFiler.LoadNetwork;
  FMap := VFiler.LoadMap;
  VFiler.Free;

  // Set FMap properties
  Self.InsertComponent(FMap);
  FMap.Parent := ScrollBox1;
  FMap.Align := alNone;
  FMap.AutoSize := true;
  FPreviousMouseClick := Point(0, 0);
  FMap.OnMouseDown := MapMouseDown; // Here the event handler is set manually
  FMap.OnMouseMove := MapMouseMove;
  FMap.PopupMenu := PopupMenu1;     // Here the popupmenu is set manually
  FMap.StartFlag := TVisFlag.Create('', nil, 0, 0, FStartFlag);
  FMap.StopFlag := TVisFlag.Create('', nil, 0, 0, FStopFlag);


  FMinStopsPlanner := TMinStopsPlanner.Create(FNetwork);
  FMinTransfersPlanner := TMinTransfersPlanner.Create(FNetwork);

  UpdateViews;
  UpdateComboboxes;
  UpdateButtons;

  with RouteStringgrid do
  begin
    Cells[0,0] := 'From';
    Cells[1,0] := 'Line';
    Cells[2,0] := 'Direction';
    Cells[3,0] := 'To';
  end;
end;

procedure TForm1.LineCheckBoxClick(Sender: TObject);
begin
  FMap.ClearSelectedLines;
  UpdateViews;
end;

procedure TForm1.StationCheckBoxClick(Sender: TObject);
begin
  UpdateViews;
end;

procedure TForm1.LandmarkCheckBoxClick(Sender: TObject);
begin
  UpdateViews;
end;

procedure TForm1.TextCheckBoxClick(Sender: TObject);
begin
  UpdateViews;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  case RadioGroup1.ItemIndex of
    0:
      begin
        FMap.HideBackground;
      end;
    1:
      begin
        FMap.ShowBackground;
      end;
  else

  end;
  UpdateViews;
end;

procedure TForm1.LinesListBoxClick(Sender: TObject);
var
  I, Index: Integer;
  VLine: TLineR;
begin
 // show selected lines on map
  FMap.ClearSelectedLines;
  with LinesListBox do
    for I := 0 to Count - 1 do
      if Selected[I] then
      begin
        VLine := FNetwork.GetLineSet.GetLine(I);
        FMap.GetLine(VLine.GetCode).Select;
      end;
  ShowMap;

  // show stations of line at index in stringgrid
  Index := LinesListBox.ItemIndex;
  if Index <> -1 then
  begin
    VLine := FNetwork.GetLineSet.GetLine(Index);
    CircularCheckbox.Checked := VLine.IsCircular;
    OneWayCheckbox.Checked := VLine.IsOneWay;
    with StopsStringgrid do
    begin
      Cols[0].Clear;
      Cols[1].Clear;
      RowCount := 0;
      for I := 0 to VLine.Count - 1 do
      begin
        RowCount := RowCount + 1;
        Cells[0, I] := VLine.Stop(I).GetCode;
        Cells[1, I] := VLine.Stop(I).GetName;
      end;
    end;
  end;
end;


procedure TForm1.FromComboBoxChange(Sender: TObject);
var
  VFrom: TStationR;
begin
  with FNetwork.GetStationSet do
  begin
    VFrom := GetStation(IndexOfName(FromComboBox.Text));
  end;
  FMap.MarkStartStation(VFrom.GetCode);
  UpdateViews;
  UpdateButtons;
end;

procedure TForm1.ToComboBoxChange(Sender: TObject);
var
  VTo: TStationR;
begin
  with FNetwork.GetStationSet do
  begin
    VTo := GetStation(IndexOfName(ToComboBox.Text));
  end;
  FMap.MarkStopStation(VTo.GetCode);
  UpdateViews;
  UpdateButtons;
end;

procedure TForm1.FindButtonClick(Sender: TObject);
var
  VRoute: TRouteR;
  VFrom, VTo: TStationR;
  I: Integer;
begin
  with FNetwork.GetStationSet do
  begin
    VFrom := GetStation(IndexOfName(FromComboBox.Text));
    VTo := GetStation(IndexOfName(ToComboBox.Text));
  end;
  case RadioGroup2.ItemIndex of
    0: VRoute := FMinStopsPlanner.FindRoute(VFrom, VTo, soAny);
    1: VRoute := FMinTransfersPlanner.FindRoute(VFrom, VTo, soAny);
  end;

  // show route on map
  ClearCheckboxes;
  FMap.HideAll;
  FMap.ShowRoute(VRoute);
  FMap.ShowFlags;

  // show route in RouteStringgrid
  with RouteStringgrid do
  begin
    RowCount := VRoute.SegmentCount + 1;
    with VRoute do
      for I := 0 to SegmentCount - 1 do
        with GetSegment(I) do
        begin
          Cells[0, I+1] := FromStation.GetName;
          Cells[1, I+1] := Line.GetName;
          Cells[2, I+1] := Direction.GetName;
          Cells[3, I+1] := ToStation.GetName;
        end;
  end;

  VRoute.Free;
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
  Clearmarks1.Enabled := true;
  MarkasFinish1.Enabled := false;
  MarkasStart1.Enabled := false;
  if (FStationClicked <> nil) then begin
    if FStationClicked.CanMark('mkStart') then begin
      MarkasStart1.Enabled := true
    end;
    if FStationClicked.CanMark('mkFinish') then begin
      MarkasFinish1.Enabled := true
    end
  end
end;

procedure TForm1.MarkasStart1Click(Sender: TObject);
var
  VFrom: TStationR;
begin
  with FNetwork.GetStationSet do
  begin
    VFrom := GetStation(IndexOfCode(FStationClicked.GetCode));
  end;
  with FromComboBox do
  begin
    ItemIndex := Items.IndexOf(VFrom.GetName);
  end;
  FMap.MarkStartStation(FStationClicked.GetCode);
  UpdateViews;
  UpdateButtons;
end;

procedure TForm1.MarkasFinish1Click(Sender: TObject);
var
  VTo: TStationR;
begin
  with FNetwork.GetStationSet do
  begin
    VTo := GetStation(IndexOfCode(FStationClicked.GetCode));
  end;
  with ToComboBox do
  begin
    ItemIndex := Items.IndexOf(VTo.GetName);
  end;
  FMap.MarkStopStation(FStationClicked.GetCode);
  UpdateViews;
  UpdateButtons;
end;

procedure TForm1.ClearMarks1Click(Sender: TObject);
begin
  FromComboBox.ItemIndex := -1;
  ToComBoBox.ItemIndex := -1;
  FMap.ClearFlags;
  UpdateViews;
  UpdateButtons;
end;

procedure TForm1.Open1Click(Sender: TObject);
var
  VFiler: TFiler;
  VChecker: TMatchChecker;
begin
  if OpenDialog1.Execute then begin
    if not(ofExtensionDifferent in OpenDialog1.Options) then begin
      if OpenDialog2.Execute then begin
        if not(ofExtensionDifferent in OpenDialog2.Options) then begin
          // Free old network and map
          FMap.Free;
          FNetwork.Free;

          // Read network from .nwk file and map from .map file
          VFiler := TFiler.Create(OpenDialog1.FileName, OpenDialog2.FileName);
          FNetwork := VFiler.LoadNetwork;
          FMap := VFiler.LoadMap;
          VFiler.Free;
          VChecker := TMatchChecker.Create(FMap, FNetwork);

          if VChecker.Compatible then begin
            // skip
          end
          else begin
            MessageDlg('The network and map are incompatible.', mtError,
              [mbOK], 0);
            FMap.Free;
            FNetwork.Free;
            FMap := TMetroMap.CreateEmpty('unknown', nil);
            FNetwork := TNetwork.CreateEmpty('unknown')
          end;

          // Set FMap properties
          Self.InsertComponent(FMap);
          FMap.Parent := ScrollBox1;
          FMap.Align := alNone;
          FMap.AutoSize := true;
          FPreviousMouseClick := Point(0, 0);
          // Here the event handler is set manually
          FMap.OnMouseDown := MapMouseDown;
          FMap.OnMouseMove := MapMouseMove;
          // Here the popupmenu is set manually
          FMap.PopupMenu := PopupMenu1;
          FMap.StartFlag := TVisFlag.Create('', nil, 0, 0, FStartFlag);
          FMap.StopFlag := TVisFlag.Create('', nil, 0, 0, FStopFlag);

          FMinStopsPlanner := TMinStopsPlanner.Create(FNetwork);
          FMinTransfersPlanner := TMinTransfersPlanner.Create(FNetwork);

          UpdateViews;
          UpdateComboboxes;
          UpdateButtons
        end
        else begin
          MessageDlg(
            'The network file does not have the appropriate extension.',
            mtError, [mbOK], 0)
        end
      end
    end
    else begin
      MessageDlg(
        'The map file does not have the appropriate extension.',
        mtError, [mbOK], 0)
    end
  end
end;

end.
