unit Nodes;

interface
uses
  Classes, SysUtils;

type

  TNodeKind = Integer;

  TNode =
  class
    protected
      FAnno: TStringList;
    public
      constructor Create;
      constructor CreateArgs(const AArgs: array of TNode);
      destructor  Destroy; override;
      class function GetKind: TNodeKind; virtual; abstract;
      class function GetNrofSons: Integer; virtual; abstract;
      function    GetSon(I: Integer): TNode; virtual; abstract;
      procedure   SetSon(I: Integer; ANode: TNode); virtual; abstract;
      class function OpName: String; virtual; abstract;
      function    HasData: Boolean;
      function    GetData: String; virtual;
      procedure   SetAnno(AName: String; AObject: TObject);
      function    HasAnno(AName: String): Boolean;
      function    GetAnno(AName: String): TObject;
      procedure   ClearAllAnno;
  end;

  TNodeClass = class of TNode;

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

constructor TNode.CreateArgs(const AArgs: array of TNode);
var
  I: Integer;
begin
  Create;
  for I := 0 to High(AArgs) do SetSon(I, AArgs[I]);
end;
  
destructor TNode.Destroy;
begin
  FAnno.Free;
  inherited Destroy;
end;

function TNode.HasData: Boolean;
begin
  Result := GetData <> '';
end;

function TNode.GetData: String;
begin
  Result := '';
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



end.
