unit RERewrite;

interface

uses
  Rewrite,
  RE; 

var
  VREMatcher: TMatcher;

implementation //===============================================================


initialization //===============================================================

  VREMatcher := TMatcher.Create;
  with VREMatcher do
  begin
    AddRule(TRule.Create(
      'Dot Left Identity',
      TRE_Dot.Create(
        TRE_Eps.Create,
        TRE_Meta.Create('A')),
      TRE_Meta.Create('A')
    ));

    AddRule(TRule.Create(
      'Dot Right Identity',
      TRE_Dot.Create(
        TRE_Meta.Create('A'),
        TRE_Eps.Create),
      TRE_Meta.Create('A')
    ));

    AddRule(TRule.Create(
      'Dot Associativity',
      TRE_Dot.Create(
        TRE_Meta.Create('A'),
        TRE_Dot.Create(
          TRE_Meta.Create('B'),
          TRE_Meta.Create('C'))),
      TRE_Dot.Create(
        TRE_Dot.Create(
          TRE_Meta.Create('A'),
          TRE_Meta.Create('B') ),
        TRE_Meta.Create('C') )
    ));

    AddRule(TRule.Create(
      'Stick Idempotency',
      TRE_Stick.Create(
        TRE_Meta.Create('A'),
        TRE_Meta.Create('A')),
      TRE_Meta.Create('A')
    ));

    AddRule(TRule.Create(
      'Stick Commutativity',
      TRE_Stick.Create(
        TRE_Meta.Create('A'),
        TRE_Meta.Create('B')),
      TRE_Stick.Create(
        TRE_Meta.Create('B'),
        TRE_Meta.Create('A'))
    ));

    AddRule(TRule.Create(
      'Stick Associativity',
      TRE_Stick.Create(
        TRE_Meta.Create('A'),
        TRE_Stick.Create(
          TRE_Meta.Create('B'),
          TRE_Meta.Create('C'))),
      TRE_Stick.Create(
        TRE_Stick.Create(
          TRE_Meta.Create('A'),
          TRE_Meta.Create('B') ),
        TRE_Meta.Create('C') )
    ));

    AddRule(TRule.Create(
      'Left Distributivity',
      TRE_Dot.Create(
        TRE_Meta.Create('A'),
        TRE_Stick.Create(
          TRE_Meta.Create('B'),
          TRE_Meta.Create('C'))),
      TRE_Stick.Create(
        TRE_Dot.Create(
          TRE_Meta.Create('A'),
          TRE_Meta.Create('B') ),
        TRE_Dot.Create(
          TRE_Meta.Create('A'),
          TRE_Meta.Create('C') ) )
    ));

    AddRule(TRule.Create(
      'Right Distributivity',
      TRE_Dot.Create(
        TRE_Stick.Create(
          TRE_Meta.Create('A'),
          TRE_Meta.Create('B')),
        TRE_Meta.Create('C')
      ),
      TRE_Stick.Create(
        TRE_Dot.Create(
          TRE_Meta.Create('A'),
          TRE_Meta.Create('C') ),
        TRE_Dot.Create(
          TRE_Meta.Create('B'),
          TRE_Meta.Create('C') ) )
    ));

    AddRule(TRule.Create(
      'Star Unfold',
      TRE_Star.Create(
        TRE_Meta.Create('A')),
      TRE_Stick.Create(
        TRE_Eps.Create,
        TRE_Plus.Create(
          TRE_Meta.Create('A')) )
    ));

    AddRule(TRule.Create(
      'Plus Unfold',
      TRE_Plus.Create(
        TRE_Meta.Create('A')),
      TRE_Dot.Create(
        TRE_Meta.Create('A'),
        TRE_Star.Create(
          TRE_Meta.Create('A')) )
    ));

  end;


end.
