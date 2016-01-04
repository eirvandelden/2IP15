unit MathRepr;

//{$MODE Delphi}

interface

uses
  Nodes, Repr, MyMath;

var
  VMathReprInfix: TStandardRepr;

implementation {==========================================}

initialization

  VMathReprInfix := TStandardRepr.Create;
  with VMathReprInfix do
  begin
    AddRep(TMath_Const  , 3, [ '' ]); // has data
    AddRep(TMath_Var    , 3, [ '' ]); // has data
    AddRep(TMath_UMinus , 2, [ '-' , '' ]);
    AddRep(TMath_BinOp  , 2, [ '' ]);
    AddRep(TMath_BinExp , 1, [ '(', '' , '', ')' ]);
    AddRep(TMath_Func   , 3, [ '' ]); // has data
    AddRep(TMath_FuncApp, 2, [ '', '.', '' ]);
  end;



end.
