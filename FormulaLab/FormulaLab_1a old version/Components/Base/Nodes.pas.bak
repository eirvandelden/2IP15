unit Nodes;

interface
uses
  Classes, SysUtils;

type

  TNodeKind = Integer;

  TNode =
  class(TObject)
    protected
      FAnno: TStringList;
    public
      // construction/destruction
      constructor Create; virtual;
      constructor CreateList(const AList: array of TNode);
      destructor  Destroy; override;

      class function GetKind: TNodeKind; virtual; abstract;
      class function OpName: String; virtual; abstract;

      // subtrees
      class function GetNrofSons: Integer; virtual; abstract;
      function    GetSon(I: Integer): TNode; virtual; abstract;
      procedure   SetSon(I: Integer; ANode: TNode); virtual; abstract;

      // data
      class function HasData: Boolean; virtual;
      function    GetData: String; virtual;
      procedure   SetData(AString: String); virtual;

      function    Clone: TNode;

      // queries
      class function IsHole: Boolean; virtual;
      class function IsMeta: Boolean; virtual;
      function    IsClosed: Boolean; virtual;

      // annotation
      procedure   SetAnno(AName: String; AObject: TObject);
      function    HasAnno(AName: String): Boolean;
      function    GetAnno(AName: String): TObject;
      procedure   ClearAllAnno;
  end;

  TNodeClass = class of TNode;

  TNodeFactory =
  class(TObject)
  public
    function  MakeHole: TNode; virtual; abstract;
    function  MakeNode(AName: String; AData: String): TNode; virtual; abstract;
    function  MakeNodeWithHoles(AName: String; AData: string): TNode; virtual;
    procedure ReturnTree(ATree: TNode); virtual; abstract;
    // more
  end;

  TSimpleNodeFactory =
  class(TNodeFactory)
  protected
    FList: TStringList;
    function GetNodeClass(AName: String): TNodeClass;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure AddNodeClass(AClass: TNodeClass);
    function  MakeHole: TNode; override;
    function  MakeNode(AName: String; AData: String): TNode; override;
    procedure ReturnTree(ATree: TNode); override;
  end;

  ENodeError =
  class(Exception)
  end;

  ESetSonIndex =
  class(ENodeError)
  end;

  EGetSonIndex =
  class(ENodeError)
  end;

  EGetAnno =
  class(ENodeError)
  end;

  ENodeKind =
  class(ENodeError)
  end;

implementation {==========================================}

constructor TNode.Create;
begin
  inherited Create;
  FAnno := TStringList.Create;
end;

constructor TNode.CreateList(const AList: array of TNode);
var
  I: Integer;
begin
  Create;
  for I := 0 to High(AList) do SetSon(I, AList[I]);
end;
  
destructor TNode.Destroy;
begin
  FAnno.Free;
  inherited Destroy;
end;

class function TNode.HasData: Boolean;
begin
  Result := false;
end;

function TNode.GetData: String;
begin
  Result := '';
end;      

procedure TNode.SetData(AString: String);
begin
end;

function TNode.Clone: TNode;
var
  I: Integer;
begin
  Result := ClassType.Create as TNode;
  Result.SetData(GetData);
  for I := 0 to GetNrOfSons - 1 do
    Result.SetSon(I, GetSon(I).Clone);
end;

class function TNode.IsHole: Boolean;
begin
  Result := false;
end;

class function TNode.IsMeta: Boolean;
begin
  Result := false;
end;

procedure TNode.SetAnno(AName: String; AObject: TObject);
var
  I: Integer;
begin
  I := FAnno.IndexOf(AName);
  if I = -1
  then FAnno.AddObject(AName, Aobject)
  else FAnno.Objects[I] := AObject;
end;

function TNode.HasAnno(AName: String): Boolean;
begin
  Result := FAnno.Indexof(AName) <> -1;
end;

function TNode.GetAnno(AName: String): TObject;
var
  I: Integer;
begin
  I := FAnno.IndexOf(AName);
  if I = -1
  then raise EGetAnno.Create('Error in GetAnno with argument: '+ AName)
  else Result := FAnno.Objects[I];
end;

procedure TNode.ClearAllAnno;
begin
  FAnno.Clear;
end;


{ TNodeFactory }

function TNodeFactory.MakeNodeWithHoles(AName: String; AData: string): TNode;
var
  I: Integer;
begin
  Result := MakeNode(AName, AData);
  with Result do
    for I := 0 to GetNrOfSons - 1 do
      SetSon(I, MakeHole);
end;

{Auxiliary class used by TSimpleNodeFactory}
type
  TNC =
  class
    FNodeClass: TNodeClass;
  end;

{ TSimpleNodeFactory }

procedure TSimpleNodeFactory.AddNodeClass(AClass: TNodeClass);
var
  VNC: TNC;
begin
  if FList.IndexOf(AClass.OpName) <> -1
  then raise Exception.Create('TSimpleNodefactory.AddNodeClass: Name added twice');
  VNC := TNC.Create;
  VNC.FNodeClass := AClass;
  FList.AddObject(AClass.OpName, VNC);
end;

constructor TSimpleNodeFactory.Create;
begin
  inherited Create;
  FList := TStringList.Create;
end;

destructor TSimpleNodeFactory.Destroy;
begin
  FList.Free;
  inherited;
end;

function TSimpleNodeFactory.GetNodeClass(AName: String): TNodeClass;
var
  I: Integer;
begin
  I := FList.IndexOf(AName);
  if I = -1
  then raise Exception.Create('TSimpleNodeFactory.GetNodeClass: Name not found');
  Result := (FList.Objects[I] as TNC).FNodeClass;
end;

function TSimpleNodeFactory.MakeHole: TNode;
begin
  Result := MakeNode('??', '');
end;

function TSimpleNodeFactory.MakeNode(AName: String; AData: String): TNode;
begin
  Result := GetNodeClass(AName).Create; //N.B. virtual constructor call
  Result.SetData(AData);
end;

procedure TSimpleNodeFactory.ReturnTree(ATree: TNode);
begin
  ATree.Free;
end;

function TNode.IsClosed: Boolean;
var
  I: Integer;
begin
  Result := true;
  if IsHole
  then Result := false
  else
    for I := 0 to GetnrOfSons - 1 do
      if not GetSon(I).IsClosed
      then Result := false;
end;

end.
