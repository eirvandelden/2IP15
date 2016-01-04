object Form1: TForm1
  Left = 227
  Top = 203
  Width = 994
  Height = 669
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 65
    Top = 50
    Height = 554
    Beveled = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 986
    Height = 50
    Align = alTop
    TabOrder = 0
    object Label2: TLabel
      Left = 136
      Top = 9
      Width = 31
      Height = 16
      Caption = 'From'
      FocusControl = FromComboBox
    end
    object Label3: TLabel
      Left = 392
      Top = 9
      Width = 17
      Height = 16
      Caption = 'To'
      FocusControl = ToComboBox
    end
    object FromComboBox: TComboBox
      Left = 169
      Top = 9
      Width = 216
      Height = 24
      Style = csDropDownList
      DropDownCount = 40
      ItemHeight = 16
      TabOrder = 0
      OnChange = FromComboBoxChange
    end
    object ToComboBox: TComboBox
      Left = 409
      Top = 9
      Width = 200
      Height = 24
      Style = csDropDownList
      DropDownCount = 30
      ItemHeight = 16
      TabOrder = 1
      OnChange = ToComboBoxChange
    end
    object FindButton: TButton
      Left = 617
      Top = 9
      Width = 73
      Height = 24
      Caption = 'Find !'
      TabOrder = 2
      OnClick = FindButtonClick
    end
    object RadioGroup2: TRadioGroup
      Left = 697
      Top = 0
      Width = 184
      Height = 41
      Caption = 'Minimize'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Stops'
        'Transfers')
      TabOrder = 3
    end
  end
  object PageControl1: TPageControl
    Left = 68
    Top = 50
    Width = 918
    Height = 554
    ActivePage = TabSheetMap
    Align = alClient
    TabOrder = 1
    object TabSheetList: TTabSheet
      Caption = 'Text'
      DesignSize = (
        910
        523)
      object Label4: TLabel
        Left = 329
        Top = 16
        Width = 66
        Height = 16
        Caption = '&All Stations'
        FocusControl = StationGrid
      end
      object Label6: TLabel
        Left = 16
        Top = 16
        Width = 35
        Height = 16
        Caption = '&Stops'
        FocusControl = StopsStringGrid
      end
      object Label1: TLabel
        Left = 681
        Top = 16
        Width = 36
        Height = 16
        Caption = '&Route'
      end
      object StationGrid: TStringGrid
        Left = 329
        Top = 41
        Width = 312
        Height = 478
        Anchors = [akLeft, akTop, akBottom]
        ColCount = 2
        FixedCols = 0
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
        TabOrder = 0
        ColWidths = (
          64
          213)
      end
      object CircularCheckBox: TCheckBox
        Left = 112
        Top = 16
        Width = 97
        Height = 17
        Caption = 'Circular'
        Enabled = False
        TabOrder = 1
      end
      object OneWayCheckBox: TCheckBox
        Left = 201
        Top = 16
        Width = 96
        Height = 17
        Caption = 'OneWay'
        Enabled = False
        TabOrder = 2
      end
      object StopsStringGrid: TStringGrid
        Left = 9
        Top = 41
        Width = 288
        Height = 478
        Anchors = [akLeft, akTop, akBottom]
        ColCount = 2
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
        TabOrder = 3
        ColWidths = (
          64
          251)
      end
      object RouteStringGrid: TStringGrid
        Left = 672
        Top = 41
        Width = 537
        Height = 472
        ColCount = 4
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 4
        ColWidths = (
          190
          40
          148
          145)
      end
    end
    object TabSheetMap: TTabSheet
      Caption = 'Map'
      ImageIndex = 1
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 113
        Height = 523
        Align = alLeft
        TabOrder = 0
        object LineCheckBox: TCheckBox
          Left = 16
          Top = 176
          Width = 89
          Height = 17
          Caption = 'Lines'
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 0
          OnClick = LineCheckBoxClick
        end
        object StationCheckBox: TCheckBox
          Left = 16
          Top = 217
          Width = 89
          Height = 16
          Caption = 'Stations'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = StationCheckBoxClick
        end
        object LandmarkCheckBox: TCheckBox
          Left = 16
          Top = 255
          Width = 89
          Height = 16
          Caption = 'Landmarks'
          Checked = True
          State = cbChecked
          TabOrder = 2
          OnClick = LandmarkCheckBoxClick
        end
        object RadioGroup1: TRadioGroup
          Left = 9
          Top = 32
          Width = 80
          Height = 105
          Caption = 'Background'
          ItemIndex = 1
          Items.Strings = (
            'Blank'
            'Map')
          TabOrder = 3
          OnClick = RadioGroup1Click
        end
        object TextCheckBox: TCheckBox
          Left = 16
          Top = 295
          Width = 119
          Height = 21
          Caption = 'Texts'
          Checked = True
          State = cbChecked
          TabOrder = 4
          OnClick = TextCheckBoxClick
        end
      end
      object ScrollBox1: TScrollBox
        Left = 113
        Top = 0
        Width = 797
        Height = 523
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 1
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 50
    Width = 65
    Height = 554
    Align = alLeft
    TabOrder = 2
    DesignSize = (
      65
      554)
    object Label5: TLabel
      Left = 9
      Top = 9
      Width = 32
      Height = 16
      Caption = '&Lines'
    end
    object LinesListBox: TListBox
      Left = 9
      Top = 32
      Width = 48
      Height = 510
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 16
      MultiSelect = True
      TabOrder = 0
      OnClick = LinesListBoxClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 944
    Top = 80
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
        Enabled = False
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
      end
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 905
    Top = 84
    object MarkasStart1: TMenuItem
      Caption = 'Mark as Start'
      OnClick = MarkasStart1Click
    end
    object MarkasFinish1: TMenuItem
      Caption = 'Mark as Finish'
      OnClick = MarkasFinish1Click
    end
    object ClearMarks1: TMenuItem
      Caption = 'Clear Marks'
      OnClick = ClearMarks1Click
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'map'
    Filter = 'Map Files (*.map)|*.map'
    Left = 323
    Top = 81
  end
  object OpenDialog2: TOpenDialog
    DefaultExt = 'nwk'
    Filter = 'Network Files (*.nwk)|*.nwk'
    Left = 355
    Top = 81
  end
end
