unit uDataModule;

{$mode ObjFPC}{$H+}

interface

uses
  Forms, Classes, SysUtils, SQLite3Conn, SQLDB, Dialogs;

type

  { TfDm }

  TfDm = class(TDataModule)
    con: TSQLite3Connection;
    sq: TSQLQuery;
    tr: TSQLTransaction;
    procedure DataModuleCreate(Sender: TObject);
  private

  public

  end;

var
  fDm: TfDm;

implementation

{$R *.lfm}

{ TfDm }

uses uMiscellaneous;

procedure TfDm.DataModuleCreate(Sender: TObject);
begin
  try
    {$IFDEF WIN32}
    sqlite3conn.SQLiteLibraryName := AppDir + 'x32-sqlite3.dll';
    {$ENDIF}
    {$IFDEF WIN64}
    sqlite3conn.SQLiteLibraryName := AppDir + 'x64-sqlite3.dll';
    //sqlite3Dyn.SQLiteDefaultLibrary := AppDir + 'x64-sqlite3.dll';
    {$ENDIF}
    if not FileExists(sqlite3conn.SQLiteLibraryName) then
      sqlite3conn.SQLiteLibraryName := AppDir + 'sqlite3.dll';
    //sqlite3conn.SQLiteLibraryName:= AppDir + 'sqlcipher.dll';
    //SQLite3Connection1.Connected := True;
  except
    {$IFDEF WINDOWS}
    MessageDlg('Library sqlite3.dll not found!', mtError, [mbOK], 0);
    {$ELSE}
    MessageDlg('Library libsqlite3.so not found!'#13#13 +
      'Type this in Terminal:'#13 + 'sudo apt-get install libsqlite3-dev',
      mtError, [mbOK], 0);
    {$ENDIF}
    Application.Terminate;
  end;
  fdm.sq.PacketRecords := -1;
end;

end.
