object CourseForm: TCourseForm
  Left = 387
  Top = 204
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1103' '#1082#1091#1088#1089#1072
  ClientHeight = 325
  ClientWidth = 598
  Color = clBtnFace
  Constraints.MinHeight = 100
  Constraints.MinWidth = 400
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 598
    Height = 325
    ActivePage = pgTable
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 612
    ExplicitHeight = 335
    object pgTable: TTabSheet
      Caption = #1058#1072#1073#1083#1080#1094#1072
      ExplicitWidth = 604
      ExplicitHeight = 307
      object dgDollar: TMyDBGridEh
        Left = 0
        Top = 0
        Width = 590
        Height = 256
        Align = alClient
        AllowedOperations = []
        DataGrouping.GroupLevels = <>
        DataSource = dsDollar
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghHighlightFocus, dghClearSelection, dghDialogFind, dghColumnResize, dghColumnMove]
        ReadOnly = True
        RowDetailPanel.Color = clBtnFace
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            EditButtons = <>
            FieldName = 'Value'
            Footers = <>
            Title.Caption = #1050#1091#1088#1089
            Width = 86
          end
          item
            EditButtons = <>
            FieldName = 'DateTm'
            Footers = <>
            Title.Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
            Width = 171
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 256
        Width = 590
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 1
        ExplicitTop = 266
        ExplicitWidth = 604
        DesignSize = (
          590
          41)
        object CloseBtn: TSpeedButton
          Left = 489
          Top = 8
          Width = 97
          Height = 25
          Anchors = [akTop, akRight]
          Caption = #1047#1072#1082#1088#1099#1090#1100
          NumGlyphs = 2
          Spacing = 5
          OnClick = CloseBtnClick
          ExplicitLeft = 428
        end
        object btClearDollar: TBitBtn
          Left = 140
          Top = 8
          Width = 141
          Height = 25
          Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1091'...'
          TabOrder = 0
          OnClick = btClearDollarClick
          NumGlyphs = 2
        end
        object btDelDollar: TBitBtn
          Left = 6
          Top = 8
          Width = 125
          Height = 25
          Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
          TabOrder = 1
          OnClick = btDelDollarClick
          NumGlyphs = 2
          Spacing = 5
        end
      end
    end
    object pgChart: TTabSheet
      Caption = #1044#1080#1072#1075#1088#1072#1084#1084#1072
      ImageIndex = 1
      ExplicitWidth = 604
      ExplicitHeight = 307
      object DBChart1: TDBChart
        Left = 0
        Top = 0
        Width = 590
        Height = 297
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Foot.Visible = False
        MarginBottom = 6
        MarginLeft = 2
        MarginRight = 5
        MarginTop = 15
        Title.Font.Height = -13
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          #1050#1091#1088#1089' '#1076#1086#1083#1083#1072#1088#1072)
        Title.Visible = False
        LeftAxis.ExactDateTime = False
        LeftAxis.Increment = 0.500000000000000000
        LeftAxis.Title.Caption = #1050#1091#1088#1089
        LeftAxis.Title.Font.Style = [fsBold]
        Legend.HorizMargin = 16
        Legend.Visible = False
        View3D = False
        Align = alClient
        BevelOuter = bvLowered
        Color = clSilver
        TabOrder = 0
        ExplicitWidth = 604
        ExplicitHeight = 307
        object Series1: TLineSeries
          Cursor = crSizeNWSE
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Length = 20
          Marks.Style = smsValue
          Marks.Visible = True
          DataSource = dm.aqUSD
          ShowInLegend = False
          XLabelsSource = 'DateOnly'
          LinePen.Width = 2
          Pointer.Brush.Color = clFuchsia
          Pointer.HorizSize = 3
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.VertSize = 3
          Pointer.Visible = True
          XValues.Name = 'X'
          XValues.Order = loAscending
          XValues.ValueSource = 'Date'
          YValues.Name = 'Y'
          YValues.Order = loNone
          YValues.ValueSource = 'Value'
        end
      end
    end
  end
  object dsDollar: TDataSource
    AutoEdit = False
    DataSet = dqDollar
    Left = 480
    Top = 136
  end
  object dqDollar: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 444
    Top = 168
  end
end
