unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ComCtrls, Menus, ShellCtrls, PairSplitter, SqlDb, SQLite3Conn, OdbcConn,
  Clipbrd, LCLIntf, IniPropStorage;

const
  icoSilver = 0;
  icoRed = 1;
  icoGreen = 2;

type

  { TfMain }

  TfMain = class(TForm)
    ilBig: TImageList;
    ilSmall: TImageList;
    IniPropStorage1: TIniPropStorage;
    lvAccounts: TListView;
    miEntryLinkOpen: TMenuItem;
    miOpenLink: TMenuItem;
    miAutoTypeLink: TMenuItem;
    miEntryAutotypeLink: TMenuItem;
    miCopyLink: TMenuItem;
    miItemNew: TMenuItem;
    miItemEdit: TMenuItem;
    miItemDelete: TMenuItem;
    miCopyUsername: TMenuItem;
    miCopyPassword: TMenuItem;
    miAutoType: TMenuItem;
    miAutoTypeAll: TMenuItem;
    miAutoTypeUsername: TMenuItem;
    miAutoTypePassword: TMenuItem;
    miHelpAbout: TMenuItem;
    miHelp: TMenuItem;
    miToolsOptions: TMenuItem;
    miTools: TMenuItem;
    miEntryAutotypeAll: TMenuItem;
    miEntryAutotypeUsername: TMenuItem;
    miEntryAutotypePassword: TMenuItem;
    miEntryAutotype: TMenuItem;
    miEntryLinkCopy: TMenuItem;
    miEntryPasswordCopy: TMenuItem;
    miEntryEdit: TMenuItem;
    miEntryDelete: TMenuItem;
    miEntryUsernameCopy: TMenuItem;
    miEdit: TMenuItem;
    miEntryNew: TMenuItem;
    miFileQuit: TMenuItem;
    miFileClose: TMenuItem;
    miFileSaveAs: TMenuItem;
    miFileSave: TMenuItem;
    miFileOpen: TMenuItem;
    miFileNew: TMenuItem;
    miFile: TMenuItem;
    mMain: TMainMenu;
    oFile: TOpenDialog;
    pmFileRecent: TPopupMenu;
    psMain: TPairSplitter;
    pssLeft: TPairSplitterSide;
    pssRight: TPairSplitterSide;
    pmAccounts: TPopupMenu;
    Separator6: TMenuItem;
    Separator7: TMenuItem;
    sFile: TSaveDialog;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Separator3: TMenuItem;
    Separator4: TMenuItem;
    Separator5: TMenuItem;
    con: TSQLite3Connection;
    sq: TSQLQuery;
    tbFileNew: TToolButton;
    tr: TSQLTransaction;
    sbMain: TStatusBar;
    tbCards: TToolBar;
    tbEditAutoType: TToolButton;
    tbFileOpen: TToolButton;
    tbFileSave: TToolButton;
    tcMain: TTabControl;
    ToolButton1: TToolButton;
    tvAccounts: TTreeView;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvAccountsAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: boolean);
    procedure lvAccountsSelectItem(Sender: TObject; Item: TListItem;
      Selected: boolean);
    procedure miEntryDeleteClick(Sender: TObject);
    procedure miEntryEditClick(Sender: TObject);
    procedure miEntryLinkOpenClick(Sender: TObject);
    procedure miEntryNewClick(Sender: TObject);
    procedure miEntryPasswordCopyClick(Sender: TObject);
    procedure miEntryLinkCopyClick(Sender: TObject);
    procedure miEntryUsernameCopyClick(Sender: TObject);
    procedure miFileCloseClick(Sender: TObject);
    procedure miFileNewClick(Sender: TObject);
    procedure miFileOpenClick(Sender: TObject);
    procedure miHelpAboutClick(Sender: TObject);
    procedure tbEditAutoTypeClick(Sender: TObject);
    procedure tcMainChange(Sender: TObject);
  private

  public

  end;

var
  fMain: TfMain;

implementation

{$R *.lfm}

{ TfMain }

uses uMiscellaneous, uEntry, uAbout;

var
  sLFiles: TStringList;

procedure PressKey(VirtualKey: word; IsKeyDown: boolean);
var
  Input: TInput;
begin
  FillChar(Input, SizeOf(Input), 0);
  Input.Itype := INPUT_KEYBOARD;
  Input.ki.wVk := VirtualKey;
  if not IsKeyDown then
    Input.ki.dwFlags := KEYEVENTF_KEYUP;
  SendInput(1, @Input, SizeOf(Input));
end;

//procedure SendChar(AChar: char);
//var
//  Input: TInput;
//  VirtualKey: word;
//begin
//  VirtualKey := VkKeyScan(AChar);

//  // Press key
//  FillChar(Input, SizeOf(Input), 0);
//  Input.Itype := INPUT_KEYBOARD;
//  Input.ki.wVk := VirtualKey;
//  SendInput(1, @Input, SizeOf(Input));

//  // Release key
//  FillChar(Input, SizeOf(Input), 0);
//  Input.Itype := INPUT_KEYBOARD;
//  Input.ki.wVk := VirtualKey;
//  Input.ki.dwFlags := KEYEVENTF_KEYUP;
//  SendInput(1, @Input, SizeOf(Input));
//end;

procedure SendChar(AChar: char);
var
  Input: TInput;
  VirtualKey: word;
  ShiftState: byte;
  IsShiftRequired: boolean;
begin
  // VkKeyScan returns the virtual key code in the low-order byte
  // and the shift state in the high-order byte.
  VirtualKey := VkKeyScan(AChar);

  // Extract the shift state.
  // The high-order byte indicates the shift state needed for the character:
  // 1 = SHIFT, 2 = CTRL, 4 = ALT
  ShiftState := Hi(VirtualKey);
  IsShiftRequired := (ShiftState and 1) <> 0; // Check if SHIFT (bit 0) is required

  // If Shift is required, press the Shift key first
  if IsShiftRequired then
  begin
    FillChar(Input, SizeOf(Input), 0);
    Input.Itype := INPUT_KEYBOARD;
    Input.ki.wVk := VK_SHIFT; // Virtual key code for Left Shift
    SendInput(1, @Input, SizeOf(Input));
  end;

  // Press the actual character key
  FillChar(Input, SizeOf(Input), 0);
  Input.Itype := INPUT_KEYBOARD;
  Input.ki.wVk := Lo(VirtualKey);
  // Use only the low-order byte for the character's virtual key
  SendInput(1, @Input, SizeOf(Input));

  // Release the actual character key
  FillChar(Input, SizeOf(Input), 0);
  Input.Itype := INPUT_KEYBOARD;
  Input.ki.wVk := Lo(VirtualKey);
  Input.ki.dwFlags := KEYEVENTF_KEYUP;
  SendInput(1, @Input, SizeOf(Input));

  // If Shift was pressed, release the Shift key last
  if IsShiftRequired then
  begin
    FillChar(Input, SizeOf(Input), 0);
    Input.Itype := INPUT_KEYBOARD;
    Input.ki.wVk := VK_SHIFT;
    Input.ki.dwFlags := KEYEVENTF_KEYUP;
    SendInput(1, @Input, SizeOf(Input));
  end;
end;

procedure SendString(str: string);
var
  i: integer;
begin
  for i := 1 to Length(str) do
  begin
    SendChar(str[i]);
    Sleep(50); // Small delay between keys can help for some applications
  end;
end;

procedure TfMain.miFileOpenClick(Sender: TObject);
var
  strFile, strName, strExt: string;
  Item: TMenuItem;
  i, j: integer;
begin
  if oFile.Execute then
  begin
    strFile := oFile.FileName;
    j := -1;
    for i := 1 to sLFiles.Count do
      if LowerCase(strFile) = sLFiles[i - 1] then
        j := i - 1;
    if j = -1 then
    begin
      strExt := ExtractFileExt(strFile);
      strName := ExtractFileName(strFile);
      strName := Copy(strName, 1, Length(strName) - Length(strExt));

      sLFiles.Add(LowerCase(strFile));
      tcMain.Tabs.AddObject(strName, TCustomObj.Create(0, strFile));
      Item := TMenuItem.Create(nil);
      Item.Caption := strFile;
      Item.Hint := strFile;
      //Item.OnClick:= ;
      pmFileRecent.Items.Add(Item);
      tcMain.TabIndex := tcMain.Tabs.Count - 1;
    end
    else
      tcMain.TabIndex := j;
    tcMainChange(Sender);
  end;
end;

procedure TfMain.miHelpAboutClick(Sender: TObject);
begin
  fAbout.ShowModal;
end;

procedure TfMain.lvAccountsAdvancedCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: boolean);
begin
  Item.Caption := IntToStr(Item.Index + 1);
  {if (Item.SubItems.Count > 1) and ((Item.SubItems[1] = 'Saturday') or
    (Item.SubItems[1] = 'Sunday')) then
    Sender.Canvas.Font.Color := clRed
  else
    Sender.Canvas.Font.Color := clDefault;}
end;

procedure TfMain.lvAccountsSelectItem(Sender: TObject; Item: TListItem;
  Selected: boolean);
begin
  tbEditAutoType.Enabled := lvAccounts.Selected <> nil;
end;

procedure TfMain.miEntryDeleteClick(Sender: TObject);
var
  Id, i: integer;
  strFile: string;
begin
  i := lvAccounts.ItemIndex;
  if (tcMain.TabIndex >= 0) and (i >= 0) then
    if MessageDlg('Delete Entry', 'Delete Entry from database?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      Id := lvAccounts.Items[i].ImageIndex;
      strFile := sLFiles[tcMain.TabIndex];
      con.DatabaseName := strFile;
      con.Connected := True;
      sq.Close;
      sq.SQL.Clear;
      sq.SQL.Add('Delete From tAccounts Where Id=:Id;');
      sq.ParamByName('Id').AsInteger := Id;
      sq.ExecSQL;
      tr.Commit;
      sq.Close;
      con.Connected := False;
      lvAccounts.Items[i].Delete;
    end;
end;

procedure TfMain.miEntryEditClick(Sender: TObject);
var
  Id, i: integer;
  strFile: string;
begin
  i := lvAccounts.ItemIndex;
  if (tcMain.TabIndex >= 0) and (i >= 0) then
  begin
    Id := lvAccounts.Items[i].ImageIndex;
    strFile := sLFiles[tcMain.TabIndex];
    con.DatabaseName := strFile;
    con.Connected := True;
    sq.Close;
    sq.SQL.Clear;
    sq.SQL.Add('Select * From tAccounts Where Id=:Id;');
    sq.ParamByName('Id').AsInteger := Id;
    sq.Open;
    fEntry.Caption := 'Edit Entry';
    fEntry.edUsername.Text := sq.FieldByName('Username').AsString;
    fEntry.edPassword.Text := sq.FieldByName('Password').AsString;
    fEntry.coLink.Text := sq.FieldByName('Link').AsString;
    fEntry.coTitle.Text := sq.FieldByName('Title').AsString;
    fEntry.coCategory.Text := sq.FieldByName('Category').AsString;
    fEntry.meNotes.Text := sq.FieldByName('Notes').AsString;
    fEntry.edCreated.Text := sq.FieldByName('Created').AsString;
    fEntry.edModified.Text := sq.FieldByName('Modified').AsString;
    fEntry.edAccessed.Text := sq.FieldByName('Accessed').AsString;
    sq.Close;
    sq.SQL.Clear;
    sq.SQL.Add('Select Distinct Link As A,0 As B From tAccounts');
    sq.SQL.Add('Where Link Is Not Null Group By Link Union All');
    sq.SQL.Add('Select Distinct Title,1 As Type From tAccounts');
    sq.SQL.Add('Where Title Is Not Null Group By Title Union All');
    sq.SQL.Add('Select Distinct Category,2 As Type From tAccounts');
    sq.SQL.Add('Where Category Is Not Null Group By Category Order By B,A;');
    sq.Open;
    fEntry.coLink.Items.Clear;
    fEntry.coTitle.Items.Clear;
    fEntry.coCategory.Items.Clear;
    while not sq.EOF do
    begin
      case sq.FieldByName('B').AsInteger of
        0:
          fEntry.coLink.Items.Add(sq.FieldByName('A').AsString);
        1:
          fEntry.coTitle.Items.Add(sq.FieldByName('A').AsString);
        2:
          fEntry.coCategory.Items.Add(sq.FieldByName('A').AsString);
      end;
      sq.Next;
    end;
    sq.Close;
    if fEntry.Execute then
    begin
      sq.SQL.Clear;
      sq.SQL.Add('Update tAccounts ');
      sq.SQL.Add('Set Username=:Username,Password=:Password,Link=:Link,');
      sq.SQL.Add('Title=:Title,Category=:Category,Notes=:Notes,Modified=:Modified');
      sq.SQL.Add('Where Id=:Id;');
      sq.ParamByName('Username').AsString := fEntry.edUsername.Text;
      sq.ParamByName('Password').AsString := fEntry.edPassword.Text;
      sq.ParamByName('Link').AsString := fEntry.coLink.Text;
      sq.ParamByName('Title').AsString := fEntry.coTitle.Text;
      sq.ParamByName('Category').AsString := fEntry.coCategory.Text;
      sq.ParamByName('Notes').AsString := fEntry.meNotes.Text;
      sq.ParamByName('Modified').AsString :=
        FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now());
      sq.ParamByName('Id').AsInteger := Id;
      sq.ExecSQL;
      tr.Commit;
      sq.Close;

      sq.SQL.Clear;
      sq.SQL.Add('Select * From tAccounts Where Id=:Id;');
      sq.ParamByName('Id').AsInteger := Id;
      sq.Open;
      lvAccounts.Items[i].SubItems[0] := sq.FieldByName('Username').AsString;
      lvAccounts.Items[i].SubItems[1] := sq.FieldByName('Password').AsString;
      lvAccounts.Items[i].SubItems[2] := sq.FieldByName('Link').AsString;
      sq.Close;
    end;

    sq.Close;
    con.Connected := False;
  end;
end;

procedure TfMain.miEntryLinkOpenClick(Sender: TObject);
var
  i: integer;
begin
  i := lvAccounts.ItemIndex;
  if i > -1 then
    LCLIntf.OpenDocument(lvAccounts.Items[i].SubItems[2]);
end;

procedure TfMain.miEntryNewClick(Sender: TObject);
var
  strFile, strCreated: string;
begin
  if tcMain.TabIndex >= 0 then
  begin
    strFile := sLFiles[tcMain.TabIndex];
    con.DatabaseName := strFile;
    con.Connected := True;
    fEntry.Caption := 'New Entry';
    fEntry.edUsername.Text := '';
    fEntry.edPassword.Text := '';
    fEntry.coLink.Text := '';
    fEntry.coTitle.Text := '';
    fEntry.coCategory.Text := '';
    fEntry.meNotes.Text := '';
    fEntry.edCreated.Text := '';
    fEntry.edModified.Text := '';
    fEntry.edAccessed.Text := '';
    sq.Close;
    sq.SQL.Clear;
    sq.SQL.Add('Select Distinct Link As A,0 As B From tAccounts');
    sq.SQL.Add('Where Link Is Not Null Group By Link Union All');
    sq.SQL.Add('Select Distinct Title,1 As Type From tAccounts');
    sq.SQL.Add('Where Title Is Not Null Group By Title Union All');
    sq.SQL.Add('Select Distinct Category,2 As Type From tAccounts');
    sq.SQL.Add('Where Category Is Not Null Group By Category Order By B,A;');
    sq.Open;
    fEntry.coLink.Items.Clear;
    fEntry.coTitle.Items.Clear;
    fEntry.coCategory.Items.Clear;
    while not sq.EOF do
    begin
      case sq.FieldByName('B').AsInteger of
        0:
          fEntry.coLink.Items.Add(sq.FieldByName('A').AsString);
        1:
          fEntry.coTitle.Items.Add(sq.FieldByName('A').AsString);
        2:
          fEntry.coCategory.Items.Add(sq.FieldByName('A').AsString);
      end;
      sq.Next;
    end;
    sq.Close;
    if fEntry.Execute then
    begin
      strCreated := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now());

      sq.SQL.Clear;
      sq.SQL.Add('Insert Into tAccounts');
      sq.SQL.Add('(Username,Password,Link,Title,Category,Notes,Created)');
      sq.SQL.Add('Values');
      sq.SQL.Add('(:Username,:Password,:Link,:Title,:Category,:Notes,:Created);');
      sq.ParamByName('Username').AsString := fEntry.edUsername.Text;
      sq.ParamByName('Password').AsString := fEntry.edPassword.Text;
      sq.ParamByName('Link').AsString := fEntry.coLink.Text;
      sq.ParamByName('Title').AsString := fEntry.coTitle.Text;
      sq.ParamByName('Category').AsString := fEntry.coCategory.Text;
      sq.ParamByName('Notes').AsString := fEntry.meNotes.Text;
      sq.ParamByName('Created').AsString := strCreated;
      sq.ExecSQL;
      tr.Commit;
      sq.Close;

      con.Connected := False;
      tcMainChange(Sender);
    end;
  end;
end;

procedure TfMain.miEntryPasswordCopyClick(Sender: TObject);
var
  i: integer;
begin
  i := lvAccounts.ItemIndex;
  if (tcMain.TabIndex >= 0) and (i >= 0) then
    ClipBoard.AsText := lvAccounts.Items[i].SubItems[1];
end;

procedure TfMain.miEntryLinkCopyClick(Sender: TObject);
var
  Id, i: integer;
begin
  i := lvAccounts.ItemIndex;
  if (tcMain.TabIndex >= 0) and (i >= 0) then
    ClipBoard.AsText := lvAccounts.Items[i].SubItems[2];
end;

procedure TfMain.miEntryUsernameCopyClick(Sender: TObject);
var
  i: integer;
begin
  i := lvAccounts.ItemIndex;
  if (tcMain.TabIndex >= 0) and (i >= 0) then
    ClipBoard.AsText := lvAccounts.Items[i].SubItems[0];
end;

procedure TfMain.miFileCloseClick(Sender: TObject);
var
  i: integer;
begin
  //tcMain.Tabs.AddObject(strName, TCustomObj.Create(0, strFile));
  //  sLFiles.Add(strFile);
  if tcMain.TabIndex > -1 then
    if MessageDlg('Close', 'Close file ' + tcMain.Tabs[tcMain.TabIndex] +
      '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      i := tcMain.TabIndex;
      tcMain.Tabs.Delete(i);
      sLFiles.Delete(i);
      tcMainChange(Sender);
    end;
end;

procedure TfMain.miFileNewClick(Sender: TObject);
var
  strFile, strName, strExt: string;
begin
  strFile := 'New';
  sFile.FileName := strFile + sFile.DefaultExt;
  if sFile.Execute then
  begin
    strFile := sFile.FileName;
    con.DatabaseName := strFile;
    if FileExists(strFile) then DeleteFile(strFile);
    con.Connected := True;
    sq.Close;
    sq.SQL.Clear;
    sq.SQL.Add('CREATE TABLE tAccounts ( ' +
      'Id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,' + 'Title TEXT,' +
      'Username TEXT,' + 'Password TEXT,' + 'Link TEXT,' + 'Notes TEXT,' +
      'Created TEXT(23),' + 'Modified TEXT(23),' + 'Accessed TEXT(23),' +
      'Icon BLOB,' + 'AutoType TEXT DEFAULT (''{username}{tab}{password}{enter}''),' +
      'Category TEXT);');
    sq.ExecSQL;
    tr.Commit;
    sq.Close;
    con.Connected := False;

    strExt := ExtractFileExt(strFile);
    strName := ExtractFileName(strFile);
    strName := Copy(strName, 1, Length(strName) - Length(strExt));

    sLFiles.Add(LowerCase(strFile));
    tcMain.Tabs.AddObject(strName, TCustomObj.Create(0, strFile));
    //Item := TMenuItem.Create(nil);
    //Item.Caption := strFile;
    //Item.Hint := strFile;
    //Item.OnClick:= ;
    //pmFileRecent.Items.Add(Item);
    tcMain.TabIndex := tcMain.Tabs.Count - 1;
    tcMainChange(Sender);
  end;
end;

procedure TfMain.FormCreate(Sender: TObject);
var
  AppDir: string;
begin
  AppDir := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)));

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
  sq.PacketRecords := -1;
end;

procedure TfMain.FormActivate(Sender: TObject);
var
  strFile, strName, strExt: string;
begin
  strFile := sbMain.Hint;
  if FileExists(strFile) then
  begin
    strExt := ExtractFileExt(strFile);
    strName := ExtractFileName(strFile);
    strName := Copy(strName, 1, Length(strName) - Length(strExt));

    sLFiles.Add(LowerCase(strFile));
    tcMain.Tabs.AddObject(strName, TCustomObj.Create(0, strFile));
    tcMainChange(Sender);
  end;
end;

procedure TfMain.tbEditAutoTypeClick(Sender: TObject);
var
  Id, i: integer;
  strFile, strAccessed, strUsername, strPassword: string;
begin
  // Example: Send "Hello World!" to the currently active application
  // You might want to use FindWindow and SetForegroundWindow first
  // to ensure the correct window is active.

  // Bring a target window to foreground (e.g., Notepad)
  // var
  //   TargetWnd: HWND;
  // begin
  //   TargetWnd := FindWindow(PChar('Notepad'), nil); // Or FindWindow(nil, PChar('Untitled - Notepad'));
  //   if TargetWnd <> 0 then
  //     SetForegroundWindow(TargetWnd);
  //   Sleep(100); // Give it a moment to become active

  i := lvAccounts.ItemIndex;
  if i >= 0 then
  begin
    strUsername := lvAccounts.Items[i].SubItems[0];
    strPassword := lvAccounts.Items[i].SubItems[1];
    Application.Minimize;

    SendString(strUsername);
    PressKey(VK_TAB, True); // Press Tab
    PressKey(VK_TAB, False); // Release Tab
    SendString(strPassword);
    PressKey(VK_RETURN, True); // Press Enter
    PressKey(VK_RETURN, False); // Release Enter

    strFile := sLFiles[tcMain.TabIndex];
    con.DatabaseName := strFile;
    con.Connected := True;

    Id := lvAccounts.Items[i].ImageIndex;
    strAccessed := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now());

    sq.SQL.Clear;
    sq.SQL.Add('Update tAccounts Set Accessed=:Accessed');
    sq.SQL.Add('Where Id=:Id;');
    sq.ParamByName('Accessed').AsString := strAccessed;
    sq.ParamByName('Id').AsInteger := Id;
    sq.ExecSQL;
    tr.Commit;
    sq.Close;

    con.Connected := False;

    lvAccounts.Items[i].StateIndex := icoGreen;
  end;
end;

procedure TfMain.tcMainChange(Sender: TObject);
var
  strFile: string;
begin
  lvAccounts.Items.BeginUpdate;
  lvAccounts.Items.Clear;

  if tcMain.TabIndex >= 0 then
  begin
    //fMain.Caption := Format('TabIndex = %d', [tcMain.TabIndex]);
    //strFile := TCustomObj(tcMain.Tabs.Objects[tcMain.TabIndex]).Name;
    //strFile := 'C:\Users\Stefan\OneDrive\Desktop\LazPass\lazpass.sqlite';
    strFile := sLFiles[tcMain.TabIndex];
    con.DatabaseName := strFile;
    con.Connected := True;
    sq.Close;
    sq.SQL.Clear;
    sq.SQL.Add('Select * From tAccounts Order By Username;');
    sq.Open;
    sbMain.Panels[0].Text := Format('%d entries', [sq.RecordCount]);
    sbMain.Panels[1].Text := strFile;
    sbMain.Hint := strFile;
    while not sq.EOF do
    begin
      with lvAccounts.Items.Add do
      begin
        StateIndex := icoSilver;
        ImageIndex := sq.FieldByName('Id').AsInteger;
        Caption := Format('%d', [lvAccounts.Items.Count]);
        SubItems.Add(sq.FieldByName('Username').AsString);
        SubItems.Add(sq.FieldByName('Password').AsString);
        SubItems.Add(sq.FieldByName('Link').AsString);
      end;
      sq.Next;
    end;
    sq.Close;
    con.Connected := False;
  end;

  lvAccounts.Items.EndUpdate;
end;

initialization
  sLFiles := TStringList.Create;

finalization
  sLFiles.Free;

end.
