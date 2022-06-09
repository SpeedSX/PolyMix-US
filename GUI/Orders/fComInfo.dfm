object frCommonInfo: TfrCommonInfo
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  AutoSize = True
  TabOrder = 0
  OnResize = FrameResize
  object paCommonInfo: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 304
    Align = alClient
    BevelOuter = bvLowered
    Color = clInfoBk
    ParentBackground = False
    TabOrder = 0
    object bvlCreation: TBevel
      Left = 263
      Top = 26
      Width = 2
      Height = 277
      Align = alRight
      Shape = bsRightLine
      ExplicitLeft = 260
    end
    object paNText: TPanel
      Left = 1
      Top = 1
      Width = 449
      Height = 25
      Align = alTop
      BevelOuter = bvNone
      Caption = ' '
      Color = clGray
      ParentBackground = False
      TabOrder = 0
      object dtID: TDBText
        Left = 80
        Top = 6
        Width = 25
        Height = 13
        AutoSize = True
        DataField = 'ID'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lbID: TLabel
        Left = 30
        Top = 6
        Width = 34
        Height = 13
        Caption = #1064#1080#1092#1088':'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object Bevel10: TBevel
        Left = 164
        Top = 3
        Width = 9
        Height = 18
        Shape = bsLeftLine
        Visible = False
      end
      object lbStateInHdr: TLabel
        Left = 174
        Top = 6
        Width = 23
        Height = 13
        Caption = #1042#1080#1076':'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object dtKindName: TDBText
        Left = 202
        Top = 6
        Width = 68
        Height = 13
        AutoSize = True
        DataField = 'KindName'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object imLock: TImage
        Left = 2
        Top = 1
        Width = 22
        Height = 22
        Transparent = True
      end
    end
    object paCreationInfo: TPanel
      Left = 265
      Top = 26
      Width = 185
      Height = 277
      Align = alRight
      BevelOuter = bvNone
      Color = clInfoBk
      ParentBackground = False
      TabOrder = 1
      object dtDModify: TDBText
        Left = 7
        Top = 61
        Width = 58
        Height = 13
        AutoSize = True
        DataField = 'ModifyDate'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object dtTModify: TDBText
        Left = 120
        Top = 61
        Width = 57
        Height = 13
        Alignment = taRightJustify
        AutoSize = True
        DataField = 'ModifyTime'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object dtModifierName: TDBText
        Left = 102
        Top = 44
        Width = 75
        Height = 13
        Alignment = taRightJustify
        AutoSize = True
        DataField = 'ModifierName'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label17: TLabel
        Left = 8
        Top = 44
        Width = 46
        Height = 13
        Caption = #1048#1079#1084#1077#1085#1077#1085':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object dtDCreation: TDBText
        Left = 9
        Top = 21
        Width = 68
        Height = 13
        AutoSize = True
        DataField = 'CreationDate'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object dtTCreation: TDBText
        Left = 110
        Top = 21
        Width = 67
        Height = 13
        Alignment = taRightJustify
        AutoSize = True
        DataField = 'CreationTime'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object dtCreatorName: TDBText
        Left = 103
        Top = 4
        Width = 74
        Height = 13
        Alignment = taRightJustify
        AutoSize = True
        DataField = 'CreatorName'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label48: TLabel
        Left = 9
        Top = 4
        Width = 41
        Height = 13
        Caption = #1057#1086#1079#1076#1072#1085':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lbFactFinDate: TLabel
        Left = 6
        Top = 86
        Width = 94
        Height = 13
        Caption = #1060#1072#1082#1090'. '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1077
      end
      object dtDFactFDate: TDBText
        Left = 6
        Top = 103
        Width = 77
        Height = 13
        AutoSize = True
        DataField = 'FactFinishDate'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dtTFactFDate: TDBText
        Left = 101
        Top = 103
        Width = 76
        Height = 13
        Alignment = taRightJustify
        AutoSize = True
        DataField = 'FactFinishTime'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sbHistory: TBitBtn
        Left = 18
        Top = 130
        Width = 161
        Height = 24
        Caption = #1048#1089#1090#1086#1088#1080#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103'...'
        TabOrder = 1
        Glyph.Data = {
          1E030000424D1E030000000000001E0100002800000020000000100000000100
          08000000000000020000120B0000120B00003A0000003A00000000000000FFFF
          FF007E7D7F007F748800FF00FF0063313100DE9C8400A24F2200D6C6BD00F7E7
          DE00CE630000C9762B00F7D6B500F6CA9A00D06F0100DA7B0D00ED973300EFBD
          7B00DE9C3900FF9C0000D6840000FFE7B500FFFFDE00FEFEFD00FCFCFB00FAFA
          F900F7F7F600F3F3F200EFEFEE00EBEBEA00306DF900FDFDFD00FBFBFB00F9F9
          F900F6F6F600F2F2F200EEEEEE00EAEAEA00E7E7E700DADADA00D6D6D600C9C9
          C900C8C8C800C6C6C600B5B5B500B1B1B1009C9C9C0094949400909090008B8B
          8B007F7F7F007A7A7A00737373006B6B6B006868680067676700626262004A4A
          4A00040404040404040404040404040404040404040404040404040404040404
          0404050505050505050504040404040404043939393939393939040404040404
          040414161513140A0A0507070707070707073524273235373739383838383838
          383804141414141405062626262626262607043535353535392D262626262626
          263804140105052E05062611111C2929260704350139392E392D262C2C242929
          263804140113142E0506260C121B1C1D260704350132352E392D262831232425
          2638040414262B0508062611111A29292607040435262B39292D262C2C222929
          263804040B1405170906260C12191A1B260704043335391F252D262831212223
          263804041426050508062611111729292607040435263939292D262C2C1F2929
          263804140113052E0506260C12171718260704350132392E392D2628311F1F20
          2638041401262B2E05062611111729292607043501262B2E392D262C2C1F2929
          26380405050505050506260C121717172607043939393939392D2628311F1F1F
          263814161513140A0A0526262626262626073524273235373739262626262626
          263814141414141414050E0E0E0E0E0E0E073535353535353539363636363636
          363804040A1010101010100D100D101E030A0404373030303030302A302A302F
          02370404040F0F0F0F0F0F0F0F0F0F0F0F040404043434343434343434343434
          3404}
        NumGlyphs = 2
        Spacing = 6
      end
      object btDecompose: TBitBtn
        Left = 48
        Top = 159
        Width = 93
        Height = 24
        Caption = #1056#1072#1079#1073#1080#1074#1082#1072' '#1079#1072#1082#1072#1079#1072'...'
        TabOrder = 0
        Visible = False
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333300000003
          33333333777777733333333330CCC03333333333F7777733F3333330330C0330
          33333337337773373333333333303333333333F33337333333F3303333333333
          3033373333333333373333333333333333333F3333333333333F033333333333
          3303733333333333337333333333333333333F3333333333333F033333333333
          3303733333333333FF7333333333333000333FFFFF33333777FF000003333307
          B70377777F333377777F09990333330BBB0377777F333377777F099903333307
          B70377777F3333777773099903333330003377777F3333377733000003333330
          3333777773F3F3F7333333333030303333333333373737333333}
        NumGlyphs = 2
      end
    end
    object paCostInfo: TPanel
      Left = 1
      Top = 26
      Width = 262
      Height = 277
      Align = alClient
      BevelOuter = bvNone
      Caption = ' '
      Color = clInfoBk
      ParentBackground = False
      TabOrder = 2
      object lbCost1Name: TLabel
        Left = 10
        Top = 21
        Width = 63
        Height = 13
        Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object dtCost1: TDBText
        Left = 123
        Top = 21
        Width = 44
        Height = 13
        AutoSize = True
        Color = clNone
        DataField = 'TotalGrn'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object lbOld: TLabel
        Left = 123
        Top = 4
        Width = 45
        Height = 13
        Caption = #1058#1077#1082#1091#1097#1072#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lbNew: TLabel
        Left = 251
        Top = 4
        Width = 31
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1086#1074#1072#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lbCost1: TLabel
        Left = 276
        Top = 21
        Width = 7
        Height = 13
        Alignment = taRightJustify
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object dtCostOf1BaseCurrency: TDBText
        Left = 123
        Top = 87
        Width = 117
        Height = 13
        AutoSize = True
        Color = clNone
        DataField = 'CostOf1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
      end
      object lbCostOf1BaseCurrency: TLabel
        Left = 277
        Top = 87
        Width = 6
        Height = 13
        Alignment = taRightJustify
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lbCostOf1BaseCurrencyName: TLabel
        Left = 10
        Top = 87
        Width = 90
        Height = 13
        Caption = #1062#1077#1085#1072' 1 '#1101#1082#1079'. '#1074' '#1091'.'#1077'.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lbFinishDate: TLabel
        Left = 10
        Top = 108
        Width = 93
        Height = 13
        Caption = #1055#1083#1072#1085'. '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 8
        Top = 160
        Width = 268
        Height = 13
        Caption = #1056#1072#1079#1084#1077#1088#1099' '#1080' '#1074#1099#1088#1072#1074#1085#1080#1074#1072#1085#1080#1077' '#1087#1072#1085#1077#1083#1077#1081' '#1084#1077#1085#1103#1102#1090#1089#1103' '#1074' '#1082#1086#1076#1077'!'
        Transparent = True
        Visible = False
      end
      object Bevel1: TBevel
        Left = 6
        Top = 60
        Width = 279
        Height = 6
        Shape = bsTopLine
      end
      object imNotes: TImage
        Left = 154
        Top = 133
        Width = 18
        Height = 18
        Transparent = True
        OnClick = imNotesClick
      end
      object paCostClient: TPanel
        Left = 4
        Top = 65
        Width = 285
        Height = 17
        BevelOuter = bvNone
        Caption = ' '
        Color = clYellow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 4
        object dtCostClientBaseCurrency: TDBText
          Left = 119
          Top = 2
          Width = 147
          Height = 13
          AutoSize = True
          DataField = 'ClientTotal'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
        object lbCostClientBaseCurrencyName: TLabel
          Left = 6
          Top = 2
          Width = 103
          Height = 13
          Caption = #1062#1077#1085#1072' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1095#1080#1082#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbCostClientBaseCurrency: TLabel
          Left = 272
          Top = 2
          Width = 7
          Height = 13
          Alignment = taRightJustify
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
        end
      end
      object btProperties: TBitBtn
        Left = 8
        Top = 130
        Width = 141
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333300333
          33333333333773FF333333333330F0033333333333373773FF333333330FFFF0
          03333333337F333773FF3333330FFFFFF003333333733FF33773333330FF00FF
          FF80333337F3773F3337333330FFFF0FFFF03FFFF7FFF3733F3700000000FFFF
          0FF0777777773FF373370000000000FFFFF07FFFFFF377FFF3370CCCCC000000
          FF037777773337773F7300CCC000003300307F77733337F37737000C00000033
          33307F373333F7F333370000007B703333307FFFF337F7F33337099900BBB033
          33307777F37777FF33370999007B700333037777F3373773FF73099900000030
          00337777FFFFF7F7773300000000003333337777777777333333}
        NumGlyphs = 2
        Spacing = 6
      end
      object paCost2: TPanel
        Left = 4
        Top = 38
        Width = 285
        Height = 17
        BevelOuter = bvNone
        Caption = ' '
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        object dtCost2: TDBText
          Left = 119
          Top = 2
          Width = 44
          Height = 13
          AutoSize = True
          Color = clNone
          DataField = 'TotalCost'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object lbCost2: TLabel
          Left = 272
          Top = 2
          Width = 7
          Height = 13
          Alignment = taRightJustify
          Caption = '0'
          Color = clNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
        object lbCost2Name: TLabel
          Left = 6
          Top = 2
          Width = 63
          Height = 13
          Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' 2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
      end
      object paFinishDate: TPanel
        Left = 116
        Top = 107
        Width = 173
        Height = 17
        BevelOuter = bvNone
        Caption = ' '
        Color = clYellow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
        object dtFinishDate: TDBText
          Left = 6
          Top = 2
          Width = 71
          Height = 13
          AutoSize = True
          Color = clNone
          DataField = 'FinishDate'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Transparent = True
        end
      end
      object pbOpenProgress: TJvProgressBar
        Left = 158
        Top = 139
        Width = 95
        Height = 10
        Smooth = True
        Step = 1
        TabOrder = 2
        Visible = False
        FillColor = clBtnShadow
      end
    end
  end
end
