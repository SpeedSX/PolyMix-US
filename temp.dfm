object PrintForm: TPrintForm
  Left = 425
  Top = 167
  BorderStyle = bsDialog
  Caption = #1055#1077#1095#1072#1090#1100' '#1087#1088#1086#1089#1095#1077#1090#1072
  ClientHeight = 303
  ClientWidth = 448
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 2
    Top = 54
    Width = 441
    Height = 211
    Caption = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103' '
    TabOrder = 0
    object CB_proba: TCheckBox
      Left = 8
      Top = 97
      Width = 97
      Height = 17
      Caption = #1062#1074#1077#1090#1086#1087#1088#1086#1073#1072
      TabOrder = 2
    end
    object CB_print: TCheckBox
      Left = 8
      Top = 116
      Width = 113
      Height = 17
      Caption = #1041#1091#1084#1072#1075#1072' '#1080' '#1087#1077#1095#1072#1090#1100
      TabOrder = 3
    end
    object CB_dopoln: TCheckBox
      Left = 144
      Top = 172
      Width = 97
      Height = 17
      Caption = #1044#1086#1087#1086#1083#1085#1077#1085#1080#1103
      Enabled = False
      TabOrder = 4
      Visible = False
    end
    object cb_utoch: TCheckBox
      Left = 8
      Top = 17
      Width = 97
      Height = 17
      Caption = #1059#1090#1086#1095#1085#1080#1090#1100' ...'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = CB_utochClick
    end
    object GrBox_prikid: TGroupBox
      Left = 142
      Top = 20
      Width = 289
      Height = 161
      Color = clBtnFace
      ParentColor = False
      TabOrder = 5
      object lbFrom: TLabel
        Left = 40
        Top = 18
        Width = 11
        Height = 13
        Caption = #1086#1090
      end
      object lbTo: TLabel
        Left = 40
        Top = 49
        Width = 12
        Height = 13
        Caption = #1076#1086
      end
      object lbStep: TLabel
        Left = 10
        Top = 79
        Width = 42
        Height = 13
        Caption = #1089' '#1096#1072#1075#1086#1084
      end
      object edFrom: TSpinEdit
        Left = 60
        Top = 14
        Width = 73
        Height = 22
        Increment = 1000
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 1000
      end
      object edTo: TSpinEdit
        Left = 60
        Top = 45
        Width = 73
        Height = 22
        Increment = 1000
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 10000
      end
      object edStep: TSpinEdit
        Left = 60
        Top = 75
        Width = 73
        Height = 22
        Increment = 500
        MaxValue = 0
        MinValue = 0
        TabOrder = 2
        Value = 1000
      end
      object dgTirazz: TMyDBGridEh
        Left = 180
        Top = 17
        Width = 97
        Height = 113
        DataSource = dsNProduct
        Enabled = False
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines]
        OptionsEh = [dghHighlightFocus, dghClearSelection, dghDialogFind]
        RowHeight = 17
        TabOrder = 4
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnExit = dgTirazzExit
        Columns = <
          item
            EditButtons = <>
            FieldName = 'N'
            Footers = <>
            Title.Caption = #1058#1080#1088#1072#1078#1080
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -11
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 56
          end>
      end
      object cbTable: TCheckBox
        Left = 160
        Top = 15
        Width = 18
        Height = 17
        TabOrder = 3
        OnClick = cbTableClick
      end
      object btDelTirazz: TBitBtn
        Left = 180
        Top = 132
        Width = 97
        Height = 21
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 5
        OnClick = btDelTirazzClick
      end
    end
    object cb_prikid: TCheckBox
      Left = 156
      Top = 16
      Width = 77
      Height = 17
      Caption = #1055#1088#1080#1082#1080#1076#1082#1072
      TabOrder = 6
      OnClick = cb_prikidClick
    end
    object for_dopoln_memo: TMemo
      Left = 142
      Top = 190
      Width = 289
      Height = 23
      Enabled = False
      TabOrder = 7
      Visible = False
      OnChange = for_dopoln_memoChange
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 140
      Width = 121
      Height = 63
      Caption = ' '#1045#1076#1080#1085#1080#1094#1099' '
      TabOrder = 8
      object rbGrn: TRadioButton
        Left = 12
        Top = 36
        Width = 60
        Height = 17
        Caption = #1075#1088#1085'.'
        TabOrder = 0
      end
      object rbUE: TRadioButton
        Left = 12
        Top = 18
        Width = 60
        Height = 17
        Caption = #1091'. '#1077'.'
        Checked = True
        TabOrder = 1
        TabStop = True
      end
    end
    object dgDetType: TMyDBGridEh
      Left = 8
      Top = 35
      Width = 121
      Height = 56
      DataSource = dsDetType
      Enabled = False
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      Options = [dgIndicator, dgColumnResize, dgRowSelect]
      OptionsEh = [dghHighlightFocus, dghClearSelection, dghDialogFind]
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          EditButtons = <>
          FieldName = 'Name'
          Footers = <>
          Title.Caption = #1058#1080#1088#1072#1078#1080
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Width = 56
        end>
    end
  end
  object gbCost: TGroupBox
    Left = 2
    Top = 6
    Width = 441
    Height = 43
    Caption = ' '#1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1079#1072#1082#1072#1079#1072' '
    TabOrder = 1
    object rbItogo: TRadioButton
      Left = 10
      Top = 16
      Width = 159
      Height = 17
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
      TabOrder = 0
    end
    object rbClient: TRadioButton
      Left = 188
      Top = 16
      Width = 113
      Height = 17
      Caption = #1062#1077#1085#1072' '#1076#1083#1103' '#1082#1083#1080#1077#1085#1090#1072
      TabOrder = 1
    end
  end
  object btPrint: TBitBtn
    Left = 244
    Top = 272
    Width = 99
    Height = 25
    Caption = #1055#1077#1095#1072#1090#1100'...'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btPrintClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      0400000000000001000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
      0003377777777777777308888888888888807F33333333333337088888888888
      88807FFFFFFFFFFFFFF7000000000000000077777777777777770F8F8F8F8F8F
      8F807F333333333333F708F8F8F8F8F8F9F07F333333333337370F8F8F8F8F8F
      8F807FFFFFFFFFFFFFF7000000000000000077777777777777773330FFFFFFFF
      03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
      03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
      33333337F3F37F3733333330F08F0F0333333337F7337F7333333330FFFF0033
      33333337FFFF7733333333300000033333333337777773333333}
    NumGlyphs = 2
    Spacing = 10
  end
  object btCancel: TBitBtn
    Left = 356
    Top = 272
    Width = 87
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object cdNProduct: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 338
    Top = 62
    object cdNProductN: TIntegerField
      FieldName = 'N'
    end
  end
  object dsNProduct: TDataSource
    DataSet = cdNProduct
    Left = 298
    Top = 58
  end
  object dsDetType: TDataSource
    Left = 102
    Top = 108
  end
end
