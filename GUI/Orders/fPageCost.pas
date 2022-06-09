unit fPageCost;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, MyDBGridEh, StdCtrls, ExtCtrls, Buttons, DBClient,
  DB, jvPageList, CalcUtils, jvFormPlacement, DBGridEhGrouping;

type
  TfrPageCost = class(TFrame)
    Panel1: TPanel;
    btAddProcess: TBitBtn;
    btDeleteProcess: TBitBtn;
    paPageCost: TPanel;
    dgPageCost: TMyDBGridEh;
    Panel3: TPanel;
    Panel2: TPanel;
    cbViewKind: TComboBox;
    Label1: TLabel;
    procedure dgPageCostGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure paPageCostResize(Sender: TObject);
  private
    cdPageCost: TClientDataSet;
    dsPageCost: TDataSource;
    FPageList: TjvPageList;
    //FIniStorage: TjvFormPlacement;
    //PrevSortID: integer;
    //DisablePrev: boolean;
    //JumpOverID: integer;
    FOnContentPageActivated: TNotifyEvent;
    //FOnInvoicePageActivated: TNotifyEvent;
    FCostVisible, FDisablePageTracking: boolean;
    //FShowInvoicesPayments: boolean;
    function GetPageCostData: TDataSet;
    procedure SetPageList(_PageList: TjvPageList);
    procedure FillData;
    procedure PageCostAfterScroll(DataSet: TDataSet);
    procedure PageCostBeforeScroll(DataSet: TDataSet);
    procedure PageCostGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure PageCaptionGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure SetIniStorage(_IniStorage: TjvFormPlacement);
    procedure SetCostVisible(c: boolean);
    function GetRowHeight: integer;
    procedure SetRowHeight(rh: integer);
    function GetRowLines: boolean;
    procedure SetRowLines(rl: boolean);
  public
    PageDataRef, GroupDataRef: TDataSet;
    GroupPageIndex: integer; // страничка, которая отображается, когда стоишь на группе
    ContentPageIndex: integer; // страничка состава заказа
    InvoicePageIndex: integer; // страничка информации о счетах и оплатах
    constructor Create(Owner: TComponent); override;
    property PageCostData: TDataSet read GetPageCostData;
    property PageList: TjvPageList read FPageList write SetPageList;
    //property IniStorage: TjvFormPlacement read FIniStorage write SetIniStorage;
    property OnContentPageActivated: TNotifyEvent read FOnContentPageActivated write FOnContentPageActivated;
    //property OnInvoicePageActivated: TNotifyEvent read FOnInvoicePageActivated write FOnInvoicePageActivated;
    procedure CreateData;
    procedure LeftToRight;
    procedure RightToLeft;
    procedure SettingsChanged;
    procedure UpdatePageInfo(PageID: integer; TotalCost: extended;
     ItemCount: integer);
    procedure EnablePageTracking;
    procedure DisablePageTracking;
    property CostVisible: boolean read FCostVisible write SetCostVisible;
    //property ShowInvoicesPayments: boolean read FShowInvoicesPayments write FShowInvoicesPayments;
    property RowHeight: integer read GetRowHeight write SetRowHeight;
    property RowLines: boolean read GetRowLines write SetRowLines;
  end;

implementation

{$R *.dfm}

uses CalcSettings, fSrvTmpl, PmProcessCfgData;

constructor TfrPageCost.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  SetIniStorage(TSettingsManager.Instance.MainFormStorage);
  SettingsChanged;
end;

procedure TfrPageCost.CreateData;
begin
  {
  // Создается пустой набор данных только для отображения в DBGrid'e.
  // В БД, конечно, НЕ сохраняется.
  }
  if cdPageCost <> nil then cdPageCost.Free;
  cdPageCost := TClientDataSet.Create(Self);
  with cdPageCost do begin
    with TIntegerField.Create(Self) do begin
      Name := 'cdPageCostSortID';
      FieldKind := fkData;
      FieldName := 'SortID';
      DataSet := cdPageCost;
    end;
    with TStringField.Create(Self) do begin
      Name := 'cdPageCostPageCaption';
      FieldKind := fkData;
      FieldName := 'PageCaption';
      Size := 127;
      DataSet := cdPageCost;
      OnGetText := PageCaptionGetText;
    end;
    with TBooleanField.Create(Self) do begin
      Name := 'cdPageCostIsGroup';
      FieldKind := fkData;
      FieldName := 'IsGroup';
      DataSet := cdPageCost;
    end;
    with TFloatField.Create(Self) do begin
      Name := 'cdPageCostPageCost';
      FieldKind := fkData;
      FieldName := 'PageCost';
      DataSet := cdPageCost;
      DisplayFormat := CalcUtils.NumDisplayFmt;
      OnGetText := PageCostGetText;
    end;
    with TIntegerField.Create(Self) do begin
      Name := 'cdPageCostPageID';
      FieldKind := fkData;
      FieldName := 'PageID';
      DataSet := cdPageCost;
    end;
    with TIntegerField.Create(Self) do begin
      Name := 'cdPageCostGrpID';
      FieldKind := fkData;
      FieldName := 'GrpID';
      DataSet := cdPageCost;
    end;
    with TIntegerField.Create(Self) do begin
      Name := 'cdPageCostItemCount';
      FieldKind := fkData;
      FieldName := 'ItemCount';
      DataSet := cdPageCost;
    end;
  end;
  cdPageCost.AfterScroll := PageCostAfterScroll;
  cdPageCost.BeforeScroll := PageCostBeforeScroll;
  if dsPageCost = nil then dsPageCost := TDataSource.Create(Self);
  dsPageCost.DataSet := cdPageCost;
  dgPageCost.DataSource := dsPageCost;
end;

procedure TfrPageCost.PageCostAfterScroll(DataSet: TDataSet);
var
  i, t, FoundIndex: integer;
  Fr: TfrSrvTemplate;
begin
  if cdPageCost.ControlsDisabled or FDisablePageTracking then Exit;
  if not cdPageCost.IsEmpty and (FPageList.PageCount > 0) then
  begin
    if cdPageCost['SortID'] = 0 then
    begin
      // активация странички с содержимым заказа
      if Assigned(FOnContentPageActivated) then FOnContentPageActivated(nil);
      FPageList.ActivePageIndex := ContentPageIndex;
    end
    {else if cdPageCost['SortID'] = 1 then
    begin
      // активация странички со счетами и оплатами
      if Assigned(FOnInvoicePageActivated) then FOnInvoicePageActivated(nil);
      FPageList.ActivePageIndex := InvoicePageIndex;
    end}
    else
    begin
      FoundIndex := -1;
      {if cdPageCost['IsGroup'] then begin  // не дает остановиться на группе
        if ((PrevSortID < cdPageCost['SortID']) and (JumpOverID <> cdPageCost['SortID']))  // двигались вниз
           or ((PrevSortID > cdPageCost['SortID']) and (JumpOverID = cdPageCost['SortID'])) then begin
          if not cdPageCost.eof then begin
            DisablePrev := true;
            JumpOverID := cdPageCost['SortID'];
            cdPageCost.Next;
            DisablePrev := false;
          end;
        end else if ((PrevSortID > cdPageCost['SortID']) and (JumpOverID <> cdPageCost['SortID']))
           or ((PrevSortID < cdPageCost['SortID']) and (JumpOverID = cdPageCost['SortID'])) then begin
          if not cdPageCost.bof then begin
            DisablePrev := true;
            JumpOverID := cdPageCost['SortID'];
            cdPageCost.Prior;
            DisablePrev := false;
          end else if not cdPageCost.eof then begin
            DisablePrev := true;
            JumpOverID := cdPageCost['SortID'];
            cdPageCost.Next;
            DisablePrev := false;
          end;
        end;
        //FoundIndex := GroupPageIndex
      end else }if not cdPageCost['IsGroup'] then begin
        if not VarIsNull(cdPageCost['PageID']) then
        begin
          t := cdPageCost['PageID'];
          for i := 0 to Pred(FPageList.PageCount) do
            if FPageList.Pages[i].Tag = t then
            begin
              FoundIndex := i;
              break;
            end;
        end;
      end;
      if FoundIndex <> -1 then
      begin
        FPageList.ActivePageIndex := FoundIndex;
        Fr := FPageList.ActivePage.Controls[0] as TfrSrvTemplate;
        Fr.OpenProcesses;
      end;
    end;
  end;
end;

procedure TfrPageCost.PageCostBeforeScroll(DataSet: TDataSet);
begin
{  try
    if not DisablePrev then
      PrevSortID := cdPageCost['SortID'];
  except PrevSortID := 0; end;}
end;

function TfrPageCost.GetPageCostData: TDataSet;
begin
  Result := cdPageCost;
end;

procedure TfrPageCost.LeftToRight;
begin
  Visible := true;
end;

procedure TfrPageCost.RightToLeft;
begin
  Visible := false;
end;

procedure TfrPageCost.SettingsChanged;
begin
  RowLines := Options.PageCostRowLines;
  RowHeight := Options.PageCostRowHeight;
end;

procedure TfrPageCost.SetPageList(_PageList: TjvPageList);
begin
  FPageList := _PageList;
  FillData;
end;

procedure TfrPageCost.DisablePageTracking;
begin
  FDisablePageTracking := true;
end;

procedure TfrPageCost.EnablePageTracking;
begin
  FDisablePageTracking := false;
  cdPageCost.First;
  dgPageCost.SetFocus;
end;

procedure TfrPageCost.FillData;
var
  i, SortID, GrpID: integer;
begin
  CreateData;
  cdPageCost.CreateDataSet;
  cdPageCost.DisableControls;
  try
    if Assigned(FPageList) and (FPageList.PageCount > 0) then
    begin
      cdPageCost.Append;
      cdPageCost['SortID'] := 0;
      cdPageCost['PageCaption'] := 'Состав заказа';
      cdPageCost['IsGroup'] := true;

      {if FShowInvoicesPayments then
      begin
        cdPageCost.Append;
        cdPageCost['SortID'] := 1;
        cdPageCost['PageCaption'] := 'Счета и оплаты';
        cdPageCost['IsGroup'] := true;
      end;}

      GrpID := 0;
      SortID := 1; {2}

      for i := 0 to Pred(FPageList.PageCount) do  // идем по всем страницам
      begin
        if (i <> GroupPageIndex) and (i <> ContentPageIndex)
          {and ((i <> InvoicePageIndex) or not FShowInvoicesPayments)} then
        begin
          cdPageCost.Append;
          cdPageCost['SortID'] := SortID;
          cdPageCost['PageCaption'] := (FPageList.Pages[i] as TPageClass).Caption;
          cdPageCost['PageID'] := FPageList.Pages[i].Tag;
          cdPageCost['PageCost'] := 0;
          cdPageCost['IsGroup'] := false;
          cdPageCost['ItemCount'] := 0;
          if Assigned(PageDataRef) and Assigned(GroupDataRef) and
             PageDataRef.Locate(F_ProcessPageID, cdPageCost['PageID'], []) then
          begin
            cdPageCost['GrpID'] := PageDataRef['GrpID'];
            if GrpID <> cdPageCost['GrpID'] then  // переход на следующую группу
            begin
              if GroupDataRef.Locate('GrpID', PageDataRef['GrpID'], []) then
              begin
                cdPageCost['SortID'] := SortID + 1;
                cdPageCost.Append;
                cdPageCost['SortID'] := SortID;
                cdPageCost['IsGroup'] := true;
                cdPageCost['PageCaption'] := GroupDataRef['GrpDesc'];
                cdPageCost['PageCost'] := 0;
                cdPageCost['GrpID'] := GroupDataRef['GrpID'];
                cdPageCost['ItemCount'] := 0;
                GrpID := cdPageCost['GrpID'];
                Inc(SortID);
              end;
            end;
          end;
          Inc(SortID);
        end;
      end;
    end;
    cdPageCost.AddIndex('SortIndex', 'SortID', []);
    cdPageCost.IndexName := 'SortIndex';
  finally
    cdPageCost.EnableControls;
  end;
end;

procedure TfrPageCost.UpdatePageInfo(PageID: integer; TotalCost: extended;
  ItemCount: integer);
var
  SID: integer;
begin
  if cdPageCost.Active and not cdPageCost.IsEmpty then
  begin
    cdPageCost.DisableControls;
    try
      SID := cdPageCost['SortID'];
      if cdPageCost.Locate('PageID', PageID, []) then
      begin
        if (cdPageCost['PageCost'] <> TotalCost) or (cdPageCost['ItemCount'] <> ItemCount) then
        begin
          cdPageCost.Edit;
          cdPageCost['PageCost'] := TotalCost;
          cdPageCost['ItemCount'] := ItemCount;
          cdPageCost.CheckBrowseMode;
        end;
        cdPageCost.Locate('SortID', SID, []);  // Возвращаемся
      end;
    finally
      cdPageCost.EnableControls;
    end;
  end;
end;

procedure TfrPageCost.dgPageCostGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if (Column <> nil) and (Column.Field <> nil) then
  try
    if Column.Field.DataSet['SortID'] = 0 then  // Страница состава заказа
      AFont.Style := [fsBold]
    else
    {if Column.Field.DataSet['SortID'] = 1 then  // Страница счетов
      AFont.Style := [fsBold]
    else}
    if not VarIsNull(Column.Field.DataSet['IsGroup']) and Column.Field.DataSet['IsGroup'] then
    begin
      Background := Options.GetColor(sPageGroupBk);
      AFont.Color := Options.GetColor(sPageGroupText);
    end else if (Column.Field.DataSet['PageCost'] <> 0) or (Column.Field.DataSet['ItemCount'] > 0) then
      AFont.Style := [fsBold]
    else
      AFont.Color := Options.GetColor(sDisabledPageText);
  except end;
end;

procedure TfrPageCost.PageCostGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender <> nil then begin
    if Sender.DataSet['IsGroup'] then Text := ''
    else
      if not VarIsNull(Sender.Value) and (Sender.AsFloat <> 0) then
        Text := FormatFloat(CalcUtils.NumDisplayFmt, Sender.AsFloat)
     else
        Text := '-';
  end;
end;

procedure TfrPageCost.PageCaptionGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender <> nil then begin
    if Options.ShowProcessCount and not VarIsNull(Sender.DataSet['ItemCount'])
        and (Sender.DataSet['ItemCount'] > 0) then
      Text := Sender.AsString + ' [' + IntToStr(Sender.DataSet['ItemCount']) + ']'
    else
      Text := Sender.AsString;
  end;
end;

procedure TfrPageCost.SetIniStorage(_IniStorage: TjvFormPlacement);
begin
  //FIniStorage := _IniStorage;
  dgPageCost.IniStorage := _IniStorage;
end;

procedure TfrPageCost.paPageCostResize(Sender: TObject);
//var c: extended;
begin
  // пропорциональное изменение ширины колонок
  {c := dgPageCost.Columns[0].Width * 1.0 / (dgPageCost.Columns[0].Width + dgPageCost.Columns[1].Width);
  dgPageCost.Columns[0].Width := c * dgPageCost.Width;
  dgPageCost.Columns[1].Width := (1 - c) * dgPageCost.Width;}
end;

procedure TfrPageCost.SetCostVisible(c: boolean);
begin
  FCostVisible := c;
  dgPageCost.Columns[1].Visible := FCostVisible;
end;

function TfrPageCost.GetRowHeight: integer;
begin
  Result := dgPageCost.RowHeight;
end;

procedure TfrPageCost.SetRowHeight(rh: integer);
begin
  dgPageCost.RowHeight := rh;
end;

function TfrPageCost.GetRowLines: boolean;
begin
  Result := dgRowLines in dgPageCost.Options;
end;

procedure TfrPageCost.SetRowLines(rl: boolean);
begin
  if rl then
    dgPageCost.Options := dgPageCost.Options + [dgRowLines]
  else
    dgPageCost.Options := dgPageCost.Options - [dgRowLines];
end;


end.
