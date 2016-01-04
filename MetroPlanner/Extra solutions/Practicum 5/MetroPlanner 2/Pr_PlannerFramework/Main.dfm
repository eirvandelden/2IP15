object Form1: TForm1
  Left = 333
  Top = 237
  Width = 1024
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
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 65
    Top = 41
    Height = 550
    Beveled = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1016
    Height = 41
    Align = alTop
    TabOrder = 0
    object Label2: TLabel
      Left = 224
      Top = 8
      Width = 31
      Height = 16
      Caption = 'From'
      FocusControl = FromComboBox
    end
    object Label3: TLabel
      Left = 576
      Top = 8
      Width = 17
      Height = 16
      Caption = 'To'
      FocusControl = ToComboBox
    end
    object FromComboBox: TComboBox
      Left = 264
      Top = 8
      Width = 297
      Height = 24
      Style = csDropDownList
      DropDownCount = 40
      ItemHeight = 16
      TabOrder = 0
      OnChange = FromComboBoxChange
    end
    object ToComboBox: TComboBox
      Left = 600
      Top = 8
      Width = 297
      Height = 24
      Style = csDropDownList
      DropDownCount = 30
      ItemHeight = 16
      TabOrder = 1
      OnChange = ToComboBoxChange
    end
    object FindButton: TButton
      Left = 920
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Find !'
      TabOrder = 2
      OnClick = FindButtonClick
    end
    object RadioGroup2: TRadioGroup
      Left = 1016
      Top = 0
      Width = 185
      Height = 33
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
    Top = 41
    Width = 948
    Height = 550
    ActivePage = TabSheetMap
    Align = alClient
    TabOrder = 1
    object TabSheetList: TTabSheet
      Caption = 'Text'
      DesignSize = (
        940
        519)
      object Label4: TLabel
        Left = 328
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
        Left = 680
        Top = 16
        Width = 36
        Height = 16
        Caption = '&Route'
      end
      object StationGrid: TStringGrid
        Left = 328
        Top = 40
        Width = 313
        Height = 473
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
        Left = 200
        Top = 16
        Width = 97
        Height = 17
        Caption = 'OneWay'
        Enabled = False
        TabOrder = 2
      end
      object StopsStringGrid: TStringGrid
        Left = 8
        Top = 40
        Width = 289
        Height = 473
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
        Top = 40
        Width = 537
        Height = 473
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
        Height = 519
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
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 0
          OnClick = LineCheckBoxClick
        end
        object StationCheckBox: TCheckBox
          Left = 16
          Top = 216
          Width = 89
          Height = 17
          Caption = 'Stations'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = StationCheckBoxClick
        end
        object LandmarkCheckBox: TCheckBox
          Left = 16
          Top = 264
          Width = 89
          Height = 17
          Caption = 'Landmarks'
          TabOrder = 2
          OnClick = LandmarkCheckBoxClick
        end
        object RadioGroup1: TRadioGroup
          Left = 8
          Top = 32
          Width = 81
          Height = 105
          Caption = 'Background'
          ItemIndex = 1
          Items.Strings = (
            'Blank'
            'Map')
          TabOrder = 3
          OnClick = RadioGroup1Click
        end
      end
      object ScrollBox1: TScrollBox
        Left = 113
        Top = 0
        Width = 827
        Height = 519
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 1
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 41
    Width = 65
    Height = 550
    Align = alLeft
    TabOrder = 2
    DesignSize = (
      65
      550)
    object Label5: TLabel
      Left = 8
      Top = 8
      Width = 32
      Height = 16
      Caption = '&Lines'
    end
    object LinesListBox: TListBox
      Left = 8
      Top = 32
      Width = 41
      Height = 505
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 16
      MultiSelect = True
      TabOrder = 0
      OnClick = LinesListBoxClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 1256
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
    Left = 1217
    Top = 76
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
    Left = 1169
    Top = 76
  end
end
