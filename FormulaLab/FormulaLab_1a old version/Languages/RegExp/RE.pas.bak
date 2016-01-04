unit RE;

interface

uses
  SysUtils,
  Nodes, TreeVisitor;

{ This unit defines subclasses of TNode for representing the following
  signature:

  Data = Char | String

  Sorts = RE
    Prop = Eps | Id | Seq | Dot | Stick | Range | Star | Plus
      Eps     = []
      Id      = D[name: Char]
      Seq     = D[val: String]
      Dot     = S[left: RE, right: RE]
      Stick   = S[left: RE, right: RE]
      Range   = D[low: Char, high: Char]
      Star    = S[arg: RE]
      Plus    = S[arg: RE]
}

const
  // regular expression kinds
  rkEps   =  11;
  rkId    =  12;
  rkDot   =  13;
  rkStick =  14;
  rkStar  =  15;
  rkSeq   =  16;
  rkRange =  17;
  rkPlus  =  18;

type
  TREKind = rkEps..rkPlus;

  TRE =
  class(TNode)
  end;

  TRE_Eps =
  class(TRE)
    class function GetKind: TNodeKind; override;
    class function GetNrofSons: Integer; override;
    function    GetSon(I: Integer): TNode; override;
    procedure   SetSon(I: Integer; ANode: TNode); override;
    class function OpName: String; override;
  end;

  TRE_Id =
  class(TRE)
    private
      FName: Char;
    public
      constructor Create(AName: Char);
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      function    GetData: String; override;
      class function Hasdata: Boolean; override;
    end;

  TRE_Seq =
  class(TRE)
    private
      FName: String;
    public
      constructor Create(AName: String);
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      function    GetData: String; override;
      class function Hasdata: Boolean; override;
    end;

  TRE_Dot =
  class(TRE)
    private
      FLeft : TRE;
      FRight: TRE;
    public
      constructor Create(ALeft, ARight: TRE);
      destructor  Destroy; override;
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      property    Left: TRE read FLeft;
      property    Right: TRE read FRight;
  end;

  TRE_Stick =
  class(TRE)
    private
      FLeft : TRE;
      FRight: TRE;
    public
      constructor Create(ALeft, ARight: TRE);
      destructor  Destroy; override;
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      property    Left: TRE read FLeft;
      property    Right: TRE read FRight;
  end;

  TRE_Range =
  class(TRE)
    private
      FLeft : Char;
      FRight: Char;
    public
      constructor Create(ALeft, ARight: Char);
      destructor  Destroy; override;
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      property    Left: Char read FLeft;
      property    Right: Char read FRight;
      function    GetData: String; override;
      class function HasData: Boolean; override;
  end;

  TRE_Star =
  class(TRE)
    private
      FArg: TRE;
    public
      constructor Create(AArg: TRE);
      destructor  Destroy; override;
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      property    Arg: TRE read FArg;
  end;

  TRE_Plus =
  class(TRE)
    private
      FArg: TRE;
    public
      constructor Create(AArg: TRE);
      destructor  Destroy; override;
      class function GetKind: TNodeKind; override;
      class function GetNrofSons: Integer; override;
      function    GetSon(I: Integer): TNode; override;
      procedure   SetSon(I: Integer; ANode: TNode); override;
      class function OpName: String; override;
      property    Arg: TRE read FArg;
  end;

  TREVisitor =
  class(TTreeVisitor)
    procedure Visit(ANode: TNode); override;
    procedure VisitEps  (ANode: TRE_Eps  ); virtual;
    procedure VisitId   (ANode: TRE_Id   ); virtual;
    procedure VisitDot  (ANode: TRE_Dot  ); virtual;
    procedure VisitStick(ANode: TRE_Stick); virtual;
    procedure VisitStar (ANode: TRE_Star ); virtual;
    procedure VisitSeq  (ANode: TRE_Seq  ); virtual;
    procedure VisitRange(ANode: TRE_Range); virtual;
    procedure VisitPlus (ANode: TRE_Plus ); virtual;
  end;



implementation{===========================================}


{ TRE_Eps }

class function TRE_Eps.GetKind: TNodeKind;
begin
  Result := rkEps;
end;

class function TRE_Eps.GetNrofSons: Integer;
begin
  Result := 0;
end;

function TRE_Eps.GetSon(I: Integer): TNode;
begin
  raise EGetSonIndex.Create('Node error: Eps.GetSon with index ' + IntToStr(I));
end;

class function TRE_Eps.OpName: String;
begin
  Result := 'Eps';
end;

procedure TRE_Eps.SetSon(I: Integer; ANode: TNode);
begin
  raise ESetSonIndex('Node error: Eps.SetSon with index ' + IntToStr(I));
end;

{ TRE_Id }

constructor TRE_Id.Create(AName: Char);
begin
  inherited Create;
  FName := Aname;
end;

class function TRE_Id.GetKind: TNodeKind;
begin
  Result := rkId;
end;

function TRE_Id.GetData: String;
begin
  Result := FName;
end;

class function TRE_Id.OpName: String;
begin
  Result := 'Id';
end;

function TRE_Id.GetSon(I: Integer): TNode;
begin
  raise EGetSonIndex('Node error: Id.GetSon with index ' + IntToStr(I));
end;

class function TRE_Id.GetNrofSons: Integer;
begin
  Result := 0;
end;

procedure TRE_Id.SetSon(I: Integer; ANode: TNode);
begin
  raise ESetSonIndex('Node error: Id.SetSon with index ' + IntToStr(I));
end;

class function TRE_Id.Hasdata: Boolean;
begin
  Result := true;
end;

{ TRE_Seq }

constructor TRE_Seq.Create(AName: String);
begin
  inherited Create;
  FName := Aname;
end;

class function TRE_Seq.GetKind: TNodeKind;
begin
  Result := rkSeq;
end;

function TRE_Seq.GetData: String;
begin
  Result := '"' + FName + '"';
end;

function TRE_Seq.GetSon(I: Integer): TNode;
begin
  raise EGetSonIndex('Node error: Seq.GetSon with index ' + IntToStr(I));
end;

class function TRE_Seq.GetNrofSons: Integer;
begin
  Result := 0;
end;

procedure TRE_Seq.SetSon(I: Integer; ANode: TNode);
begin
  raise ESetSonIndex('Node error: Seq.SetSon with index ' + IntToStr(I));
end;

class function TRE_Seq.OpName: String;
begin
  Result := 'Seq';
end;

class function TRE_Seq.Hasdata: Boolean;
begin
  Result := true;
end;

{ TRE_Dot }

constructor TRE_Dot.Create(ALeft, ARight: TRE);
begin
  inherited create;
  FLeft := ALeft;
  FRight := ARight;
end;

destructor TRE_Dot.Destroy;
begin
  FLeft.Free;
  FRight.Free;
  inherited Destroy;
end;

class function TRE_Dot.GetKind: TNodeKind;
begin
  Result := rkDot;
end;

class function TRE_Dot.GetNrofSons: Integer;
begin
  Result := 2;
end;

function TRE_Dot.GetSon(I: Integer): TNode;
begin
  case I of
    0: Result := FLeft;
    1: Result := FRight
  else
    raise EGetSonIndex('Node error: Dot.GetSon with index ' + IntToStr(I))
  end;
end;

procedure TRE_Dot.SetSon(I: Integer; ANode: TNode);
begin
  case I of
    0: FLeft := ANode as TRE;
    1: FRight := ANode as TRE
  else
    raise ESetSonIndex('Node error: Dot.SetSon with index ' + IntToStr(I))
  end;
end;

class function TRE_Dot.OpName: String;
begin
  Result := 'Dot';
end;

{ TRE_Stick }

constructor TRE_Stick.Create(ALeft, ARight: TRE);
begin
  inherited Create;
  FLeft := Aleft;
  FRight := ARight;
end;

destructor TRE_Stick.Destroy;
begin
  FLeft.Free;
  FRight.Free;
  inherited Destroy;
end;

class function TRE_Stick.GetKind: TNodeKind;
begin
  Result := rkStick;
end;

class function TRE_Stick.GetNrofSons: Integer;
begin
  Result := 2;
end;

function TRE_Stick.GetSon(I: Integer): TNode;
begin
  case I of
    0: Result := FLeft;
    1: Result := FRight
  else
    raise EGetSonIndex('Node error: Stick.GetSon with index ' + IntToStr(I))
  end;
end;

procedure TRE_Stick.SetSon(I: Integer; ANode: TNode);
begin
  case I of
    0: FLeft := ANode as TRE;
    1: FRight := ANode as TRE
  else
    raise EGetSonIndex('Node error: Stick.SetSon with index ' + IntToStr(I))
  end;
end;

class function TRE_Stick.OpName: String;
begin
  Result := 'Stick';
end;

{ TRE_Range }

constructor TRE_Range.Create(ALeft, ARight: Char);
begin
  inherited Create;
  FLeft := Aleft;
  FRight := ARight;
end;

destructor TRE_Range.Destroy;
begin
  inherited Destroy;
end;

class function TRE_Range.GetKind: TNodeKind;
begin
  Result := rkRange;
end;

function TRE_Range.GetData: String;
begin
  Result := '[' + FLeft + '-' + FRight + ']';
end;

class function TRE_Range.GetNrofSons: Integer;
begin
  Result := 0;
end;

function TRE_Range.GetSon(I: Integer): TNode;
begin
  raise EGetSonIndex('Node error: Range.GetSon with index ' + IntToStr(I))
end;

procedure TRE_Range.SetSon(I: Integer; ANode: TNode);
begin
  raise ESetSonIndex('Node error: Id.SetSon with index ' + IntToStr(I));
end;

class function TRE_Range.OpName: String;
begin
  Result := 'Range';
end;

class function TRE_Range.HasData: Boolean;
begin
  Result := true;
end;

{ TRE_Star }

constructor TRE_Star.Create(AArg: TRE);
begin
  inherited Create;
  FArg := AArg;
end;

destructor TRE_Star.Destroy;
begin
  FArg.Free;
  inherited Destroy;
end;

class function TRE_Star.GetKind: TNodeKind;
begin
  Result := rkStar;
end;

class function TRE_Star.GetNrofSons: Integer;
begin
  Result := 1;
end;

function TRE_Star.GetSon(I: Integer): TNode;
begin
  case I of
    0: Result := FArg
  else
    raise EGetSonIndex('Node error: Star.GetSon with index ' + IntToStr(I))
  end;
end;

procedure TRE_Star.SetSon(I: Integer; ANode: TNode);
begin
  case I of
    0: FArg := ANode as TRE
  else
    raise ESetSonIndex('Node error: Star.SetSon with index ' + IntToStr(I))
  end;
end;

class function TRE_Star.OpName: String;
begin
  Result := 'Star';
end;

{ TRE_Plus }

constructor TRE_Plus.Create(AArg: TRE);
begin
  inherited Create;
  FArg := AArg;
end;

destructor TRE_Plus.Destroy;
begin
  FArg.Free;
  inherited Destroy;
end;

class function TRE_Plus.GetKind: TNodeKind;
begin
  Result := rkPlus;
end;

class function TRE_Plus.GetNrofSons: Integer;
begin
  Result := 1;
end;

function TRE_Plus.GetSon(I: Integer): TNode;
begin
  case I of
    0: Result := FArg
  else
    raise EGetSonIndex('Node error: Plus.GetSon with index ' + IntToStr(I))
  end;
end;

procedure TRE_Plus.SetSon(I: Integer; ANode: TNode);
begin
  case I of
    0: FArg := ANode as TRE
  else
    raise ESetSonIndex('Node error: Plus.SetSon with index ' + IntToStr(I))
  end;
end;

class function TRE_Plus.OpName: String;
begin
  Result := 'Plus';
end;

 { TREVisitor }

procedure TREVisitor.Visit(ANode: TNode);
begin
  // Dispatch by means of ANode.GetKind
  case ANode.GetKind of
  rkEps   : VisitEps  (ANode as TRE_Eps  );
  rkId    : VisitId   (ANode as TRE_Id   );
  rkDot   : VisitDot  (ANode as TRE_Dot  );
  rkStick : VisitStick(ANode as TRE_Stick);
  rkStar  : VisitStar (ANode as TRE_Star );
  rkSeq   : VisitSeq  (ANode as TRE_Seq  );
  rkRange : VisitRange(ANode as TRE_Range);
  rkPlus  : VisitPlus (ANode as TRE_Plus );
  else
    raise ENodeKind.Create('Unexpected NodeKind in TREVisitor');
  end;
end;

procedure TREVisitor.VisitEps  (ANode: TRE_Eps  );
begin
end;

procedure TREVisitor.VisitId   (ANode: TRE_Id   );
begin
end;

procedure TREVisitor.VisitDot  (ANode: TRE_Dot  );
begin
end;

procedure TREVisitor.VisitStick(ANode: TRE_Stick);
begin
end;

procedure TREVisitor.VisitStar (ANode: TRE_Star );
begin
end;

procedure TREVisitor.VisitSeq  (ANode: TRE_Seq  );
begin
end;

procedure TREVisitor.VisitRange(ANode: TRE_Range);
begin
end;

procedure TREVisitor.VisitPlus (ANode: TRE_Plus );
begin
end;


end.
