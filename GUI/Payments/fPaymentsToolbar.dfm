inherited PaymentsToolbar: TPaymentsToolbar
  Width = 827
  Height = 52
  ExplicitWidth = 827
  ExplicitHeight = 52
  object Toolbar: TJvSpeedBar
    Left = 0
    Top = 0
    Width = 827
    Height = 47
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [sbAllowResize, sbFlatBtns, sbGrayedBtns, sbTransparentBtns]
    BtnOffsetHorz = 2
    BtnOffsetVert = 1
    BtnWidth = 65
    BtnHeight = 44
    Version = 3
    BevelOuter = bvNone
    ParentColor = True
    ShowHint = False
    TabOrder = 0
    InternalVer = 1
    object lbOrderType: TJvLabel
      Left = 8
      Top = 16
      Width = 81
      Height = 13
      Caption = #1055#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ShadowColor = clWhite
      Transparent = True
      AutoOpenURL = False
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'Tahoma'
      HotTrackFont.Style = []
    end
    object SpeedbarSection1: TJvSpeedBarSection
      Caption = #1054#1087#1077#1088#1072#1094#1080#1080
    end
    object siNew: TJvSpeedItem
      BtnCaption = #1042#1085#1077#1089#1090#1080
      Caption = 'New'
      Glyph.Data = {
        3E020000424D3E02000000000000EA0000002800000011000000110000000100
        08000000000054010000120B0000120B00002D0000002D00000000000000FFFF
        FF0000BB000000B7000000B1000000AA000000A30000009B0000009200000089
        00000080000000760000006D000000640000005C000000550000004E00000048
        000069D7690069C46900416B4100446F440069A96900007B0400007F0A000085
        1100008C190000932100009A2A001FC94E0000A2330044E6770000A93C0041E2
        7B0000B0450000B74D0035E7810000BE550000C45C0000C8620011B26200FEFE
        FE00FBFBFB00F8F8F800FFFFFF00010101010101010101010101010101010100
        0000010101010101141111111115010101010100000001010101010110171717
        171001010101010000000101010101010F181818180F01010101010000000101
        010101010E191919190E01010101010000000101010101010D1A1A1A1A0D0101
        01010100000001160C0C0C0C0C1B1B1B1B0C0C0C0C0C16000000010B1C1C1C1C
        1C1C1C1C1C1C1C1C1C1C0B000000010A1E1E1E1E1E1E1E1E1E1E1E1E1E1E0A00
        0000010920202020202020202020202020200900000001082121212121222222
        2221212121210800000001130707070707232323230707070707130000000101
        0101010106252525250601010101010000000101010101010526262626050101
        01010100000001010101010104271D1D1D040101010101000000010101010101
        03241F1F1F030101010101000000010101010101120202020228010101010100
        0000}
      Hint = 'New|'
      Margin = 6
      Spacing = 3
      Left = 93
      Top = 1
      Visible = True
      SectionName = #1054#1087#1077#1088#1072#1094#1080#1080
    end
    object siEdit: TJvSpeedItem
      BtnCaption = #1048#1079#1084#1077#1085#1080#1090#1100
      Caption = 'Edit'
      Glyph.Data = {
        0A040000424D0A04000000000000420000002800000016000000160000000100
        100003000000C8030000D60D0000D60D00000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C30463046304630463046304230421042
        104210421042304230421F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C3046FF7FFF7F
        FF7FFF7FFF7FDE7B9C737B6F7B6F7B6F9C739C73BD770F3E1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C3046DE7B9C739C73BD77BD777B6F00000035D65AF75E18633967
        7B6FEE3D1F7C1F7C1F7C1F7C1F7C1F7C1F7C3046DE7BBC779C739C73BD779C73
        4041E420262D40415A6B7B6FBD770F3E1F7C1F7C1F7C1F7C1F7C1F7C1F7C3046
        FF7FBD77BD77BC779C73BD77BD776735905E0A4E6045BD77FF7F30421F7C1F7C
        1F7C1F7C1F7C1F7C1F7C3146FF7FBD77BD77BD77BC779C73BD77604598776C62
        0A4E6045FF7F30421F7C1F7C1F7C1F7C1F7C104231463146FF7FBD77BD77BD77
        BC779C739C73BD77604598778C660A52604530421F7C1F7C1F7C1F7C1F7C1042
        9452D65A3146BD77186318631863186318631863396760459877AD660A526045
        1F7C1F7C1F7C1F7C1F7C104294529452D65A314610421042104210429452BD77
        BD77BD77604598778D660B5260451F7C1F7C1F7C1F7C1F7C7041945294521042
        1B5B9942993ED94A1042524A1863BD77BD77604598778D660A4E60451F7C1F7C
        1F7C1F7C1F7CEE391042D94EBA46FA521B57D94EDA4A10421863BD77BD77BD77
        60459877AD66EA4D60451F7C1F7C1F7C1F7C1042D852B942B94ED952D952D856
        9846B94A104218631863BD77FF7F6045B877AD6A0B5260451F7C1F7C1F7C1042
        FA56FB527C677D6B5C633B5F1B5B993E1042BD77BD77BD77FF7F31466045B877
        AD6A0B5260451F7C1F7C1042D952FB527D6B7D6B9D6B1A57B946993E10421863
        1863BD77FF7F31461F7C60459877AE6660451F7C1F7C1042B75299429D6FBE73
        BE735C63BA46B94A1042BD77BD77BD77FF7F31461F7C1F7C604560451F7C1F7C
        1F7C10421042D852B9465C5F5C63DA4EB94A10425A6BBD77BD77BD77FF7F3146
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C304639671042F856FA52FA52D95210423967
        FF7FFF7FFF7FFF7FFF7F31461F7C1F7C1F7C1F7C1F7C1F7C1F7C145231461042
        104210421042104210423146314631463146314631461F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C}
      Hint = 'Edit|'
      Margin = 3
      Spacing = 1
      Left = 158
      Top = 1
      Visible = True
      SectionName = #1054#1087#1077#1088#1072#1094#1080#1080
    end
    object siDelete: TJvSpeedItem
      BtnCaption = #1059#1076#1072#1083#1080#1090#1100
      Caption = 'Delete'
      Glyph.Data = {
        F6010000424DF601000000000000A20000002800000011000000110000000100
        08000000000054010000120B0000120B00001B0000001B00000000000000FFFF
        FF006900B900FF00FF00FE00FE00FB00FB00F900F900F800F8003DA5EC00016C
        BE00017EE0000655AC000066FF000059FB000041EC000029D6000000DF000000
        DD000000D0000000CA000000BD000000BB000000A80000009500000088006969
        EB00FFFFFF000303030303030303030303030303030303000000030303030303
        0303030303030303030303000000030303030303030303030303030303030300
        0000030303030303030303030303030303030300000003030303030303030303
        0303030303030300000003030303030303030303030303030303030000000302
        1818181818181818181818181818030000000B17151515151515151515151515
        150F170000000816131313131313131313131313130E160000000A1410101010
        1010101010101010100D1400000009120C0C0C0C0C0C0C0C0C0C0C0C0C0C1200
        0000031911111111111111111111111111110300000003030303030303030303
        0303030303030300000003030303030303030303030303030303030000000303
        0303030303030303030303030303030000000303030303030303030303030303
        0303030000000303030303030303030303030303030303000000}
      Hint = 'Delete|'
      Margin = 6
      Spacing = 3
      Left = 223
      Top = 1
      Visible = True
      SectionName = #1054#1087#1077#1088#1072#1094#1080#1080
    end
    object siPrint: TJvSpeedItem
      BtnCaption = #1054#1090#1095#1077#1090#1099
      Caption = 'Print'
      DropDownMenu = pmPaymentReports
      Glyph.Data = {
        62030000424D6203000000000000420000002800000014000000140000000100
        10000300000020030000120B0000120B00000000000000000000007C0000E003
        00001F0000008031803180318031803180318031803180318031803180318031
        8031803180318031803180318031803180318C318C318C318C318C318C318C31
        8C318C318C318C318C318C318C318C318C3180318031803180318C31FF7FFF7F
        FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F8C31803180318031
        803194528C31FF7F3967945239679452396794523967945239679452FF7F8C31
        94528031803131460000000000009452FF7F3146945231469452314694523146
        9452FF7F94520000000000008C318C3194523146314600008C318C318C318C31
        8C318C318C318C318C318C31000031463146314600008C31FF7F396739679452
        0000000000000000000000000000000000000000945239673967314600008C31
        FF7F396739673967396739673967396739673967396739673967396739673967
        3967314600008C31FF7F39673967396739673967396739673967396739673967
        39673967396739673967314600008C31FF7F3967396739673967396739673967
        396739673967396739673967396739673967314600008C31FF7F39674C124C12
        3967396739673967396739673967396739673967FF7F00003967314600008C31
        FF7F396739673967396739673967396739673967396739673967396739673967
        3967314600008C31FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
        FF7FFF7FFF7FFF7FFF7F9452000031468C318C318C318C318C318C318C318C31
        8C318C318C318C318C318C318C318C318C318C313146803180318C3139670000
        E07FE07FE07FE07FE07FE07FE07FE07FE07FE07F000039678C31803180318031
        80318C318C310000E07FE07FE07FE07FE07FE07FE07FE07FE07FE07F00008C31
        8C318031803180318031803180310000E07FE07FE07FE07FE07FE07FE07FE07F
        E07FE07F0000803180318031803180318031803180310000E07FE07FE07FE07F
        E07FE07FE07FE07FE07FE07F0000803180318031803180318031803180318C31
        8C318C318C318C318C318C318C318C318C318C318C3180318031803180318031
        8031803180318031803180318031803180318031803180318031803180318031
        803180318031}
      Hint = 'Print|'
      Margin = 4
      Spacing = 2
      Left = 288
      Top = 1
      Visible = True
      SectionName = #1054#1087#1077#1088#1072#1094#1080#1080
    end
    object siLocateInvoice: TJvSpeedItem
      BtnCaption = #1057#1095#1077#1090
      Caption = #1057#1095#1077#1090
      Glyph.Data = {
        CA040000424DCA040000000000008A0200002800000018000000180000000100
        08000000000040020000120B0000120B0000950000009500000000000000FFFF
        FF00815D8200FF00FF00D8BEA800CAB4A200CDB9A800EBDED300F1E5DB00CCA2
        7D00CFA88500CEA98700D1AC8A00CDAC8F00D2B39600CCAE9200CFB29800DCBE
        A200DDBFA400D0B49A00CBB09700CAB09900D4BAA200D0B8A200DFC8B300D7C2
        AF00E2CFBE00EAD8C800E8D7C800C3B5A800BCAFA300EADACB00C8BBAF00ECE0
        D500EEE3D900ECE2D900F6EEE700CCA37B00CFA67F00D6B08C00CBA88700D2AF
        8D00CBAD9000D8B99B00C4A88D00D1B89F00DCC3AB00D6BFA900D2BCA600CAB6
        A300E6D2BE00C8B7A700EAD7C500C8B9AA00F4ECE400DCC8B300AFAF9B00A2A2
        900099998800B2B2A100C3C3B200BFBFAE00CFCFBE00C7C7B600D5D5C400D3D3
        C200D0D0BF00CBCBBB00DDDDCC00DBDBCA00D8D8C800F9F9E900F3F3E300EFEF
        E000E9E9DA00F4F4E600EBEBDE00B2B2A800B1B1A800EEEEE300F1F1E800F5F5
        EE00FAFAF400FBFBF700FDFDFB00B8B997008C9765006F9C6C00A3A4A3003E7E
        4600287E38001F7C3C000371270011783300127733002E874B004F9867009194
        92008083810003742A00068132001C7A3C003F8457004C8A6100047E3000067E
        320009883A0009893D000A8D4100099B49000A9A48000CA350000C9448000BAE
        58000BA854000CA352000C9C4F000DB45E000CA657000FAE5D000FA85A0010BC
        680013C46E0013BF6B00A6A8A7008C8E8D00D5D7D600CACCCB00C2C4C30014C1
        6F0016D6820019DC8B001CDE8F001BED9A001EF5A30020FEAC001FF0A10028FF
        B30031FFB700757877003EFFC50048FFC900848787008184840082848400CBCC
        CC00B7B8B800E5E5E500FFFFFF00030303030303030303030303030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        03030303030303030303030303030303030303030303030303034D39394E9303
        393939394E39394E93033A3A3A3C030303033B4748383A3A3A38474748484F93
        3A3A384A4A3C030303033D4B4A494B494955555C5C5C4F4F4F4F4A4A4A3F0303
        03033D4B4A494B49555C5C686F645C664F4F4A4A4A3F03030303464B4A494B55
        5C6E727171716E69674F55554A4303030303464B4C494B5A6B79797676757979
        6B654B4B4B4303030303464B51494B55637369555C6E7A7A775C5151513E0303
        0303464B51515149844A4A4A6D7A8282735E5353514203030303464B5555554C
        4C4C5C6D81837A6E5C0155555142907D7D03464B5151514F5C7681857B6C5B01
        0101010151419058927D4651555550566A84866A5C0101010155555553419058
        58927D626262627C70898988785C788452010101534003025858623728251062
        61888A8A8A8A8A8A5F015555534003038B622D29042E130E628074888C878478
        5D01010101460303621D0B153105352C0F62575C8D745D605455555501460303
        622F111F211C1A18266201575C5901010101010101450303621712072322190D
        09620101010101010101010101440303621E0A0824361B271462444444444444
        44444444444403038F62330C32342B2A627E0303030303030303030303030303
        03916220301606627F03030303030303030303030303030303038E626262628E
        0303030303030303030303030303}
      Hint = #1057#1095#1077#1090'|'
      Margin = 3
      Spacing = 0
      Left = 353
      Top = 1
      Visible = True
      SectionName = #1054#1087#1077#1088#1072#1094#1080#1080
    end
    object siClosePayments: TJvSpeedItem
      BtnCaption = #1047#1072#1082#1088#1099#1090#1100
      Caption = #1047#1072#1082#1088#1099#1090#1100
      Glyph.Data = {
        E6050000424DE605000000000000420000002800000026000000130000000100
        100003000000A4050000120B0000120B00000000000000000000007C0000E003
        00001F000000386B386B386B386B386B52564945A538633463346334A5384945
        5152386B386B386B386B386B386B386B386B386B386B734EAD35292508210821
        08212925AD35734E386B386B386B386B386B386B386B386B386B084163348340
        E45404652469246D045DC34463340841386B386B386B386B386B386B386B386B
        8C3108212925AD35EF3DEF3DEF3DAD354A2908218C31386B386B386B386B386B
        386B386B8438633CE5600671A66C877087748774C67825794471A3448438386B
        386B386B386B386B386B29252925CE3931461042104210423146524A524A1042
        4A292925386B386B386B386B17678438843CE76847644664855C855485548554
        85648674C6784579C3488438386B386B386B386B29254A291042AD35CE39AD35
        AD35AD35AD35CE391042524A31464A292925386B386B386B294563382C6D4760
        665C4A59F76EDE7BFF7FDE7B386F8C598568A6744575A3440841386B386BAD35
        2925524AAD35AD3510423967DE7BFF7FDE7B5A6B3146EF3D314631464A298C31
        386B386B62344A5DE96C66600F62FF7FFF7FFF7FFF7FFF7FFF7FFF7F0F5E8568
        A674446D8334386B386B082110423146AD35734EFF7FFF7FFF7FFF7FFF7FFF7F
        FF7F734EEF3D314610420821734E6B49843CCE75096D8D61FF7FFF7FFF7F5266
        65680B71197BFF7FFF7FCE6166700675C4484945EF3D4A29B556524A524AFF7F
        FF7FFF7FD65ACE39524A7B6FFF7FFF7F734EEF3D31466B2DAD35C6444A59AD71
        4A6D5A73FF7FFF7FFF7FDE7B4A596668666CD77AFF7FBD7B6564A66C0461C640
        6B2D1042B556524A7B6FFF7FFF7FFF7FDE7B1042CE39EF3D5A6BFF7FBD77CE39
        1042CE396B2D8444AD61CE718C69FF7FFF7FF876FF7FFF7FDE7B4A5966688768
        FF7FFF7F2B694764256584446B2D524AB556734EFF7FFF7F5A6BFF7FFF7FDE7B
        1042CE39EF3DFF7FFF7F3146CE39EF3D6B2D844C526ECF6D5372FF7F7B77C864
        D776FF7FFF7FDE7B2A5945643A7BFF7F4D6946602565A54C8C31F75EB556F75E
        FF7F9C73EF3D3967FF7FFF7FDE7B1042AD357B6FFF7F524AAD35EF3D8C318554
        F06932725372FF7FDE7B8D650B69D776FF7FFF7FDE7B2955BD7BFF7F4D694660
        4769A654AD359452D65AF75EFF7FDE7B734E31463967FF7FFF7FDE7BEF3DBD77
        FF7F524AAD351042AD35E75CCE699572F06DDE7FFF7FAD5D116EF06D5B7BFF7F
        FF7FDE7BFF7FFF7F2C69F16DCC6DE758EF3D94521863B556FF7FFF7F524AD65A
        B5569C73FF7FFF7FDE7BFF7FFF7F524AB556734EEF3DAD6508651977116E3A77
        FF7FDE7B4A554A59AE65F772FF7FFF7FFF7F5B7B126E537228696B61734E1042
        5A6BB5567B6FFF7FDE7BEF3D1042734E3967FF7FFF7FFF7F9C73D65AF75E3146
        524A386BA66474729672326EBD7BFF7FFF7F186F7266F76EFF7FFF7FBD7B336E
        336E3072A6647262386BEF3D18631863D65ADE7BFF7FFF7F5A6BD65A3967FF7F
        FF7FDE7BD65AD65AD65AEF3DB556386B6B65E86419777572126E7C7BFF7FFF7F
        FF7FFF7FFF7F9D7B326E326E7372E7644B65386B386B524A10427B6F1863D65A
        BD77FF7FFF7FFF7FFF7FFF7FBD77D65AD65AF75E10423146386B386B386BE764
        296919779672126E5372F8761977F8767472126E336EB6722A69C764386B386B
        386B386B104231467B6F1863B556F75E5A6B7B6F5A6BF75EB556D65A3967524A
        1042386B386B386B386B386BE764E8647472197796725472126E336E7472D772
        5372E864C764386B386B386B386B386B386B1042104218635A6B1863F75ED65A
        D65AF75E3967F75E10421042386B386B386B386B386B386B176B6B65A6642969
        F06D537295725272CF6D0969A6646B65386B386B386B386B386B386B386B386B
        524AEF3D3146B556F75E1863D65AB5563146EF3D524A386B386B386B386B386B
        386B386B386B386BB46AAD65E864A664A664A664E864AD65B46A386B386B386B
        386B386B386B386B386B386B386BF75E734E1042EF3DEF3DEF3D1042734EF75E
        386B386B386B386B386B}
      Hint = #1047#1072#1082#1088#1099#1090#1100'|'
      Margin = 4
      NumGlyphs = 2
      Spacing = 2
      Left = 418
      Top = 1
      Visible = True
      SectionName = #1054#1087#1077#1088#1072#1094#1080#1080
    end
  end
  object pmPaymentReports: TPopupMenu
    AutoLineReduction = maManual
    Left = 404
    Top = 16
    object miPrintOrders: TMenuItem
      Caption = #1047#1072#1082#1072#1079#1099
    end
    object miPrintIncomes: TMenuItem
      Caption = #1055#1086#1089#1090#1091#1087#1083#1077#1085#1080#1103
    end
  end
end
