unit TreeVisitor;

//{$MODE Delphi}

interface

uses
  Contnrs,
  Nodes;

type
  TTreeVisitor =
  class(TObject)
    procedure Visit(ANode: TNode); virtual; abstract;
    procedure PreOrder(ANode: TNode); virtual;
    procedure Postorder(ANode: TNode); virtual;
    procedure BreadthFirst(ANode: TNode); virtual;
    // could be extended with other services, e.g.:
    // find first node satisfying a predicate
    // collect all nodes satisfying a predicate
  end;

implementation

{ TTreeVisitor }

procedure TTreeVisitor.BreadthFirst(ANode: TNode);
var
  Q: TObjectQueue;
  N: TNode;
  I: Integer;
begin
  Q := TObjectQueue.Create;
  Q.Push(ANode);
  while Q.Count <> 0 do
  begin
    N := Q.Pop as TNode;;
    Visit(N);
    for I := 0 to N.GetNrOfSons - 1 do
      Q.Push(N.GetSon(I));
  end;
  Q.Free;
end;

procedure TTreeVisitor.Postorder(ANode: TNode);
var
  I: Integer;
begin
  with ANode do
    for I := 0 to GetnrOfSons - 1 do
      PostOrder(GetSon(I));
  Visit(ANode);
end;

procedure TTreeVisitor.PreOrder(ANode: TNode);
var
  I: Integer;
begin
  Visit(ANode);
  with ANode do
    for I := 0 to GetNrOfSons - 1 do
      PreOrder(GetSon(I));
end;

end.
