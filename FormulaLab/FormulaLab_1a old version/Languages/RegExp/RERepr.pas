unit RERepr;

//{$MODE Delphi}

interface

uses
  Nodes, Repr, RE;

var
  VREReprInfix: TStandardRepr;

implementation {==========================================}

initialization

  VREReprInfix := TStandardRepr.Create;
  with VReReprInfix do
  begin
    AddRep(TRE_Eps  , 5, [ '&' ]);
    AddRep(TRE_Id   , 5, [ '']); // has data
    AddRep(TRE_Dot  , 2, [ '(', '.', ')' ]);
    AddRep(TRE_Stick, 1, [ '(', '|', ')' ]);
    AddRep(TRE_Star , 3, [ '' , '*' ]);
    AddRep(TRE_Plus , 4, [ '' , '+' ]);
    AddRep(TRE_Seq  , 5, [ '']); // has data
    AddRep(TRE_Range, 5, [ '']); // has data
  end;



end.
