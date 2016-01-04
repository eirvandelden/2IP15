unit Repr;
//# BEGIN TODO  Completed by: author name, id.nr., date
  { E.I.R. v. Delden, 0618959, 06-06-'08 }
//# END TODO

//------------------------------------------------------------------------------
// This unit contains facilities for mapping formula trees to textual
// representations.
//------------------------------------------------------------------------------

interface

uses
  Classes,
  Nodes;

function NodesToPrefix(ANode: TNode): String;
// returns a standard prefix representation of the formula tree with root ANode

function NodesToStringlist(ANode: TNode): TStringList;
// returns the same standard prefix representation as NodesToPrefix, but in the
// form of a string list with indentation.

type
  //----------------------------------------------------------------------------
  // TRepr is an abstract base class which provides facilities for mapping
  // a formula tree to an infix representation.
  // - function Rep(ANode, I) returns the string parts needed for the textual
  //   representation of the formula with root ANode.
  //   E.g. if ANode corresponds to the 2-ary operator And, the results would be
  //   - Rep(ANode, 0) = '('
  //     Rep(ANode, 1) = '/\'
  //     Rep(ANode, 2) = ')'
  //   Rep is abstract in class TRepr, but will be instantiated in language-
  //   specific subclasses.
  // - function TreeToString recursively produces the entire textual
  //   representation of the formula tree with root ANode, using Rep for each
  //   in the tree.
  //----------------------------------------------------------------------------
  TRepr =
  class(TObject)
  public
    function Rep(ANode: TNode; I: Integer): String; virtual; abstract;
    // pre: ANode <> nil, 0 <= I < ANode.GetNrOfSons
    // ret: the I-th substring in the textual representation of the operator
    //      ANode.OpName
    function TreeToString(ANode: TNode): String; virtual;
    // pre: ANode <> nil
    // ret: textual representation of formula tree with root ANode
  end;

  //----------------------------------------------------------------------------
  // TStandardRepr provides a particular implementation of Rep in the form of a
  // list (indexed by ANode.OpName) of array of String.
  // For a particular language the list can be built up by means of procedure
  // AddRep.
  //----------------------------------------------------------------------------
  TStandardRepr =
  class(TRepr)
  protected
    FList: TStringList;
  public
    constructor Create;
    destructor  Destroy; override;
    function    Rep(ANode: TNode; I: Integer): String; override;
    procedure   AddRep(ANodeClass: TNodeClass; APrio: Integer;
                    ASepList: array of String);
  end;

implementation //===============================================================

uses
  StrUtils, SysUtils;


function Ind(AInd: Integer): String;
begin
  Result := DupeString(' ', AInd);
end;

function NodesToPrefix(ANode: TNode): String;
var
  I: Integer;
begin
  Result := ANode.OpName;
  if ANode.HasData
  then Result := Result + '{' + ANode.GetData + '}';
  if ANode.GetNrofSons > 0 then
  begin
    Result := Result + '[' + NodesToPrefix(ANode.GetSon(0));
    for I := 1 to ANode.GetNrofSons - 1 do
      Result := Result +',' + NodesToPrefix(ANode.GetSon(I));
    Result := Result + ']';
  end;
end;

function NodesToStringList(ANode: TNode): TStringList;
var
  R: TStringList;

  procedure NTSL(ANode: TNode; AInd: Integer);
  var
    I: Integer;
    S: String;
  begin
    S := ANode.OPName;
    if ANode.HasData
    then S := S + '[' + ANode.GetData + ']';
    R.AddObject(Ind(AInd) + S, ANode);
    for I := 0 to ANode.GetNrOfSons - 1
    do NTSL(ANode.GetSon(I), AInd + 1);
  end;{NTSL}

begin{NodesToStringList}
  R := TStringList.Create;
  NTSL(ANode, 0);
  Result := R;
end;{NodesToStringList}

{ TRepr }

function TRepr.TreeToString(ANode: TNode): String;

var TreeString: String;
  I: Integer;

begin
//# BEGIN TODO body of TRepr.TreeToString
// Replace the follwing line by your own code

    // pre: ANode <> nil
    // ret: textual representation of formula tree with root ANode

    //Assert( not ANode.HasData, 'TRepr.TreeToString.pre failed: ANode = nil');

    { Idee:
     Roep rep op 0 aan.
     Recurse op links totdat je in een leaf zit. (Aan de hand van NrOf Sons?)
        Case getNRofSons 2:
        Roep Rep op leaf aan.
        Return, roep Rep op 1 aan
        Recurse rechts.
        Case getNRofSons 1:
     Roep rep op 3 aan.

    }

  //Result := IntToStr( ANode.GetNrOfSons);

  //--- Initialisation ---
  TreeString := '';


  //--- Procedure ---

  // In Order Treewalk  for operators
  if ANode.HasData = false then                                                // We're in an operator check
  begin
    Treestring := TreeString + Rep( ANode, 0);                                 // Create first bracket

    // Process all children
    for I := 0 to ANode.GetNrofSons - 1 do                                     // Every Operator has i children, and is closed by the i+1th Rep
    begin
      TreeString := TreeString + TreeToString( ANode.GetSon(i)) + Rep( ANode, i+1);

    end;

  end;

  if ANode.HasData then                                                         // We're in a leaf
  begin
    TreeString := TreeString + ANode.GetData;                                   // Extend with Leaf contents
  end;

  Result := TreeString;

//# END TODO
end;


{ TOpRepr; auxiliary class used by TStandardRepr}
type
  TOpRepr =
  class(TObject)
    FPrio: Integer;
    FSepList: array of String;
    constructor Create(APrio: Integer; ASepList: array of String);
  end;

constructor TOpRepr.Create(APrio: Integer; ASepList: array of String);
var
  I: Integer;
begin
  inherited Create;
  FPrio := APrio;
  SetLength(FSepList, Length(ASepList));
  for I := 0 to Length(ASepList) - 1 do
    FSepList[I] := ASepList[I];
end;


{ TStandardRepr }

procedure TStandardrepr.AddRep(ANodeClass: TNodeClass; APrio: Integer;
            ASepList: array of String);
var
  VOpName: String;
begin
  VOpName := ANodeClass.OpName;
  if FList.IndexOf(VOpName) <> -1 then
    raise Exception.Create(
      'In TStandardRepr.AddRep(' +  VOpName +
      ',...): Attempt to add opname more than once' );
  if ANodeClass.GetNrofSons + 1 <> Length(ASepList) then
    raise Exception.Create(
      'In TStandardRepr.AddRep(' +  VOpName +
      ',...): Wrong  length of separator list' );
  FList.AddObject(VOpName, TOpRepr.Create(APrio, ASepList));
end;

constructor TStandardRepr.Create;
begin
  inherited Create;
  FList := TStringList.Create;
end;

destructor TStandardRepr.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TStandardRepr.Rep(ANode: TNode; I: Integer): String;
var
  VOpRepr: TOpRepr;
  VI: Integer;
begin
  VI := FList.IndexOf(ANode.OpName);
  if VI = -1
  then raise Exception.Create(
    'Unknown OpName in TStandardRepr.Rep(' + ANode.OpName + ',' +
    IntToStr(I) + ')' );
  VOpRepr := FList.Objects[VI] as TOpRepr;
  if (0 <= I) and (I <= High(VOpRepr.FSepList))
  then Result := VOpRepr.FSepList[I]
  else raise Exception.Create(
    'Invalid Index in TStandardRepr.Rep(' + ANode.OpName + ',' +
    IntToStr(I) + ')' );
end;


end.
