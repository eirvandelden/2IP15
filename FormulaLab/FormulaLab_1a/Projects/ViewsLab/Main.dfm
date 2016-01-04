object Form1: TForm1
  Left = 192
  Top = 118
  Caption = 'Form1'
  ClientHeight = 629
  ClientWidth = 944
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 185
    Top = 97
    Height = 532
    Beveled = True
    ExplicitHeight = 528
  end
  object Splitter3: TSplitter
    Left = 401
    Top = 97
    Height = 532
    ExplicitHeight = 528
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 944
    Height = 97
    Align = alTop
    TabOrder = 0
    DesignSize = (
      944
      97)
    object RadioGroup1: TRadioGroup
      Left = 1
      Top = 1
      Width = 185
      Height = 95
      Align = alLeft
      Caption = 'Problem Domain'
      ItemIndex = 0
      Items.Strings = (
        '&Regular Expressions'
        '&Propositions'
        '&Analysis')
      TabOrder = 0
      OnClick = RadioGroup1Click
    end
    object InfixText: TLabeledEdit
      Left = 208
      Top = 24
      Width = 713
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 19
      EditLabel.Height = 13
      EditLabel.Caption = 'Infix'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object PrefixText: TLabeledEdit
      Left = 208
      Top = 64
      Width = 713
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = 'Prefix'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 97
    Width = 185
    Height = 532
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 0
      Top = 241
      Width = 185
      Height = 2
      Cursor = crVSplit
      Align = alTop
    end
    object ScrollBox1: TScrollBox
      Left = 0
      Top = 243
      Width = 185
      Height = 289
      Align = alClient
      BevelInner = bvNone
      TabOrder = 0
    end
    object PanelOutline: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 241
      Align = alTop
      BevelOuter = bvNone
      Caption = 'PanelOutline'
      TabOrder = 1
    end
  end
  object Memo1: TMemo
    Left = 188
    Top = 97
    Width = 213
    Height = 532
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
  end
  object ScrollBox2: TScrollBox
    Left = 404
    Top = 97
    Width = 540
    Height = 532
    Align = alClient
    TabOrder = 3
  end
end
