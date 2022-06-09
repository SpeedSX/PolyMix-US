unit fmDimDic;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, JvDBControls, StdCtrls, DBCtrls, DB,
  JvExExtCtrls, JvComponent, JvSplit, ExtCtrls,
  DBGridEh, MyDBGridEh, DIcObj, JvExtComponent, GridsEh,
  PmDictionaryList;

type
  TfrDimDic = class(TFrame)
    dgDic: TMyDBGridEh;
    dgDimDic: TMyDBGridEh;
    Panel1: TPanel;
    sbValues: TSpeedButton;
    btAdd: TSpeedButton;
    sbDelValue: TSpeedButton;
    DBCheckBox1: TDBCheckBox;
    JvxSplitter1: TJvxSplitter;
    dsDic: TDataSource;
    dsDimDic: TDataSource;
    procedure sbValuesClick(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure sbDelValueClick(Sender: TObject);
    procedure dgDimDicGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
  private
    FDic: TDictionary;
    procedure SetupElemGrid(de: TDictionary);
    procedure dqMultiDimAfterScroll(DataSet: TDataSet);
    procedure ReadDicDimension;
  public
    procedure SetupDimDicGrid(de: TDictionary);
    property Dictionary: TDictionary read FDic write SetupElemGrid;
  end;

implementation

uses DicUtils, MDimFrm, CalcUtils, PmConfigManager;

{$R *.DFM}

procedure TfrDimDic.SetupElemGrid(de: TDictionary);
begin
  FDic := de;
  dsDic.DataSet := de.DicItems;
  de.DicItems.AfterScroll := dqMultiDimAfterScroll;
  dqMultiDimAfterScroll(de.DicItems);
//  sbDelValue.Enabled := not dqCurDic.IsEmpty and not de.ReadOnly;
//  sbNewValue.Enabled := not de.ReadOnly;
//  dgDic.DataSource := de.DataSource;
end;

procedure TfrDimDic.SetupDimDicGrid(de: TDictionary);
begin
  dsDimDic.DataSet := de.DicItems;
  DicSetupGridColumns(de, dgDimDic);
  OptimizeColumns(dgDimDic);
end;

procedure TfrDimDic.sbValuesClick(Sender: TObject);
begin
{  dgDic.DataSource.DataSet.DisableControls;
  dgDimDic.DataSource.DataSet.DisableControls;
  try}
    TConfigManager.Instance.DictionaryList.ApplyDic(FDic);
    ExecMultiDimForm(FDic);
{  finally
    dgDimDic.DataSource.DataSet.EnableControls;
    dgDic.DataSource.DataSet.EnableControls;
  end;}
end;

procedure TfrDimDic.btAddClick(Sender: TObject);
begin
  if FDic.AllowModifyDim then
    dgDimDic.DataSource.DataSet.Append;
end;

procedure TfrDimDic.sbDelValueClick(Sender: TObject);
begin
    if FDic.AllowModifyDim then
      dgDimDic.DataSource.DataSet.Delete;
end;

procedure TfrDimDic.dgDimDicGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  DicGetCellParams(Column, AFont, Background, State);
end;

procedure TfrDimDic.dqMultiDimAfterScroll(DataSet: TDataSet);
begin
  // “олько в режиме редактора!
  {if Assigned(DicEditForm) and not cdDics.ControlsDisabled then }
  ReadDicDimension;
end;

procedure TfrDimDic.ReadDicDimension;
var de: TDictionary;
begin
    //if not DataSet['MultiDim'] then Exit;
    // „итаем им€ многомерного справочника + внутреннее им€ текущей размерности
    de := TConfigManager.Instance.DictionaryList[FDic.Name + '_' + FDic.DicItems['A1']];
    if de <> nil then
    begin
      dsDimDic.DataSet := de.DicItems;
      SetupDimDicGrid(de);
    end;
end;

end.
