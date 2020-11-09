unit Unit1;

interface

uses
  SysUtils, Classes, Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Controls;

type
  TBinPatch = class(TForm)
    Edit1       : TEdit;
    Memo1       : TMemo;
    Panel1      : TPanel;
    Button1     : TButton;
    Button2     : TButton;
    Splitter1   : TSplitter;
    ListView1   : TListView;
    StatusBar1  : TStatusBar;
    OpenDialog1 : TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure ListView1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function CompareInt (const S1, S2: string): Integer;
    function CompareData(const S1, S2: string): Integer;
    procedure PopulateHeader;
    procedure Populate;
    procedure Update;
    procedure Load;
  private
    Descending  : Boolean;
    SortedColumn: Integer;
  end;

var
  BinPatch: TBinPatch;

implementation

{$R *.dfm}

type
  TItem = record            // Patch item
    Addr: Cardinal;         // Patch address
    Len : Integer;          // Length of patch
    Data: array of byte;    // Patch bytes
  end;

  TPatch = record           // BinPatcher data holder
    Count: Integer;         // Number of loaded patches
    List : array of TItem;  // Array of patches
  end;

var
  P: TPatch;                // Patches

procedure TBinPatch.PopulateHeader;
// Populate column headers and add sort direction arrow.
begin
  ListView1.Column[0].Caption := 'Id.';
  ListView1.Column[1].Caption := 'Address';
  ListView1.Column[2].Caption := 'Len.';
  ListView1.Column[3].Caption := 'Data';
  if Descending
    then ListView1.Column[SortedColumn].Caption := #$2191#$20 + ListView1.Column[SortedColumn].Caption
    else ListView1.Column[SortedColumn].Caption := #$2193#$20 + ListView1.Column[SortedColumn].Caption;
end;

procedure TBinPatch.Load;
// Read data from provided file to P
var
  I: Integer;
  m: TMemoryStream;
begin
  m := TMemoryStream.Create;
  m.LoadFromFile(Edit1.Text);
  m.Seek(soFromBeginning, 0);
  m.ReadBuffer(P.Count, 4);
  SetLength(P.List, P.Count);
  for I := 0 to P.Count - 1 do
  begin
    m.ReadBuffer(P.List[I].Addr, 4);
    m.ReadBuffer(P.List[I].Len, 4);
    SetLength(P.List[I].Data, P.List[I].Len);
    m.Read(Pointer(P.List[I].Data)^, P.List[I].Len);
  end;
  m.Free;
end;

procedure TBinPatch.Populate;
// Populate ListView1 from P
var
  I, II: Integer;
  Item : TListItem;
  s    : string;
begin
  ListView1.Items.BeginUpdate;
  ListView1.Items.Clear;
  for i := 0 to P.Count - 1 do
  begin
    Item         := ListView1.Items.Add();
    Item.Caption := IntToStr(I + 1);
    Item.SubItems.Add('$' + IntToHex(P.List[I].Addr, 8));
    Item.SubItems.Add(IntToStr(P.List[I].Len));
    s := '';
    for II := 0 to P.List[I].Len - 1 do s := s + IntToHex(P.List[I].Data[II], 2) + ' ';
    Item.SubItems.Add(s);
  end;
end;

procedure TBinPatch.Update;
// Reload data and populate listview
var
  I, II: Integer;
  Item : TListItem;
  s    : string;
begin
  // Exit if file not exists
  if not FileExists(Edit1.Text) then Exit;

  // Load data and populate listview
  Load;
  Populate;

  // Autoselect first item and update
  if ListView1.Items.Count > 0 then ListView1.ItemIndex:= 0;
  ListView1.Items.EndUpdate;
  ListView1Click(nil);
end;

procedure TBinPatch.Button1Click(Sender: TObject);
begin
  // Exit if open dialog file not selected
  if not OpenDialog1.Execute(Application.Handle) then Exit;

  // If file exist add name to edit, otherwise clear all
  if FileExists(OpenDialog1.FileName) then
    begin
    Edit1.Text      := OpenDialog1.FileName;
    Button2.Enabled := True;
    end
  else
    begin
    Edit1.Text      := '';
    Button2.Enabled := False;
    ListView1.Items.Clear;
    Memo1.Lines.Clear;
    end;

  Update;
end;

procedure TBinPatch.Button2Click(Sender: TObject);
begin
  Update;
end;

procedure TBinPatch.FormCreate(Sender: TObject);
// Initial preparation
begin
  // If first parameter provided load it. If there are no parameter provided set current
  // open dialog location to program location but only in debug builds.
  if FileExists(ParamStr(1)) then
    begin
    OpenDialog1.FileName   := ParamStr(1);
    OpenDialog1.InitialDir := ExtractFileDir(OpenDialog1.FileName);
    Edit1.Text             := OpenDialog1.FileName;
    Button2.Enabled        := True;
    Update;
  {$IF Defined(DEBUG)}
    end
    else OpenDialog1.InitialDir := ExtractFileDir(Application.ExeName) + '\Data\';
  {$ELSE}
    end;
  {$IFEND}

  // Initialize column header
  SortedColumn := 1;
  PopulateHeader;
end;

procedure TBinPatch.ListView1Click(Sender: TObject);
// Update detail in memo for long truncated items in listview
begin
    if ListView1.Selected = nil then Exit;
    Memo1.Lines.Clear;
    Memo1.Lines.Add(ListView1.Selected.SubItems.Strings[2]);
end;

function TBinPatch.CompareInt(const S1, S2: string): Integer;
// Comparator. Compare two strings as integer.
var Code, N1, N2: Integer;
begin
  Val(S1, N1, Code);
  if Code <> 0 then N1 := 0;
  Val(S2, N2, Code);
  if Code <> 0 then N2 := 0;

  Result := N1 - N2;
end;

function TBinPatch.CompareData(const S1, S2: string): Integer;
// Comparator. Compare two strings by length.
begin
  Result := Length(S1) - Length(S2);
end;

procedure TBinPatch.ListView1ColumnClick(Sender: TObject; Column: TListColumn);
// Sort data in listview
begin
  TListView(Sender).SortType := stNone;
  if Column.Index <> SortedColumn then
  begin
    SortedColumn := Column.Index;
    Descending   := False;
  end
  else Descending            := not Descending;
  TListView(Sender).SortType := stText;
  PopulateHeader;
end;

procedure TBinPatch.ListView1Compare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
// Comparator. Integers are compared by values and patch data is compared by length.
begin
  if SortedColumn = 0
    then Compare := CompareInt(Item1.Caption, Item2.Caption)
    else if SortedColumn = 3  then Compare := CompareData(Item1.SubItems[SortedColumn - 1], Item2.SubItems[SortedColumn - 1])
    else if SortedColumn <> 0 then Compare := CompareInt(Item1.SubItems[SortedColumn - 1], Item2.SubItems[SortedColumn - 1]);
  if Descending then Compare := -Compare;
end;

end.
