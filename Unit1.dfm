object BinPatch: TBinPatch
  Left = 0
  Top = 0
  Caption = 'BinPatch'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 300
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 355
    Width = 624
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ResizeStyle = rsUpdate
    ExplicitTop = 31
    ExplicitWidth = 302
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 422
    Width = 624
    Height = 19
    AutoHint = True
    Panels = <>
    ParentShowHint = False
    ShowHint = True
    SimplePanel = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 31
    Align = alTop
    TabOrder = 1
    DesignSize = (
      624
      31)
    object Button1: TButton
      Left = 575
      Top = 4
      Width = 46
      Height = 21
      Hint = '|Open *.bin file.'
      Anchors = [akTop, akRight]
      Caption = 'Open'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = Button1Click
    end
    object Edit1: TEdit
      Left = 4
      Top = 4
      Width = 517
      Height = 21
      Hint = '|Path to *.bin file.'
      Anchors = [akLeft, akTop, akRight]
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
    end
    object Button2: TButton
      Left = 527
      Top = 4
      Width = 46
      Height = 21
      Hint = '|Reload opened file.'
      Anchors = [akTop, akRight]
      Caption = 'Reload'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object ListView1: TListView
    Left = 0
    Top = 31
    Width = 624
    Height = 324
    Hint = '|Patch list.'
    Align = alClient
    Columns = <
      item
        Caption = 'Id.'
        Width = 35
      end
      item
        Caption = 'Address'
        Width = 80
      end
      item
        Caption = 'Len.'
        Width = 45
      end
      item
        AutoSize = True
        Caption = 'Data'
      end>
    ReadOnly = True
    RowSelect = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    ViewStyle = vsReport
    OnClick = ListView1Click
    OnColumnClick = ListView1ColumnClick
    OnCompare = ListView1Compare
  end
  object Memo1: TMemo
    Left = 0
    Top = 358
    Width = 624
    Height = 64
    Hint = '|Patch data.'
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Patcher file (*.bin)|*.bin|Any file (*.*)|*.*'
    FilterIndex = 0
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 40
    Top = 80
  end
end
