unit MyRichEdit;

interface

uses
  ComCtrls, Graphics,
  Nodes, Repr;

type
  TMyRichEdit =
  class(TRichEdit)
  protected
    FRepr: TRepr;
    FTree: TNode;
    FFocus: TNode;
    FLine: String;
    FSelStart: Integer;
    FSelLength: Integer;
    procedure BuildLine;
    procedure WriteNode(ANode: TNode);
  public
    procedure SetRepr(ARepr: Trepr);
    procedure AddTree(ATree: TNode);
    procedure ChangeFocus(AFocus: TNode);
  end;

implementation

{ TMyRichEdit }

procedure TMyRichEdit.AddTree(ATree: TNode);
var
  VLength: Integer;
begin
  FTree := ATree;
  FFocus := ATree;
  BuildLine;
  VLength := Length(Text);
  Lines.Add(FLine);
  SelStart := VLength + FSelStart;
  SelLength := FSelLength;
end;

procedure TMyRichEdit.BuildLine;
begin
  FLine := '';
  WriteNode(FTree);
end;

procedure TMyRichEdit.ChangeFocus(AFocus: TNode);
var
  VLength: Integer;
begin
  FFocus := AFocus;
  BuildLine;
  with Lines do
    if Count > 0
    then Delete(Count - 1);

  VLength := Length(Text);
  Lines.Add(FLine);
  SelStart := VLength + FSelStart;
  SelLength := FSelLength;
  with SelAttributes do
    Style := [fsBold];
end;

procedure TMyRichEdit.SetRepr(ARepr: Trepr);
begin
  FRepr := ARepr;
end;

procedure TMyRichEdit.WriteNode(ANode: TNode);
var
  I: Integer;
begin
  if ANode = FFocus
  then FSelStart := Length(FLine);

  with ANode do
    if HasData
    then FLine := FLine + GetData
    else
      begin
        for I := 0 to GetNrOfSons - 1 do
        begin
          FLine := FLine + FRepr.Rep(ANode, I);
          WriteNode(GetSon(I));
        end;
        FLine := FLine + FRepr.Rep(ANode, GetNrOfSons);
      end;

  if ANode = FFocus
  then FSelLength := Length(FLine) - FSelStart;
end;


end.
