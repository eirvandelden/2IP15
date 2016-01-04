unit PropRewrite;

interface

uses
  TMatcher,
  Prop;

var
  VPropmatcher: TMatcher;

implementation //===============================================================


initialization //===============================================================

  VPropMatcher := TMatcher.Create;
  with VPropMatcher, VPropFactory do
  begin
    AddRule(TRule.Create(
      'Comm and',
      MakeAnd(
        MakeMeta('P'),
        Makemeta('Q')),
      MakeAnd(
        MakeMeta('Q'),
        MakeMeta('P'))
    ));

    AddRule(TRule.Create(
      'Comm or',
      MakeOr(
        MakeMeta('P'),
        Makemeta('Q')),
      MakeOr(
        MakeMeta('Q'),
        MakeMeta('P'))
    ));

    AddRule(TRule.Create(
      'Comm equiv',
      MakeEquiv(
        MakeMeta('P'),
        Makemeta('Q')),
      MakeEquiv(
        MakeMeta('Q'),
        MakeMeta('P'))
    ));

    AddRule(TRule.Create(
      'Null left or',
      MakeOr(
        MakeConst(vkTrue),
        MakeMeta('P')),
      MakeConst(vkTrue),
    ));

    AddRule(TRule.Create(
      'Null right or',
      MakeOr(
        MakeMeta('P'),
        MakeConst(vkTrue)),
      MakeConst(vkTrue)
    ));

    AddRule(TRule.Create(
      'Null left and',
      MakeAnd(
        MakeConst(vkFalse),
        MakeMeta('P')),
      MakeConst(vkFalse)
    ));

    AddRule(TRule.Create(
      'Null right and',
      MakeAnd(
        MakeMeta('P'),
        MakeConst(vkFalse)),
      MakeConst(vkFalse)
    ));

    AddRule(TRule.Create(
      'Unit left or',
      MakeOr(
        MakeConst(vkFalse),
        MakeMeta('P')),
      MakeMeta('P'),
    ));

    AddRule(TRule.Create(
      'Unit right or',
      MakeOr(
        MakeMeta('P'),
        MakeConst(vkFalse)),
      MakeMeta('P')
    ));

    AddRule(TRule.Create(
      'Unit left and',
      MakeAnd(
        MakeConst(vkTrue),
        MakeMeta('P')),
      MakeMeta('P')
    ));

    AddRule(TRule.Create(
      'Unit right and',
      MakeAnd(
        MakeMeta('P'),
        MakeConst(vkTrue)),
      MakeMeta('P')
    ));

    AddRule(TRule.Create(
      'Double negation',
      MakeNot(
        MakeNot(
          Makemeta('P'))),
      MakeMeta('P')
    ));

    AddRule(TRule.Create(
      'Exclude or',
      MakeOr(
        Makemeta('P'),
        MakeNot(
          Makemeta('P'))),
      MakeConst(vkTrue)
    ));

    AddRule(TRule.Create(
      'Exclude and',
      MakeAnd(
        Makemeta('P'),
        MakeNot(
          Makemeta('P'))),
      MakeConst(vkFalse)
    ));

    AddRule(Trule.Create(
      'De Morgan 1',
      MakeNot(
        MakeOr(
          MakeMeta('P'),
          MakeMeta('Q'))),
      MakeAnd(
        MakeNot(
          MakeMeta('P')),
        MakeNot(
          Makemeta('Q')))
    ));

    AddRule(Trule.Create(
      'De Morgan 2',
      MakeNot(
        MakeAnd(
          MakeMeta('P'),
          MakeMeta('Q'))),
      MakeOr(
        MakeNot(
          MakeMeta('P')),
        MakeNot(
          Makemeta('Q')))
    ));

    AddRule(TRule.Create(
      'Left distr and or',
      MakeAnd(
        MakeMeta('P'),
        MakeOr(
          MakeMeta('Q'),
          Makemeta('R'))),
      MakeOr(
        MakeAnd(
          MakeMeta('P'),
          MakeMeta('Q')),
        MakeAnd(
          MakeMeta('P'),
          MakeMeta('R')))
    ));

    AddRule(TRule.Create(
      'Left distr or and',
      MakeOr(
        MakeMeta('P'),
        MakeAnd(
          MakeMeta('Q'),
          Makemeta('R'))),
      MakeAnd(
        MakeOr(
          MakeMeta('P'),
          MakeMeta('Q')),
        MakeOr(
          MakeMeta('P'),
          MakeMeta('R')))
    ));

    AddRule(TRule.Create(
      'Left distr or equiv',
      MakeOr(
        MakeMeta('P'),
        MakeEquiv(
          MakeMeta('Q'),
          Makemeta('R'))),
      MakeEquiv(
        MakeOr(
          MakeMeta('P'),
          MakeMeta('Q')),
        MakeOr(
          MakeMeta('P'),
          MakeMeta('R')))
    ));

    AddRule(Trule.Create(
      'Implication',
      MakeImp(
        MakeMeta('P'),
        MakeMeta('Q')),
      MakeOr(
        MakeNot(
          MakeMeta('P')),
        MakeMeta('Q'))
    ));

  AddRule(TRule.Create(
    'Equivalence',
    MakeEquiv(
      MakeMeta('P'),
      MakeMeta('Q')),
    MakeAnd(
      MakeImp(
        MakeMeta('P'),
        MakeMeta('Q')),
      MakeImp(
        MakeMeta('Q'),
        MakeMeta('P')))
  ));

  end;{with}


end.
