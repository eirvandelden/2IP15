unit Prop;

interface

uses
  SysUtils,
  Nodes, TreeVisitor;

{ This unit defines subclasses of TNode for representing the following
  signature:

  Data = String | ValKind

  Sorts = Prop
    Prop = Hole | Meta | Const | Var | Not | And | Or | Imp | Equiv
      Hole    = []
      Meta    = D[name: String]
      Const   = D[val: ValKind]
      Var     = D[name: String]
      Not     = S[arg: Prop]
      And     = S[left: Prop, right: Prop]
      Or      = S[left: Prop, right: Prop]
      Imp     = S[left: Prop, right: Prop]
      Equiv   = S[left: Prop, right: Prop]
}

const
  // proposition kinds
  pkHole  =  19;
  pkMeta  =  20;
  pkConst =  21;
  pkVar   =  22;
  pkNot   =  23;
  pkAnd   =  24;
  pkOr    =  25;
  pkImp   =  26;
  pkEquiv =  27;

type
  TPropKind = pkConst..pkEquiv;
  TValKind  = (vkTrue, vkFalse);

  TProp =
  class(TNode)
  end;

  TProp_Hole =
  class(TProp)
    class function GetKind: TNodeKind; override;
    class function GetNrofSons: Integer; override;
    function    GetSon(I: Integer): TNode; override;
    procedure   SetSon(I: Integer; ANode: TNode); override;
    class function OpName: String; override;
    class function IsHole: Boolean; override;
  end;

  TProp_Meta =
  class(TProp)
    private
      FName: String;
    public
      constructor Create(AName: String);
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      class function HasData: Boolean; override;
      function    GetData: String; override;
      procedure   SetData(AString: String); override;
      class function IsMeta: Boolean; override;
    end;

  TProp_Const =
  class(TProp)
    private
      FVal: TValKind;
    public
      constructor Create(AVal: TValKind);
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      class function HasData: Boolean; override;
      function    GetData: String; override;
      procedure   SetData(AString: String); override;
    end;

  TProp_Var =
  class(TProp)
    private
      FName: String;
    public
      constructor Create(AName: String);
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      class function HasData: Boolean; override;
      function    GetData: String; override;
      procedure   SetData(AString: String); override;
    end;

  TProp_Not =
  class(TProp)
    private
      FArg: TProp;
    public
      constructor Create(AArg: TProp);
      destructor  Destroy; override;
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
    end;

  TProp_And =
  class(TProp)
    private
      FLeft : TProp;
      FRight: TProp;
    public
      constructor Create(ALeft, ARight: TProp);
      destructor  Destroy; override;
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      property    Left: TProp read FLeft;
      property    Right: TProp read FRight;
  end;

  TProp_Or =
  class(TProp)
    private
      FLeft : TProp;
      FRight: TProp;
    public
      constructor Create(ALeft, ARight: TProp);
      destructor  Destroy; override;
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      property    Left: TProp read FLeft;
      property    Right: TProp read FRight;
  end;

  TProp_Imp =
  class(TProp)
    private
      FLeft : TProp;
      FRight: TProp;
      
    public
      constructor Create(ALeft, ARight: TProp);
      destructor  Destroy; override;

      class function GetKind: TNodeKind; override;
      class function OpName: String; override;

      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;

      property    Left: TProp read FLeft;
      property    Right: TProp read FRight;
  end;

  TProp_Equiv =
  class(TProp)
    private
      FLeft : TProp;
      FRight: TProp;
    public
      constructor Create(ALeft, ARight: TProp);
      destructor  Destroy; override;
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      property    Left: TProp read FLeft;
      property    Right: TProp read FRight;
  end;


  TPropVisitor =
  class(TTreeVisitor)
    procedure Visit(ANode: TNode); override;
    procedure VisitConst(ANode: TProp_Const); virtual;
    procedure VisitVar  (ANode: TProp_Var  ); virtual;
    procedure VisitNot  (ANode: TProp_Not  ); virtual;
    procedure VisitAnd  (ANode: TProp_And  ); virtual;
    procedure VisitOr   (ANode: TProp_Or   ); virtual;
    procedure VisitImp  (ANode: TProp_Imp  ); virtual;
    procedure VisitEquiv(ANode: TProp_Equiv); virtual;
  end;

  TPropFactory =
  class(TSimpleNodeFactory)
    function MakeHole: TProp_Hole; reintroduce;
    function MakeMeta(AName: String): TProp_Meta; virtual;
    function MakeConst(AVal: TValKind): TProp_Const; virtual;
    function MakeVar(AName: String): TProp_Var; virtual;
    function MakeNot(AArg: TProp): TProp_Not; virtual;
    function MakeAnd(ALeft, ARight: TProp): TProp_And; virtual;
    function MakeOr(ALeft, ARight: TProp): TProp_Or; virtual;
    function MakeImp(ALeft, ARight: TProp): TProp_Imp; virtual;
    function MakeEquiv(ALeft, ARight: TProp): TProp_Equiv; virtual;
  end;

var
  VPropFactory: TPropFactory;


implementation //===============================================================

{ TProp_Hole }

class function TProp_Hole.GetKind: TNodeKind;
begin
  Result := pkHole;
end;

class function TProp_Hole.GetNrofSons: Integer;
begin
  Result := 0;
end;

function TProp_Hole.GetSon(I: Integer): TNode;
begin
  raise EGetSonIndex.Create('Node error: Hole.GetSon with index ' + IntToStr(I));
end;

class function TProp_Hole.IsHole: Boolean;
begin
  Result := true;
end;

class function TProp_Hole.OpName: String;
begin
  Result := '??';
end;

procedure TProp_Hole.SetSon(I: Integer; ANode: TNode);
begin
  raise ESetSonIndex('Node error: Hole.SetSon with index ' + IntToStr(I));
end;

{ TProp_Meta }

constructor TProp_Meta.Create(AName: String);
begin
  inherited Create;
  FName := AName;
end;

function TProp_Meta.GetData: String;
begin
  Result := FName;
end;

class function TProp_Meta.GetKind: TNodeKind;
begin
  Result := pkMeta;
end;

class function TProp_Meta.GetNrofSons: Integer;
begin
  Result := 0;
end;

function TProp_Meta.GetSon(I: Integer): TNode;
begin
  raise EGetSonIndex.Create('Node error: Meta.GetSon with index ' + IntToStr(I));
end;

class function TProp_Meta.HasData: Boolean;
begin
  Result := true;
end;

class function TProp_Meta.IsMeta: Boolean;
begin
  Result := true;
end;

class function TProp_Meta.OpName: String;
begin
  Result := 'Meta';
end;

procedure TProp_Meta.SetData(AString: String);
begin
  FName := AString;
end;

procedure TProp_Meta.SetSon(I: Integer; ANode: TNode);
begin
  raise ESetSonIndex('Node error: Meta.SetSon with index ' + IntToStr(I));
end;

{ TProp_Const }

constructor TProp_Const.Create(AVal: TValKind);
begin
  inherited Create;
  FVal := AVal;
end;

class function TProp_Const.GetKind: TNodeKind;
begin
  Result := pkConst;
end;

function TProp_Const.GetData: String;
begin
  case FVal of
    vkTrue: Result := 'true';
    vkFalse: Result := 'false';
  end;
end;

class function TProp_Const.OpName: String;
begin
  Result := 'Const';
end;

function TProp_Const.GetSon(I: Integer): TNode;
begin
  raise EGetSonIndex('Node error: Const.GetSon with index ' + IntToStr(I));
end;

class function TProp_Const.GetNrofSons: Integer;
begin
  Result := 0;
end;

procedure TProp_Const.SetSon(I: Integer; ANode: TNode);
begin
  raise ESetSonIndex('Node error: Const.SetSon with index ' + IntToStr(I));
end;



class function TProp_Const.HasData: Boolean;
begin
  Result := true;
end;

procedure TProp_Const.SetData(AString: String);
begin
  if StrToBool(AString)
  then FVal := vkTrue
  else FVal := vkFalse;
end;

{ TProp_Var }

constructor TProp_Var.Create(AName: String);
begin
  inherited Create;
  FName := Aname;
end;

class function TProp_Var.GetKind: TNodeKind;
begin
  Result := pkVar;
end;

function TProp_Var.GetData: String;
begin
  Result := FName;
end;

class function TProp_Var.OpName: String;
begin
  Result := 'Var';
end;

function TProp_Var.GetSon(I: Integer): TNode;
begin
  raise EGetSonIndex('Node error: Var.GetSon with index ' + IntToStr(I));
end;

class function TProp_Var.GetNrofSons: Integer;
begin
  Result := 0;
end;

procedure TProp_Var.SetSon(I: Integer; ANode: TNode);
begin
  raise ESetSonIndex('Node error: Var.SetSon with index ' + IntToStr(I));
end;


class function TProp_Var.HasData: Boolean;
begin
  Result := true;
end;

procedure TProp_Var.SetData(AString: String);
begin
  FName := AString;
end;

{ TProp_Not }

constructor TProp_Not.Create(AArg: TProp);
begin
  inherited Create;
  FArg := AArg;
end;

destructor TProp_Not.Destroy;
begin
  FArg.Free;
  inherited Destroy;
end;

class function TProp_Not.GetKind: TNodeKind;
begin
  Result := pkNot;
end;

class function TProp_Not.GetNrofSons: Integer;
begin
  Result := 1;
end;

function TProp_Not.GetSon(I: Integer): TNode;
begin
  case I of
    0: Result := FArg
  else
    raise EGetSonIndex('Node error: Not.GetSon with index ' + IntToStr(I))
  end;
end;

procedure TProp_Not.SetSon(I: Integer; ANode: TNode);
begin
  case I of
    0: FArg := ANode as TProp
  else
    raise ESetSonIndex('Node error: Not.SetSon with index ' + IntToStr(I))
  end;
end;

class function TProp_Not.OpName: String;
begin
  Result := 'Not';
end;


{ TProp_And }

constructor TProp_And.Create(ALeft, ARight: TProp);
begin
  inherited create;
  FLeft := ALeft;
  FRight := ARight;
end;

destructor TProp_And.Destroy;
begin
  FLeft.Free;
  FRight.Free;
  inherited Destroy;
end;

class function TProp_And.GetKind: TNodeKind;
begin
  Result := pkAnd;
end;

class function TProp_And.GetNrofSons: Integer;
begin
  Result := 2;
end;

function TProp_And.GetSon(I: Integer): TNode;
begin
  case I of
    0: Result := FLeft;
    1: Result := FRight
  else
    raise EGetSonIndex('Node error: And.GetSon with index ' + IntToStr(I))
  end;
end;

procedure TProp_And.SetSon(I: Integer; ANode: TNode);
begin
  case I of
    0: FLeft := ANode as TProp;
    1: FRight := ANode as TProp
  else
    raise ESetSonIndex('Node error: And.SetSon with index ' + IntToStr(I))
  end;
end;

class function TProp_And.OpName: String;
begin
  Result := 'And';
end;

{ TProp_Or }

constructor TProp_Or.Create(ALeft, ARight: TProp);
begin
  inherited create;
  FLeft := ALeft;
  FRight := ARight;
end;

destructor TProp_Or.Destroy;
begin
  FLeft.Free;
  FRight.Free;
  inherited Destroy;
end;

class function TProp_Or.GetKind: TNodeKind;
begin
  Result := pkOr;
end;

class function TProp_Or.GetNrofSons: Integer;
begin
  Result := 2;
end;

function TProp_Or.GetSon(I: Integer): TNode;
begin
  case I of
    0: Result := FLeft;
    1: Result := FRight
  else
    raise EGetSonIndex('Node error: Or.GetSon with index ' + IntToStr(I))
  end;
end;

procedure TProp_Or.SetSon(I: Integer; ANode: TNode);
begin
  case I of
    0: FLeft := ANode as TProp;
    1: FRight := ANode as TProp
  else
    raise ESetSonIndex('Node error: Or.SetSon with index ' + IntToStr(I))
  end;
end;

class function TProp_Or.OpName: String;
begin
  Result := 'Or';
end;


{ TProp_Imp }

constructor TProp_Imp.Create(ALeft, ARight: TProp);
begin
  inherited create;
  FLeft := ALeft;
  FRight := ARight;
end;

destructor TProp_Imp.Destroy;
begin
  FLeft.Free;
  FRight.Free;
  inherited Destroy;
end;

class function TProp_Imp.GetKind: TNodeKind;
begin
  Result := pkImp;
end;

class function TProp_Imp.GetNrofSons: Integer;
begin
  Result := 2;
end;

function TProp_Imp.GetSon(I: Integer): TNode;
begin
  case I of
    0: Result := FLeft;
    1: Result := FRight
  else
    raise EGetSonIndex('Node error: Imp.GetSon with index ' + IntToStr(I))
  end;
end;

procedure TProp_Imp.SetSon(I: Integer; ANode: TNode);
begin
  case I of
    0: FLeft := ANode as TProp;
    1: FRight := ANode as TProp
  else
    raise ESetSonIndex('Node error: Imp.SetSon with index ' + IntToStr(I))
  end;
end;

class function TProp_Imp.OpName: String;
begin
  Result := 'Imp';
end;


{ TProp_Equiv }

constructor TProp_Equiv.Create(ALeft, ARight: TProp);
begin
  inherited create;
  FLeft := ALeft;
  FRight := ARight;
end;

destructor TProp_Equiv.Destroy;
begin
  FLeft.Free;
  FRight.Free;
  inherited Destroy;
end;

class function TProp_Equiv.GetKind: TNodeKind;
begin
  Result := pkEquiv;
end;

class function TProp_Equiv.GetNrofSons: Integer;
begin
  Result := 2;
end;

function TProp_Equiv.GetSon(I: Integer): TNode;
begin
  case I of
    0: Result := FLeft;
    1: Result := FRight
  else
    raise EGetSonIndex('Node error: Equiv.GetSon with index ' + IntToStr(I))
  end;
end;

procedure TProp_Equiv.SetSon(I: Integer; ANode: TNode);
begin
  case I of
    0: FLeft := ANode as TProp;
    1: FRight := ANode as TProp
  else
    raise ESetSonIndex('Node error: Equiv.SetSon with index ' + IntToStr(I))
  end;
end;

class function TProp_Equiv.OpName: String;
begin
  Result := 'Equiv';
end;


 { TPropVisitor }

procedure TPropVisitor.Visit(ANode: TNode);
begin
  // Dispatch by means of ANode.GetKind
  case ANode.GetKind of
  pkConst : VisitConst(ANode as TProp_Const);
  pkVar   : VisitVar  (ANode as TProp_Var  );
  pkNot   : VisitNot  (ANode as TProp_Not  );
  pkAnd   : VisitAnd  (ANode as TProp_And  );
  pkOr    : VisitOr   (ANode as TProp_Or   );
  pkImp   : VisitImp  (ANode as TProp_Imp  );
  pkEquiv : VisitEquiv(ANode as TProp_Equiv);
  else
    raise ENodeKind.Create('Unexpected NodeKind in TPropVisitor');
  end;
end;



procedure TPropVisitor.VisitAnd(ANode: TProp_And);
begin

end;

procedure TPropVisitor.VisitConst(ANode: TProp_Const);
begin

end;

procedure TPropVisitor.VisitEquiv(ANode: TProp_Equiv);
begin

end;

procedure TPropVisitor.VisitImp(ANode: TProp_Imp);
begin

end;

procedure TPropVisitor.VisitNot(ANode: TProp_Not);
begin

end;

procedure TPropVisitor.VisitOr(ANode: TProp_Or);
begin

end;

procedure TPropVisitor.VisitVar(ANode: TProp_Var);
begin

end;


{ TPropFactory }

function TPropFactory.MakeAnd(ALeft, ARight: TProp): TProp_And;
begin
  Result := TProp_And.Create(ALeft, ARight);
end;

function TPropFactory.MakeConst(AVal: TValKind): TProp_Const;
begin
  Result := TProp_Const.Create(AVal);
end;

function TPropFactory.MakeEquiv(ALeft, ARight: TProp): TProp_Equiv;
begin
  Result := TProp_Equiv.Create(ALeft, ARight);
end;

function TPropFactory.MakeHole: TProp_Hole;
begin
  Result := TProp_Hole.Create;
end;

function TPropFactory.MakeImp(ALeft, ARight: TProp): TProp_Imp;
begin
  Result := TProp_Imp.Create(ALeft, ARight);
end;

function TPropFactory.MakeMeta(AName: String): TProp_Meta;
begin
  Result := TProp_Meta.Create(AName);
end;

function TPropFactory.MakeNot(AArg: TProp): TProp_Not;
begin
  Result := TProp_Not.Create(AArg);
end;

function TPropFactory.MakeOr(ALeft, ARight: TProp): TProp_Or;
begin
  Result := TProp_Or.Create(ALeft, ARight);
end;

function TPropFactory.MakeVar(AName: String): TProp_Var;
begin
  Result := TProp_Var.Create(AName);
end;

initialization

  VPropFactory := TPropFactory.Create;
  with VPropFactory do
  begin
    AddNodeClass(TProp_Hole);
    AddNodeClass(TProp_Meta);
    AddNodeClass(TProp_Const);
    AddNodeClass(TProp_Var);
    AddNodeClass(TProp_Not);
    AddNodeClass(TProp_And);
    AddNodeClass(TProp_Or);
    AddNodeClass(TProp_Imp);
    AddNodeClass(TProp_Equiv);
  end;



end.
