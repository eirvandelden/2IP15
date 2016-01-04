object Form1: TForm1
  Left = 192
  Top = 118
  Caption = 'Form1'
  ClientHeight = 638
  ClientWidth = 914
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenuRE
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 185
    Top = 97
    Height = 541
    Beveled = True
    ExplicitHeight = 537
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 914
    Height = 97
    Align = alTop
    TabOrder = 0
    DesignSize = (
      914
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
      Width = 683
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
  end
  object Panel2: TPanel
    Left = 0
    Top = 97
    Width = 185
    Height = 541
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 0
      Top = 224
      Width = 185
      Height = 2
      Cursor = crVSplit
      Align = alTop
    end
    object ScrollBox1: TScrollBox
      Left = 0
      Top = 0
      Width = 185
      Height = 224
      Align = alTop
      BevelInner = bvNone
      BevelOuter = bvNone
      TabOrder = 0
    end
    object Button1: TButton
      Left = 48
      Top = 248
      Width = 75
      Height = 25
      Caption = 'Undo'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 48
      Top = 320
      Width = 75
      Height = 25
      Caption = 'Redo'
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object Panel3: TPanel
    Left = 188
    Top = 97
    Width = 726
    Height = 541
    Align = alClient
    Caption = 'Panel3'
    TabOrder = 2
    object Splitter3: TSplitter
      Left = 1
      Top = 257
      Width = 724
      Height = 2
      Cursor = crVSplit
      Align = alTop
    end
    object ScrollBox2: TScrollBox
      Left = 1
      Top = 1
      Width = 724
      Height = 256
      Align = alTop
      TabOrder = 0
    end
    object Panel4: TPanel
      Left = 1
      Top = 259
      Width = 724
      Height = 46
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object DataEdit: TLabeledEdit
        Left = 40
        Top = 16
        Width = 121
        Height = 21
        EditLabel.Width = 52
        EditLabel.Height = 13
        EditLabel.Caption = 'Node Data'
        TabOrder = 0
        OnChange = DataEditChange
        OnKeyDown = DataEditKeyDown
      end
      object DataOKButton: TButton
        Left = 176
        Top = 16
        Width = 33
        Height = 20
        Caption = 'OK'
        TabOrder = 1
        OnClick = DataOKButtonClick
      end
    end
  end
  object PopupMenuProp: TPopupMenu
    OnPopup = PopupMenuPropPopup
    Left = 688
    Top = 56
    object true1: TMenuItem
      Caption = 'true'
      OnClick = true1Click
    end
    object false1: TMenuItem
      Caption = 'false'
      OnClick = false1Click
    end
    object Var2: TMenuItem
      Caption = 'Var ...'
      OnClick = Var2Click
    end
    object Not1: TMenuItem
      Caption = 'Not'
      OnClick = Not1Click
    end
    object And1: TMenuItem
      Caption = 'And'
      OnClick = And1Click
    end
    object Or1: TMenuItem
      Caption = 'Or'
      OnClick = Or1Click
    end
    object Implies1: TMenuItem
      Caption = 'Implies'
      OnClick = Implies1Click
    end
    object Equivalent1: TMenuItem
      Caption = 'Equivalent'
      OnClick = Equivalent1Click
    end
    object Tautology1: TMenuItem
      Caption = 'Tautology'
      object AndElim1: TMenuItem
        Caption = 'And Elim'
        OnClick = AndElim1Click
      end
      object OrIntro1: TMenuItem
        Caption = 'Or Intro'
        OnClick = OrIntro1Click
      end
      object DeMorgan1: TMenuItem
        Caption = 'De Morgan'
        OnClick = DeMorgan1Click
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Cut1: TMenuItem
      Caption = 'Cut'
      OnClick = Cut1Click
    end
    object Copy1: TMenuItem
      Caption = 'Copy'
      OnClick = Copy1Click
    end
    object Paste1: TMenuItem
      Caption = 'Paste'
      OnClick = Paste1Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Delete1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Clear1: TMenuItem
      Caption = 'Clear'
      OnClick = Clear1Click
    end
  end
  object PopupMenuRE: TPopupMenu
    OnPopup = PopupMenuREPopup
    Left = 760
    Top = 56
    object Eps1: TMenuItem
      Caption = 'Eps'
      OnClick = Eps1Click
    end
    object Id1: TMenuItem
      Caption = 'Id ...'
      OnClick = Id1Click
    end
    object Seq1: TMenuItem
      Caption = 'Seq ...'
    end
    object Dot1: TMenuItem
      Caption = 'Dot'
      OnClick = Dot1Click
    end
    object Stick1: TMenuItem
      Caption = 'Stick'
      OnClick = Stick1Click
    end
    object Range1: TMenuItem
      Caption = 'Range ...'
    end
    object Star1: TMenuItem
      Caption = 'Star'
      OnClick = Star1Click
    end
    object Plus1: TMenuItem
      Caption = 'Plus'
      OnClick = Plus1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Cut2: TMenuItem
      Caption = 'Cut'
      OnClick = Cut2Click
    end
    object Copy2: TMenuItem
      Caption = 'Copy'
      OnClick = Copy2Click
    end
    object Paste2: TMenuItem
      Caption = 'Paste'
      OnClick = Paste2Click
    end
    object Delete2: TMenuItem
      Caption = 'Delete'
      OnClick = Delete2Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Clear2: TMenuItem
      Caption = 'Clear'
      OnClick = Clear2Click
    end
  end
  object PopupMenuMath: TPopupMenu
    OnPopup = PopupMenuMathPopup
    Left = 832
    Top = 56
    object Const1: TMenuItem
      Caption = 'Const ...'
      OnClick = Const1Click
    end
    object Var1: TMenuItem
      Caption = 'Var ...'
      OnClick = Var1Click
    end
    object Unary1: TMenuItem
      Caption = 'Unary'
      object Minus1: TMenuItem
        Caption = 'Minus'
        OnClick = Minus1Click
      end
    end
    object Binary1: TMenuItem
      Caption = 'Binary'
      object Plus2: TMenuItem
        Caption = 'Plus'
        OnClick = Plus2Click
      end
      object Minus2: TMenuItem
        Caption = 'Minus'
        OnClick = Minus2Click
      end
      object Times1: TMenuItem
        Caption = 'Times'
        OnClick = Times1Click
      end
      object Divides1: TMenuItem
        Caption = 'Divides'
        OnClick = Divides1Click
      end
    end
    object FuncAppl1: TMenuItem
      Caption = 'Func Appl'
      object Sin1: TMenuItem
        Caption = 'Sin'
        OnClick = Sin1Click
      end
      object Cos1: TMenuItem
        Caption = 'Cos'
        OnClick = Cos1Click
      end
      object Exp1: TMenuItem
        Caption = 'Exp'
        OnClick = Exp1Click
      end
      object Ln1: TMenuItem
        Caption = 'Ln'
        OnClick = Ln1Click
      end
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Cut3: TMenuItem
      Caption = 'Cut'
      OnClick = Cut3Click
    end
    object Copy3: TMenuItem
      Caption = 'Copy'
      OnClick = Copy3Click
    end
    object Paste3: TMenuItem
      Caption = 'Paste'
      OnClick = Paste3Click
    end
    object Delete3: TMenuItem
      Caption = 'Delete'
      OnClick = Delete3Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Clear3: TMenuItem
      Caption = 'Clear'
      OnClick = Clear3Click
    end
  end
end
