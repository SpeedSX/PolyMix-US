unit JvInterpreterInit;

interface

type
  TInterpreterInitializer = class
    class procedure Init;
  end;

implementation

uses JvInterpreter, JvInterpreter_Graphics, JvInterpreter_SysUtils, JvInterpreter_Classes,
  JvInterpreter_Windows, JvInterpreter_System,
  JvInterpreter_StdCtrls, JvInterpreter_Controls, JvInterpreter_ComCtrls,
  JvInterpreter_ExtCtrls,
  JvInterpreter_Forms, JvInterpreter_Db, JvInterpreter_JvUtils,
  JvInterpreter_AddCtrls, JvInterpreter_Midas, JvInterpreter_Dialogs,
  JvInterpreter_DBCtrls, JvInterpreter_DbGrids, JvInterpreter_Types,
  JvInterpreter_Contnrs, JvInterpreter_Menus, RAI2_JvAppStorage,
  RAI2_JvCheckListBox, RAI2_JvDateEdit, RAI2_Mouse, JvInterpreter_CustomQuery,
  RAI2_JvDBdateEdit, RAI2_JvxCheckListBox, RAI2_MyDBGridEh, RAI2_AnyColor,
  JvInterpreter_UserRights, JvInterpreter_Settings, RAI2_CalcSrv, RAI2_SrvPage,
  JvInterpreter_Reports, JvInterpreter_Schedule;


class procedure TInterpreterInitializer.Init;
begin
  // Для скриптов регистрируются функции модуля System, специальные функции, классы
  // и устанавливаются глобальные переменные.
  RAI2_CalcSrv.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_UserRights.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Settings.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);

  JvInterpreter_Graphics.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_System.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_SysUtils.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Classes.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Types.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Windows.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_StdCtrls.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Controls.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_ComCtrls.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_ExtCtrls.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Forms.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Menus.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Dialogs.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Db.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_DBCtrls.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  //JvInterpreter_DBGrids.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Contnrs.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);

  JvInterpreter_JvUtils.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);

  JvInterpreter_AddCtrls.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Midas.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);

  JvInterpreter_Reports.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  RAI2_SrvPage.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);

  RAI2_JvAppStorage.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  RAI2_JvCheckListBox.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  RAI2_JvxCheckListBox.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  RAI2_JvDateEdit.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  RAI2_JvDBDateEdit.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  RAI2_Mouse.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  RAI2_MyDBGridEh.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  RAI2_AnyColor.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_CustomQuery.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Schedule.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
end;

initialization

end.
