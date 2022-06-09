object CodeEditForm: TCodeEditForm
  Left = 392
  Top = 279
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1094#1077#1085#1072#1088#1080#1077#1074
  ClientHeight = 429
  ClientWidth = 572
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 373
    Width = 572
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    object lbErrMsg: TLabel
      Left = 6
      Top = 8
      Width = 41
      Height = 13
      Caption = 'lbErrMsg'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Panel2: TPanel
      Left = 392
      Top = 0
      Width = 180
      Height = 37
      Align = alRight
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      object btOk: TButton
        Left = 10
        Top = 8
        Width = 75
        Height = 25
        Caption = #1054#1050
        ModalResult = 1
        TabOrder = 0
      end
      object btCancel: TButton
        Left = 96
        Top = 8
        Width = 75
        Height = 25
        Caption = #1054#1090#1084#1077#1085#1072
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 572
    Height = 39
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object Label1: TLabel
      Left = 4
      Top = 14
      Width = 49
      Height = 13
      Caption = #1057#1094#1077#1085#1072#1088#1080#1081
    end
    object sbFirst: TSpeedButton
      Left = 426
      Top = 10
      Width = 23
      Height = 22
      Hint = #1055#1077#1088#1074#1099#1081
      Flat = True
      Glyph.Data = {
        46010000424D460100000000000076000000280000001C0000000D0000000100
        040000000000D000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333000033333333333333333333333333330000333333333333
        3333FFF33333FFF30000330733333370333733F333FF33F30000330733337000
        333733F3FF3333F30000330733700000333733FF333333F30000330770000000
        33373333333333F3000033073370000033373337333333F30000330733337000
        333733F3773333F30000330733333370333733F3337733F30000333333333333
        3337773333337733000033333333333333333333333333330000333333333333
        33333333333333330000}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbFirstClick
    end
    object sbPrev: TSpeedButton
      Left = 474
      Top = 10
      Width = 23
      Height = 22
      Hint = #1055#1088#1077#1076#1099#1076#1091#1097#1080#1081
      Flat = True
      Glyph.Data = {
        12010000424D12010000000000007600000028000000140000000D0000000100
        0400000000009C00000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333335AAA33333333333333333333E11133333333333333333FFF5AAA3333
        33370333333FF33FF0003333370003333FF3333FD22233370000033FF333333F
        F0003700000003733333333FD2223337000003377333333F3000333337000333
        3773333FD2223333333703333337733FF00033333333333333333773D2223333
        3333333333333333F00033333333333333333333D222}
      NumGlyphs = 2
      OnClick = sbPrevClick
    end
    object sbNext: TSpeedButton
      Left = 498
      Top = 10
      Width = 23
      Height = 22
      Hint = #1057#1083#1077#1076#1091#1102#1097#1080#1081
      Flat = True
      Glyph.Data = {
        12010000424D12010000000000007600000028000000140000000D0000000100
        0400000000009C00000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33333333FFFF33333333333333333333CEEC33333333333FF3333333CDFC3073
        333333733FF33333CDFC300073333373333FF333CDFC30000073337333333FF3
        CCEC3000000073733333333FCFFD30000073337333333773EFFF300073333373
        33377333EFFE30733333337337733333EEEE33333333337773333333FFFF3333
        3333333333333333FFFF33333333333333333333FFFF}
      NumGlyphs = 2
      OnClick = sbNextClick
    end
    object sbNextNonEmp: TSpeedButton
      Left = 522
      Top = 10
      Width = 23
      Height = 22
      Hint = #1057#1083#1082#1076#1091#1102#1097#1080#1081' '#1085#1077#1087#1091#1089#1090#1086#1081
      Flat = True
      Glyph.Data = {
        12010000424D12010000000000007600000028000000140000000D0000000100
        0400000000009C000000120B0000120B00001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33333333000033333333333333333333333333333333333FF333333333333073
        333333733FF333333333300073333373333FF333307333300073337FF3333FF3
        300033333000737FFFF3333F333033300073337FF33337733333300073333373
        3337733333303073333333733773333330003333333333777333333330733333
        33333333333333333333333333333333333333333333}
      NumGlyphs = 2
      OnClick = sbNextNonEmpClick
    end
    object sbPrevNonEmp: TSpeedButton
      Left = 450
      Top = 10
      Width = 23
      Height = 22
      Hint = #1055#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1085#1077#1087#1091#1089#1090#1086#1081
      Flat = True
      Glyph.Data = {
        12010000424D12010000000000007600000028000000140000000D0000000100
        0400000000009C000000120B0000120B00001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33333333000033333333333333333333333333333333333333333FFF33333333
        33370333333FF33F33333333370003333FF3333F333333370003333FF3333FFF
        3333370003333373333FFFFF333733370003333773333FFF3700333337000333
        3773333F33373333333703333337733F33333333333333333333377333333333
        33333333333333333333333333333333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbPrevNonEmpClick
    end
    object sbLast: TSpeedButton
      Left = 546
      Top = 10
      Width = 23
      Height = 22
      Hint = #1055#1086#1089#1083#1077#1076#1085#1080#1081
      Flat = True
      Glyph.Data = {
        46010000424D460100000000000076000000280000001C0000000D0000000100
        040000000000D000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333000033333333333333333333333333330000333333333333
        3333FF333333FFF30000330733333370333733FF333733F30000330007333370
        33373333FF3733F300003300000733703337333333F333F30000330000000770
        33373333333333F3000033000007337033373333337733F30000330007333370
        33373333773733F3000033073333337033373377333733F30000333333333333
        3337773333377733000033333333333333333333333333330000333333333333
        33333333333333330000}
      NumGlyphs = 2
      OnClick = sbLastClick
    end
    object cbScript: TComboBox
      Left = 68
      Top = 11
      Width = 353
      Height = 21
      Style = csDropDownList
      DropDownCount = 12
      ItemHeight = 0
      TabOrder = 0
      OnChange = cbScriptChange
      OnMeasureItem = cbScriptMeasureItem
    end
  end
  object edScript: TJvHLEditor
    Left = 0
    Top = 39
    Width = 572
    Height = 334
    Cursor = crIBeam
    GutterWidth = 0
    RightMarginColor = clSilver
    Completion.ItemHeight = 13
    Completion.Interval = 800
    Completion.ListBoxStyle = lbStandard
    Completion.CaretChar = '|'
    Completion.CRLF = '/n'
    Completion.Separator = '='
    TabStops = '3 5'
    BracketHighlighting.StringEscape = #39#39
    SelForeColor = clHighlightText
    SelBackColor = clHighlight
    OnChangeStatus = edScriptChangeStatus
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabStop = True
    UseDockManager = False
    Colors.Comment.Style = [fsItalic]
    Colors.Comment.ForeColor = clOlive
    Colors.Comment.BackColor = clWindow
    Colors.Number.ForeColor = clNavy
    Colors.Number.BackColor = clWindow
    Colors.Strings.ForeColor = clPurple
    Colors.Strings.BackColor = clWindow
    Colors.Symbol.ForeColor = clBlue
    Colors.Symbol.BackColor = clWindow
    Colors.Reserved.Style = [fsBold]
    Colors.Reserved.ForeColor = clWindowText
    Colors.Reserved.BackColor = clWindow
    Colors.Identifier.ForeColor = clWindowText
    Colors.Identifier.BackColor = clWindow
    Colors.Preproc.ForeColor = clGreen
    Colors.Preproc.BackColor = clWindow
    Colors.FunctionCall.ForeColor = clWindowText
    Colors.FunctionCall.BackColor = clWindow
    Colors.Declaration.ForeColor = clWindowText
    Colors.Declaration.BackColor = clWindow
    Colors.Statement.Style = [fsBold]
    Colors.Statement.ForeColor = clWindowText
    Colors.Statement.BackColor = clWindow
    Colors.PlainText.ForeColor = clWindowText
    Colors.PlainText.BackColor = clWindow
  end
  object sbScript: TStatusBar
    Left = 0
    Top = 410
    Width = 572
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 100
      end
      item
        Alignment = taCenter
        Width = 100
      end
      item
        Alignment = taCenter
        Width = 100
      end
      item
        Width = 50
      end>
  end
  object CodeEditFormStorage: TJvFormStorage
    AppStoragePath = 'ServiceScriptCodeEdit\'
    StoredValues = <>
    Left = 84
    Top = 52
  end
end
