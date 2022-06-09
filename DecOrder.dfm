object DecompForm: TDecompForm
  Left = 335
  Top = 210
  BorderStyle = bsDialog
  Caption = #1056#1072#1079#1073#1080#1074#1082#1072' '#1079#1072#1082#1072#1079#1072
  ClientHeight = 273
  ClientWidth = 577
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 235
    Width = 577
    Height = 38
    Align = alBottom
    TabOrder = 0
    object Label9: TLabel
      Left = 8
      Top = 11
      Width = 68
      Height = 13
      Caption = #1064#1080#1092#1088' '#1079#1072#1082#1072#1079#1072
    end
    object Panel3: TPanel
      Left = 88
      Top = 6
      Width = 177
      Height = 25
      BevelOuter = bvLowered
      TabOrder = 0
      object dtChifer: TDBText
        Left = 3
        Top = 6
        Width = 166
        Height = 17
        DataField = 'ID'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object btOk: TBitBtn
      Left = 372
      Top = 6
      Width = 93
      Height = 25
      Caption = #1054#1050
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = btOkClick
      NumGlyphs = 2
    end
    object btCancel: TBitBtn
      Left = 472
      Top = 6
      Width = 87
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 2
      OnClick = btCancelClick
      NumGlyphs = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 577
    Height = 235
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 4
    Caption = 'Panel2'
    TabOrder = 1
    object ScrollBox: TScrollBox
      Left = 6
      Top = 6
      Width = 565
      Height = 223
      HorzScrollBar.Margin = 6
      HorzScrollBar.Range = 311
      VertScrollBar.Margin = 6
      VertScrollBar.Range = 160
      Align = alClient
      AutoScroll = False
      BorderStyle = bsNone
      TabOrder = 0
      object Label6: TLabel
        Left = 5
        Top = 196
        Width = 48
        Height = 13
        Caption = #1047#1072#1082#1072#1079#1095#1080#1082
      end
      object Label8: TLabel
        Left = 6
        Top = 136
        Width = 50
        Height = 13
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        FocusControl = edComment
      end
      object Label1: TLabel
        Left = 133
        Top = 168
        Width = 33
        Height = 13
        Caption = #1058#1080#1088#1072#1078
      end
      object Label2: TLabel
        Left = 264
        Top = 168
        Width = 60
        Height = 13
        Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099
      end
      object Label3: TLabel
        Left = 6
        Top = 168
        Width = 68
        Height = 13
        Caption = #8470' '#1087#1086#1076#1079#1072#1082#1072#1079#1072
      end
      object btNewCust: TSpeedButton
        Left = 428
        Top = 191
        Width = 125
        Height = 25
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1079#1072#1082#1072#1079#1095#1080#1082#1072
        Caption = #1047#1072#1082#1072#1079#1095#1080#1082#1080
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btNewCustClick
      end
      object edComment: TDBEdit
        Left = 62
        Top = 133
        Width = 319
        Height = 21
        DataField = 'Comment'
        TabOrder = 0
      end
      object lkCustomer: TJvDBLookupCombo
        Left = 62
        Top = 193
        Width = 319
        Height = 21
        DataField = 'Customer'
        DisplayEmpty = '<'#1047#1072#1084#1086#1074#1085#1080#1082'>'
        LookupField = 'N'
        LookupDisplay = 'Name;Phone'
        LookupSource = dm.dsCust
        TabOrder = 1
        OnCloseUp = lkCustomerCloseUp
      end
      object dgItems: TDBGrid
        Left = 4
        Top = 4
        Width = 557
        Height = 120
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete]
        TabOrder = 2
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Color = clInfoBk
            Expanded = False
            FieldName = 'SubNumber'
            Title.Caption = #1055#1086#1076#1079#1072#1082#1072#1079
            Width = 55
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Comment'
            Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
            Width = 179
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NProduct'
            Title.Caption = #1058#1080#1088#1072#1078
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'Percent'
            Title.Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099
            Width = 67
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CustName'
            Title.Caption = #1047#1072#1082#1072#1079#1095#1080#1082
            Width = 154
            Visible = True
          end>
      end
      object btDelete: TBitBtn
        Left = 428
        Top = 160
        Width = 125
        Height = 24
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 3
        OnClick = btDeleteClick
        NumGlyphs = 2
      end
      object btAppend: TBitBtn
        Left = 428
        Top = 130
        Width = 125
        Height = 24
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        TabOrder = 4
        OnClick = btAppendClick
        NumGlyphs = 2
      end
      object edNProduct: TDBEdit
        Left = 174
        Top = 164
        Width = 81
        Height = 21
        DataField = 'NProduct'
        TabOrder = 5
      end
      object edPercent: TDBEdit
        Left = 332
        Top = 164
        Width = 49
        Height = 21
        DataField = 'Percent'
        TabOrder = 6
      end
      object edSub: TDBEdit
        Left = 80
        Top = 164
        Width = 41
        Height = 21
        DataField = 'SubNumber'
        TabOrder = 7
      end
    end
  end
end
