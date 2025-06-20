unit uAbout;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ButtonPanel,
  LCLVersion;

type

  { TfAbout }

  TfAbout = class(TForm)
    ButtonPanel1: TButtonPanel;
    Label1: TLabel;
    laTarget: TLabel;
    laFpc: TLabel;
    laLazarus: TLabel;
    laChecksum: TLabel;
    laComputer: TLabel;
    laUsername: TLabel;
    laVersion: TLabel;
    lbApplication: TLabel;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  fAbout: TfAbout;

implementation

{$R *.lfm}

{ TfAbout }

Uses uMiscellaneous;

procedure TfAbout.FormCreate(Sender: TObject);
var
  FileDate: integer;
  strExeVersion: string;
begin
  laUsername.Caption := 'Username: ' + GetUserFromWindows;
  laComputer.Caption := 'Computer: ' + GetComputerNetName;
  FileDate := FileAge(Application.ExeName);
  if FileDate > -1 then
    strExeVersion := FormatDateTime('yyyymmdd-hhnn', FileDateToDateTime(FileDate))
  else
    strExeVersion := 'undetected';
  laVersion.Caption := 'Version: ' + strExeVersion;
  laLazarus.Caption := 'Lazarus: ' + lcl_version;
  laFPC.Caption := 'FPC: ' + {$I %FPCVersion%};
  laTarget.Caption := 'Target: ' + {$I %FPCTarget%};
end;

end.
