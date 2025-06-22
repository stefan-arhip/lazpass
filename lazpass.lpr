program lazpass;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, uMain, uMiscellaneous, uEntry, uAbout, uOptions,
uDataModule
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
//  {$PUSH}{$WARN 5044 OFF}
  Application.MainFormOnTaskbar:=True;
//  {$POP}
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfEntry, fEntry);
  Application.CreateForm(TfAbout, fAbout);
  Application.CreateForm(TfOptions, fOptions);
  Application.CreateForm(TfDm, fDm);
  Application.Run;
end.

