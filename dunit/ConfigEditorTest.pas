unit ConfigEditorTest;

interface

uses Classes, SysUtils,
  DicFrm,
  TestFrameWork,
  PmProcess, DicObj, Variants, PmEntity;

type
  TConfigEditorTests = class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestUserControlsValid;
  end;

implementation

uses MainData, PmProviders, DB, PmAccessManager, Dialogs, Controls, DateUtils,
  ServMod, CalcSettings, RDBUtils, PmEntityController,
  PmAppController, RDialogs, PmDictionaryList;

{$REGION 'Utility Methods'}

procedure TConfigEditorTests.TestUserControlsValid;
begin
  CreateDicEditForm(false);
  CheckTrue(DicFrm.DicEditForm.boxUserAccess.Items.Count > 0, 'boxUserAccess is empty');
  CheckTrue(DicFrm.DicEditForm.boxKindAccess.Items.Count > 0, 'boxKindAccess is empty');
  CheckTrue(DicFrm.DicEditForm.boxProcAccess.Items.Count > 0, 'boxProcAccess is empty');
  DestroyDicEditForm(false);
end;

{$ENDREGION}

procedure TConfigEditorTests.SetUp;
begin
end;

procedure TConfigEditorTests.TearDown;
begin
end;

initialization

  TestFramework.RegisterTest('ConfigEditorTests Suite',
    TConfigEditorTests.Suite);

end.
