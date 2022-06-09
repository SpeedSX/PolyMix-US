unit PmConfigObjects;

interface

uses SysUtils, PmConfigTree, VirtualTrees;

type
  TCfgRoot = class(TMVCNode)
  protected
    FChildClass: TNodeClass;
    function DoCanAddMovingChild(aNode: TMVCNode): boolean; override;
  public
    constructor Create; override;
  end;

  TCfgOrderKindRoot = class(TCfgRoot)
  public
    constructor Create; override;
  end;

  TCfgOrderKind = class(TMVCNode)
  private
    FKindID: integer;
  public
    function GetUniqueID: string; override;
    property KindID: integer read FKindID write FKindID;
  end;

  TCfgProcessRoot = class(TCfgRoot)
  protected
  public
    function GetImageIndex: integer; override;
    constructor Create; override;
  end;

  TCfgProcess = class(TMVCNode)
  private
    FProcessID: integer;
    FIsActive: boolean;
  protected
  public
    function GetImageIndex: integer; override;
    function GetUniqueID: string; override;
    property ProcessID: integer read FProcessID write FProcessID;
    property IsActive: boolean read FIsActive write FIsActive;
  end;

  TCfgProcessGrid = class(TMVCNode)
  private
    FGridID: integer;
  protected
  public
    function GetImageIndex: integer; override;
    function GetUniqueID: string; override;
    property GridID: integer read FGridID write FGridID;
  end;

  TCfgDictionaryRoot = class(TCfgRoot)
  protected
    function DoCanAddMovingChild(aNode: TMVCNode): boolean; override;
  public
    function GetImageIndex: integer; override;
    constructor Create; override;
  end;

  TCfgDictionaryFolder = class(TMVCNode)
  private
    FFolderID: integer;
  protected
    function DoCanAddMovingChild(aNode: TMVCNode): boolean; override;
  public
    constructor Create; override;
    function GetUniqueID: string; override;
    function GetImageIndex: integer; override;
    property FolderID: integer read FFolderID write FFolderID;
  end;

  TCfgDictionary = class(TMVCNode)
  private
    FDicID: integer;
  protected
  public
    constructor Create; override;
    function GetUniqueID: string; override;
    function GetImageIndex: integer; override;
    property DicID: integer read FDicID write FDicID;
  end;

  TCfgOrderInterfaceRoot = class(TCfgRoot)
    constructor Create; override;
  end;

  TCfgOrderPageGroup = class(TMVCNode)

  end;

  TCfgOrderPage = class(TMVCNode)
    constructor Create; override;
  end;

  TCfgAccessRoot = class(TCfgRoot)
  protected
  public
    constructor Create; override;
    function GetImageIndex: integer; override;
  end;

  TCfgUser = class(TMVCNode)
  private
    FUserID: integer;
  public
    function GetUniqueID: string; override;
    function GetImageIndex: integer; override;
    property UserID: integer read FUserID write FUserID;
  end;

  TCfgModuleRoot = class(TCfgRoot)
  protected
    function DoCanAddMovingChild(aNode: TMVCNode): boolean; override;
  public
    constructor Create; override;
  end;

  TCfgModule = class(TMVCNode)

  end;

  TCfgUnit = class(TCfgModule)

  end;

  TCfgReport = class(TCfgModule)

  end;

  TCfgEventRoot = class(TCfgRoot)
    constructor Create; override;
  end;

  TCfgEvent = class(TMVCNode)

  end;

  TCfgFormRoot = class(TCfgRoot)
    constructor Create; override;
  end;

  TCfgForm = class(TMVCNode)

  end;

implementation

constructor TCfgRoot.Create;
begin
  inherited;
  FCanMove := false;
end;

function TCfgRoot.DoCanAddMovingChild(aNode: TMVCNode): boolean;
begin
  Result := not (aNode is TCfgRoot);
  if Result and Assigned(FChildClass) then
  begin
    Result := aNode is FChildClass;
  end;
end;

constructor TCfgOrderKindRoot.Create;
begin
  inherited;
  Caption := 'Виды заказов';
  FChildClass := TCfgOrderKind;
end;

// Возвращает по возможности уникальный идентификатор узла для сохранения состояния дерева
function TCfgOrderKind.GetUniqueID: string;
begin
  Result := ClassName + IntToStr(KindID);
end;

constructor TCfgDictionaryRoot.Create;
begin
  inherited;
  Caption := 'Справочники';
  FCanAddChild := true;
end;

function TCfgDictionaryRoot.GetImageIndex: integer;
begin
  Result := 1;
end;

function TCfgDictionaryRoot.DoCanAddMovingChild(aNode: TMVCNode): boolean;
begin
  Result := inherited DoCanAddMovingChild(aNode)
    and ((aNode is TCfgDictionaryFolder) or (aNode is TCfgDictionary));
end;

constructor TCfgDictionaryFolder.Create;
begin
  inherited;
  FCanMove := true;
  FCanAddChild := true;
end;

function TCfgDictionaryFolder.GetImageIndex: integer;
begin
  if Assigned(VirtualNode) and (vsExpanded in VirtualNode.States) then
    Result := 13
  else
    Result := 12;
end;

function TCfgDictionaryFolder.GetUniqueID: string;
begin
  Result := ClassName + IntToStr(FolderID);
end;

function TCfgDictionaryFolder.DoCanAddMovingChild(aNode: TMVCNode): boolean;
begin
  Result := inherited DoCanAddMovingChild(aNode)
    and ((aNode is TCfgDictionaryFolder) or (aNode is TCfgDictionary));
end;

constructor TCfgDictionary.Create;
begin
  inherited;
  FCanMove := true;
end;

function TCfgDictionary.GetImageIndex: integer;
begin
  Result := 14;
end;

function TCfgDictionary.GetUniqueID: string;
begin
  Result := ClassName + IntToStr(DicID);
end;

constructor TCfgProcessRoot.Create;
begin
  inherited;
  Caption := 'Структура заказа';
  FChildClass := TCfgProcess;
end;

function TCfgProcessRoot.GetImageIndex: integer;
begin
  Result := 10;
end;

function TCfgProcess.GetImageIndex: integer;
begin
  if IsActive then
    Result := 16
  else
    Result := 9;
end;

function TCfgProcess.GetUniqueID: string;
begin
  Result := ClassName + IntToStr(ProcessID);
end;

function TCfgProcessGrid.GetImageIndex: integer;
begin
  Result := 7;
end;

function TCfgProcessGrid.GetUniqueID: string;
begin
  Result := ClassName + IntToStr(GridID);
end;

constructor TCfgOrderInterfaceRoot.Create;
begin
  inherited;
  Caption := 'Редактор заказа';
  FChildClass := TCfgOrderPageGroup;
end;

constructor TCfgOrderPage.Create;
begin
  inherited;
  FCanMove := true;
end;

constructor TCfgModuleRoot.Create;
begin
  inherited;
  Caption := 'Модули';
end;

function TCfgModuleRoot.DoCanAddMovingChild(aNode: TMVCNode): boolean;
begin
  Result := inherited DoCanAddMovingChild(aNode)
    and ((aNode is TCfgUnit) or (aNode is TCfgReport));
end;

constructor TCfgAccessRoot.Create;
begin
  inherited;
  Caption := 'Пользователи';
  FChildClass := TCfgUser;
end;

function TCfgAccessRoot.GetImageIndex: integer;
begin
  Result := 11;
end;

constructor TCfgFormRoot.Create;
begin
  inherited;
  Caption := 'Формы';
  FChildClass := TCfgForm;
end;

constructor TCfgEventRoot.Create;
begin
  inherited;
  Caption := 'События';
  FChildClass := TCfgEvent;
end;

function TCfgUser.GetImageIndex: integer;
begin
  Result := 15;
end;

function TCfgUser.GetUniqueID: string;
begin
  Result := ClassName + IntToStr(UserID);
end;

end.
