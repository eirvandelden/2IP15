unit NodeOutline;

//{$MODE Delphi}

interface
uses
  Classes, Outline,
  Nodes;

type
  TNodeOutLine =
  class(TOutLine)
  public
    procedure SelectNode(ANode: TNode);
    procedure Show(ANode: TNode);
  end;


implementation //===============================================================

uses
  Repr;

{ TNodeOutline }

procedure TNodeOutline.SelectNode(ANode: TNode);
var
  I: Integer;
begin
  // N.B. range is 1 .. ItemCount; Help says it is 0 .. ItemCount-1 .
  for I := 1{0} to ItemCount {- 1} do  
    if Items[I].Data = ANode
    then SelectedItem := I;
end;

procedure TNodeOutLine.Show(ANode: TNode);
begin
  Lines := NodesToStringList(ANode);
  FullExpand;
end;

end.
