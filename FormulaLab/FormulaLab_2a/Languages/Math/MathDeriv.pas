unit MathDeriv;

interface

uses
  MyMath;

  
function Deriv(ATree: TMath): TMath;
function Simplify(ATree: TMath): TMath;

implementation //===============================================================

uses
  SysUtils;

function Deriv(ATree: TMath): TMath;
begin
//  with VMathFactory do
//  Result := MakeVar('Dummy derivative');
  with VMathFactory do
    case ATree.GetKind of
      mkConst:
        begin
          Result := MakeConst(0);
        end;
      mkVar:
        begin
          if ATree.GetData = 'x'
          then Result := MakeConst(1)
          else Result := MakeConst(0);
        end;
      mkUMinus:
        begin
          with ATree as TMath_UMinus do
            Result := MakeUMinus(Deriv(Arg));
        end;
      mkBinExp:
        begin
          with ATree as TMath_BinExp do
            case Op.OpKind of
              boPlus:
                begin
                  Result := MakeBinExp(Deriv(Left), MakeBinOp(boPlus), Deriv(Right))
                end;
              boMinus:
                begin
                  Result := MakeBinExp(Deriv(Left), MakeBinOp(boMinus), Deriv(Right))
                end;
              boTimes:
                begin
                  Result :=
                    MakeBinExp(
                      MakeBinExp(Deriv(Left), MakeBinOp(boTimes), Right.Clone as TMath),
                      MakeBinOp(boPlus),
                      MakeBinExp(Left.Clone as TMath, MakeBinOp(boTimes), Deriv(Right))
                    );
                end;
              boDivide:
                begin
                  Result :=
                    MakeBinExp(
                      MakeBinExp(
                        MakeBinExp(Deriv(Left), MakeBinOp(boTimes), Right.Clone as TMath),
                        MakeBinOp(boMinus),
                        MakeBinExp(Left.Clone as TMath, MakeBinOp(boTimes), Deriv(Right))),
                      MakeBinOp(boDivide),
                      MakeBinExp(
                        Right.Clone as TMath,
                        MakeBinOp(boTimes),
                        Right.Clone as TMath)
                    );
                end
            end{case}
        end;
      mkFuncApp:
        begin
          with ATree as TMath_FuncApp do
            case Func.FuncKind of
              fkSin:
                begin
                  Result :=
                    MakeBinExp(
                      MakeFuncApp(MakeFunc(fkCos), Arg.Clone as TMath),
                      MakeBinOp(boTimes),
                      Deriv(Arg)
                    );
                end;
              fkCos:
                begin
                  Result :=
                    MakeBinExp(
                      MakeUMinus(
                        MakeFuncApp(MakeFunc(fkSin), Arg.Clone as TMath)),
                      MakeBinOp(boTimes),
                      Deriv(Arg)
                    );
                end;
              fkExp:
                begin
                  Result :=
                    MakeBinExp(
                      MakeFuncApp(MakeFunc(fkExp), Arg.Clone as TMath),
                      MakeBinOp(boTimes),
                      Deriv(Arg)
                    );
                end;
              fkLn:
                begin
                  Result :=
                    MakeBinExp(
                      Deriv(Arg),
                      MakeBinOp(boDivide),
                      Arg.Clone as TMath
                    );
                end
            end{case}
        end
    else
      raise Exception.Create('Deriv: unknown node kind');
    end;{case}
end;

function Simplify(ATree: TMath): TMath;
begin
  Result := ATree.Clone as TMath;
end;

end.
