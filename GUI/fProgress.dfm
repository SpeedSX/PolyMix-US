object ProgressFrame: TProgressFrame
  Left = 0
  Top = 0
  Width = 451
  Height = 58
  Align = alBottom
  TabOrder = 0
  object paWorkBottom: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 58
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    ParentColor = True
    TabOrder = 0
    object lbPlan: TLabel
      Left = 6
      Top = 8
      Width = 29
      Height = 13
      Caption = #1055#1083#1072#1085
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbFact: TLabel
      Left = 6
      Top = 36
      Width = 30
      Height = 13
      Caption = #1060#1072#1082#1090
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btFactStartNow: TSpeedButton
      Left = 176
      Top = 33
      Width = 22
      Height = 22
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1076#1072#1090#1091'/'#1074#1088#1077#1084#1103
      Flat = True
      Glyph.Data = {
        B6030000424DB603000000000000B60100002800000020000000100000000100
        08000000000000020000F40E0000F40E0000600000006000000000000000FFFF
        FF00FF00FF00BA251300E9331D00EA3D2800EB463200EC513E00ED584600EE60
        4F00F0746500F17C6E00F17D6F00F5A09600F6AAA100F8BEB700F9C6C000FAD1
        CC00FDEAE800FDECEA00E42E170076180C00E9372100EA392300EA412C00EB43
        2E00EC4D3900EC534000ED574400ED5D4B00EE5F4D00F0796A00F17F7100F285
        7700F2897C00F28B7E00F4978B00F49B9000F59F9400F6A99F00F6AFA600F8BF
        B800F8C3BC00F9CBC500FACDC700FCE4E100FCE5E200FCE7E400FEF6F500FEF7
        F600FBFBFB00FAFAFA00F6F6F600F5F5F500F4F4F400F3F3F300F2F2F200EAEA
        EA00E7E7E700E4E4E400E2E2E200E1E1E100E0E0E000D9D9D900D7D7D700D6D6
        D600D2D2D200D1D1D100D0D0D000CDCDCD00C8C8C800C7C7C700C4C4C400C2C2
        C200C1C1C100C0C0C000BFBFBF00BCBCBC00B2B2B200B1B1B100B0B0B000AEAE
        AE00ADADAD00ABABAB00AAAAAA00A8A8A800A4A4A400A3A3A300A2A2A200A0A0
        A0009D9D9D009C9C9C009B9B9B0095959500808080005C5C5C00020202020202
        0202020202020202020202020202020202020202020202020202020202020214
        0404040405020202020202020202025D5C5C5C5C590202020202020202071820
        2C032C2C0B1B170202020202025458493A5E3A3A4B535A020202020208062812
        011E0101122818170202020251563F35014F0101353F585A020202021E28032F
        010101010101281C020202024F3F5E360101010101013F520202020A21132F03
        010101010101121F1B02024D4834365E010101010101354C5302020C2B300101
        03260F2E2E30012C0602024A3A3301015E433E373733013A560202222B300101
        2615030303031103050202473A330101435F5E5E5E5E395E59020224031E0101
        13032C010101012C050202455E4F0101345E3A010101013A590202252D010101
        01032C010101012C0602024438010101015E3A010101013A560202252C310101
        01032C010101120A160202443A320101015E3A010101354D5B0202020F2F0101
        010313010101271C020202023E360101015E340101014152020202020D292E12
        011101011227191A02020202423D3735013901013541575502020202020D102A
        2C032C2C0E091D020202020202423B3C3A5E3A3A404E5002020202020202020D
        26230C0C0C020202020202020202024243464A4A4A0202020202020202020202
        0202020202020202020202020202020202020202020202020202}
      Layout = blGlyphRight
      NumGlyphs = 2
      Transparent = False
      OnClick = btFactStartNowClick
    end
    object btFactFinishNow: TSpeedButton
      Left = 360
      Top = 33
      Width = 22
      Height = 22
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1076#1072#1090#1091'/'#1074#1088#1077#1084#1103
      Flat = True
      Glyph.Data = {
        B6030000424DB603000000000000B60100002800000020000000100000000100
        08000000000000020000F40E0000F40E0000600000006000000000000000FFFF
        FF00FF00FF00BA251300E9331D00EA3D2800EB463200EC513E00ED584600EE60
        4F00F0746500F17C6E00F17D6F00F5A09600F6AAA100F8BEB700F9C6C000FAD1
        CC00FDEAE800FDECEA00E42E170076180C00E9372100EA392300EA412C00EB43
        2E00EC4D3900EC534000ED574400ED5D4B00EE5F4D00F0796A00F17F7100F285
        7700F2897C00F28B7E00F4978B00F49B9000F59F9400F6A99F00F6AFA600F8BF
        B800F8C3BC00F9CBC500FACDC700FCE4E100FCE5E200FCE7E400FEF6F500FEF7
        F600FBFBFB00FAFAFA00F6F6F600F5F5F500F4F4F400F3F3F300F2F2F200EAEA
        EA00E7E7E700E4E4E400E2E2E200E1E1E100E0E0E000D9D9D900D7D7D700D6D6
        D600D2D2D200D1D1D100D0D0D000CDCDCD00C8C8C800C7C7C700C4C4C400C2C2
        C200C1C1C100C0C0C000BFBFBF00BCBCBC00B2B2B200B1B1B100B0B0B000AEAE
        AE00ADADAD00ABABAB00AAAAAA00A8A8A800A4A4A400A3A3A300A2A2A200A0A0
        A0009D9D9D009C9C9C009B9B9B0095959500808080005C5C5C00020202020202
        0202020202020202020202020202020202020202020202020202020202020214
        0404040405020202020202020202025D5C5C5C5C590202020202020202071820
        2C032C2C0B1B170202020202025458493A5E3A3A4B535A020202020208062812
        011E0101122818170202020251563F35014F0101353F585A020202021E28032F
        010101010101281C020202024F3F5E360101010101013F520202020A21132F03
        010101010101121F1B02024D4834365E010101010101354C5302020C2B300101
        03260F2E2E30012C0602024A3A3301015E433E373733013A560202222B300101
        2615030303031103050202473A330101435F5E5E5E5E395E59020224031E0101
        13032C010101012C050202455E4F0101345E3A010101013A590202252D010101
        01032C010101012C0602024438010101015E3A010101013A560202252C310101
        01032C010101120A160202443A320101015E3A010101354D5B0202020F2F0101
        010313010101271C020202023E360101015E340101014152020202020D292E12
        011101011227191A02020202423D3735013901013541575502020202020D102A
        2C032C2C0E091D020202020202423B3C3A5E3A3A404E5002020202020202020D
        26230C0C0C020202020202020202024243464A4A4A0202020202020202020202
        0202020202020202020202020202020202020202020202020202}
      NumGlyphs = 2
      Transparent = False
      OnClick = btFactFinishNowClick
    end
    object imPlanArr: TImage
      Left = 208
      Top = 7
      Width = 16
      Height = 16
      Picture.Data = {
        07544269746D617036030000424D360300000000000036000000280000001000
        000010000000010018000000000000030000130B0000130B0000000000000000
        0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FF988671FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF988671988671
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FF988671EEBA8E988671FF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF988671EEBA8E
        EEBA8E988671FF00FFFF00FFFF00FFFF00FFD0A2849886719886719886719886
        71988671988671988671988671EEBA8EFFB47BEEBA8E988671FF00FFFF00FFFF
        00FFD0A284FFC992EEBA8EEEBA8EEEBA8EEEBA8EEEBA8EEEBA8EEEBA8EEEBA8E
        FFB47BFFB47BEEBA8E988671FF00FFFF00FFD0A284FFC992FFB47BFFB47BFFB4
        7BFFB47BFFB47BFFB47BFFB47BFFB47BFFB47BFFB47BFFB47BEEBA8E988671FF
        00FFD0A284FFC992FFBB81FFBB81FFBB81FFBB81FFBB81FFBB81FFBB81FFBB81
        FFBB81FFBB81FFBB81FFC992988671FF00FFD0A284FFC992F9CAA7F9CAA7F9CA
        A7F9CAA7F9CAA7F9CAA7F8C197EEBA8EFFBB81FFBB81F1D2AD988671FF00FFFF
        00FFD0A284D0A284D0A284D0A284D0A284D0A284D0A284D0A284D0A284EEBA8E
        FFBB81F1D2AD988671FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFD0A284EEBA8EF1D2AD988671FF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD0A284F1D2AD
        988671FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFD0A284988671FF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF988671FF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FF}
      Transparent = True
    end
    object imFactArr: TImage
      Left = 208
      Top = 35
      Width = 16
      Height = 16
      Picture.Data = {
        07544269746D617036030000424D360300000000000036000000280000001000
        000010000000010018000000000000030000130B0000130B0000000000000000
        0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FF988671FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF988671988671
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FF988671EEBA8E988671FF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF988671EEBA8E
        EEBA8E988671FF00FFFF00FFFF00FFFF00FFD0A2849886719886719886719886
        71988671988671988671988671EEBA8EFFB47BEEBA8E988671FF00FFFF00FFFF
        00FFD0A284FFC992EEBA8EEEBA8EEEBA8EEEBA8EEEBA8EEEBA8EEEBA8EEEBA8E
        FFB47BFFB47BEEBA8E988671FF00FFFF00FFD0A284FFC992FFB47BFFB47BFFB4
        7BFFB47BFFB47BFFB47BFFB47BFFB47BFFB47BFFB47BFFB47BEEBA8E988671FF
        00FFD0A284FFC992FFBB81FFBB81FFBB81FFBB81FFBB81FFBB81FFBB81FFBB81
        FFBB81FFBB81FFBB81FFC992988671FF00FFD0A284FFC992F9CAA7F9CAA7F9CA
        A7F9CAA7F9CAA7F9CAA7F8C197EEBA8EFFBB81FFBB81F1D2AD988671FF00FFFF
        00FFD0A284D0A284D0A284D0A284D0A284D0A284D0A284D0A284D0A284EEBA8E
        FFBB81F1D2AD988671FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFD0A284EEBA8EF1D2AD988671FF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD0A284F1D2AD
        988671FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFD0A284988671FF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF988671FF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FF}
      Transparent = True
    end
    object shPlanDur: TShape
      Left = 390
      Top = 6
      Width = 87
      Height = 19
    end
    object shFactDur: TShape
      Left = 390
      Top = 34
      Width = 87
      Height = 19
    end
    object Bevel1: TBevel
      Left = 202
      Top = 5
      Width = 9
      Height = 50
      Shape = bsLeftLine
    end
    object shPlanExec: TShape
      Left = 391
      Top = 7
      Width = 25
      Height = 18
      Brush.Color = clSkyBlue
      Pen.Style = psClear
      Pen.Width = 0
    end
    object dtPlanDur: TDBText
      Left = 390
      Top = 9
      Width = 87
      Height = 17
      Alignment = taCenter
      DataField = 'PlanDuration'
      Transparent = True
    end
    object shFactExec: TShape
      Left = 391
      Top = 35
      Width = 33
      Height = 18
      Brush.Color = clSkyBlue
      Pen.Style = psClear
      Pen.Width = 0
    end
    object dtFactDur: TDBText
      Left = 390
      Top = 37
      Width = 87
      Height = 17
      Alignment = taCenter
      DataField = 'FactDuration'
      Transparent = True
    end
    object dtPlanStartDate: TDBText
      Left = 48
      Top = 8
      Width = 57
      Height = 17
      DataField = 'PlanStartDate'
    end
    object dtPlanStartTime: TDBText
      Left = 132
      Top = 8
      Width = 65
      Height = 17
      DataField = 'PlanStartTime_ICalc'
    end
    object dtPlanFinishDate: TDBText
      Left = 232
      Top = 8
      Width = 57
      Height = 17
      DataField = 'PlanFinishDate'
    end
    object dtPlanFinishTime: TDBText
      Left = 316
      Top = 8
      Width = 65
      Height = 17
      DataField = 'PlanFinishTime_ICalc'
    end
    object deFactStart: TJvDBDateEdit
      Left = 46
      Top = 33
      Width = 80
      Height = 21
      Hint = #1044#1072#1090#1072' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1085#1072#1095#1072#1083#1072' '#1087#1088#1086#1094#1077#1089#1089#1072
      DataField = 'FactStartDate'
      DialogTitle = #1042#1099#1073#1086#1088' '#1076#1072#1090#1099
      ImageKind = ikDropDown
      TabOrder = 0
    end
    object tmFactStart: TDBDateTimeEditEh
      Left = 132
      Top = 33
      Width = 42
      Height = 21
      Hint = #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1085#1072#1095#1072#1083#1072' '#1087#1088#1086#1094#1077#1089#1089#1072
      DataField = 'FactStartTime_ICalc'
      EditButton.Visible = False
      EditButtons = <>
      TabOrder = 1
      Visible = True
      EditFormat = 'HH:NN'
    end
    object deFactFinish: TJvDBDateEdit
      Left = 230
      Top = 33
      Width = 80
      Height = 21
      Hint = #1044#1072#1090#1072' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1087#1088#1086#1094#1077#1089#1089#1072
      DataField = 'FactFinishDate'
      DialogTitle = #1042#1099#1073#1086#1088' '#1076#1072#1090#1099
      ImageKind = ikDropDown
      TabOrder = 2
    end
    object tmFactFinish: TDBDateTimeEditEh
      Left = 316
      Top = 33
      Width = 42
      Height = 21
      Hint = #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1087#1088#1086#1094#1077#1089#1089#1072
      DataField = 'FactFinishTime_ICalc'
      EditButton.Visible = False
      EditButtons = <>
      TabOrder = 3
      Visible = True
      EditFormat = 'HH:NN'
    end
  end
end
