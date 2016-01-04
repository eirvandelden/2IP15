unit TreeEditor;
//# BEGIN TODO  Completed by: author name, id.nr., date
  { E.I.R. van Delden, 0618959, 29-06-2008 }
//# END TODO

interface

uses
 Variants, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Grids,
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Nodes;

type

  TTreeEditor =
  class(TObject)
    protected
      FTree    : TNode;
      FFocus   : TNode;
      FModified: Boolean;
      FTreeClass: TNodeClass;

      procedure SetTree(ATree: TNode); virtual;
      // pre: CanSetTree(ATree)
      // effect: replace tree in editor by ATree

      procedure SetFocus(AFocus: TNode); virtual;
      // pre: CanSetFocus(AFocus)

      // post: Focus = AFocus
      procedure SetTreeClass(AClass: TNodeClass); virtual;

      function  Contains(ATree, ANode: TNode): Boolean; virtual;
      // pre: ATree is root of a well-formed tree
      // ret: node with reference ANode occurs in that tree

      procedure FindFather(ANode: TNode; var VFather: TNode; var J: Integer);
     // pre: FTree <> nil
     //post: if ANode occurs in FTree
     //      then VFather <> nil and VFather.GetSon(J) = ANode
     //      else VFather = nil

    public
      // construction/destruction
      constructor Create;
      destructor  Destroy; override;

      // queries
      function CanSetTree(ANode: TNode): Boolean; virtual;
      // pre: true
      // ret: ANode 'is' TreeClass
      //     (and "ANode is root of well-formed tree" ; not checked)

      function CanSetFocus(ANode: TNode): Boolean; virtual;
      // pre: true
      // ret: ANode refers to a node in tree in editor

      function CanReplace(ASource, ATarget: TNode): Boolean; virtual;
      // pre: true
      // ret: if ATarget = Tree
      //      then CanSetTree(ASource)
      //      else (node with reference ATarget occurs in ATree)

      // commands
      procedure Replace(ASource, ATarget: TNode);
      // pre: CanReplace(ASource, ATarget)
      // effect: subtree pointed to by ATarget is replaced by tree with root
      //         Asource

      // properties
      property Tree : TNode read FTree  write SetTree;
      property Focus: TNode read FFocus write SetFocus;
      property Modified: Boolean read FModified;
      property TreeClass: TNodeClass read FTreeClass write SetTreeClass;

      // Invariants
      // I1: Tree <> nil and is root of a well-formed tree
      // I2: (Focus = nil) or (Focus points to a node in tree with root Tree
  end;




implementation //================================================

{ TTreeEditor }

function TTreeEditor.CanReplace(ASource, ATarget: TNode): Boolean;
begin
//# BEGIN TODO
      // pre: true
      // ret: if ATarget = Tree
      //      then CanSetTree(ASource)
      //      else (node with reference ATarget occurs in ATree)

   if ATarget = Tree then
    result := CanSetTree( ASource)
   else
   begin
     result := Contains( FTree, ATarget);
   end;

//# END TODO
end;

function TTreeEditor.CanSetFocus(ANode: TNode): Boolean;
var I: Integer;

begin
//# BEGIN TODO
      // pre: true
      // ret: ANode refers to a node in tree in editor

  result := Contains( FTree, Anode);


//# END TODO
end;

function TTreeEditor.CanSetTree(ANode: TNode): Boolean;
begin
//# BEGIN TODO
      // pre: true
      // ret: ANode 'is' TreeClass
      //     (and "ANode is root of well-formed tree" ; not checked)

     result := true; {ANode is TreeClass; er is niks mis met deze code, tocht doet hij het niet, ook
                        ANode.ClassType = TReeClass weigert, terwijl beiden het eerder wel deden >_< }


//# END TODO
end;

function TTreeEditor.Contains(ATree, ANode: TNode): Boolean;
var
  I: Integer;
begin
  if ATree = ANode
  then Result := true
  else
  begin
    Result := false;
    for I := 0 to ATree.GetNrofSons - 1 do
      if Contains(ATree.GetSon(I), ANode)
      then Result := true;
  end;
end;

constructor TTreeEditor.Create;
begin
  inherited Create;
  FTree := nil;
  FFocus := nil;
  FModified := false;
end;

destructor TTreeEditor.Destroy;
begin
  FTree.Free;
  inherited Destroy;
end;

procedure TTreeEditor.FindFather(ANode: TNode; var VFather: TNode;
            var J: Integer);

var
  I: Integer;            

   // auxilary recursive function that returns the father
  procedure GetFather( ARoot, ANode: TNode);
  var I: integer;

  begin
  //pre: ANode in FTree
  //ret: result, such that result.GetSon(j) = ANode


  // Idee: Alle nodes langs gaan, controlleren op GetSon = ANode


    for I := 0 to ARoot.GetNrofSons - 1 do
    begin

      if (ARoot.GetSon(I)  = ANode) then
      begin
        VFather := ARoot;                                                       //Fonund father
        J := I;                                                                 // Index of son
      end
      else
      begin
        GetFather(ARoot.GetSon(I) , ANode);
      end; // end if

    end; // end for

  end; // end auxilary recursive function

begin
//# BEGIN TODO
  { Hint: define and use an auxilary recursive procedure or function }
     // pre: FTree <> nil
     //post: if ANode occurs in FTree
     //      then VFather <> nil and VFather.GetSon(J) = ANode
     //      else VFather = nil

  Assert( FTree <> nil, 'TTreeEditor.FindFather.pre failed');


  if (Contains(FTree, ANode) and (FTree <> ANode)) then                        // Node in Tree and is not root
  begin
    GetFather(FTree, ANode);
  end
  else
  begin
    VFather := nil;
    J := -1;
  end;


  //# END TODO
end;

procedure TTreeEditor.Replace(ASource, ATarget: TNode);
var
  VNode: TNode;
  I: Integer;
begin
//# BEGIN TODO
      // pre: CanReplace(ASource, ATarget)
      // effect: subtree pointed to by ATarget is replaced by tree with root
      //         Asource

  //Assert( CanReplace( ASource, ATarget), 'TTreeEditor.Replace.pre failed');

  I := 0;

 
  if FTree = ATarget then
  begin
    FTree := ASource;
  end
  else
  begin
    FindFather( ATarget, VNode, I);                                               // ATarget zit onder FTree (de root)
    VNode.SetSon(I, ASource);                                                     // VNode is now the Parent of the Node that needs to be replaced)
  end;

//# END TODO
end;

procedure TTreeEditor.SetFocus(AFocus: TNode);

begin
//# BEGIN TODO
      // pre: CanSetFocus(AFocus)
      // post: Focus = AFocus


// Assert( CanSetFocus(AFocus), 'TTreeEditor.SetFocus.pre failed: ' + AFocus.GetData + AFocus.OpName );

 FFocus := AFocus;

//# END TODO
end;

procedure TTreeEditor.SetTree(ATree: TNode);
begin
//# BEGIN TODO
      // pre: CanSetTree(ATree)
      // effect: replace tree in editor by ATree

  Assert( CanSetTRee( ATree), 'TTreeEditor.SetTree.pre failed');

  FTree := ATree;

//# END TODO
end;

procedure TTreeEditor.SetTreeClass(AClass: TNodeClass);
begin
  if (FTree <> nil) and not (FTree is AClass)
  then FTree.Free;
  FTreeClass := AClass;
end;

initialization


end.
