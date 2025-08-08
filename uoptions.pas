unit uOptions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ButtonPanel, StdCtrls,
  IniPropStorage, Spin;

type

  { TfOptions }

  TfOptions = class(TForm)
    ButtonPanel1: TButtonPanel;
    chEncryptDatabase: TCheckBox;
    chHidePasswords: TCheckBox;
    chReopenLastFile: TCheckBox;
    chSelectNextAfterAutoType: TCheckBox;
    chRestoreAfterAutoType: TCheckBox;
    seDelayAutotype: TFloatSpinEdit;
    iniMain: TIniPropStorage;
    Label1: TLabel;
  private

  public

  end;

var
  fOptions: TfOptions;

implementation

{$R *.lfm}

end.

