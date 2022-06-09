unit PmDictionaryEditorFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Buttons, ExtCtrls, Menus, JvExControls, JvGradientHeaderPanel,

  DicObj, PmConfigTree, PmDictionaryList, PmBaseConfigEditorFrame,
  fmTabDic, fmDimDic, fmEmptyTabDic, PmConfigObjects;

type
  TDictionaryEditorFrame = class(TBaseConfigEditorFrame)
    paDicBut: TPanel;
    sbNewDic: TSpeedButton;
    sbEditDic: TSpeedButton;
    sbDelDic: TSpeedButton;
    paDicFrame: TPanel;
    pmDic: TPopupMenu;
    miProperties: TMenuItem;
    miDelete: TMenuItem;
    procedure miPropertiesClick(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
  private
    frTabDic: TfrTabDic;
    frDimDic: TfrDimDic;
    frEmptyTabDic: TfrEmptyTabDic;
    FOnEditDictionaryProperties: TNotifyEvent;
    //FOnNewDictionary: TNotifyEvent;
    FOnDeleteDictionary: TNotifyEvent;
    procedure ReadDicElement;
    procedure SetupElemGrid(de: TDictionary);
  public
    constructor Create(Owner: TComponent);
    procedure SetNode(ANode: TMVCNode); override;
    function GetPopupMenu: TPopupMenu; override;
    property OnEditDictionaryProperties: TNotifyEvent read FOnEditDictionaryProperties write FOnEditDictionaryProperties;
    //property OnNewDictionary: TNotifyEvent read FOnNewDictionary write FOnNewDictionary;
    property OnDeleteDictionary: TNotifyEvent read FOnDeleteDictionary write FOnDeleteDictionary;
  end;

implementation

{$R *.dfm}

uses PmConfigManager;

constructor TDictionaryEditorFrame.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  frTabDic := TfrTabDic.Create(Self);
  RemoveControl(frTabDic);
  paDicFrame.InsertControl(frTabDic);
  frTabDic.Visible := true;
  frTabDic.Align := alClient;

  frDimDic := TfrDimDic.Create(Self);
  RemoveControl(frDimDic);
  paDicFrame.InsertControl(frDimDic);
  frDimDic.Visible := false;

  frEmptyTabDic := TfrEmptyTabDic.Create(Self);
  RemoveControl(frEmptyTabDic);
  paDicFrame.InsertControl(frEmptyTabDic);
  frEmptyTabDic.Visible := false;
end;

procedure TDictionaryEditorFrame.miDeleteClick(Sender: TObject);
begin
  FOnDeleteDictionary(Self);
end;

procedure TDictionaryEditorFrame.miPropertiesClick(Sender: TObject);
begin
  FOnEditDictionaryProperties(Self);
end;

procedure TDictionaryEditorFrame.ReadDicElement;
var
  de: TDictionary;
begin
  de := TConfigManager.Instance.DictionaryList.FindID((Node as TCfgDictionary).DicID);
  if de <> nil then
  begin
    //CurDic.DataSet := de.DicMemTable;//DicItems;
    //dsCurDic.DataSet.Filtered := false;
    SetupElemGrid(de);
  end;
end;

procedure TDictionaryEditorFrame.SetNode(ANode: TMVCNode);
begin
  inherited SetNode(ANode);
  
  ReadDicElement;
end;

procedure TDictionaryEditorFrame.SetupElemGrid(de: TDictionary);
begin
  sbDelDic.Enabled := not TConfigManager.Instance.DictionaryList.IsEmpty and not de.ReadOnly and not de.BuiltIn;
  // Делаем видимым нужный фрейм и вызываем установку вида таблицы в этом фрейме
  if de.MultiDim then
  begin
    frTabDic.Visible := false;           // многомерный справочник
    frDimDic.Visible := true;
    frDimDic.Dictionary := de;
  end
  else
  begin                    // табличный
    frTabDic.Visible := true;
    frDimDic.Visible := false;
    frTabDic.Dictionary := de;
  end;
end;

function TDictionaryEditorFrame.GetPopupMenu: TPopupMenu;
begin
  Result := pmDic;
end;

end.
