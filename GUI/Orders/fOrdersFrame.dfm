inherited OrdersFrame: TOrdersFrame
  inherited paFilter: TPanel
    TabOrder = 1
    ExplicitLeft = 281
    ExplicitHeight = 304
  end
  object paOrdMain: TPanel
    Left = 0
    Top = 0
    Width = 281
    Height = 304
    Align = alClient
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    object spOrders: TJvNetscapeSplitter
      Left = -119
      Top = 0
      Height = 304
      Align = alRight
      AutoSnap = False
      ResizeStyle = rsUpdate
      Maximized = False
      Minimized = False
      ButtonCursor = crDefault
      WindowsButtons = []
      ButtonWidthKind = btwPercentage
      ButtonWidth = 30
      ExplicitLeft = 186
      ExplicitTop = -345
      ExplicitHeight = 689
    end
    object paOrderLeft: TPanel
      Left = 0
      Top = 0
      Width = 78
      Height = 304
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object dgOrders: TMyDBGridEh
        Left = 0
        Top = 0
        Width = 78
        Height = 304
        Align = alClient
        AllowedOperations = []
        AllowedSelections = [gstRecordBookmarks, gstColumns, gstAll]
        ColumnDefValues.Layout = tlCenter
        DataGrouping.GroupLevels = <>
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = [fsBold]
        Options = [dgTitles, dgColumnResize, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgMultiSelect]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDblClickOptimizeColWidth, dghColumnResize, dghColumnMove]
        ParentFont = False
        PopupMenu = CalcMenu
        RowDetailPanel.Color = clBtnFace
        RowHeight = 16
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        TitleHeight = 16
        UseMultiTitle = True
        VTitleMargin = 5
        OnCheckButton = dgOrderCheckButton
        OnDblClick = acEditOrderExecute
        OnDrawColumnCell = dgCalcOrderDrawColumnCell
        OnGetCellParams = dgCalcOrderGetCellParams
        OnKeyPress = dgOrderKeyPress
        OnTitleBtnClick = dgTitleBtnClick
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object panRight: TPanel
      Left = -109
      Top = 0
      Width = 390
      Height = 304
      Align = alRight
      BevelOuter = bvNone
      Caption = ' '
      Constraints.MinWidth = 240
      TabOrder = 0
      object paOrderBottom: TPanel
        Left = 0
        Top = 275
        Width = 390
        Height = 29
        Align = alBottom
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        Visible = False
        object paTotalItogo: TPanel
          Left = 6
          Top = 3
          Width = 313
          Height = 28
          BevelOuter = bvNone
          Enabled = False
          ParentBackground = False
          TabOrder = 0
        end
        object Panel16: TPanel
          Left = 194
          Top = 0
          Width = 196
          Height = 29
          Align = alRight
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 1
          object btCancel: TBitBtn
            Left = 110
            Top = 3
            Width = 84
            Height = 25
            Caption = #1054#1090#1084#1077#1085#1072
            TabOrder = 1
            Visible = False
            OnClick = btCancelClick
            Glyph.Data = {
              E6050000424DE605000000000000420000002800000026000000130000000100
              100003000000A4050000120B0000120B00000000000000000000007C0000E003
              00001F000000386B386B386B386B386B52564945A538633463346334A5384945
              5152386B386B386B386B386B386B386B386B386B386BF75E9452314631463146
              314631469452F75E386B386B386B386B386B386B386B386B386B084163348340
              E45404652469246D045DC34463340841386B386B386B386B386B386B386B386B
              734E314631469452B556B556B5569452524A3146734E386B386B386B386B386B
              386B386B8438633CE5600671A66C877087748774C67825794471A3448438386B
              386B386B386B386B386B314631469452D65AD65AD65AD65AD65AF75EF75ED65A
              524A3146386B386B386B386B17678438843CE76847644664855C855485548554
              85648674C6784579C3488438386B386B386B386B3146524AD65A945294529452
              9452945294529452D65AF75ED65A524A3146386B386B386B294563382C6D4760
              665C4A59F76EDE7BFF7FDE7B386F8C598568A6744575A3440841386B386B9452
              3146F75E94529452D65A7B6FDE7BFF7FDE7B9C73D65AB556D65AD65A524A734E
              386B386B62344A5DE96C66600F62FF7FFF7FFF7FFF7FFF7FFF7FFF7F0F5E8568
              A674446D8334386B386B3146D65AD65A9452F75EFF7FFF7FFF7FFF7FFF7FFF7F
              FF7FF75EB556D65AD65A3146F75E6B49843CCE75096D8D61FF7FFF7FFF7F5266
              65680B71197BFF7FFF7FCE6166700675C4484945B556524A3967F75EF75EFF7F
              FF7FFF7F39679452F75E9C73FF7FFF7FF75EB556D65A524A9452C6444A59AD71
              4A6D5A73FF7FFF7FFF7FDE7B4A596668666CD77AFF7FBD7B6564A66C0461C640
              524AD65A3967F75E9C73FF7FFF7FFF7FDE7BD65A9452B5569C73FF7FDE7B9452
              D65A9452524A8444AD61CE718C69FF7FFF7FF876FF7FFF7FDE7B4A5966688768
              FF7FFF7F2B69476425658444524AF75E3967F75EFF7FFF7F9C73FF7FFF7FDE7B
              D65A9452B556FF7FFF7FD65A9452B556524A844C526ECF6D5372FF7F7B77C864
              D776FF7FFF7FDE7B2A5945643A7BFF7F4D6946602565A54C734E5A6B39675A6B
              FF7FBD77B5567B6FFF7FFF7FDE7BD65A94529C73FF7FF75E9452B556734E8554
              F06932725372FF7FDE7B8D650B69D776FF7FFF7FDE7B2955BD7BFF7F4D694660
              4769A6549452186339675A6BFF7FDE7BF75ED65A7B6FFF7FFF7FDE7BB556DE7B
              FF7FF75E9452D65A9452E75CCE699572F06DDE7FFF7FAD5D116EF06D5B7BFF7F
              FF7FDE7BFF7FFF7F2C69F16DCC6DE758B55618637B6F3967FF7FFF7FF75E3967
              3967BD77FF7FFF7FDE7BFF7FFF7FF75E3967F75EB556AD6508651977116E3A77
              FF7FDE7B4A554A59AE65F772FF7FFF7FFF7F5B7B126E537228696B61F75ED65A
              9C7339679C73FF7FDE7BB556D65AF75E7B6FFF7FFF7FFF7FBD7739675A6BD65A
              F75E386BA66474729672326EBD7BFF7FFF7F186F7266F76EFF7FFF7FBD7B336E
              336E3072A6647262386BB5567B6F7B6F3967DE7BFF7FFF7F9C7339677B6FFF7F
              FF7FDE7B396739673967B5563967386B6B65E86419777572126E7C7BFF7FFF7F
              FF7FFF7FFF7F9D7B326E326E7372E7644B65386B386BF75ED65A9C737B6F3967
              DE7BFF7FFF7FFF7FFF7FFF7FDE7B396739675A6BD65AD65A386B386B386BE764
              296919779672126E5372F8761977F8767472126E336EB6722A69C764386B386B
              386B386BD65AD65A9C737B6F39675A6B9C739C739C735A6B396739677B6FF75E
              D65A386B386B386B386B386BE764E8647472197796725472126E336E7472D772
              5372E864C764386B386B386B386B386B386BD65AD65A7B6F9C737B6F5A6B3967
              39675A6B7B6F5A6BD65AD65A386B386B386B386B386B386B176B6B65A6642969
              F06D537295725272CF6D0969A6646B65386B386B386B386B386B386B386B386B
              F75EB556D65A39675A6B7B6F39673967D65AB556F75E386B386B386B386B386B
              386B386B386B386BB46AAD65E864A664A664A664E864AD65B46A386B386B386B
              386B386B386B386B386B386B386B5A6BF75ED65AB556B556B556D65AF75E5A6B
              386B386B386B386B386B}
            NumGlyphs = 2
            Spacing = 6
          end
          object btOK: TBitBtn
            Left = 6
            Top = 3
            Width = 97
            Height = 25
            Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
            TabOrder = 0
            Visible = False
            OnClick = btOKClick
            Glyph.Data = {
              32060000424D3206000000000000420000002800000028000000130000000100
              100003000000F0050000120B0000120B00000000000000000000007C0000E003
              00001F0000001F7C1F7C1F7C1F7C1F7C1F7C903E4D2E85018501850185014D2E
              903E1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1863D65A524A
              524A524A524A734E39671F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CC811
              8501E605861EC62E273B4643C636862AC50D85014E361F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7C734E524A734EB556D65AF75EF75ED65AB556734E524AD65A1F7C
              1F7C1F7C1F7C1F7C1F7C1F7CA6098501C71E081BE90AEA16E9260A2F09332837
              4743A62E85050B221F7C1F7C1F7C1F7C1F7C1F7C734E524AD65AD65AB556D65A
              F75EF75EF75EF75EF75EB556524AB5561F7C1F7C1F7C1F7C1F7CC70DC6052A2F
              CA06CA02C902EA12E926092F092F092F092F283BE63A85052D2E1F7C1F7C1F7C
              1F7C734E524A1863945294529452D65AF75EF75EF75EF75EF75EF75ED65A524A
              D65A1F7C1F7C1F7C4D2E8501EC1ACA06CA026602E511A80AEA1EE92A092F092F
              092F0A2F283BC636850192461F7C1F7CD65A524AD65AB5569452734E734EB556
              D65AF75EF75EF75EF75EF75EF75ED65A524A18631F7C1F7C85016A1A0C1BCA06
              4602D34E7B6B4A26A80EE922E92A092F092F092FEA2A27370516E9191F7C1F7C
              524AB556D65AB556734E39679C73B556B556D65AF75EF75EF75EF75EF75EF75E
              945294521F7C903E8401313B0C1F670ED34E9C737C6F9C736C2EA70EEA1EE922
              E926E922EA1EE91AE62EA601134AF75E524A3967D65A94525A6BBD77BD77BD77
              D65AB556D65AD65AF75EF75ED65AD65AD65A524AD9662B1E2912523BCC1E1453
              BD779D73BD779D73BD776D32A70AEA0EE912E912C90ACA062727CA02C709B556
              94523967D65A5A6BDE7BBD77DE7BBD77DE7BF75E9452B556B556B556B5569452
              F75E9452734E2A1AAD26523B323FDE7BDE7BDE7BBC6FDE7BDE7BDE7B8D326602
              CA02CA02CA02CA02E81EE81EE6059452D65A39673967FF7FFF7FFF7FBD77FF7F
              FF7FFF7FF75E94529452945294529452D65AD65A734E4A1AD032533F30337653
              FF7F5447C90E985BFF7FFF7FFF7F8D366602CA02CA02CA02E81AE81E4712B556
              F75E396718637B6FFF7F5A6BB5569C73FF7FFF7FFF7FF75E734E945294529452
              D65AD65A94526B1ACF2E754F323B323B5343323B3137C90E9857FF7FFF7FFF7F
              8D364602CA02C9020B27E81E670AB556F75E7B6F396718635A6B39671863B556
              7B6FFF7FFF7FFF7FF75E734E94529452F75ED65A734EAC1EAC1A9857533F533F
              533F533F533F54430E23BA63FF7FFF7FFF7F1453880E31337353CA028802D65A
              B5567B6F39673967396739675A6B5A6BF75EBD77FF7FFF7FFF7F5A6B94521863
              7B6F9452B556F13A8702995F5443544354435443544354435443533FBB6BFF7F
              FF7FFF7F995F54432F3B8802D13A186394529C735A6B5A6B5A6B5A6B5A6B5A6B
              5A6B3967BD77FF7FFF7FFF7F9C735A6B186394521F7C1F7CA9061033995F533F
              544354435443544354435443533FBB67FF7FBB6B533F7453A90EAD221F7C1F7C
              945218639C735A6B5A6B5A6B5A6B5A6B5A6B5A6B3967BD77FF7FBD7739677B6F
              B556D65A1F7C1F7CF036870277579857533F544354435443544354435443533F
              7753533F754BED268802165B1F7C1F7C186394527B6F7B6F5A6B5A6B5A6B5A6B
              5A6B5A6B5A6B39677B6F39675A6BF75E94521F7C1F7C1F7C1F7CAB12880A9857
              985B5443544354435443544354435443533F764F323B8802D23E1F7C1F7C1F7C
              1F7CB55694527B6F9C735A6B5A6B5A6B5A6B5A6B5A6B5A6B5A6B7B6F39679452
              18631F7C1F7C1F7C1F7C1F7CAB128806323BBA639757754B5443544375477653
              9757ED228802CF2A1F7C1F7C1F7C1F7C1F7C1F7CB55694523967BD777B6F5A6B
              5A6B5A6B5A6B7B6F7B6FD65A9452F75E1F7C1F7C1F7C1F7C1F7C1F7C1F7CCF2E
              8802A90E102F5547764F7653323BEE2687028906144F1F7C1F7C1F7C1F7C1F7C
              1F7C1F7C1F7CF75E9452B55618635A6B7B6F7B6F3967F75E945294525A6B1F7C
              1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CCF2EA90A8802880288028802AB1A
              F13E1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CF75EB5569452
              945294529452B55618631F7C1F7C1F7C1F7C1F7C1F7C}
            NumGlyphs = 2
            Spacing = 6
          end
        end
      end
      object paParams: TPanel
        Left = 0
        Top = 0
        Width = 390
        Height = 57
        Align = alTop
        BevelOuter = bvNone
        Color = 10930928
        TabOrder = 1
        OnResize = paParamsResize
        object paCommentButtons: TPanel
          Left = 358
          Top = 0
          Width = 32
          Height = 57
          Align = alRight
          BevelOuter = bvNone
          Caption = ' '
          Color = 10930928
          ParentBackground = False
          TabOrder = 0
          object btAddComment2: TBitBtn
            Left = 1
            Top = 4
            Width = 27
            Height = 21
            TabOrder = 0
            TabStop = False
            OnClick = btAddComment2Click
            Glyph.Data = {
              E6040000424DE604000000000000E60200002800000020000000100000000100
              08000000000000020000E50E0000E50E0000AC000000AC00000000000000FFFF
              FF00FF00FF00AD908900812B1000AB5E4600CBB4AD009F563D00A03D1700B264
              4600C3A89D00A2502D00F1793D00BC6D4600DE957000C88C6F00D4A28400AD85
              6D00BC9F8D00F2BD9B00BD987F00F3E6DD00DCAB8800AB896F00E2B59400B18F
              7500CDC0B600EBE0D800CAB19C00CCA98B00CFAD8E00CDAE9200EDD3BC00BD9C
              7B00DFBA9700E3BF9B00DAB79500D2B09000E5C29E00BDA08300D9B79700EBC9
              A600E9C6A400EECCAA00E0BFA000F0CFAD00F2D1AF00F5D5B400D6BEA600FAE0
              C600FBE2C900F8E0C800FDEAD700FEEDDD00FEEEDE00FEF5EC00FEF8F200FEF9
              F400EFCEAB00F3D3B100F6D7B600F6D7B700F7D9B900F7D9BA00F8DABB00F8DB
              BC00F9DCBE00F8DCBD00F0D4B700F9DEC100E0C8AE00FADFC300FAE0C300F9DF
              C200E0C9AF00FBE1C600EED7BE00FCE4CB00FCE5CC00FCE5CD00EFDAC300EFDC
              C700E6D6C400FEEEDD00C8BCAF00FEF2E500FEF3E700FEF4E900FEF6ED00E1CB
              B200E1CCB400A79A8B00EFE0CF00F9EBDB00F4E7D800F4E8DA00FEF7EF00FEFB
              F700F6EFE500FAFAFA00F9F9F900F8F8F800F6F6F600F5F5F500F3F3F300F2F2
              F200F1F1F100EEEEEE00EDEDED00EAEAEA00E8E8E800E7E7E700E6E6E600E4E4
              E400E3E3E300E2E2E200E1E1E100E0E0E000DFDFDF00DEDEDE00DDDDDD00DBDB
              DB00DADADA00D9D9D900D8D8D800D6D6D600D5D5D500D4D4D400D3D3D300D2D2
              D200D0D0D000CECECE00CDCDCD00CCCCCC00CACACA00C9C9C900C8C8C800C7C7
              C700C6C6C600C1C1C100C0C0C000BFBFBF00BEBEBE00BCBCBC00BBBBBB00B8B8
              B800B7B7B700B3B3B300B2B2B200B1B1B100B0B0B000AFAFAF00AEAEAE00ACAC
              AC00ABABAB00A7A7A700A4A4A400A0A0A0009E9E9E009C9C9C009B9B9B009999
              990097979700939393008D8D8D00818181007C7C7C00787878006E6E6E006767
              67005B5B5B0048484800020E0B0B0B0B0B020217020202020202029BA9A9A9A9
              A90202A40202020202020E0B0B01010B0B5B27170202020202029BA9A90101A9
              A9A19DA40202020202020B0B0B01010B0B0B0E19020202020202A9A9A90101A9
              A9A99BA30202020202020B0101010101010B0B28211E02020202A90101010101
              01A9A9919F98020202020C0101010101010C0C16292321020202A20101010101
              01A2A294888D9F0202020C0C0C01010C0C0C0E182E2924210202A2A2A20101A2
              A2A29B908288929F02020C0C0C01010C0C0C1A473D3B2A221E02A2A2A20101A2
              A2A28B777D818A909802020E0C0C0C0C0C0D09313F3C3A261F02029BA2A2A2A2
              A2A5A6757C7D848B9702024C0E0C0C0E540D0932423E3B291D02027D9BA2A29B
              90A5A673797C81889A020250355557361008054D45402F2B1E02027B6C6A686B
              99AAA772787B7F8598020251553738621211144F48433C2D250202796A67656C
              9CA49E71777A7D839502025256606161150F134F48433C2D1C02027E69666363
              6EA08A71777A7D839302024C5E5839390604072048433C1D0202027D70676464
              8FABA87F777A7D9A020202024C5F58581B030A3349412D2C020202027D6F6767
              74A09675787A838C02020202024C5C5D53344E4B441D2C0202020202027D766D
              6C6D7175809A8C020202020202024C525A594A46300202020202020202027D7E
              868789898E0202020202}
            NumGlyphs = 2
          end
          object btRemoveComment2: TBitBtn
            Left = 1
            Top = 31
            Width = 27
            Height = 21
            TabOrder = 1
            TabStop = False
            OnClick = btRemoveComment2Click
            Glyph.Data = {
              32050000424D3205000000000000320300002800000020000000100000000100
              08000000000000020000E50E0000E50E0000BF000000BF00000000000000FFFF
              FF00FF00FF00E8E7E800AD908900812B1000AB5E4600CBB4AD009F563D00B163
              4600A03D1700B2644600C3A89D00BC623800B75E3800BC6D4600C88C6F00D4A2
              8400AD856D00BC9F8D00E1A78000E2A88200F2BD9B00BD987F00F3E6DD00DCAB
              8800AB896F00E2B59400B18F7500EBE0D800CAB19C00CCA98B00CFAD8E00CDAE
              9200EDD3BC00FEEEDF00BD9C7B00DFBA9700E3BF9B00E1BC9900DAB79500D2B0
              9000E5C29E00D9B79700EBC8A600EBC9A600E9C6A400EECCAA00E0BFA000ECCB
              A900F0CFAD00F2D1AF00F5D5B400D6BEA600FAE0C600FBE2C900F8E0C800FDE5
              CE00FDE6D000FDE7D100FEE9D500FDEAD700FEECDA00FEEDDD00FEEEDE00FEF5
              EC00FEF8F200FEF9F400EFCEAB00F3D3B100F6D7B600F6D7B700F7D9B900F7D9
              BA00F8DABB00F8DBBC00F9DCBE00F8DCBD00F0D4B700F9DEC100E0C8AE00FADF
              C300FAE0C300F9DFC200E0C9AF00FBE1C600E4CDB400FCE3C900EED7BE00FCE4
              CA00FCE4CB00FCE5CC00FCE5CD00EFDAC300EFDCC700FDE9D400E6D6C400FEEE
              DD00FEF2E500FEF3E700FEF4E900FEF6ED00E1CBB200E1CCB400EFE0CF00F9EB
              DB00F4E7D800F4E8DA00FEF7EF00FEFBF700F6EFE500C9D5E7001415E3005F5F
              F4009091D700FAFAFA00F9F9F900F8F8F800F6F6F600F5F5F500F3F3F300F2F2
              F200F1F1F100EEEEEE00EDEDED00ECECEC00EAEAEA00E9E9E900E8E8E800E7E7
              E700E6E6E600E5E5E500E4E4E400E3E3E300E2E2E200E1E1E100E0E0E000DFDF
              DF00DEDEDE00DDDDDD00DBDBDB00DADADA00D9D9D900D8D8D800D6D6D600D5D5
              D500D4D4D400D3D3D300D2D2D200D0D0D000CECECE00CDCDCD00CCCCCC00CACA
              CA00C9C9C900C8C8C800C7C7C700C6C6C600C1C1C100C0C0C000BFBFBF00BEBE
              BE00BDBDBD00BCBCBC00BBBBBB00B8B8B800B7B7B700B3B3B300B2B2B200B1B1
              B100B0B0B000AFAFAF00AEAEAE00ACACAC00ABABAB00A9A9A900A4A4A4009E9E
              9E009C9C9C009B9B9B00939393008D8D8D00818181007C7C7C007B7B7B007A7A
              7A0078787800777777006E6E6E005B5B5B00484848000270707070707202021A
              02020202020202B8B8B8B8B8A70202B502020202020270736F706F737002241A
              020202020202B8738FB88F73B802B2B50202020202027072736F73717024271C
              020202020202B8A7738F73AFB8B2A2B402020202020270707173727070312C2B
              242002020202B8B8AF73A7B8B8999BA5B2AC0202020270037371730370151419
              2D2624020202B88173AF7381B8A8AAA89BA0B2020202700371707103700D0E1B
              332D28240202B881AFB8AF81B8B9BBA4959BA6B20202027070707070590F0951
              47452E25200202B8B8B8B8B885B6B88A90949DA4AC02025657393A3A3B0F0B36
              4946442A210202988683828281B6B7888F90979EAB0202585F3E23233C0F0B37
              4C48452D1F020290807D7B7B7FB6B7868C8F949BAE02025D3F626440110A065A
              4F4A342F2002028E7C7A787BADBDBA858B8E9298AC02025E6241426E1312175C
              524D46322902028C7A77757CB0B5B1848A8D9096A9020260636C6D6D1810165C
              524D46321E0202917976737380B39D848A8D9096A70202586A65434307050822
              524D461F0202029082777474A3BEBC928A8D90AE02020202586B65651D040C38
              534B3230020202029081777787B3AA888B8D969F0202020202586869613D5B55
              4E1F3002020202020290897E7C7E848893AE9F02020202020202586067665450
              350202020202020202029091999A9C9CA10202020202}
            NumGlyphs = 2
          end
        end
        object paParamsControls: TPanel
          Left = 0
          Top = 0
          Width = 358
          Height = 57
          Align = alClient
          BevelOuter = bvNone
          Caption = ' '
          Color = 10930928
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 1
          DesignSize = (
            358
            57)
          object lbTirazz: TLabel
            Left = 4
            Top = 8
            Width = 32
            Height = 13
            Caption = #1058#1080#1088#1072#1078
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object lbComment: TLabel
            Left = 134
            Top = 8
            Width = 73
            Height = 13
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          end
          object lbComment2: TLabel
            Left = 4
            Top = 34
            Width = 67
            Height = 13
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
          end
          object edTirazz: TDBEdit
            Left = 44
            Top = 5
            Width = 83
            Height = 21
            DataField = 'Tirazz'
            Enabled = False
            TabOrder = 0
            OnChange = edTirazzChange
            OnKeyPress = edEnterKeyPress
          end
          object edComment: TDBEdit
            Left = 216
            Top = 5
            Width = 142
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            DataField = 'Comment'
            TabOrder = 1
            OnChange = edCommentChange
            OnKeyPress = edEnterKeyPress
          end
          object edComment2: TDBEdit
            Left = 80
            Top = 31
            Width = 278
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            DataField = 'Comment2'
            TabOrder = 2
            OnChange = edComment2Change
            OnKeyPress = edEnterKeyPress
          end
        end
      end
      object paOrdInfo: TPanel
        Left = 0
        Top = 57
        Width = 390
        Height = 218
        Align = alClient
        BevelOuter = bvNone
        Caption = ' '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object paOrdInfoBottom: TPanel
          Left = 0
          Top = 186
          Width = 390
          Height = 32
          Align = alClient
          BevelOuter = bvNone
          Caption = ' '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object paOrdInfoTop: TPanel
          Left = 0
          Top = 0
          Width = 390
          Height = 186
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
      end
    end
  end
  object CalcMenu: TPopupMenu
    OnPopup = CalcMenuPopup
    Left = 103
    Top = 167
    object CopyItem: TMenuItem
      Tag = 1
      Caption = #1050#1086#1087#1080#1103'...'
      ImageIndex = 6
    end
    object MkOrderItem: TMenuItem
      Tag = 2
      Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100' '#1074' '#1079#1072#1082#1072#1079'...'
      ImageIndex = 8
    end
    object MkCalcItem: TMenuItem
      Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100' '#1074' '#1087#1088#1086#1089#1095#1077#1090'...'
      ImageIndex = 9
    end
    object miDelete: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100'...'
      ImageIndex = 7
    end
    object miSeparator1: TMenuItem
      Caption = '-'
    end
    object miProtectCost: TMenuItem
      Caption = #1047#1072#1097#1080#1090#1072' '#1089#1090#1086#1080#1084#1086#1089#1090#1080
      OnClick = miProtectCostClick
    end
    object miProtectContent: TMenuItem
      Caption = #1047#1072#1097#1080#1090#1072' '#1089#1086#1089#1090#1072#1074#1072
      OnClick = miProtectContentClick
    end
    object miUnprotectCost: TMenuItem
      Caption = #1057#1085#1103#1090#1100' '#1079#1072#1097#1080#1090#1091' '#1089#1090#1086#1080#1084#1086#1089#1090#1080
      OnClick = miUnprotectCostClick
    end
    object miUnprotectContent: TMenuItem
      Caption = #1057#1085#1103#1090#1100' '#1079#1072#1097#1080#1090#1091' '#1089#1086#1089#1090#1072#1074#1072
      OnClick = miUnprotectContentClick
    end
    object miSeparator2: TMenuItem
      Caption = '-'
    end
    object miBulkEdit: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1086#1089#1090#1086#1103#1085#1080#1103'...'
      OnClick = miBulkEditClick
    end
  end
  object CalcTimer: TTimer
    Enabled = False
    Interval = 10
    Left = 729
    Top = 250
  end
  object OrderInfoTimer: TTimer
    Enabled = False
    Interval = 100
    Left = 727
    Top = 216
  end
end
