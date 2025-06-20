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

implementation

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

end.
