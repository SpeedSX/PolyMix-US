object UEForm: TUEForm
  Left = 553
  Top = 332
  BorderStyle = bsDialog
  Caption = #1050#1091#1088#1089' '#1091#1089#1083#1086#1074#1085#1086#1081' '#1077#1076#1080#1085#1080#1094#1099
  ClientHeight = 161
  ClientWidth = 376
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
  object lbAppCourse: TLabel
    Left = 8
    Top = 16
    Width = 81
    Height = 26
    Caption = #1050#1091#1088#1089' '#1076#1083#1103' '#1085#1086#1074#1099#1093#13#10#1079#1072#1082#1072#1079#1086#1074
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbGlobalCap: TLabel
    Left = 8
    Top = 94
    Width = 130
    Height = 13
    Caption = #1058#1077#1082#1091#1097#1080#1081' '#1082#1091#1088#1089' '#1085#1072' '#1089#1077#1088#1074#1077#1088#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbOrdCourse: TLabel
    Left = 8
    Top = 52
    Width = 61
    Height = 13
    Caption = #1050#1091#1088#1089' '#1079#1072#1082#1072#1079#1072
  end
  object btViewCourse: TSpeedButton
    Left = 203
    Top = 87
    Width = 166
    Height = 25
    Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1080#1079#1084#1077#1085#1077#1085#1080#1081' '#1075#1083#1086#1073#1072#1083#1100#1085#1086#1075#1086' '#1082#1091#1088#1089#1072
    Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1103' '#1082#1091#1088#1089#1072'...'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      0400000000000001000000000000000000001000000010000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00337333733373
      3373337F3F7F3F7F3F7F33737373737373733F7F7F7F7F7F7F7F770000000000
      000077777777777777773303333333333333337FF333333F33333709333333C3
      333337773F3FF373F333330393993C3C33333F7F7F77F7F7FFFF77079797977C
      77777777777777777777330339339333C333337FF73373F37F33370C333C3933
      933337773F3737F37FF33303C3C33939C9333F7F7F7FF7F777FF7707C7C77797
      7C97777777777777777733033C3333333C33337F37F33333373F37033C333333
      33C3377F37333333337333033333333333333F7FFFFFFFFFFFFF770777777777
      7777777777777777777733333333333333333333333333333333}
    NumGlyphs = 2
    OnClick = btViewCourseClick
  end
  object lbSrvCourse: TLabel
    Left = 156
    Top = 94
    Width = 35
    Height = 13
    Caption = '55555'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 8
    Top = 80
    Width = 365
    Height = 13
    Shape = bsTopLine
  end
  object Bevel2: TBevel
    Left = 7
    Top = 118
    Width = 365
    Height = 13
    Shape = bsTopLine
  end
  object edAppCourse: TJvValidateEdit
    Left = 108
    Top = 12
    Width = 85
    Height = 21
    AutoSize = False
    CriticalPoints.MaxValueIncluded = False
    CriticalPoints.MinValueIncluded = False
    DisplayFormat = dfFloat
    DecimalPlaces = 2
    EditText = '0,00'
    TabOrder = 0
  end
  object edOrdCourse: TJvValidateEdit
    Left = 108
    Top = 48
    Width = 85
    Height = 21
    AutoSize = False
    CriticalPoints.MaxValueIncluded = False
    CriticalPoints.MinValueIncluded = False
    DisplayFormat = dfFloat
    DecimalPlaces = 2
    EditText = '0,00'
    TabOrder = 1
  end
  object btOk: TButton
    Left = 204
    Top = 128
    Width = 77
    Height = 25
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btCancel: TButton
    Left = 292
    Top = 128
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object btSetSrvCourse: TBitBtn
    Left = 208
    Top = 11
    Width = 161
    Height = 25
    Hint = #1057#1076#1077#1083#1072#1090#1100' '#1082#1091#1088#1089' '#1075#1083#1086#1073#1072#1083#1100#1085#1099#1084
    Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1072' '#1089#1077#1088#1074#1077#1088#1077
    ModalResult = 6
    TabOrder = 4
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      0400000000000001000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      555555555555555555555555555555555555555555FF55555555555559055555
      55555555577FF5555555555599905555555555557777F5555555555599905555
      555555557777FF5555555559999905555555555777777F555555559999990555
      5555557777777FF5555557990599905555555777757777F55555790555599055
      55557775555777FF5555555555599905555555555557777F5555555555559905
      555555555555777FF5555555555559905555555555555777FF55555555555579
      05555555555555777FF5555555555557905555555555555777FF555555555555
      5990555555555555577755555555555555555555555555555555}
    NumGlyphs = 2
  end
end
