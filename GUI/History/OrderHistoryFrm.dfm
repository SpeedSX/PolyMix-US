inherited OrderHistoryForm: TOrderHistoryForm
  Left = 382
  Top = 261
  OnClose = FormClose
  ExplicitWidth = 644
  ExplicitHeight = 443
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    inherited dgHistory: TMyDBGridEh
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghColumnResize, dghColumnMove]
    end
  end
  inherited FormStorage: TJvFormStorage
    AppStoragePath = 'OrderHistoryForm\'
  end
end
