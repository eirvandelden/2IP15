unit PropRepr;

//{$MODE Delphi}

interface

uses
  Nodes, Repr, Prop;

var
  VPropReprInfix: TStandardRepr;

implementation {==========================================}

initialization

  VPropReprInfix := TStandardRepr.Create;
  with VPropReprInfix do
  begin
    AddRep(TProp_Const, 4, [ '' ]); // has data
    AddRep(TProp_Var  , 4, [ '' ]); // has data
    AddRep(TProp_Not  , 3, [ '~' , '' ]);
    AddRep(TProp_And  , 2, [ '(', '/\' , ')' ]);
    AddRep(TProp_Or   , 2, [ '(', '\/' , ')' ]);
    AddRep(TProp_Imp  , 1, [ '(', '=>' , ')' ]);
    AddRep(TProp_Equiv, 1, [ '(', '<=>', ')' ]);
  end;



end.
