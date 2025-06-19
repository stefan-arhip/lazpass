unit uEntry;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ButtonPanel, StdCtrls;

type

  { TfEntry }

  TfEntry = class(TForm)
    ButtonPanel1: TButtonPanel;
    edURL: TEdit;
    edUsername: TEdit;
    edPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private

  public
    function Execute: boolean;
  end;

var
  fEntry: TfEntry;

implementation

{$R *.lfm}

{ TfEntry }

procedure TfEntry.OKButtonClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfEntry.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfEntry.FormActivate(Sender: TObject);
begin
  edUsername.SetFocus;
end;

function TfEntry.Execute: boolean;
begin
  Result := ShowModal = mrOk;
end;

end.

