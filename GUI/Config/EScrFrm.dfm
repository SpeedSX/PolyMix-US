object EditScriptForm: TEditScriptForm
  Left = 384
  Top = 325
  ActiveControl = edScript
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1094#1077#1085#1072#1088#1080#1103
  ClientHeight = 372
  ClientWidth = 573
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object edScript: TJvHLEditor
    Left = 0
    Top = 0
    Width = 573
    Height = 316
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
  object Panel1: TPanel
    Left = 0
    Top = 316
    Width = 573
    Height = 56
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
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
      Left = 393
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
    object sbScript: TStatusBar
      Left = 0
      Top = 37
      Width = 573
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
  end
  object ScriptStorage: TJvFormStorage
    AppStoragePath = 'EditScriptForm\'
    StoredValues = <>
    Left = 272
    Top = 324
  end
end
