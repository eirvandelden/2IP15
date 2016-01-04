unit MyMath;

interface

uses
  SysUtils,
  Nodes, TreeVisitor;

{ This unit defines subclasses of TNode for representing the following
  signature:

  Data = Real | BinOpKind | Funckind

  Sorts = Math
    Math = Hole | Meta | Const | Var | UMinus | BinOp | BinExp | Func | FuncApp
      Hole    = []
      Meta    = D[name: String]
      Const   = D[val: Real]
      Var     = D[name: Char]
      UMinus  = S[arg: Math]
      BinOp   = D[kind: BinOpKind]
      BinExp  = S[left: Math, op: BinOp, right: Math]
      Func    = D[kind: FuncKind]
      FuncApp = S[func: Func, arg: Math]
}

const
  // math kinds
  mkHole    = 29;
  mkMeta    = 30;
  mkConst   = 31;
  mkVar     = 32;
  mkUMinus  = 33; // Unary minus
  mkBinop   = 34; // Binary operator
  mkBinExp  = 35; // Binary expression
  mkFunc    = 36; // Function symbol
  mkFuncApp = 37; // Function application

type
  TMathKind  = mkConst..mkFuncApp;
  TBinOpKind = (boPlus, boMinus, boTimes, boDivide);
  TFuncKind  = (fkSin, fkCos, fkExp, fkLn);

  TMath =
  class(TNode)
  end;

  TMath_Hole =
  class(TMath)
    class function GetKind: TNodeKind; override;
    class function GetNrofSons: Integer; override;
    function    GetSon(I: Integer): TNode; override;
    procedure   SetSon(I: Integer; ANode: TNode); override;
    class function OpName: String; override;
    class function IsHole: Boolean; override;
  end;

  TMath_Meta =
  class(TMath)
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

  TMath_Const =
  class(TMath)
    private
      FVal: Integer;
    public
      constructor Create(AVal: Integer);
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      class function HasData: Boolean; override;
      function    GetData: String; override;
      procedure   SetData(AString: String); override;
      property    Val: Integer read FVal;
    end;

  TMath_Var =
  class(TMath)
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
      procedure   Setdata(AString: String); override;
    end;

  TMath_Uminus =
  class(TMath)
    private
      FArg: TMath;
    public
      constructor Create(AArg: TMath);
      destructor  Destroy; override;
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      property Arg: TMath read FArg;
    end;

  TMath_BinOp =
  class(TMath)
    private
      FOpKind: TBinOpKind;
    public
      constructor Create(AOpKind: TBinOpKind);
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      class function HasData: Boolean; override;
      function    GetData: String; override;
      procedure   SetData(AString: String); override;
      property    OpKind: TBinOpKind read FOpKind;
    end;

  TMath_BinExp =
  class(TMath)
    private
      FLeft : TMath;
      FOp   : TMath_BinOp;
      FRight: TMath;
    public
      constructor Create(ALeft: TMath; AOp: TMath_BinOp; ARight: TMath);
      destructor  Destroy; override;
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      property    Left: TMath read FLeft;
      property    Op: TMath_BinOp read FOp;
      property    Right: TMath read FRight;
  end;

  TMath_Func =
  class(TMath)
    private
      FFuncKind: TFuncKind;
    public
      constructor Create(AFuncKind: TFuncKind);
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      class function HasData: Boolean; override;
      function    GetData: String; override;
      procedure   Setdata(AString: String); override;
      property    FuncKind: TFuncKind read FFuncKind;
    end;

  TMath_FuncApp =
  class(TMath)
    private
      FFunc : TMath_Func;
      FArg: TMath;
    public
      constructor Create(AFunc: TMath_Func; AArg: TMath);
      destructor  Destroy; override;
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      property    Func: TMath_Func read FFunc;
      property    Arg: TMath read FArg;
  end;



  TMathVisitor =
  class(TTreeVisitor)
    procedure Visit(ANode: TNode); override;
    procedure VisitConst  (ANode: TMath_Const); virtual;
    procedure VisitVar    (ANode: TMath_Var); virtual;
    procedure VisitUMinus (ANode: TMath_UMinus); virtual;
    procedure VisitBinOp  (ANode: TMath_BinOp); virtual;
    procedure VisitBinExp (ANode: TMath_BinExp); virtual;
    procedure VisitFunc   (ANode: TMath_Func); virtual;
    procedure VisitFuncApp(ANode: TMath_FuncApp); virtual;
  end;

  TMathFactory =
  class(TSimpleNodeFactory)
  public
    function MakeHole: TMath_Hole; reintroduce;
    function MakeMeta(AName: String): TMath_Meta; virtual;
    function MakeConst(AVal: Integer): TMath_Const; virtual;
    function MakeVar(AName: String): TMath_Var;  virtual;
    function MakeUMinus(AArg: TMath): TMath_UMinus; virtual;
    function MakeBinExp(ALeft: TMath; AOp: TMath_BinOp; ARight: TMath)
      : TMath_BinExp; virtual;
    function MakeBinOp(AOpKind: TBinOpKind): TMath_BinOp; virtual;
    function MakeFuncApp(AFunc: TMath_Func; AArg: TMath): TMath_FuncApp;
      virtual;
    function MakeFunc(AFuncKind: TFuncKind): TMath_Func;
  end;



var
  VMathFactory: TMathFactory;

implementation //===============================================================

{ TMath_Hole }

class function TMath_Hole.GetKind: TNodeKind;
begin
  Result := mkHole;
end;

class function TMath_Hole.GetNrofSons: Integer;
begin
  Result := 0;
end;

function TMath_Hole.GetSon(I: Integer): TNode;
begin
  raise EGetSonIndex.Create('Node error: Hole.GetSon with index ' + IntToStr(I));
end;

class function TMath_Hole.IsHole: Boolean;
begin
  Result := true;
end;

class function TMath_Hole.OpName: String;
begin
  Result := '??';
end;

procedure TMath_Hole.SetSon(I: Integer; ANode: TNode);
begin
  raise ESetSonIndex('Node error: Hole.SetSon with index ' + IntToStr(I));
end;

{ TMath_Meta }

constructor TMath_Meta.Create(AName: String);
begin
  inherited Create;
  FName := AName;
end;

function TMath_Meta.GetData: String;
begin
  Result := FName;
end;

class function TMath_Meta.GetKind: TNodeKind;
begin
  Result := mkMeta;
end;

class function TMath_Meta.GetNrofSons: Integer;
begin
  Result := 0;
end;

function TMath_Meta.GetSon(I: Integer): TNode;
begin
  raise EGetSonIndex.Create('Node error: Meta.GetSon with index ' + IntToStr(I));
end;

class function TMath_Meta.HasData: Boolean;
begin
  Result := true;
end;

class function TMath_Meta.IsMeta: Boolean;
begin
  Result := true;
end;

class function TMath_Meta.OpName: String;
begin
  Result := 'Meta';
end;

procedure TMath_Meta.SetData(AString: String);
begin
  FName := AString;
end;

procedure TMath_Meta.SetSon(I: Integer; ANode: TNode);
begin
  raise ESetSonIndex('Node error: Meta.SetSon with index ' + IntToStr(I));
end;

{ TMath_Const }

constructor TMath_Const.Create(AVal: Integer);
begin
  inherited Create;
  FVal := AVal;
end;

class function TMath_Const.GetKind: TNodeKind;
begin
  Result := mkConst;
end;

function TMath_Const.GetData: String;
begin
  Result := IntToStr(FVal);
end;

class function TMath_Const.OpName: String;
begin
  Result := 'Const';
end;

function TMath_Const.GetSon(I: Integer): TNode;
begin
  raise EGetSonIndex('Node error: Const.GetSon with index ' + IntToStr(I));
end;

class function TMath_Const.GetNrofSons: Integer;
begin
  Result := 0;
end;

procedure TMath_Const.SetSon(I: Integer; ANode: TNode);
begin
  raise ESetSonIndex('Node error: Const.SetSon with index ' + IntToStr(I));
end;



class function TMath_Const.HasData: Boolean;
begin
  Result := true;
end;

procedure TMath_Const.SetData(AString: String);
begin
  FVal := StrToInt(AString);
end;

{ TMath_Var }

constructor TMath_Var.Create(AName: String);
begin
  inherited Create;
  FName := Aname;
end;

class function TMath_Var.GetKind: TNodeKind;
begin
  Result := mkVar;
end;

function TMath_Var.GetData: String;
begin
  Result := FName;
end;

class function TMath_Var.OpName: String;
begin
  Result := 'Var';
end;

function TMath_Var.GetSon(I: Integer): TNode;
begin
  raise EGetSonIndex('Node error: Var.GetSon with index ' + IntToStr(I));
end;

class function TMath_Var.GetNrofSons: Integer;
begin
  Result := 0;
end;

procedure TMath_Var.SetSon(I: Integer; ANode: TNode);
begin
  raise ESetSonIndex('Node error: Var.SetSon with index ' + IntToStr(I));
end;


class function TMath_Var.HasData: Boolean;
begin
  Result := true;
end;

procedure TMath_Var.Setdata(AString: String);
begin
  FName := AString;
end;

{ TMath_UMinus }

constructor TMath_UMinus.Create(AArg: TMath);
begin
  inherited Create;
  FArg := AArg;
end;

destructor TMath_UMinus.Destroy;
begin
  FArg.Free;
  inherited Destroy;
end;

class function TMath_UMinus.GetKind: TNodeKind;
begin
  Result := mkUMinus;
end;

class function TMath_UMinus.GetNrofSons: Integer;
begin
  Result := 1;
end;

function TMath_UMinus.GetSon(I: Integer): TNode;
begin
  case I of
    0: Result := FArg
  else
    raise EGetSonIndex('Node error: UMinus.GetSon with index ' + IntToStr(I))
  end;
end;

procedure TMath_UMinus.SetSon(I: Integer; ANode: TNode);
begin
  case I of
    0: FArg := ANode as TMath
  else
    raise ESetSonIndex('Node error: UMinus.SetSon with index ' + IntToStr(I))
  end;
end;

class function TMath_UMinus.OpName: String;
begin
  Result := 'UMinus';
end;

{ TMath_BinOp }

constructor TMath_BinOp.Create(AOpKind: TBinOpKind);
begin
  inherited Create;
  FOpKind := AOpKind;
end;

class function TMath_BinOp.GetKind: TNodeKind;
begin
  Result := mkBinOp;
end;

function TMath_BinOp.GetData: String;
begin
  case FOpKind of
    boPlus:
      Result := '+';
    boMinus:
      Result := '-';
    boTimes:
      Result := '*';
    boDivide:
      Result := '/';
    end;
end;

class function TMath_BinOp.OpName: String;
begin
  Result := 'BinOp';
end;

function TMath_BinOp.GetSon(I: Integer): TNode;
begin
  raise EGetSonIndex('Node error: BinOp.GetSon with index ' + IntToStr(I));
end;

class function TMath_BinOp.GetNrofSons: Integer;
begin
  Result := 0;
end;

procedure TMath_BinOp.SetSon(I: Integer; ANode: TNode);
begin
  raise ESetSonIndex('Node error: Const.SetSon with index ' + IntToStr(I));
end;


class function TMath_BinOp.HasData: Boolean;
begin
  Result := true;
end;

procedure TMath_BinOp.SetData(AString: String);
begin
  if AString = '+' then FOpKind := boPlus
  else if AString = '-' then FOpKind := boMinus
  else if AString = '*' then FOpKind := boTimes
  else if AString = '/' then FOpKind := boDivide
  else raise Exception.Create('TMath_BinOp.SetData: wrong operator: ' + AString);
end;

{ TMath_BinExp }

constructor TMath_BinExp.Create(ALeft: TMath; AOp: TMath_BinOp;
              ARight: TMath);
begin
  inherited Create;
  FLeft := ALeft;
  FOp := AOp;
  FRight := ARight;
end;

destructor TMath_BinExp.Destroy;
begin
  FLeft.Free;
  FOp.Free;
  FRight.Free;
  inherited Destroy;
end;

class function TMath_BinExp.GetKind: TNodeKind;
begin
  Result := mkBinExp;
end;

class function TMath_BinExp.GetNrofSons: Integer;
begin
  Result := 3;
end;

function TMath_BinExp.GetSon(I: Integer): TNode;
begin
  case I of
    0: Result := FLeft;
    1: Result := FOp;
    2: Result := FRight
  else
    raise EGetSonIndex('Node error: BinExp.GetSon with index ' + IntToStr(I))
  end;
end;

procedure TMath_BinExp.SetSon(I: Integer; ANode: TNode);
begin
  case I of
    0: FLeft := ANode as TMath;
    1: FOp := ANode as TMath_BinOp;
    2: FRight := ANode as TMath
  else
    raise ESetSonIndex('Node error: BinExp.SetSon with index ' + IntToStr(I))
  end;
end;

class function TMath_BinExp.OpName: String;
begin
  Result := 'BinExp';
end;


{ TMath_Func }

constructor TMath_Func.Create(AFuncKind: TFuncKind);
begin
  inherited Create;
  FFuncKind := AFuncKind;
end;

class function TMath_Func.GetKind: TNodeKind;
begin
  Result := mkFunc;
end;

function TMath_Func.GetData: String;
begin
  case FFuncKind of
    fkSin:
      Result := 'Sin';
    fkCos:
      Result := 'Cos';
    fkExp:
      Result := 'Exp';
    fkLn:
      Result := 'Ln';
    end;
end;

procedure TMath_Func.Setdata(AString: String);
var
  VString: String;
begin
  VString := UpperCase(AString);
  if VString = 'SIN' then FFuncKind := fkSin
  else if VString = 'COS' then FFuncKind := fkCos
  else if VString = 'EXP' then FFuncKind := fkExp
  else if VString = 'LN' then FFuncKind := fkLn
  else raise Exception.Create('TMath_Func.SetData: wrong function: ' + AString);
end;


class function TMath_Func.OpName: String;
begin
  Result := 'Func';
end;

function TMath_Func.GetSon(I: Integer): TNode;
begin
  raise EGetSonIndex('Node error: Func.GetSon with index ' + IntToStr(I));
end;

class function TMath_Func.GetNrofSons: Integer;
begin
  Result := 0;
end;

procedure TMath_Func.SetSon(I: Integer; ANode: TNode);
begin
  raise ESetSonIndex('Node error: Func.SetSon with index ' + IntToStr(I));
end;



class function TMath_Func.HasData: Boolean;
begin
  Result := true;
end;

{ TMath_FuncApp }

constructor TMath_FuncApp.Create(AFunc: TMath_Func; AArg: TMath);
begin
  inherited Create;
  FFunc := AFunc;
  FArg := AArg;
end;

destructor TMath_FuncApp.Destroy;
begin
  FFunc.Free;
  FArg.Free;
  inherited Destroy;
end;

class function TMath_FuncApp.GetKind: TNodeKind;
begin
  Result := mkFuncApp;
end;

class function TMath_FuncApp.GetNrofSons: Integer;
begin
  Result := 2;
end;

function TMath_FuncApp.GetSon(I: Integer): TNode;
begin
  case I of
    0: Result := FFunc;
    1: Result := FArg;
  else
    raise EGetSonIndex('Node error: FuncApp.GetSon with index ' + IntToStr(I))
  end;

end;

class function TMath_FuncApp.OpName: String;
begin
  Result := 'FuncApp';
end;

procedure TMath_FuncApp.SetSon(I: Integer; ANode: TNode);
begin
  case I of
    0: FFunc := ANode as TMath_Func;
    1: FArg := ANode as TMath;
  else
    raise ESetSonIndex('Node error: FuncApp.SetSon with index ' + IntToStr(I))
  end;
end;





 { TMathVisitor }

procedure TMathVisitor.Visit(ANode: TNode);
begin
  // Dispatch by means of ANode.GetKind
  case ANode.GetKind of
  mkConst  : VisitConst  (ANode as TMath_Const);
  mkVar    : VisitVar    (ANode as TMath_Var  );
  mkUMinus : VisitUMinus (ANode as TMath_UMinus);
  mkBinOp  : VisitBinOp  (ANode as TMath_BinOp  );
  mkBinExp : VisitBinExp (ANode as TMath_BinExp   );
  mkFunc   : VisitFunc   (ANode as TMath_Func  );
  mkFuncApp: VisitFuncApp(ANode as TMath_FuncApp);
  else
    raise ENodeKind.Create('Unexpected NodeKind in TPropVisitor');
  end;
end;




procedure TMathVisitor.VisitBinExp(ANode: TMath_BinExp);
begin

end;

procedure TMathVisitor.VisitBinOp(ANode: TMath_BinOp);
begin

end;

procedure TMathVisitor.VisitConst(ANode: TMath_Const);
begin

end;

procedure TMathVisitor.VisitFunc(ANode: TMath_Func);
begin

end;

procedure TMathVisitor.VisitFuncApp(ANode: TMath_FuncApp);
begin

end;

procedure TMathVisitor.VisitUMinus(ANode: TMath_UMinus);
begin

end;

procedure TMathVisitor.VisitVar(ANode: TMath_Var);
begin

end;


{ TMathFactory }

function TMathFactory.MakeBinExp(ALeft: TMath; AOp: TMath_BinOp;
  ARight: TMath): TMath_BinExp;
begin
  Result := TMath_BinExp.Create(ALeft, AOP, ARight);
end;

function TMathFactory.MakeBinOp(AOpKind: TBinOpKind): TMath_BinOp;
begin
  Result := TMath_BinOp.Create(AOpKind);
end;

function TMathFactory.MakeConst(AVal: Integer): TMath_Const;
begin
  Result := TMath_Const.Create(AVal);
end;

function TMathFactory.MakeFunc(AFuncKind: TFuncKind): TMath_Func;
begin
  Result := TMath_Func.Create(AFuncKind);
end;

function TMathFactory.MakeFuncApp(AFunc: TMath_Func;
  AArg: TMath): TMath_FuncApp;
begin
  Result := TMath_FuncApp.Create(AFunc, AArg);
end;

function TMathFactory.MakeHole: TMath_Hole;
begin
  Result := TMath_Hole.Create;
end;

function TMathFactory.MakeMeta(AName: String): TMath_Meta;
begin
  Result := TMath_Meta.Create(AName);
end;

function TMathFactory.MakeUMinus(AArg: TMath): TMath_UMinus;
begin
  Result := TMath_UMinus.Create(AArg);
end;

function TMathFactory.MakeVar(AName: String): TMath_Var;
begin
  Result := TMath_Var.Create(AName);
end;

initialization

  VMathFactory := TMathFactory.Create;
  with VMathFactory do
  begin
    AddNodeClass(TMath_Hole);
    AddNodeClass(TMath_Meta);
    AddNodeClass(TMath_Const);
    AddNodeClass(TMath_Var);
    AddNodeClass(TMath_UMinus);
    AddNodeClass(TMath_BinExp);
    AddNodeClass(TMath_FuncApp);
    AddNodeClass(TMath_BinOp);
    AddNodeClass(TMath_Func);
  end;





end.
