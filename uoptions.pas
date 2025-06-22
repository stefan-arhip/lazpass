unit uOptions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ButtonPanel, StdCtrls,
  IniPropStorage;

type

  { TfOptions }

  TfOptions = class(TForm)
    ButtonPanel1: TButtonPanel;
    chEncryptDatabase: TCheckBox;
    chHidePasswords: TCheckBox;
    chReopenLastFile: TCheckBox;
    chSelectNextAfterAutoType: TCheckBox;
    chRestoreAfterAutoType: TCheckBox;
    iniMain: TIniPropStorage;
  private

  public

  end;

var
  fOptions: TfOptions;

implementation

{$R *.lfm}

end.

