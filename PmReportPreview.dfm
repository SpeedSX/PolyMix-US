object ReportPreviewForm: TReportPreviewForm
  Left = 192
  Top = 389
  ClientHeight = 533
  ClientWidth = 768
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 768
    Height = 496
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object dgReport: TMyDBGridEh
      Left = 5
      Top = 5
      Width = 758
      Height = 486
      Align = alClient
      DataSource = dsReport
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'Tahoma'
      FooterFont.Style = []
      OptionsEh = [dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDblClickOptimizeColWidth, dghDialogFind]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 496
    Width = 768
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      768
      37)
    object Label1: TLabel
      Left = 10
      Top = 20
      Width = 441
      Height = 13
      Caption = 
        #1044#1074#1072#1078#1076#1099' '#1085#1072#1078#1084#1080#1090#1077' '#1084#1099#1096#1100#1102' '#1085#1072' '#1088#1072#1079#1076#1077#1083#1080#1090#1077#1083#1077' '#1089#1090#1086#1083#1073#1094#1086#1074' '#1076#1083#1103' '#1086#1087#1090#1080#1084#1080#1079#1072#1094#1080#1080' '#1096#1080#1088 +
        #1080#1085#1099' '#1089#1090#1086#1083#1073#1094#1072
    end
    object BitBtn2: TBitBtn
      Left = 688
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ModalResult = 2
      TabOrder = 0
    end
    object btXL: TBitBtn
      Left = 528
      Top = 6
      Width = 153
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1074' Excel'
      TabOrder = 1
      Glyph.Data = {
        76010000424D7601000000000000760000002800000010000000100000000100
        08000000000000010000120B0000120B00001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000A0802080208
        020802080208020802080802080208020802080208020802080202080F0F0F0F
        0F0F0F0F0F0F0F0F020808020F0F0F0F0F0F0F0802080208080202080F020802
        080208020F020802020808020F0802080208020F0208020F080202080F020802
        08020F020802080F020808020F0F0208020F02080208020F080202080F0F0F02
        0F020802080F0F0F020808020F0F020F0208020802080F0F080202080F020F02
        080208020802080F020808020F08020802080F080208020F080202080F020802
        080F0F0F0802080F020808020F0F0F0F0F0F0F0F0F0F0F0F0802020802080208
        020802080208020802080A02080208020802080208020802080A}
      Spacing = 8
    end
    object cbAutoFit: TCheckBox
      Left = 10
      Top = 0
      Width = 165
      Height = 17
      Caption = #1042#1084#1077#1089#1090#1080#1090#1100' '#1074#1089#1077' '#1089#1090#1086#1083#1073#1094#1099
      TabOrder = 2
      OnClick = cbAutoFitClick
    end
  end
  object dsReport: TDataSource
    Left = 194
    Top = 140
  end
end
