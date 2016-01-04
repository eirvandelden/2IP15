unit MyTreeView;
//# BEGIN TODO  Completed by: author name, id.nr., date
  { E.I.R. van Delden, 0618959, 29-06-2008 }
//# END TODO

//------------------------------------------------------------------------------
// This unit defines class TMyTreeView, which is a descendant of the standard
// TTreeView component from the Delphi VCL (Vusial Component Library).
// See the Delphi Help for information on TTreeView !!
//

interface

uses
  ComCtrls,
  Nodes;

type
  TMyTreeView =
  class(TTreeView)
  private
  public
    procedure SelectNode(ANode: TNode);
    procedure Show(ANode: TNode);
  end;

implementation

{ TMyTreeView }

procedure TMyTreeView.SelectNode(ANode: TNode);
var
  I: integer;
begin
  with Items do
    for I := 0 to Count - 1 do
      if Item[I].Data = ANode
      then Selected := Item[I];
end;

procedure TMyTreeView.Show(ANode: TNode);
//# BEGIN TODO
// Add declarations of local variables and/or functions, if necessary
var
  I: Integer;
  AFather: TTreeNode;
//# END TODO

  procedure RecAddSons(AFather: TTreeNode; ANode: TNode);
  var
    I: Integer;
  begin
  //# BEGIN TODO
  // Recursively build a tree of TTreeNode with root AFather corresponding to
  // the formula tree with root ANode


     for I := 0 to ANode.GetNrofSons - 1 do
     begin
       if ANode.HasData then
       begin
        Items.AddChild(AFather, ANode.OpName+ '[' + ANode.GetData + ']');
       end
       else
       begin
        Items.AddChild( AFather, ANode.OpName);
       end;

       AFather.Item[I].Data := ANode.GetSon(I);
       RecAddSons( AFather.Item[I] , ANode.GetSon(I));  // voeg zoon toe aan de laatste node in de tree view
     end;

  //# END TODO
  end;

begin
//# BEGIN TODO
  { Add code corresponding to the following steps:}

  // Clear Items
  // Add a new root object corresponding to ANode
  // Recursively add sons by means of procedure RecAddSons
  // Show the tree in expanded form

 Items.Clear;                                                                   // clear items list
 AFather := Items.AddFirst(nil, ANode.OpName);                                             // add root
 AFather.Data := ANode;

 // Add Nodse

  RecAddSons( AFather, ANode);


AFather.Expand(true);

//# END TODO
end;

end.
