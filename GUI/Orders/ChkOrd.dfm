object ChkOrdForm: TChkOrdForm
  Left = 311
  Top = 182
  BorderStyle = bsDialog
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072
  ClientHeight = 355
  ClientWidth = 543
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 318
    Width = 543
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    object Panel2: TPanel
      Left = 272
      Top = 0
      Width = 271
      Height = 37
      Align = alRight
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      object btOk: TButton
        Left = 8
        Top = 8
        Width = 85
        Height = 25
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        ModalResult = 1
        TabOrder = 0
      end
      object btCancel: TButton
        Left = 100
        Top = 8
        Width = 165
        Height = 25
        Caption = #1042#1077#1088#1085#1091#1090#1100#1089#1103' '#1082' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1102
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 543
    Height = 318
    ActivePage = tsMsgs
    Align = alClient
    TabOrder = 1
    object tsMsgs: TTabSheet
      Caption = '0 '#1089#1086#1086#1073#1097#1077#1085#1080#1081
      object dgMsgs: TJvDrawGrid
        Left = 0
        Top = 0
        Width = 535
        Height = 290
        Align = alClient
        ColCount = 3
        DefaultRowHeight = 35
        FixedCols = 0
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
        OnDrawCell = dgMsgsDrawCell
        DrawButtons = False
        ColWidths = (
          40
          110
          353)
      end
    end
  end
end
