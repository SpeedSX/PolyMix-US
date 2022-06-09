unit PmProviders;

interface

uses Classes, DB, PmEntity, PmOrder, CalcUtils;

type
  IOrderParamsProvider = interface(IUnknown)
  ['{F0E34405-7617-4CF3-BAB1-868D342B23A4}']
    procedure SetOnAddAttachedFile(Value: TNotifyEvent);
    procedure SetOnRemoveAttachedFile(Value: TNotifyEvent);
    procedure SetOnOpenAttachedFile(Value: TNotifyEvent);
    procedure SetOnGetCostVisible(Value: TBooleanEvent);
    procedure SetOnAddNote(Value: TNotifyEvent);
    procedure SetOnEditNote(Value: TIntNotifyEvent);
    procedure SetOnDeleteNote(Value: TIntNotifyEvent);
    procedure SetOnSelectTemplate(Value: TNotifyEvent);
    function GetOnAddAttachedFile: TNotifyEvent;
    function GetOnRemoveAttachedFile: TNotifyEvent;
    function GetOnOpenAttachedFile: TNotifyEvent;
    function GetOnGetCostVisible: TBooleanEvent;
    function GetOnAddNote: TNotifyEvent;
    function GetOnEditNote: TIntNotifyEvent;
    function GetOnDeleteNote: TIntNotifyEvent;
    function GetOnSelectTemplate: TNotifyEvent;

    function ExecOrderProps(Order: TOrder; InsideOrder, ReadOnly: boolean): integer;
    property OnGetCostVisible: TBooleanEvent read GetOnGetCostVisible write SetOnGetCostVisible;
    property OnAddAttachedFile: TNotifyEvent read GetOnAddAttachedFile write SetOnAddAttachedFile;
    property OnRemoveAttachedFile: TNotifyEvent read GetOnRemoveAttachedFile write SetOnRemoveAttachedFile;
    property OnOpenAttachedFile: TNotifyEvent read GetOnOpenAttachedFile write SetOnOpenAttachedFile;
    property OnAddNote: TNotifyEvent read GetOnAddNote write SetOnAddNote;
    property OnEditNote: TIntNotifyEvent read GetOnEditNote write SetOnEditNote;
    property OnDeleteNote: TIntNotifyEvent read GetOnDeleteNote write SetOnDeleteNote;
    property OnSelectTemplate: TNotifyEvent read GetOnSelectTemplate write SetOnSelectTemplate;
  end;

  IMakeOrderParamsProvider = interface(IUnknown)
    ['{95498232-4007-4CD1-B38B-96B04950579E}']
    //function IncludeAdv: boolean;
    function OrderState: integer;
    function PayState: variant;
    function RowColor: integer;
    function FinishDate: variant;
    function CopyToWork: boolean;
    procedure CreateForm;
    function Execute: integer;
  end;

  IMakeDraftParamsProvider = interface(IUnknown)
    ['{85812EC7-F827-44F9-B4BF-A240C831F8CA}']
    function RowColor: integer;
    function CopyToDraft: boolean;
    procedure CreateForm;
    function Execute: integer;
  end;

  ICopyParamsProvider = interface(IUnknown)
    ['{85812EC7-F827-44F9-B4BF-A240C831F8CB}']
    function FinishDate: variant;
    procedure CreateForm(Order: TOrder);
    function Execute: integer;
  end;

const
  NullTime = '  :  ';

implementation

end.
