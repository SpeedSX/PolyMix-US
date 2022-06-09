unit PmAdvancedEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBaseEditForm, JvComponentBase, JvFormPlacement, StdCtrls, ComCtrls,
  PmJobParams;

type
  TJobAdvancedEditForm = class(TBaseEditForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    cbSplitMode1: TComboBox;
    Label2: TLabel;
    cbSplitMode2: TComboBox;
    Label3: TLabel;
    cbSplitMode3: TComboBox;
    edSplitPart1: TEdit;
    udSplitPart1: TUpDown;
    Label4: TLabel;
    edSplitPart2: TEdit;
    udSplitPart2: TUpDown;
    Label5: TLabel;
    edSplitPart3: TEdit;
    udSplitPart3: TUpDown;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edJobID: TEdit;
    edItemID: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ExecAdvancedEditForm(Job: TJobParams): boolean;

implementation

{$R *.dfm}

uses RDBUtils;

function ExecAdvancedEditForm(Job: TJobParams): boolean;
var
  EForm: TJobAdvancedEditForm;
begin
  EForm := TJobAdvancedEditForm.Create(nil);
  try
    if VarIsNull(Job.SplitMode1) then
      EForm.cbSplitMode1.ItemIndex := 0
    else
      EForm.cbSplitMode1.ItemIndex := Job.SplitMode1 + 1;
    if VarIsNull(Job.SplitMode2) then
      EForm.cbSplitMode2.ItemIndex := 0
    else
      EForm.cbSplitMode2.ItemIndex := Job.SplitMode2 + 1;
    if VarIsNull(Job.SplitMode3) then
      EForm.cbSplitMode3.ItemIndex := 0
    else
      EForm.cbSplitMode3.ItemIndex := Job.SplitMode3 + 1;
    EForm.udSplitPart1.Position := NvlInteger(Job.SplitPart1);
    EForm.udSplitPart2.Position := NvlInteger(Job.SplitPart2);
    EForm.udSplitPart3.Position := NvlInteger(Job.SplitPart3);

    EForm.edJobID.Text := VarToStr(Job.JobID);  // нередактируемые, просто для копирования
    EForm.edItemID.Text := varToStr(Job.ItemID);

    Result := EForm.ShowModal = mrOk;

    if Result then
    begin
      if (EForm.cbSplitMode1.ItemIndex = 0) and not VarIsNull(Job.SplitMode1) then
        Job.SplitMode1 := null
      else if (EForm.cbSplitMode1.ItemIndex <> 0)
              and (NvlInteger(Job.SplitMode1) <> EForm.cbSplitMode1.ItemIndex - 1) then
        Job.SplitMode1 := EForm.cbSplitMode1.ItemIndex - 1;

      if (EForm.cbSplitMode2.ItemIndex = 0) and not VarIsNull(Job.SplitMode2) then
        Job.SplitMode2 := null
      else if (EForm.cbSplitMode2.ItemIndex <> 0)
              and (NvlInteger(Job.SplitMode2) <> EForm.cbSplitMode2.ItemIndex - 1) then
        Job.SplitMode2 := EForm.cbSplitMode2.ItemIndex - 1;

      if (EForm.cbSplitMode3.ItemIndex = 0) and not VarIsNull(Job.SplitMode3) then
        Job.SplitMode3:= null
      else if (EForm.cbSplitMode3.ItemIndex <> 0)
              and (NvlInteger(Job.SplitMode3) <> EForm.cbSplitMode3.ItemIndex - 1) then
        Job.SplitMode3 := EForm.cbSplitMode3.ItemIndex - 1;

      if (EForm.udSplitPart1.Position = 0) and not VarIsNull(Job.SplitPart1) then
        Job.SplitPart1 := null
      else if (EForm.udSplitPart1.Position > 0) and (NvlInteger(Job.SplitPart1) <> EForm.udSplitPart1.Position) then
        Job.SplitPart1 := EForm.udSplitPart1.Position;

      if (EForm.udSplitPart2.Position = 0) and not VarIsNull(Job.SplitPart2) then
        Job.SplitPart2 := null
      else if (EForm.udSplitPart2.Position > 0) and (NvlInteger(Job.SplitPart2) <> EForm.udSplitPart2.Position) then
        Job.SplitPart2 := EForm.udSplitPart2.Position;

      if (EForm.udSplitPart3.Position = 0) and not VarIsNull(Job.SplitPart3) then
        Job.SplitPart3 := null
      else if (EForm.udSplitPart3.Position > 0) and (NvlInteger(Job.SplitPart3) <> EForm.udSplitPart3.Position) then
        Job.SplitPart3 := EForm.udSplitPart3.Position;
    end;
  finally
    EForm.Free;
  end;
end;

procedure TJobAdvancedEditForm.FormCreate(Sender: TObject);
var
  Splits: TStringList;
begin
  Splits := TStringList.Create;
  Splits.Add('<нет>');
  Splits.Add('Тираж');
  Splits.Add('Лист');
  Splits.Add('Сторона');
  cbSplitMode1.Items.Assign(Splits);
  cbSplitMode2.Items.Assign(Splits);
  cbSplitMode3.Items.Assign(Splits);
end;

end.
