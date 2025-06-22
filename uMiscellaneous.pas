unit uMiscellaneous;

{$mode ObjFPC}{$H+}

interface

uses
  Windows, Classes, SysUtils;

type
  TInput = record
    Itype: DWORD; // <--- This MUST be present
    case integer of
      0: (mi: TMouseInput;);
      1: (ki: TKeyBdInput;); // <--- This is what your code uses (Input.ki)
      2: (hi: THardwareInput;);
  end;

  TCustomObj = class
  private
    fId: integer;
    fName: string;
  public
    property Id: integer read fId write fId;
    property Name: string read fName write fName;
    constructor Create(_Id: integer; _Name: string);
  end;

var
  AppDir: string;

function GetUserFromWindows: string;
function GetComputerNetName: string;
procedure ExtractWords(const str: string; var Words: TStringList);
function GetPasswordFromDB(strFile: string; Id: integer): string;

implementation

uses uDataModule, uOptions;

constructor TCustomObj.Create(_Id: integer; _Name: string);
begin
  fId := _Id;
  fName := _Name;
end;

function GetUserFromWindows: string;
var
  UserName: string;
  UserNameLen: dWord;
begin
  UserNameLen := 255;
  SetLength(UserName, UserNameLen);
  if GetUserName(PChar(UserName), UserNameLen) then
    Result := Copy(UserName, 1, UserNameLen - 1)
  else
    Result := 'Unknown';
end;

function GetComputerNetName: string;
var
  buffer: array[0..255] of char;
  Size: dWord;
begin
  Size := 256;
  if GetComputerName(Buffer, Size) then
    Result := Buffer
  else
    Result := 'Undetected';
end;

procedure ExtractWords(const str: string; var Words: TStringList);
var
  StartPos, EndPos: integer;
  CurrentWord: string;
begin
  StartPos := 1;
  Words := TStringList.Create;
  try
    while StartPos <= Length(str) do
    begin
      EndPos := Pos('{', str, StartPos);
      if EndPos = 0 then
        Break;
      StartPos := EndPos;
      EndPos := Pos('}', str, StartPos);
      if EndPos = 0 then
        Break;
      CurrentWord := Copy(str, StartPos, EndPos - StartPos + 1);
      if CurrentWord <> '' then
        Words.Add(CurrentWord);
      StartPos := EndPos + 1;
    end;
  except
    on E: Exception do
    begin
      Writeln('Exception: ' + E.Message);
      Words.Free;
    end;
  end;
end;

function GetPasswordFromDB(strFile: string; Id: integer): string;
begin
  fdm.con.DatabaseName := strFile;
  fdm.con.Connected := True;

  fdm.sq.Close;
  if fOptions.chEncryptDatabase.Checked then
    fdm.con.ExecuteDirect('PRAGMA key = ''your_encryption_password''');
  fdm.sq.SQL.Clear;
  fdm.sq.SQL.Add('Select Password From tAccounts Where Id=:Id');
  fdm.sq.ParamByName('Id').AsInteger := Id;
  fdm.sq.Open;
  if fdm.sq.RecordCount = 1 then
    Result := fdm.sq.FieldByName('Password').AsString;
  fdm.sq.Close;
  fdm.con.Connected := False;
end;

end.
