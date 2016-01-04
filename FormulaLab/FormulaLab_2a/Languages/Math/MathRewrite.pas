unit MathRewrite;

interface

uses
  Rewrite,
  MyMath;

var
  VMathMatcher: TMatcher;

implementation //===============================================================


initialization //===============================================================

  VMathMatcher := TMatcher.Create;
  with VMathMatcher, VMathFactory do
  begin
    AddRule(TRule.Create(
      'Left unit add',
      MakeBinExp(
        MakeConst(0),
        MakeBinOp(boPlus),
        MakeMeta('A')),
      MakeMeta('A')
    ));

    AddRule(TRule.Create(
      'Right unit add',
      MakeBinExp(
        MakeMeta('A'),
        MakeBinOp(boPlus),
        MakeConst(0)),
      MakeMeta('A')
    ));

    AddRule(TRule.Create(
      'Comm add',
      MakeBinExp(
        MakeMeta('A'),
        MakeBinOp(boPlus),
        Makemeta('B')),
      MakeBinExp(
        MakeMeta('B'),
        MakeBinOp(boPlus),
        MakeMeta('A'))
    ));

    AddRule(TRule.Create(
      'Left zero mul',
      MakeBinExp(
        MakeConst(0),
        MakeBinOp(boTimes),
        MakeMeta('A')),
      MakeConst(0)
    ));

    AddRule(TRule.Create(
      'Left zero mul',
      MakeBinExp(
        MakeMeta('A'),
        MakeBinOp(boTimes),
        MakeConst(0)),
      MakeConst(0)
    ));

    AddRule(TRule.Create(
      'Left unit mul',
      MakeBinExp(
        MakeConst(1),
        MakeBinOp(boTimes),
        MakeMeta('A')),
      MakeMeta('A')
    ));

    AddRule(TRule.Create(
      'Right unit mul',
      MakeBinExp(
        MakeMeta('A'),
        MakeBinOp(boTimes),
        MakeConst(1)),
      MakeMeta('A')
    ));

    AddRule(TRule.Create(
      'Comm mul',
      MakeBinExp(
        MakeMeta('A'),
        MakeBinOp(boTimes),
        Makemeta('B')),
      MakeBinExp(
        MakeMeta('B'),
        MakeBinOp(boTimes),
        MakeMeta('A'))
    ));

    AddRule(TRule.Create(
      'Left distr mul add',
      MakeBinExp(
        MakeMeta('A'),
        MakeBinOp(boTimes),
        MakeBinExp(
          MakeMeta('B'),
          MakeBinOp(boPlus),
          Makemeta('C'))),
      MakeBinExp(
        MakeBinExp(
          MakeMeta('A'),
          MakeBinOp(boTimes),
          MakeMeta('B')),
        MakeBinOp(boPlus),
        MakeBinExp(
          MakeMeta('A'),
          MakeBinOp(boTimes),
          MakeMeta('C')))
    ));

  end;


end.
