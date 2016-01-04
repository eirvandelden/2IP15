object Form1: TForm1
  Left = 192
  Top = 128
  Caption = 'p'
  ClientHeight = 525
  ClientWidth = 707
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 501
    Width = 707
    Height = 24
    Panels = <>
  end
  object Panel1: TPanel
    Left = 0
    Top = 443
    Width = 707
    Height = 58
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 208
      Top = 7
      Width = 23
      Height = 13
      Caption = 'From'
    end
    object Label2: TLabel
      Left = 332
      Top = 7
      Width = 13
      Height = 13
      Caption = 'To'
    end
    object Label3: TLabel
      Left = 455
      Top = 7
      Width = 26
      Height = 13
      Caption = 'Index'
    end
    object ButtonNewGame: TButton
      Left = 20
      Top = 20
      Width = 60
      Height = 20
      Caption = 'New Game'
      TabOrder = 0
      OnClick = ButtonNewGameClick
    end
    object ButtonNewCard: TButton
      Left = 111
      Top = 20
      Width = 60
      Height = 20
      Caption = 'New Card'
      TabOrder = 1
      OnClick = ButtonNewCardClick
    end
    object ComboBoxFrom: TComboBox
      Left = 241
      Top = 7
      Width = 78
      Height = 21
      DropDownCount = 12
      ItemHeight = 13
      TabOrder = 2
      Text = 'Tab 1'
      OnChange = ComboBoxFromChange
    end
    object ComboBoxTo: TComboBox
      Left = 351
      Top = 7
      Width = 79
      Height = 21
      DropDownCount = 12
      ItemHeight = 13
      TabOrder = 3
      Text = 'Tab 1'
      OnChange = ComboBoxToChange
    end
    object ButtonMoveCard: TButton
      Left = 351
      Top = 33
      Width = 61
      Height = 20
      Caption = 'Move Card'
      TabOrder = 4
      OnClick = ButtonMoveCardClick
    end
    object ButtonFlip: TButton
      Left = 241
      Top = 33
      Width = 60
      Height = 20
      Caption = 'Flip Top'
      TabOrder = 5
      OnClick = ButtonFlipClick
    end
    object ButtonMovePile: TButton
      Left = 488
      Top = 33
      Width = 60
      Height = 20
      Caption = 'Move Pile'
      TabOrder = 6
      OnClick = ButtonMovePileClick
    end
    object ComboBoxIndex: TComboBox
      Left = 488
      Top = 7
      Width = 65
      Height = 21
      ItemHeight = 13
      TabOrder = 7
      Text = 'ComboBoxIndex'
      OnChange = ComboBoxIndexChange
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 707
    Height = 443
    ActivePage = TabSheetImages
    Align = alClient
    TabOrder = 2
    object TabSheetText: TTabSheet
      Caption = 'Text'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 1006
      ExplicitHeight = 541
      object DeckStringGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 699
        Height = 46
        Align = alTop
        ColCount = 7
        FixedCols = 0
        RowCount = 2
        TabOrder = 0
        ExplicitWidth = 1006
        ColWidths = (
          64
          64
          64
          64
          64
          64
          64)
      end
      object TableauStringGrid: TStringGrid
        Left = 0
        Top = 46
        Width = 699
        Height = 369
        Align = alClient
        ColCount = 8
        RowCount = 21
        TabOrder = 1
        ExplicitWidth = 1006
        ExplicitHeight = 495
      end
    end
    object TabSheetImages: TTabSheet
      Caption = 'Images'
      ImageIndex = 1
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 699
        Height = 415
        Align = alClient
        Color = clGreen
        TabOrder = 0
        DesignSize = (
          699
          415)
        object TableauDrawGrid: TDrawGrid
          Left = 13
          Top = 65
          Width = 596
          Height = 344
          Anchors = [akLeft, akTop, akBottom]
          Color = clGreen
          ColCount = 8
          DefaultColWidth = 60
          DefaultRowHeight = 50
          RowCount = 19
          FixedRows = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
          TabOrder = 0
          OnDragDrop = TableauDrawGridDragDrop
          OnDragOver = TableauDrawGridDragOver
          OnDrawCell = TableauDrawGridDrawCell
          OnMouseDown = TableauDrawGridMouseDown
        end
        object DeckDrawGrid: TDrawGrid
          Left = 63
          Top = 13
          Width = 546
          Height = 47
          Color = clGreen
          ColCount = 7
          DefaultColWidth = 60
          DefaultRowHeight = 48
          FixedCols = 0
          RowCount = 1
          FixedRows = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
          ScrollBars = ssNone
          TabOrder = 1
          OnDragDrop = DeckDrawGridDragDrop
          OnDragOver = DeckDrawGridDragOver
          OnDrawCell = DeckDrawGridDrawCell
          OnMouseDown = DeckDrawGridMouseDown
        end
      end
    end
    object TabSheetGUI: TTabSheet
      Caption = 'GUI'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 1006
      ExplicitHeight = 541
    end
  end
end
