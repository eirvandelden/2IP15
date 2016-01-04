unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Menus,
  MetroBase, NetworkFiler;

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
    StationGrid: TStringGrid;
    Label1: TLabel;
    LinesListBox: TListBox;
    Label2: TLabel;
    CircularCheckBox: TCheckBox;
    OneWayCheckBox: TCheckBox;
    StopsStringGrid: TStringGrid;
    Label3: TLabel;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure LinesListBoxClick(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Open1Click(Sender: TObject);
  private
    { Private declarations }
    FNetwork: TNetwork;
  public
    { Public declarations }
    procedure InitNetwork;
    procedure ShowStations;
    procedure ShowLines;
    procedure ShowLine(ALine: TLineR);
  end;

var
  Form1: TForm1;

implementation

uses
  IniFiles;

{$R *.dfm}

{ TForm1 }

procedure TForm1.InitNetwork;
var
  VLine1, VLine4: TLineRW;
begin
  FNetwork := TNetwork.CreateEmpty('Dummy');
  with FNetwork do
  begin
    AddStation(TStationRW.Create('PdC', 'Porte de Clignancourt'));
    AddStation(TStationRW.Create('CDG', 'Charles de Gaulle - Etoile'));
    AddStation(TStationRW.Create('CEC', 'Champs-Elysees Clemenceau'));
    AddStation(TStationRW.Create('BAR', 'Barbes RocheChouart'));
    AddStation(TStationRW.Create('CON', 'Concorde'));
    AddStation(TStationRW.Create('TUI', 'Tuileries'));
    AddStation(TStationRW.Create('LRI', 'Louvre Rivoli'));
    AddStation(TStationRW.Create('GdN', 'Gare du Nord'));
    AddStation(TStationRW.Create('CHA', 'Chatelet'));
    AddStation(TStationRW.Create('HdV', 'Hotel de Ville'));
    AddStation(TStationRW.Create('SSD', 'Strasbourg St-Denis'));
    AddStation(TStationRW.Create('StP', 'St-Paul'));
    AddStation(TStationRW.Create('BAS', 'Bastille'));
    AddStation(TStationRW.Create('REA', 'Reaumur Sebastopol'));
    AddStation(TStationRW.Create('GdL', 'Gare de Lyon'));
  end;

  VLine1 := TLineRW.Create('L1', '1', [loCircular]);
  with FNetwork.GetStationSet, VLine1 do
  begin
    AddStop(GetStation(IndexOfCode('CDG')));
    AddStop(GetStation(IndexOfCode('CEC')));
    AddStop(GetStation(IndexOfCode('CON')));
    AddStop(GetStation(IndexOfCode('TUI')));
    AddStop(GetStation(IndexOfCode('LRI')));
    AddStop(GetStation(IndexOfCode('CHA')));
    AddStop(GetStation(IndexOfCode('HdV')));
    AddStop(GetStation(IndexOfCode('StP')));
    AddStop(GetStation(IndexOfCode('BAS')));
    AddStop(GetStation(IndexOfCode('GdL')));
  end;
  FNetwork.AddLine(VLine1);

  VLine4 := TLineRW.Create('L4', '4', [loOneWay]);
  with FNetwork.GetStationSet, VLine4 do
  begin
    AddStop(GetStation(IndexOfCode('PdC')));
    AddStop(GetStation(IndexOfCode('BAR')));
    AddStop(GetStation(IndexOfCode('GdN')));
    AddStop(GetStation(IndexOfCode('SSD')));
    AddStop(GetStation(IndexOfCode('REA')));
    AddStop(GetStation(IndexOfCode('CHA')));
  end;
  FNetwork.AddLine(VLine4);

end;

procedure TForm1.ShowLines;
var
  I: Integer;
begin
  LinesListBox.Items.Clear;
  with FNetwork.GetLineSet do
    for I := 0 to Count - 1 do
      LinesListBox.Items.Add(GetLine(I).GetName);
end;

procedure TForm1.ShowStations;
var
  I: Integer;
begin
  with Stationgrid do
  begin
    Cols[0].Clear;
    Cols[1].Clear;
    RowCount := 2;
    Cells[0,0] := 'Code';
    Cells[1,0] := 'Name';

    with FNetwork.GetStationSet do
      for I := 0 to Count - 1 do
      begin
        RowCount := RowCount + 1;
        Cells[0, I + 1] := GetStation(I).GetCode;
        Cells[1, I + 1] := GetStation(I).GetName;
      end;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  InitNetwork;
  ShowStations;
  ShowLines;
end;

procedure TForm1.LinesListBoxClick(Sender: TObject);
var
  Index: Integer;
  VLine: TLineR;
begin
  Index := LinesListBox.ItemIndex;
  if Index <> -1
  then VLine := FNetwork.GetLineSet.GetLine(Index)
  else VLine := nil;
  ShowLine(VLine);
end;

procedure TForm1.ShowLine(ALine: TLineR);
var
  I: Integer;
begin
  if ALine = nil then
  begin
    CircularCheckbox.Checked := false;
    OneWayCheckBox.Checked := false;
    with StopsStringGrid do
    begin
      Cols[0].Clear;
      Cols[1].Clear;
      RowCount := 0;
    end
  end
  else {ALine <> nil}
  begin
    CircularCheckbox.Checked := false;
    OneWayCheckBox.Checked := false;
    with StopsStringGrid do
    begin
      Cols[0].Clear;
      Cols[1].Clear;
      RowCount := 0;
      for I := 0 to ALine.Count - 1 do
      begin
        RowCount := RowCount + 1;
        Cells[0, I] := ALine.Stop(I).GetCode;
        Cells[1, I] := ALine.Stop(I).GetName;
      end;
    end
  end
end;

procedure TForm1.SaveAs1Click(Sender: TObject);
var
  VFiler: TNetworkFiler;
begin
  if SaveDialog1.Execute then
  begin
    VFiler := TNetworkFiler.Create(SaveDialog1.FileName);
    VFiler.WriteNetwork(FNetwork);
    VFiler.Free;
  end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FNetwork.Free;
end;

procedure TForm1.Open1Click(Sender: TObject);
var
  VFiler: TNetworkFiler;
begin
  if OpenDialog1.Execute then
  begin
    VFiler := TNetworkFiler.Create(OpenDialog1.FileName);
    FNetwork := VFiler.LoadNetwork;

    ShowStations;
    ShowLines;
    LinesListBoxClick(Sender);

    VFiler.Free;
  end;
end;

end.
