unit fOrdersFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseFrame, ExtCtrls, JvExExtCtrls, JvNetscapeSplitter, StdCtrls,
  Mask, DBCtrls, Buttons, GridsEh, DBGridEh, MyDBGridEh, Menus, ImgList,
  JvPageList, JvImageList, jvFormPlacement, JvInterpreter,

  fSrvTmpl, fComInfo, fPageCost, fOrderItems, PmOrder, CalcUtils, PmProcess,
  NotifyEvent, fBaseFilter, fMainFilter, PmEntity,
  PmOrderProcessItems, DBGridEhGrouping;

type
  TOrderViewMode = (vmLeft, vmRight{, vmDoing});

  TOrdersFrame = class(TBaseFrame)
    dgOrders: TMyDBGridEh;
    panRight: TPanel;
    paOrderBottom: TPanel;
    paTotalItogo: TPanel;
    Panel16: TPanel;
    btCancel: TBitBtn;
    btOK: TBitBtn;
    paParams: TPanel;
    paCommentButtons: TPanel;
    btAddComment2: TBitBtn;
    btRemoveComment2: TBitBtn;
    paParamsControls: TPanel;
    lbTirazz: TLabel;
    lbComment: TLabel;
    lbComment2: TLabel;
    edTirazz: TDBEdit;
    edComment: TDBEdit;
    edComment2: TDBEdit;
    paOrdInfo: TPanel;
    paOrdInfoBottom: TPanel;
    paOrdInfoTop: TPanel;
    spOrders: TJvNetscapeSplitter;
    CalcMenu: TPopupMenu;
    CopyItem: TMenuItem;
    MkOrderItem: TMenuItem;
    MkCalcItem: TMenuItem;
    miDelete: TMenuItem;
    miProtectCost: TMenuItem;
    miProtectContent: TMenuItem;
    miUnprotectCost: TMenuItem;
    miUnprotectContent: TMenuItem;
    miSeparator1: TMenuItem;
    paOrderLeft: TPanel;
    CalcTimer: TTimer;
    OrderInfoTimer: TTimer;
    paOrdMain: TPanel;
    miSeparator2: TMenuItem;
    miBulkEdit: TMenuItem;
    procedure dgOrderCheckButton(Sender: TObject; ACol: Integer;
      Column: TColumnEh; var Enabled: Boolean);
    procedure CalcMenuPopup(Sender: TObject);
    procedure miProtectCostClick(Sender: TObject);
    procedure miProtectContentClick(Sender: TObject);
    procedure miUnprotectCostClick(Sender: TObject);
    procedure miUnprotectContentClick(Sender: TObject);
    procedure miBulkEditClick(Sender: TObject);
    procedure acEditOrderExecute(Sender: TObject);   // Редактирование расчета
    procedure dgCalcOrderDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure dgCalcOrderGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState); virtual;
    procedure dgOrderKeyPress(Sender: TObject; var Key: Char);
    procedure dgTitleBtnClick(Sender: TObject; ACol: Integer; Column: TColumnEh);
    procedure edTirazzChange(Sender: TObject);
    procedure edEnterKeyPress(Sender: TObject; var Key: Char);
    procedure edCommentChange(Sender: TObject);
    procedure edComment2Change(Sender: TObject);
    procedure btAddComment2Click(Sender: TObject);
    procedure btRemoveComment2Click(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure paParamsResize(Sender: TObject);
    //procedure CopyItemClick(Sender: TObject);
    //procedure MkOrderItemClick(Sender: TObject);
    //procedure MkCalcItemClick(Sender: TObject);
    //procedure miDeleteClick(Sender: TObject);
  private
    FOnEditOrder: TNotifyEvent;
    FImageList: TjvImageList;
    //FOrder: TOrder;
    FOnProtectCost: TNotifyEvent;
    FOnUnProtectCost: TNotifyEvent;
    FOnProtectContent: TNotifyEvent;
    FOnUnProtectContent: TNotifyEvent;
    FOnGetCostVisible: TBooleanEvent;
    FComInfoFrame: TfrCommonInfo;
    FPageCostFrame: TfrPageCost;
    FOrderItemsFrame: TfOrderItems;
    FOnContentPageActivated: TNotifyEvent;
    FOnOrderBeforeScroll: TNotifyEvent;
    FOnCancel: TNotifyEvent;
    FOnUpdateModified: TNotifyEvent;
    FOnSaveAndClose: TBooleanEvent;
    FOnBulkEdit: TIntArrayNotifyEvent;
    WasRight: boolean;
    FModified: boolean;
    OrdersWidthNormal,{, OrdersWidthWide, }SaveOrdersWidth, ProcessListWidth: integer;
    FContentPage, FGroupPage{, FInvoicePage}: TPageClass;
    FProcessPages: TJvPageList;
    FViewMode: TOrderViewMode;
    TmpPageID: integer;
    TmpGridList: TList;
    CurFrame: TfrSrvTemplate;
    
    //FGridTotalUpdateID: TNotifyHandlerID;
    //function GetOrder: TOrder;
    procedure SetModified(Value: boolean);
  protected
    procedure CreateGridColumns; virtual; abstract;
    procedure ClearGridColumns;
    function GetStoragePath: string;
    {procedure btPanRightClick(Sender: TObject);
    procedure btPanLeftClick(Sender: TObject);}
    // является ли заказ просроченным
    function IsUrgentOrder(UrgentHours: integer): boolean;
    function SaveOrderAndClose: boolean;
    procedure UpdateControlSettings;
    function InsideOrder: boolean;
    function EqualGrids(p: TPageClass; Grids: TList): boolean;
    procedure CreateSrvFrame(TmpGridList: TList; Page: TPageClass;
      SetActiveControl, CallCreateScript, EmptyFrame, EnableOnCreateFrame: boolean);
    procedure FrameGetValue(Sender: TObject; Identifer: String;
      var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
    procedure DoOnContentPageActivated(Sender: TObject);
    function GetPageTotal(Page: TPageClass; var ItemCount: integer): extended;
    procedure LoadProcessSettings;
    procedure SaveProcessSettings;
    procedure DoOnTirazzChanged(Sender: TObject);
    procedure TirazzGetCellParams(Sender: TObject; EditMode: Boolean;
      Params: TColCellParamsEh);
  public
    constructor Create(Owner: TComponent; {_Name: string; }_Order: TEntity); override;
    destructor Destroy; override;
    procedure RightToLeft;  // Выход из расчета - установка состояний контролов
    procedure LeftToRight;  // Вход в расчет - установка состояний контролов
    procedure SaveSettings; override;
    procedure LoadSettings; override;
    procedure SettingsChanged; override;
    procedure RefreshOrderItems;
    procedure BeforeCloseProcessItems;
    //procedure Activate; virtual;  закомментил т.к. не вызывается
    procedure HideProgress;
    procedure CreateProcessPageList;
    procedure FreeProcessPageList;
    procedure UpdateMainParamsVisible;
    procedure StartFramesToRight;
    procedure FinishFramesToRight;
    procedure CreatePages;
    procedure GridTotalUpdate(ProcessGrid: TProcessGrid);
    function Order: TOrder;
    function CreateFilterFrame: TBaseFilterFrame; override;

    procedure SetImageList(_ImageList: TjvImageList);
    //property Order: TOrder read FOrder;
    property OnEditOrder: TNotifyEvent read FOnEditOrder write FOnEditOrder;
    property OnProtectCost: TNotifyEvent read FOnProtectCost write FOnProtectCost;
    property OnUnProtectCost: TNotifyEvent read FOnUnProtectCost write FOnUnProtectCost;
    property OnProtectContent: TNotifyEvent read FOnProtectContent write FOnProtectContent;
    property OnUnProtectContent: TNotifyEvent read FOnUnProtectContent write FOnUnProtectContent;
    property OnGetCostVisible: TBooleanEvent read FOnGetCostVisible write FOnGetCostVisible;
    property OnContentPageActivated: TNotifyEvent read FOnContentPageActivated write FOnContentPageActivated;
    property OnOrderBeforeScroll: TNotifyEvent read FOnOrderBeforeScroll write FOnOrderBeforeScroll;
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
    property OnUpdateModified: TNotifyEvent read FOnUpdateModified write FOnUpdateModified;
    property OnSaveAndClose: TBooleanEvent read FOnSaveAndClose write FOnSaveAndClose;
    property OnBulkEdit: TIntArrayNotifyEvent read FOnBulkEdit write FOnBulkEdit;

    property PageCostFrame: TfrPageCost read FPageCostFrame;
    property ComInfoFrame: TfrCommonInfo read FComInfoFrame;
    property OrderItemsFrame: TfOrderItems read FOrderItemsFrame;
    property Modified: boolean read FModified write SetModified;
    property ViewMode: TOrderViewMode read FViewMode write FViewMode;
    property ProcessPages: TJvPageList read FProcessPages;
  end;

  TOrdersFrameClass = class of TOrdersFrame;

implementation

uses JvJVCLUtils, CalcSettings, PmAccessManager, StdDic, PmStates,
  ColorLst, DateUtils, MainFilter, PmActions, RVCLUtils, PmScriptManager,
  fTabSrv, fTabSrv2, fTabSrv3L1, ServData, ServMod, RAI2_SrvPage,
  PmConfigManager, RAI2_CalcSrv, PmProcessCfgData, PmEntSettings;

{$R *.dfm}

const
  DefOrdersWidthNormal = 195;
//  DefOrdersWidthWide = 598;}

constructor TOrdersFrame.Create(Owner: TComponent; {_Name: string; }_Order: TEntity);
begin
  inherited Create(Owner, _Order{_Name});
  //FOrder := _Order;

  FModified := true;  // 10.04.2009 Эксперимент

  TMainActions.SetAction(CopyItem, TOrderActions.Copy);
  TMainActions.SetAction(MkOrderItem, TOrderActions.MakeWork);
  TMainActions.SetAction(MkCalcItem, TOrderActions.MakeDraft);
  TMainActions.SetAction(miDelete, TOrderActions.Delete);

  CreateGridColumns;
  dgOrders.DataSource := Order.DataSource;
  edTirazz.DataSource := Order.DataSource;

  // ПОЧЕМУ-ТО ПРИШЛОСЬ ЗДЕСЬ ПРИСВАИВАТЬ ОБРАБОТЧИКИ!
  edTirazz.OnKeyPress := edEnterKeyPress;
  edTirazz.OnChange := edTirazzChange;

  edComment.DataSource := Order.DataSource;
  edComment2.DataSource := Order.DataSource;

  edComment.OnKeyPress := edEnterKeyPress;
  edComment.OnChange := edCommentChange;
  edComment2.OnKeyPress := edEnterKeyPress;
  edComment2.OnChange := edComment2Change;
  btAddComment2.OnClick := btAddComment2Click;
  btRemoveComment2.OnClick := btRemoveComment2Click;

  //OrdersWidthNormal := DefOrdersWidthNormal;
  //OrdersWidthWide := DefOrdersWidthWide;
  //ProcessListWidth := OrdersWidthNormal;
  //SaveOrdersWidth := OrdersWidthNormal;

  FComInfoFrame := TfrCommonInfo.Create(Self);
  FComInfoFrame.Parent := paOrdInfoTop;
  FComInfoFrame.SetPropAction(TMainActions.GetAction(TOrderActions.EditProperties));
  FComInfoFrame.SetHistoryAction(TMainActions.GetAction(TOrderActions.History));
  FComInfoFrame.SetOkCancel(btOk, btCancel);

  FPageCostFrame := TfrPageCost.Create(Self);  // создается невидимым
  FPageCostFrame.Parent := paOrderLeft;
  //FPageCostFrame.IniStorage := _MainStorage;
  FPageCostFrame.OnContentPageActivated := DoOnContentPageActivated;

  FOrderItemsFrame := TfOrderItems.Create(Self, Order.OrderItems);
  //FOrderItemsFrame.IniStorage := _MainStorage;
  FOrderItemsFrame.Parent := paOrdInfoBottom;

  FilterObject := Order.Criteria;
  FilterFrame.Entity := _Order;

  Order.OnTirazzChanged := DoOnTirazzChanged;

  TSettingsManager.Instance.XPActivateMenuItem(CalcMenu.Items, true);
  //TSettingsManager.Instance.XPInitComponent(paParams);
  TSettingsManager.Instance.XPInitComponent(edTirazz);
  TSettingsManager.Instance.XPInitComponent(edComment);
  TSettingsManager.Instance.XPInitComponent(edComment2);
  TSettingsManager.Instance.XPInitComponent(btAddComment2);
  TSettingsManager.Instance.XPInitComponent(btRemoveComment2);
  TSettingsManager.Instance.XPInitComponent(btOk);
  TSettingsManager.Instance.XPInitComponent(btCancel);

  UpdateControlSettings;

    // в версии 2.5 появилась кнопка Счет. Ставим ее вместо Экспорта и Импорта
   {if siExport.Visible then
    begin
      siMakeInvoice.Visible := true;
      siMakeInvoice.Left := siExport.Left;
      siMakeInvoice.Top := siExport.Top;
      siExport.Visible := false;
      siImport.Visible := false;
    end;}
end;

procedure TOrdersFrame.SetImageList(_ImageList: TjvImageList);
begin
  FImageList := _ImageList;
  CalcMenu.Images := _ImageList;
end;

destructor TOrdersFrame.Destroy;
begin
  inherited;
end;

procedure TOrdersFrame.dgOrderCheckButton(Sender: TObject; ACol: Integer;
  Column: TColumnEh; var Enabled: Boolean);
begin
                             // Почему-то не получается сортировка по НОМЕРУ!
  Enabled := (Column.Field <> nil) and (Column.Field.FieldName <> TOrder.F_OrderKey);
end;

procedure TOrdersFrame.CalcMenuPopup(Sender: TObject);
begin
  //ShowAllItem.Enabled := MFFilter.FilterEnabled;

  Order.ReadKindPermissions(false);

  miUnprotectCost.Visible := AccessManager.CurKindPerm.CostProtection
    and not Order.IsEmpty and Order.CostProtected;
  miUnprotectContent.Visible := AccessManager.CurKindPerm.ContentProtection
    and not Order.IsEmpty  and Order.ContentProtected;
  miProtectCost.Visible := AccessManager.CurKindPerm.CostProtection
    and not Order.IsEmpty and not Order.CostProtected;
  // Если не разрешена защита стоимости ВООБЩЕ, то включить этот пункт меню,
  // только если она уже включена для заказа.
  if not EntSettings.AllowCostProtect then
    miProtectCost.Visible := Order.CostProtected;
  miProtectContent.Visible := AccessManager.CurKindPerm.ContentProtection
    and not Order.IsEmpty and not Order.ContentProtected;
  miBulkEdit.Visible := not Order.IsEmpty and (dgOrders.SelectedRows.Count > 1);
end;

{procedure TOrdersFrame.CopyItemClick(Sender: TObject);
begin
  TMainActions.GetAction(TOrderActions.Copy).Execute;
end;}

procedure TOrdersFrame.miProtectCostClick(Sender: TObject);
begin
  FOnProtectCost(Self);
end;

{procedure TOrdersFrame.miDeleteClick(Sender: TObject);
begin
  TMainActions.GetAction(TOrderActions.Delete).Execute;
end;}

procedure TOrdersFrame.miProtectContentClick(Sender: TObject);
begin
  FOnProtectContent(Self);
end;

procedure TOrdersFrame.miUnprotectCostClick(Sender: TObject);
begin
  FOnUnProtectCost(Self);
end;

procedure TOrdersFrame.miBulkEditClick(Sender: TObject);
var
  i: integer;
  ids: TIntArray;
begin
  if dgOrders.SelectedRows.Count > 1 then
  begin
    SetLength(ids, dgOrders.SelectedRows.Count);
    for i := 0 to Pred(dgOrders.SelectedRows.Count) do
    begin
      Entity.DataSet.GotoBookmark(pointer(dgOrders.SelectedRows[i]));
      ids[i] := Order.KeyValue;
    end;
    FOnBulkEdit(ids);
  end
end;

{procedure TOrdersFrame.MkCalcItemClick(Sender: TObject);
begin
  TMainActions.GetAction(TOrderActions.MakeDraft).Execute;
end;

procedure TOrdersFrame.MkOrderItemClick(Sender: TObject);
begin
  TMainActions.GetAction(TOrderActions.MakeWork).Execute;
end;}

procedure TOrdersFrame.paParamsResize(Sender: TObject);
begin
  {if ViewMode = vmRight then bw := btAddComment2.Width + 3 else bw := 0;
  edComment.Width := paParams.Width - edComment.Left - 5 - bw;
  edComment2.Width := paParams.Width - edComment2.Left - 5 - bw;}
  if InsideOrder then
  begin
    paCommentButtons.Visible := true;
    //btAddComment2.Visible := true;
    //btAddComment2.Left := edComment2.Left + edComment2.Width + 3;
    //btRemoveComment2.Visible := true;
    //btRemoveComment2.Left := btAddComment2.Left;
  end
  else
  begin
    paCommentButtons.Visible := false;
    //btAddComment2.Visible := false;
    //btRemoveComment2.Visible := false;
  end;
end;

procedure TOrdersFrame.miUnprotectContentClick(Sender: TObject);
begin
  FOnUnprotectContent(Self);
end;

procedure TOrdersFrame.acEditOrderExecute(Sender: TObject);   // Редактирование расчета
begin
  FOnEditOrder(Self);
end;

procedure TOrdersFrame.dgCalcOrderDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
begin
  // Рисует стрелочку на сортирующем поле.
  // Принадлежность ячейки заголовку определяется не очень хорошо, по Rect.Top.
  if (Rect.Top <= (Sender as TOrderGridClass).TitleHeight * 2)
     and ({((Pos('Modify', Column.FieldName) <> 0) and (Pos('Modify', SortFields[QIndex]) <> 0))
     or ((Pos('Creation', Column.FieldName) <> 0) and (Pos('Creation', SortFields[QIndex]) <> 0))
     or ((Column.FieldName = 'ID') and (SortFields[QIndex] = OrderSortByID))}
     ((CompareText(Column.FieldName, Order.SortField) = 0)
     or (CompareText(Column.Field.Origin, Order.SortField) = 0)))
  then
  begin
    if Options.NewAtEnd and (SortDownBmp <> nil) then
      DrawBitmapTransparent((Sender as TOrderGridClass).Canvas, Rect.Right - SortDownBmp.Width - 4,
                             1, SortDownBmp, clSilver)
    else if not Options.NewAtEnd and (SortUpBmp <> nil) then
      DrawBitmapTransparent((Sender as TOrderGridClass).Canvas, Rect.Right - SortUpBmp.Width - 4,
                             1, SortUpBmp, clSilver);
  end
  else
  begin
    try      // Состояние заказа
      if (CompareText(Column.FieldName, TOrder.F_OrderState) = 0) and (Column.Field <> nil) then
      begin
        DrawOrderState(Sender as TOrderGridClass, Column, Rect);
      end
      else  // Состояние оплаты
      if (CompareText(Column.FieldName, TOrder.F_PayState) = 0) and (Column.Field <> nil) then
      begin
        DrawPayState(Sender as TOrderGridClass, Column, Rect);
      end
      else  // Состояние отгрузки
      if (CompareText(Column.FieldName, TOrder.F_ShipmentState) = 0) and (Column.Field <> nil) then
      begin
        DrawShipmentState(Sender as TOrderGridClass, Column, Rect);
      end
      else
      if (CompareText(Column.FieldName, TOrder.F_IsLockedByUser) = 0) and (Column.Field <> nil) then
      begin
        DrawLockState(Sender as TOrderGridClass, Column, Rect);
      end;
    except end;
  end;
end;


procedure TOrdersFrame.dgCalcOrderGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
var
  i, rc: integer;
  Highlight: boolean;
  States: TStringList;
begin
  //if not HighLight and (Field <> nil) then
  //begin
    // Раскраска строк таблицы
    try
      if not (Sender as TOrderGridClass).Enabled then
        Background := (Sender as TOrderGridClass).Color
      {$IFNDEF Manager}
      else
      if (Column.Field.DataSet.FindField(TOrder.F_OrderState) <> nil)
        and Options.OrdStateRowColor then
      begin // Определять цвет по состоянию
        Background := clWindow;
        if not VarIsNull(Column.Field.DataSet[TOrder.F_OrderState]) then
        begin
          States := TConfigManager.Instance.StandardDics.OrderStates;
          i := States.IndexOf(IntToStr(Column.Field.DataSet[TOrder.F_OrderState]));
          if (i <> -1) and (States.Objects[i] <> nil) then
          begin
            rc := (States.Objects[i] as TOrderState).RowColorCode;
            if rc <> 0 then
            begin
              rc := ColorItems.IndexOf(IntToStr(rc));
              if (rc <> -1) then
                Background := TColor(ColorItems.Objects[rc])
            end;
          end;
        end;
      end
      else // цвет берется из данных
      if not VarIsNull(Column.Field.DataSet[TOrder.F_RowColor]) then
      begin
        Background := Column.Field.DataSet[TOrder.F_RowColor];
        if Background = clBlack then
          AFont.Color := clWhite;
      end;
      // В режиме выделения срочных и просроченных заказов меняем цвет шрифта
      if (Order is TWorkOrder) and Options.MarkUrgentOrders
          and IsUrgentOrder(Options.UrgentHours) then
        AFont.Color := Options.GetColor(sUrgentOrderText);
      {$ENDIF}
    except end;
  //end else
  //  if not (Sender as TOrderGridClass).Enabled then AFont.Color := clWhite;
end;

function TOrdersFrame.IsUrgentOrder(UrgentHours: integer): boolean;
begin
  Result := not Order.IsEmpty and Order.Active
    and VarIsNull((Order as TWorkOrder).FactFinishDate)
    and (IncHour((Order as TWorkOrder).FinishDate, -UrgentHours) <= Now);
end;

procedure TOrdersFrame.dgOrderKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then FOnEditOrder(Self);
end;

procedure TOrdersFrame.dgTitleBtnClick(Sender: TObject; ACol: Integer; Column: TColumnEh);
begin
  if Column.Field <> nil then
  begin
    FOnOrderBeforeScroll(Self);
    CalcTimer.Enabled := false;
    try
      if Column.Field.Origin <> '' then
        Order.SetSortOrder(Column.Field.Origin, true)
      else
        Order.SetSortOrder(Column.Field.FieldName, true);
    finally
      CalcTimer.Enabled := Options.AutoOpen;
    end;
  end;
end;

procedure TOrdersFrame.edTirazzChange(Sender: TObject);
var
  i: integer;   // обижается красным на нулевой тираж - S.B.
begin
  if Trim(edTirazz.Text) <> '' then
    try i := StrToInt(edTirazz.Text);
    except on EConvertError do i := 0; end
  else
    i := 0;

  if i <= 0 then
  begin
    // некорректный тираж
    edTirazz.Font.Color := clRed;
    edTirazz.Font.Style := [fsBold];
  end
  else
  begin
    edTirazz.Font.Color := clBlack;
    edTirazz.Font.Style := [];
  end;
end;

procedure TOrdersFrame.edEnterKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    FindNextControl(Sender as TWinControl, true, true, false).SetFocus;
    //FocusControl(FindNextControl(Sender as TWinControl, true, true, false));
    Key := #0;
  end;
end;

procedure TOrdersFrame.edCommentChange(Sender: TObject);
begin
  FOnUpdateModified(nil);
end;

procedure TOrdersFrame.btAddComment2Click(Sender: TObject);
begin
  if InsideOrder and Order.Active and VarIsNull(Order.Comment2) then
  begin
    Order.Comment2 := '';
    UpdateMainParamsVisible;
  end;
end;

procedure TOrdersFrame.btCancelClick(Sender: TObject);
begin
  FOnCancel(Self);
end;

procedure TOrdersFrame.btOKClick(Sender: TObject);
begin
  SaveOrderAndClose;
end;

function TOrdersFrame.SaveOrderAndClose: boolean;
begin
  Result := FOnSaveAndClose;
end;

procedure TOrdersFrame.btRemoveComment2Click(Sender: TObject);
begin
  if InsideOrder and Order.Active then
  begin
    Order.Comment2 := null;
    UpdateMainParamsVisible;
  end;
end;

procedure TOrdersFrame.edComment2Change(Sender: TObject);
begin
  FOnUpdateModified(nil);
end;

procedure TOrdersFrame.LoadProcessSettings;
var
  i: integer;
  c: TControl;
begin
  if Assigned(FProcessPages) then
    if FProcessPages.PageCount > 0 then
      for i := 0 to Pred(FProcessPages.PageCount) do
      begin
        if FProcessPages.Pages[i].Tag > 0 then
        begin
          c := FProcessPages.Pages[i].Controls[0];
          if c is TfrSrvTemplate then
            (c as TfrSrvTemplate).LoadSettings;
        end;
      end;
end;

procedure TOrdersFrame.SaveProcessSettings;
var
  i: integer;
  c: TControl;
begin
  if Assigned(FProcessPages) then
    if FProcessPages.PageCount > 0 then
      for i := 0 to Pred(FProcessPages.PageCount) do
      begin
        if FProcessPages.Pages[i].Tag > 0 then
        begin
          c := FProcessPages.Pages[i].Controls[0];
          if c is TfrSrvTemplate then
            (c as TfrSrvTemplate).SaveSettings;
        end;
      end;
end;

// Выход из расчета - установка состояний контролов
procedure TOrdersFrame.RightToLeft;
var
  h, m: integer;
begin
  SaveProcessSettings;
    //miInWork.Enabled := true;
    //miPlan.Enabled := true;

    //btPanLeft.Enabled := true;
    //btPanRight.Enabled := true;
    dgOrders.Enabled := true;
    dgOrders.Color := clWindow;

    if WasRight then
      ProcessListWidth := paOrderLeft.Width;

    if Options.WideOrderList then begin
      paOrderLeft.Align := alClient;
      panRight.Align := alBottom;
      spOrders.Align := alBottom;
      spOrders.Visible := false;
    end else begin
      paOrderLeft.Align := alClient;
      panRight.Align := alRight;
      spOrders.Align := alRight;
      spOrders.Left := panRight.Left - 10;
      spOrders.Visible := true;
    end;

    paOrderLeft.Visible := true;
    {if WorkAreaExpanded then begin
      WorkAreaExpanded := false;
      btPanRightClick(btPanRight);
    end;}
    // В начале идет один вызов без реального переключения справа налево,
    // поэтому пропускаем его, а сохраняем, только если уже были справа.

    //TotalItogo.Color := clBtnFace;
    //TotalItogo.Caption := '';
    //lbTotalItogo.Enabled := false;

    if not Options.AutoOpen then begin
      edComment.Enabled := false;
      edComment2.Enabled := false;
      edTirazz.Enabled := false;
    end;

    //paProTool.Visible := true;

    //paOrderBottom.Visible := false;

    ComInfoFrame.Visible := false;
    ComInfoFrame.RightToLeft;
    FOrderItemsFrame.Visible := false;
    //FOrderInvPayFrame.Visible := false;
    //paOrdContent.Visible := false;
    ComInfoFrame.Align := alNone;
    ComInfoFrame.Parent := paOrdInfoTop;
    paOrdInfoTop.Align := alTop;
    h := paOrdInfoBottom.Height;
    paOrdInfoBottom.Align := alClient;
    paOrdInfoTop.Height := ComInfoFrame.GetNormalHeight;

    //paParams.Parent := panRight;  // 14.10.2008

    //paOrdMain.RemoveControl(fOrdItems);
    //paOrdContent.Parent := paOrdMain;
    FOrderItemsFrame.RightToLeft;
    FOrderItemsFrame.Parent := paOrdInfoBottom;
    //FOrderInvPayFrame.Parent := Self;

    PageCostFrame.RightToLeft;

    //panLeft.Width := SaveOrdersWidth;    24.11.2005
    if not Options.WideOrderList and (SaveOrdersWidth > 0) then begin
      //m := Width - SaveOrdersWidth - spOrders.Width;
      //if Options.ShowFilterPanel then m := m - paFilter.Width * 2;
      m := SaveOrdersWidth;
      if m < ComInfoFrame.GetMinWidth then
        m := ComInfoFrame.GetMinWidth;
      panRight.Width := m;
    end;

    if not paFilter.Visible and Options.ShowFilterPanel then paFilter.Show;
    ComInfoFrame.Align := alClient;
    ComInfoFrame.Visible := true;

    FOrderItemsFrame.RightToLeft;
    FOrderItemsFrame.Visible := true;

    paCommentButtons.Visible := false;

    //pcCalcOrderChange(nil);    // TODO! НАДО?
    dgOrders.SetFocus;

    //AllNotifIgnore := false;    // Вкл. обработку обновлений расчетов

    WasRight := false;

    UpdateMainParamsVisible;
end;

procedure TOrdersFrame.LeftToRight;  // Вход в расчет - установка состояний контролов
var
  c, cp, PermitParamUpdate: boolean;
  h: integer;
begin
    //miInWork.Enabled := false;
    //miPlan.Enabled := false;

    // какие то непонятные глюки происходят, если активна страница со счетами оплатами
    // получается неправильный размер панели с общей информацией, поэтому переключаем временно на другую страницу 
    FOrderItemsFrame.HideInvPayFrame;

    // Изменение расположения панелей
    paOrderLeft.Align := alLeft;
    spOrders.Align := alLeft;
    spOrders.Visible := true;
    spOrders.Left := paOrderLeft.Left + paOrderLeft.Width + 1;
    panRight.Align := alClient;

    //pcCalcOrder.Visible := false;
    //paProTool.Visible := false;

    SaveOrdersWidth := panRight.Width;

    //paOrdContent.Align := alNone;
    if not Options.AutoOpen then paFilter.Hide;
    ComInfoFrame.Visible := false;
    ComInfoFrame.Align := alNone;

    paOrderLeft.Width := ProcessListWidth;

    //fOrdItems.Visible := false;
    h := paOrdInfoTop.Height;
    //paOrdInfoBottom.RemoveControl(fOrdItems);
    FOrderItemsFrame.LeftToRight;
    //fOrdItems.Parent := FContentPage;  // перенес в CreatePages
    //ts := fOrdItems.ProcessPage;
    //paOrdContent.Align := alClient;
    //paOrdContent.Visible := false;
    //paOrdContent.Parent := ts;
    //fOrdItems.Parent := paOrdMain;

    //paParams.Parent := paOrdMain;  // 14.10.2008

    paOrdInfoBottom.Align := alBottom;
    paOrdInfoBottom.Height := h;
    paOrdInfoTop.Align := alClient;
    ComInfoFrame.Parent := paOrdInfoBottom;
    ComInfoFrame.Align := alBottom;   // 2.10.2008 почему то раньше было alClient, и неправильные размеры иногда получались
    //paOrdContent.Visible := true;
    //fOrdItems.Visible := true;
    ComInfoFrame.LeftToRight;
    ComInfoFrame.Visible := true;
    //FOrderInvPayFrame.Visible := CurrentView is TWorkView;

    //CreateProcessPages;

    PageCostFrame.LeftToRight;
    //c := pcCalcOrder.ActivePage.TabIndex = 0;
    {if CurFrame <> nil then CurFrame.Free;
    CurFrame := nil;}

    // Кнопочки
    //btPanLeft.Enabled := Options.AutoOpen;
    //btPanRight.Enabled := Options.AutoOpen;
    dgOrders.Enabled := Options.AutoOpen;
    if not Options.AutoOpen then begin
      dgOrders.Color := clBtnFace;
    end;

    paOrderLeft.Visible := not Options.HideOnEdit;
    //spOrders.Visible := HideOnEdit;

    if not Options.AutoOpen then
    begin
      c := OnGetCostVisible;
      // во избежание значительного усложнения блокируем тираж
      // и при защите стоимости
      cp := not Order.ContentProtected and not Order.CostProtected
        and AccessManager.CurKindPerm.Update;
      // нет отдельной настройки для прав на изменение цвета, заказчика, комментария
      // поэтому ставим по праву создания или модификации. см. также OrdProp
      PermitParamUpdate := AccessManager.CurKindPerm.CreateNew or AccessManager.CurKindPerm.Update;
      edComment.Enabled := PermitParamUpdate;
      edTirazz.Enabled := c and cp;
      edComment2.Enabled := c;
    end;

    paOrderBottom.Visible := false;

    paCommentButtons.Visible := true;
    
    //if not AutoOpen then edTirazz.SetFocus;

    WasRight := true;

    FOrderItemsFrame.ShowInvPayFrame;  // восстанавливаем активную страницу счетов-оплат

    LoadProcessSettings;

    UpdateMainParamsVisible;
end;

procedure TOrdersFrame.SaveSettings;
begin
  inherited SaveSettings;
  with TSettingsManager.Instance do
  begin
    SaveGridLayout(dgOrders, GetStoragePath + 'OrdersGrid');
  end;
  TSettingsManager.Instance.Storage.WriteInteger(iniInterface + '\panLeftWidth', OrdersWidthNormal);
  //TSettingsManager.Instance.Storage.WriteInteger(iniInterface + '\panLeftWidthWide', OrdersWidthWide);
  TSettingsManager.Instance.Storage.WriteInteger(iniInterface + '\panLeftWidthIsNormal',
        Ord(paOrderLeft.Width = OrdersWidthNormal));
  if ProcessListWidth <> 0 then
    TSettingsManager.Instance.Storage.WriteInteger(iniInterface + '\ProcessListWidth', ProcessListWidth);

  //if Toolbar.IniStorage <> nil then MForm.Toolbar.SaveLayout;
  OrderItemsFrame.SaveSettings;
end;

function TOrdersFrame.GetStoragePath: string;
begin
  Result := Order.InternalName + 'OrderView' + '\';
end;

procedure TOrdersFrame.LoadSettings;
var
  i, index: integer;
begin
  inherited LoadSettings;

  try OrdersWidthNormal := StrToInt(TSettingsManager.Instance.Storage.ReadString(iniInterface + '\panLeftWidth',
    IntToStr(OrdersWidthNormal)));
  except end;
  {try OrdersWidthWide := StrToInt(TSettingsManager.Instance.Storage.ReadString(iniInterface + '\panLeftWidthWide', IntToStr(DefOrdersWidthWide)));
  except end;}
  //NormWidth := Storage.ReadString(iniInterface + '\panLeftWidthIsNormal', '1') = '1';
  {if NormWidth then panRight.Width := MForm.paOrdContent.Width - MForm.spOrders.Width - OrdersWidthNormal
  else MForm.panRight.Width := MForm.paOrdContent.Width - MForm.spOrders.Width - OrdersWidthWide;}
  //if paOrderLeft.Width = 0 then paOrderLeft.Width := DefOrdersWidthNormal;
  panRight.Width := TfrCommonInfo.MinHorViewFrameWidth + 2;
  SaveOrdersWidth := 0;
  try ProcessListWidth := StrToInt(TSettingsManager.Instance.Storage.ReadString(iniInterface + '\ProcessListWidth',
    IntToStr(DefOrdersWidthNormal)));
  except end;
  if ProcessListWidth = 0 then ProcessListWidth := DefOrdersWidthNormal;

  //if MForm.Toolbar.IniStorage <> nil then MForm.Toolbar.RestoreLayout;

  FOrderItemsFrame.Order := Order;
  FOrderItemsFrame.LoadSettings;

  TSettingsManager.Instance.LoadGridLayout(dgOrders, GetStoragePath + 'OrdersGrid');

end;

{function TOrdersFrame.GetOrder: TOrder;
begin
  Result := Entity as TOrder;
end;}

procedure TOrdersFrame.SetModified(Value: boolean);
begin
  if Value <> FModified then
  begin
    if Value then
    begin
      btOk.Enabled := true;
      btCancel.Caption := 'Отмена';
      TMainActions.GetAction(TOrderActions.Save).Enabled := true;
    end
    else if not Value then
    begin
      btOk.Enabled := false;
      btCancel.Caption := 'Закрыть';
      TMainActions.GetAction(TOrderActions.Save).Enabled := false;
    end;
    FModified := Value;
  end;
end;

{procedure TOrdersFrame.btPanRightClick(Sender: TObject);
var m: integer;
begin
  m := paOrdContent.Width - spOrders.Width - OrdersWidthWide;
  if m < ComInfoFrame.GetMinWidth then m := ComInfoFrame.GetMinWidth;
  panRight.Width := m;
  btPanRight.Visible := false;
  btPanLeft.Visible := true;
end;

procedure TOrdersFrame.btPanLeftClick(Sender: TObject);
var m: integer;
begin
  m := paOrdContent.Width - spOrders.Width - OrdersWidthNormal;
  if m < ComInfoFrame.GetMinWidth then m := ComInfoFrame.GetMinWidth;
  panRight.Width := m;
  btPanLeft.Visible := false;
  btPanRight.Visible := true;
end;}

procedure TOrdersFrame.UpdateMainParamsVisible;
begin
  // показываем комментарий только если разрешено отображение стоимости
  if not Order.IsEmpty and not VarIsNull(Order.Comment2)
    and FOnGetCostVisible then
  begin
    paParams.Height := edComment2.Height + edComment2.Top + 5;
    btAddComment2.Enabled := false;
    btRemoveComment2.Enabled := InsideOrder;
  end
  else
  begin
    paParams.Height := edComment.Height + edComment.Top + 5;
    btAddComment2.Enabled := InsideOrder;
    btRemoveComment2.Enabled := false;
  end;
  btAddComment2.Visible := InsideOrder;
  btRemoveComment2.Visible := InsideOrder;
end;

procedure TOrdersFrame.SettingsChanged;
begin
  if ProcessPages <> nil then ProcessPages.Repaint;
  UpdateControlSettings;
  if FComInfoFrame <> nil then ComInfoFrame.SettingsChanged;
  if FPageCostFrame <> nil then PageCostFrame.SettingsChanged;
  if FOrderItemsFrame <> nil then FOrderItemsFrame.SettingsChanged;
  if FilterFrame <> nil then FilterFrame.SettingsChanged;
  ClearGridColumns;
  CreateGridColumns;
end;

// При изменении состава заказа внутри заказа
procedure TOrdersFrame.RefreshOrderItems;
begin
  FOrderItemsFrame.Order := Order;
  FOrderItemsFrame.DisableControls;
  FOrderItemsFrame.RefreshData;    // обязательно после ShowExecState
  FOrderItemsFrame.EnableControls;
end;

procedure TOrdersFrame.BeforeCloseProcessItems;
begin
  if Assigned(FOrderItemsFrame) then
    FOrderItemsFrame.BeforeCloseData;
end;

procedure TOrdersFrame.UpdateControlSettings;
begin
  dgOrders.Font.Name := Options.ScheduleFontName;
  dgOrders.Font.Size := Options.ScheduleFontSize;
  paParamsControls.Color := Options.GetColor(sParamsPanelBk);
end;

function TOrdersFrame.CreateFilterFrame: TBaseFilterFrame;
begin
  Result := TFilterFrame.Create(Self);
end;
{
procedure TMForm.CreateFilter;
begin
  FilterFrame := TFilterFrame.Create(Self);
  paQuery.Width := FilterFrame.Width + 2;
  FilterFrame.Parent := paQuery;
  FilterFrame.OnCreate;
  FilterFrame.FilterObj := MFFilter;
  FilterFrame.OnFilterChange := FilterChange;
  FilterFrame.OnDisableFilter := DisableFilter;
  FilterFrame.OnHideFrame := HideFilter;
  FilterFrame.AppStorage := TSettingsManager.Instance.Storage;
end;
}

{procedure TOrdersFrame.Activate;
begin
  paFilter.Visible := Options.ShowFilterPanel;

  // переключаем фильтр - у него не все работает в расчетах
  FilterFrame.Entity := Order;
  ComInfoFrame.Order := Order;

  edTirazz.DataSource := Order.DataSource;
  edComment.DataSource := Order.DataSource;
  edComment2.DataSource := Order.DataSource;

  UpdateMainParamsVisible;

  CalcTimer.Enabled := Options.AutoOpen;

end;}

 procedure TOrdersFrame.HideProgress;
 begin
   ComInfoFrame.HideProgress;
 end;

 procedure TOrdersFrame.CreateProcessPageList;
var ts: TPageClass;
begin
  FProcessPages := TJvPageList.Create(Self);
  FProcessPages.Parent := paOrdInfoTop;
  FProcessPages.Align := alClient;
  FContentPage := nil;
  //FInvoicePage := nil;

  // создаем страницу, которая отображается, когда стоишь на названии группы
  ts := TPageClass.Create(Self);
  ts.Tag := -1;
  ts.PageList := FProcessPages;
  ts.PageIndex := 0;
  FGroupPage := ts;

  // создаем страницу, которая отображается, когда стоишь на составе заказа
  ts := TPageClass.Create(Self);
  ts.Tag := -1;
  ts.PageList := FProcessPages;
  ts.PageIndex := 1;
  FContentPage := ts;

  {if CurrentView is TWorkView then
  begin
    // создаем страницу, которая отображается, когда стоишь на счетах
    ts := TPageClass.Create(Self);
    ts.Tag := -1;
    ts.PageList := ProcessPages;
    ts.PageIndex := 2;
    FInvoicePage := ts;
  end;}
end;

procedure TOrdersFrame.FreeProcessPageList;
var
  i: integer;
  c: TControl;
begin
  if Assigned(FProcessPages) then
  begin
    if FProcessPages.PageCount > 0 then
      for i := 0 to Pred(FProcessPages.PageCount) do
      begin
        if FProcessPages.Pages[i].Tag > 0 then
        begin
          c := FProcessPages.Pages[i].Controls[0];
          if c is TfrSrvTemplate then
            (c as TfrSrvTemplate).BeforeDelete;
        end;
      end;
  end;
  FreeAndNil(FProcessPages);
  FContentPage := nil;
  FGroupPage := nil;
  //FInvoicePage := nil;
end;

function TOrdersFrame.InsideOrder: boolean;
begin
  Result := ViewMode = vmRight;
end;

procedure TOrdersFrame.StartFramesToRight;
begin
  PageCostFrame.ContentPageIndex := FContentPage.PageIndex;
  OrderItemsFrame.Parent := FContentPage;  // перенес из LeftToRight
  // TODO: некрасиво
  PageCostFrame.DisablePageTracking;  // иначе будет бегать по страницам
  { TODO: Надо посмотреть: может быть, достаточно cdKindPages? }
  PageCostFrame.GroupDataRef := sdm.cdSrvGrps;   // Сначала эти надо дать...
  PageCostFrame.PageDataRef := sdm.cdSrvPages;
  //PageCostFrame.ShowInvoicesPayments := CurrentView is TWorkView;
  PageCostFrame.PageList := FProcessPages;  // ...теперь по списку там создается таблица страниц
  PageCostFrame.GroupPageIndex := FGroupPage.PageIndex;
end;

procedure TOrdersFrame.FinishFramesToRight;
begin
  PageCostFrame.EnablePageTracking;
end;

function TOrdersFrame.EqualGrids(p: TPageClass; Grids: TList): boolean;
var
  cnt: TControl;
  g1, g2, g3, go1, go2, go3: TProcessGrid;
begin
  Result := false;
  cnt := p.Controls[0];
  if cnt is TfrTabSrv then
    Result := (Grids.Count = 1) and ((cnt as TfrTabSrv).ProcessGrid = Grids[0])
  else if cnt is TfrTabSrv2H then begin
    if Grids.Count = 2 then begin
      go1 := Grids[0];
      go2 := Grids[1];
      g1 := (cnt as TfrTabSrv2H).ProcessGrid1;
      g2 := (cnt as TfrTabSrv2H).ProcessGrid2;
      Result := ((g1 = go1) and (g2 = go2)) or ((g1 = go2) and (g2 = go1));
    end;
  end else if cnt is TfrTabSrv3L1 then begin
    if Grids.Count = 3 then
    begin
      go1 := Grids[0];
      go2 := Grids[1];
      go3 := Grids[2];
      g1 := (cnt as TfrTabSrv3L1).ProcessGrid1;
      g2 := (cnt as TfrTabSrv3L1).ProcessGrid2;
      g3 := (cnt as TfrTabSrv3L1).ProcessGrid3;
      Result := ((g1 = go1) and ((g2 = go2) and (g3 = go3) or (g2 = go3) and (g3 = go2))) or
                ((g1 = go2) and ((g2 = go1) and (g3 = go3) or (g2 = go3) and (g3 = go1))) or
                ((g1 = go3) and ((g2 = go1) and (g3 = go2) or (g2 = go2) and (g3 = go1)));
    end;
  end else Exception.Create('Неизвестный тип фрейма. Обратитесь к разработчику');
end;

// Создает страницы для процессов
procedure TOrdersFrame.CreatePages;
var
  i: integer;
  ts: TPageClass;
  Srv: TPolyProcess;
  _CreatePage, PermitUpdate: boolean;
  TmpPageCaption: string;
  TmpEmptyFrame, TmpEnableOnCreateFrame: boolean;
begin
  sdm.OpenKindPageInfo(Order.KindID, Order is TDraftOrder);
  // удаляем все страницы, которых нет вообще в текущем виде (с учетом прав на просмотр)
  if FProcessPages.PageCount > 0 then
  begin
    TmpGridList := TList.Create;
    try
      // составляем список страниц, которые надо удалить
      for i := 0 to Pred(FProcessPages.PageCount) do
        if (FProcessPages.Pages[i].Tag > 0) and  // встроенные пропускаем
           not sdm.cdKindPages.Locate(F_ProcessPageID, FProcessPages.Pages[i].Tag, []) then
        begin
          TmpGridList.Add(FProcessPages.Pages[i]);
          //sm.BeforeDeletePage(ProcessPages.Pages[i] as TPageClass);
        end;
      // удаляем
      if TmpGridList.Count > 0 then
        for i := 0 to Pred(TmpGridList.Count) do
          TPageClass(TmpGridList.Items[i]).Free;
    finally
      TmpGridList.Free;
    end;
  end;
    sdm.cdKindPages.First;
    // Гриды упорядочены по группе, номеру в группе и номеру грида на странице
    while not sdm.cdKindPages.eof do
    begin
      TmpPageID := sdm.cdKindPages[F_ProcessPageID];
      TmpPageCaption := sdm.cdKindPages['PageCaption'];
      TmpEmptyFrame := sdm.cdKindPages['EmptyFrame'];
      TmpEnableOnCreateFrame := sdm.cdKindPages['EnableOnCreateFrame'];
      // теперь находим все таблицы, ссылающиеся на страничку
      TmpGridList := TList.Create;
      try

        repeat
          TmpGridList.Add(Order.Processes.GridByID(sdm.cdKindPages['GridID'], false));
          Srv := Order.Processes.ServiceByID(sdm.cdKindPages['ProcessID'], false);
          PermitUpdate := AccessManager.CurKindPerm.Update;
          if Order is TDraftOrder then
            Srv.SetPermissions(sdm.cdKindPages['DraftInsert'] and PermitUpdate,
              sdm.cdKindPages['DraftUpdate'] and PermitUpdate,
              sdm.cdKindPages['DraftDelete'] and PermitUpdate,
              sdm.cdKindPages['PlanDate'], sdm.cdKindPages['FactDate'])
          else
            Srv.SetPermissions(sdm.cdKindPages['WorkInsert'] and PermitUpdate,
              sdm.cdKindPages['WorkUpdate'] and PermitUpdate,
              sdm.cdKindPages['WorkDelete'] and PermitUpdate,
              sdm.cdKindPages['PlanDate'], sdm.cdKindPages['FactDate']);
          sdm.cdKindPages.Next;
        until sdm.cdKindPages.eof or sdm.cdKindPages[F_ProcessPageID] <> TmpPageID;

        if TmpGridList.Count > 0 then
        begin  // Если такие есть
          _CreatePage := true;
          for i := 0 to Pred(FProcessPages.PageCount) do  // ищем эту страничку
            if FProcessPages.Pages[i].Tag = TmpPageID then
            begin
              // такая страница есть, сравниваем ее гриды с теми, что у нас
              _CreatePage := not EqualGrids(FProcessPages.Pages[i] as TPageClass, TmpGridList);
              if _CreatePage then
                FProcessPages.Pages[i].Free
              else  // обновляем ссылку на заказ
                ((FProcessPages.Pages[i] as TPageClass).Controls[0] as TfrSrvTemplate).Order := Order;
              break;
            end;
          if _CreatePage then
          begin
            ts := TPageClass.Create(Self);   // Создаем страничку
            ts.Tag := TmpPageID;
            ts.PageList := FProcessPages;
            ts.PageIndex := FProcessPages.PageCount - 1;  // Номер текущей странички...
            ts.Caption := TmpPageCaption;
            for i := 0 to Pred(TmpGridList.Count) do    // присваиваем страничку всем таблицам
              TProcessGrid(TmpGridList[i]).Page := ts;
            //if not sdm.cdSrvPages['CreateFrameOnShow'] then begin // если создается фрейм сразу и навсегда
            CreateSrvFrame(TmpGridList, ts, false {activate}, true {script},
              TmpEmptyFrame, TmpEnableOnCreateFrame);
          end;
          CurFrame := nil; { TODO: Вообще-то переменная CurFrame уже не нужна как глобальная, т.к. все фреймы создаются сразу }
        end;

      finally
        TmpGridList.Free;
      end;
    end;
end;

function CompareGrids(Item1, Item2: Pointer): Integer;
var
 a, b: integer;
begin
  a := TProcessGrid(Item1).GridCfg.PageOrderNum;
  b := TProcessGrid(Item2).GridCfg.PageOrderNum;
  if a > b then Result := 1
  else if a < b then Result := -1
  else Result := 0;
end;

procedure TOrdersFrame.CreateSrvFrame(TmpGridList: TList; Page: TPageClass;
  SetActiveControl, CallCreateScript, EmptyFrame, EnableOnCreateFrame: boolean);
var
  Srv, Srv2, Srv3: TProcessGrid;
  cf: TfrTabSrv;
  cf2: TfrTabSrv2H;
  cf3l1: TfrTabSrv3L1;

  procedure CallScript(_frame: TFrame);
  begin
    if (_frame <> nil) and CallCreateScript then
    try
      if EnableOnCreateFrame then
      begin
        ScriptFrame := _frame;
        ScriptPageGrids := TmpGridList;
        ScriptPage := Page;
        ScriptSetActiveControl := SetActiveControl;
        ScriptOrder := Order;
        ScriptManager.ExecPageScript('OnCreateFrame', Page.Tag, FrameGetValue);
      end;
    except end;
  end;

begin
  if EmptyFrame then
  begin
    CurFrame := TfrSrvTemplate.Create(Self);
    RemoveControl(CurFrame);
    Page.InsertControl(CurFrame);
    if TmpGridList.Count = 1 then
    begin
      Srv := TProcessGrid(TmpGridList[0]);
      CurFrame.AddProcessGrid(Srv);
    end;
    CallScript(CurFrame);
  end
  else
  if TmpGridList.Count > 0 then
  begin
    if TmpGridList.Count = 1 then   // страничка на одну таблицу
    begin
      Srv := TProcessGrid(TmpGridList[0]);
      CurFrame := TfrTabSrv.Create(Self);
      RemoveControl(CurFrame);
      Page.InsertControl(CurFrame);
      cf := CurFrame as TfrTabSrv;
      cf.AddProcessGrid(Srv);
      CallScript(cf);
      if SetActiveControl then
        //ActiveControl := cf.dgCommon;
        cf.dgCommon.SetFocus;
    end
    else begin
      TmpGridList.Sort(@CompareGrids);  // сортируем по номеру таблицы на странице
      Srv := TProcessGrid(TmpGridList[0]);
      if TmpGridList.Count = 2 then
      begin
        Srv2 := TProcessGrid(TmpGridList[1]);
        CurFrame := TfrTabSrv2H.Create(Self);   // создать фрейм на два сервиса
        RemoveControl(CurFrame);
        Page.InsertControl(CurFrame);
        cf2 := CurFrame as TfrTabSrv2H;
        cf2.AddProcessGrid(Srv);
        cf2.AddProcessGrid(Srv2);
        CallScript(cf2);
        if SetActiveControl then
          //ActiveControl := cf2.dg1;
          cf2.dg1.SetFocus;
      end
      else if TmpGridList.Count = 3 then
      begin
        Srv2 := TProcessGrid(TmpGridList[1]);
        Srv3 := TProcessGrid(TmpGridList[2]);
        CurFrame := TfrTabSrv3L1.Create(Self);   // создать фрейм на три сервиса
        RemoveControl(CurFrame);
        Page.InsertControl(CurFrame);
        cf3l1 := CurFrame as TfrTabSrv3L1;
        cf3l1.AddProcessGrid(Srv);
        cf3l1.AddProcessGrid(Srv2);
        cf3l1.AddProcessGrid(Srv3);
        CallScript(cf3l1);
        if SetActiveControl then
          //ActiveControl := cf3l1.dg1;
          cf3l1.dg1.SetFocus;
      end;
    end;
  end;
  if CurFrame <> nil then
  begin
    CurFrame.Order := Order;
    CurFrame.AppStorage := TSettingsManager.Instance.Storage;
    CurFrame.LoadLayout;
  end;
end;

procedure TOrdersFrame.FrameGetValue(Sender: TObject; Identifer: String;
  var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
var
  Com: TComponent;
begin
  if ScriptFrame <> nil then
  begin
    Com := ScriptFrame.FindComponent(Identifer);
    if Com <> nil then
    begin
      Value := O2V(Com);
      Done := True;
    end;
  end;
end;

procedure TOrdersFrame.DoOnContentPageActivated(Sender: TObject);
begin
  FOnContentPageActivated(Self);
  FOrderItemsFrame.Activate;  // обновляет суммирование времени
end;

procedure TOrdersFrame.DoOnTirazzChanged(Sender: TObject);
begin
  FOrderItemsFrame.Activate;  // обновляет суммирование времени
end;

function TOrdersFrame.GetPageTotal(Page: TPageClass; var ItemCount: integer): extended;
var
  Fr: TfrSrvTemplate;
begin
  if (Page <> nil) and (Page.ControlCount > 0) and (Page.Controls[0] <> nil)
     and (Page.Controls[0] is TfrSrvTemplate) then begin
    Fr := Page.Controls[0] as TfrSrvTemplate;
    Result := Fr.GetFrameTotal(ItemCount);
  end
  else
  begin
    Result := 0;
    ItemCount := 0;
  end;
end;

procedure TOrdersFrame.GridTotalUpdate(ProcessGrid: TProcessGrid);
var
  ItemCount: integer;
  PageTotal: extended;
begin
  if PageCostFrame <> nil then begin
    PageTotal := GetPageTotal(ProcessGrid.Page, ItemCount);
    PageCostFrame.UpdatePageInfo(ProcessGrid.GridCfg.PageID, PageTotal, ItemCount);
  end;
end;

procedure TOrdersFrame.ClearGridColumns;
begin
  dgOrders.Columns.Clear;
end;

function TOrdersFrame.Order: TOrder;
begin
  Result := Entity as TOrder
end;

procedure TOrdersFrame.TirazzGetCellParams(Sender: TObject; EditMode: Boolean;
    Params: TColCellParamsEh);
begin
  Params.Text := FormatFloat('# ##0', Order.Tirazz);
end;

end.
