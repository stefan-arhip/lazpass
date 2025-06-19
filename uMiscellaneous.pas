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

Var AppDir : String;

implementation

constructor TCustomObj.Create(_Id: integer; _Name: string);
begin
  fId := _Id;
  fName := _Name;
end;

end.
