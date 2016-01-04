object Form1: TForm1
  Left = 230
  Top = 215
  Width = 952
  Height = 656
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    944
    591)
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 40
    Top = 24
    Width = 66
    Height = 16
    Caption = '&All Stations'
    FocusControl = StationGrid
  end
  object Label2: TLabel
    Left = 384
    Top = 24
    Width = 32
    Height = 16
    Caption = '&Lines'
  end
  object Label3: TLabel
    Left = 488
    Top = 80
    Width = 35
    Height = 16
    Caption = '&Stops'
    FocusControl = StopsStringGrid
  end
  object StationGrid: TStringGrid
    Left = 40
    Top = 48
    Width = 297
    Height = 521
    Anchors = [akLeft, akTop, akBottom]
    ColCount = 2
    FixedCols = 0
    TabOrder = 0
    ColWidths = (
      64
      213)
  end
  object LinesListBox: TListBox
    Left = 384
    Top = 48
    Width = 73
    Height = 521
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 16
    TabOrder = 1
    OnClick = LinesListBoxClick
  end
  object CircularCheckBox: TCheckBox
    Left = 488
    Top = 48
    Width = 97
    Height = 17
    Caption = 'Circular'
    Enabled = False
    TabOrder = 2
  end
  object OneWayCheckBox: TCheckBox
    Left = 600
    Top = 48
    Width = 97
    Height = 17
    Caption = 'OneWay'
    Enabled = False
    TabOrder = 3
  end
  object StopsStringGrid: TStringGrid
    Left = 488
    Top = 104
    Width = 320
    Height = 465
    Anchors = [akLeft, akTop, akBottom]
    ColCount = 2
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 4
    ColWidths = (
      64
      251)
  end
  object MainMenu1: TMainMenu
    Left = 856
    Top = 8
    object File1: TMenuItem
      Caption = '&File'
      object New1: TMenuItem
        Caption = '&New'
        Enabled = False
      end
      object Open1: TMenuItem
        Caption = '&Open...'
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = '&Save'
        Enabled = False
      end
      object SaveAs1: TMenuItem
        Caption = 'Save &As...'
        OnClick = SaveAs1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Print1: TMenuItem
        Caption = '&Print...'
        Enabled = False
      end
      object PrintSetup1: TMenuItem
        Caption = 'P&rint Setup...'
        Enabled = False
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'ini'
    Filter = 'Network files (*.nwk)|*.nwk'
    Left = 808
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Network files (*.nwk)|*.nwk'
    Left = 760
    Top = 8
  end
end
