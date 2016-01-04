unit Game;

interface

uses
  CardPiles;

type
  //----------------------------------------------------------------------------
  // TGame acts as a 'facade' for the solitaire game:
  // - It manages the various piles and their consistency
  // - It provides functions for accessing the piles
  // - It provides commands for the various moves of the game
  // - It provides functions for testing the preconditions of the moves
  // Short description of public operations:
  // - MovesCount            number of moves since begining of game
  // - Finished              is game finished (i.e. all suit piles complete) ?
  // - Deckpile              accessor
  // - DiscardPile           accessor
  // - SuitPile(ASuit)       accessor
  // - TableauPile(AIndex)   accessor
  //
  // - CanMoveCard           precondition for MoveCard
  // - CanMoveSubPile        precondition for MoveSubPile
  // - CanFlipTop            precondition for FlipTop
  //
  // - NewGame               start new game (collect cards, shuffle, and deal)
  // - NewCard               take card from deck and put it faceup on discard
  // - Recycle               take all cards from discard pile and put them
  //                         facedown on deck pile
  // - MoveCard(AFrom, ATo)  move a card from pile AFrom to pile ATo
  // - MoveSubPile(AIndex, AFrom, ATo) move subpile with indices at least AIndex
  //                         from pile AFrom to pile ATo
  // - FlipTop(APile)        flip card on top of pile APile
  //
  // Short description of protected operations
  // - Collect               collect all cards of the game facedown in deck pile
  // - Shuffle               shuffle cards in deck pile
  // - Deal                  deal cards from deck to start configuration
  //----------------------------------------------------------------------------
  TGame =
  class(TObject)
  protected
    FMovesCount: Integer;
    FDeckPile: TDeckPile;
    FDiscardPile: TDiscardPile;
    FSuitPiles: array[TSuit] of TSuitPile;
    FTableauPiles: array[1..7] of TTableauPile;

    procedure Collect;
    // pre: true
    // effect: collect cards from all piles face-down in FDeckPile
    procedure Shuffle;
    // pre: true
    // effect: shuffle FDeckPile
    procedure Deal;
    // pre: all cards in deck pile; all other piles empty
    // post:
    // (forall I: 1 <= I <= 7:
    //  - FTableauPiles[I].Count = I
    //  - (forall J: 0 <= J < FTableauPiles[I].Count -1:
    //         not FTableauPile[I].Card(J).FaceUp )
    //  - FTableauPiles[I].Top.FaceUp
    // )
    // remaining cards are all face-down in FDeckPile
  public
    // construction/destruction
    constructor Create;
    destructor Destroy; override;

    // queries/functions -------------------------------------------------------
    function MovesCount: Integer;
    // ret: number of NewCard, Recycle, MoveCard, MoveSubPile since game start
    function Finished: Boolean; virtual;
    // ret: (forall S in TSuit: SUitPile(S).IsComplete
    function DeckPile: TDeckPile;
    function DiscardPile: TDiscardPile;
    function SuitPile(ASuit: TSuit): TSuitPile;
    function TableauPile(AIndex: Integer): TTableauPile;

    // preconditions -----------------------------------------------------------
    function CanMoveCard(AFrom, ATo: TPile): Boolean;
    // ret:
    // (AFrom.PileKind in [pkDiscard, pkSuit, pkTableau]) and
    // (ATo.PileKind in [pkSuit, pkTableau]) and
    // not AFrom.IsEmpty and
    // ATo.Acceptable(AFrom.Top);
    function CanMoveSubPile(I: Integer; AFrom, ATo: TTableauPile): Boolean;
    // ret: (AFrom.DownCount <= I) and (I < AFrom.Count) and
    //      ATo.Acceptable(AFrom.Card(I));
    function CanFlipTop(APile: TTableauPile): Boolean;
    // ret: APile.CanFlipTop

    // commands/procedures -----------------------------------------------------
    procedure NewGame;
    // effect: collect all cards in deck; shuffle; deal
    procedure NewCard;
    // pre: not DeckPile.IsEmpty
    // effect: take card from DeckPile and put it faceup on DiscardPile
    procedure Recycle;
    // pre: true
    // effect: take all cards from DiscardPile and put them facedown on DeckPile
    procedure MoveCard(AFrom, ATo: TPile);
    // pre: CanMoveCard(AFrom, ATo)
    procedure MoveSubPile(I: Integer; AFrom, ATo: TTableauPile);
    // pre: CanMoveSubPile(I, AFrom, ATo)
    procedure FlipTop(APile: TTableauPile);
    // pre: CanFlipTop(APile)
  end;

implementation //===============================================================

uses
  SysUtils;

{ TGame }

function TGame.CanFlipTop(APile: TTableauPile): Boolean;
begin
//# BEGIN TODO body of TGame.CanFlipTop
{ VERVANG DIT DOOR EIGEN CODE }

{ True = APile.DownCount == APile.Count }
//Assert(not APile.IsEmpty , 'TGame.CanFlipTop.pre failed');

//Result := (APile.DownCount = APile.Count);
Result := APile.CanFlipTop;

//# END TODO
end;

function TGame.CanMoveCard(AFrom, ATo: TPile): Boolean;
var VCard: TCard;

begin
//# BEGIN TODO body of TGame.CanMoveCard
{ VERVANG DIT DOOR EIGEN CODE }
// ret:
// (AFrom.PileKind in [pkDiscard, pkSuit, pkTableau]) and
// (ATo.PileKind in [pkSuit, pkTableau]) and
// not AFrom.IsEmpty and
// ATo.Acceptable(AFrom.Top);
 {NIET IN TERMEN VAN CANMOVESUBPILE!}
 
 {zie schema in aantekeningen+tentamen}
 
 {Denk aan acceptable.}

 Result :=  (AFrom.PileKind in [pkDiscard, pkSuit, pkTableau]) and
            (ATo.PileKind in [pkSuit, pkTableau]) and
            (not AFrom.IsEmpty) and
            ATo.Acceptable(AFrom.Top);

//# END TODO
end;

function TGame.CanMoveSubPile(I: Integer; AFrom, ATo: TTableauPile): Boolean;
var VCard: TCard;
begin
//# BEGIN TODO body of TGame.CanMoveSubPile
{ VERVANG DIT DOOR EIGEN CODE }
// ret: (AFrom.DownCount <= I) and (I < AFrom.Count) and
//      ATo.Acceptable(AFrom.Card(I));


VCard := AFrom.Card(I);

Result := (AFrom.DownCount <= I) and 
          (I < AFrom.Count) and
          ATo.Acceptable( VCard );

//# END TODO
end;

procedure TGame.Collect;
var 
//  vPile: TPile;
  vCard: TCard;
  i,j: integer;
  s: TSuit;
  b: Boolean;

begin
//# BEGIN TODO body of TGame.Collect
{ VERVANG DIT DOOR EIGEN CODE }
// pre: true
// effect: collect cards from all piles face-down in FDeckPile

{voor alle bestaande piles de kaarten moven naar discard}
{via een aparte pile?}
{kan niet met MoveCard, ivm CanMoveCard}

{alle tableau piles langsgaan}
{alle suitpiles langsgaan}
{discardpile}


//*** Discard Pile ***
while not FDiscardPile.IsEmpty do
begin
    FDiscardPile.Remove( vCard );           // verwijder die kaart van Discard
    VCard.SetFaceUp(false);
    FDeckPile.Put( vCard );                     // stop kaart op hulp pile
end;  // end while


//*** TableauPiles ***
  for j := 1 to 7 do begin
    while not FTableauPiles[j].IsEmpty do
    begin
      FTableauPiles[j].Remove( vCard );           // verwijder die kaart van Discard
      VCard.SetFaceUp(false);
      // FTableauPiles[j].Put( vCard );                     // stop kaart op hulp pile
      FDeckPile.Put(vCard);
    end;  // end while
  end; //for j


//*** SuitPiles ***
  for s := suHeart to suSpade do begin                  // 4 suits
    while not FSuitPiles[s].IsEmpty do
    begin
      FSuitPiles[s].Remove( vCard );           // verwijder die kaart van Discard
      VCard.SetFaceUp(false);
      FSuitPiles[s].Put( vCard );                     // stop kaart op hulp pile
    end;  // end while
  end; // end for s


//# END TODO
end;

constructor TGame.Create;
var
  VSuit: TSuit;
  I: Integer;
begin
  inherited create;

  FMovesCount := 0;

  // create DeckPile with all cards
  FDeckPile := TDeckPile.Create;

  // create DiscardPile
  FDiscardPile := TDiscardPile.Create(24); // maxsize of discardpile = 24

  // create SuitPiles
  for VSuit := suHeart to suSpade
  do FSuitPiles[VSuit] := TSuitPile.Create(13, VSuit);

  // create TableauPiles
  for I := 1 to 7
  do FTableauPiles[I] := TTableauPile.Create(20);
    { maxsize of tableau pile = 20 (7 facedown, 13 faceup) }
end;

procedure TGame.Deal;
  var i,j: integer;
  vCard: TCard;
begin
//# BEGIN TODO body of TGame.Deal
{ VERVANG DIT DOOR EIGEN CODE }
// pre: all cards in deck pile; all other piles empty
// post:
// (forall I: 1 <= I <= 7:
//  - FTableauPiles[I].Count = I
//  - (forall J: 0 <= J < FTableauPiles[I].Count -1:
//         not FTableauPile[I].Card(J).FaceUp )
//  - FTableauPiles[I].Top.FaceUp
// )
// remaining cards are all face-down in FDeckPile

Assert((FDeckpile.Count = 52), 'FDeal fault, DeckPile not fully filled');

for i := 1 to 7 do begin
  for j := 1 to i  do begin
    {boveste kaart van Deckpile naar tableaupile}
//    vCard := FDeckPile.Top;
    FDeckPile.Remove( vCard );
    FTableauPiles[i].Put( vCard );

  end;

  FTableauPiles[i].FlipTop;

end;


//# END TODO
end;

function TGame.DeckPile: TDeckPile;
begin
  Result := FDeckPile;
end;

destructor TGame.Destroy;
var
  VCard: TCard;
  VSuit: TSuit;
  I: Integer;
begin
  // collect all cards in deck and free them
  Collect;
  while not FDeckPile.IsEmpty do
  begin
    FDeckPile.Remove(VCard);
    VCard.Free;
  end;
  //all cards freed, all piles empty

  // free deckpile and discardpile
  FDeckPile.Free;
  FDiscardPile.Free;

  // free suit piles
  for VSuit := suHeart to suSpade
  do FSuitPiles[VSuit].Free;

  // free tableau piles
  for I := 1 to 7
  do FTableauPiles[I].Free;

  inherited;
end;

function TGame.DiscardPile: TDiscardPile;
begin
  Result := FDiscardPile;
end;

function TGame.Finished: Boolean;
var i:integer;
begin
//# BEGIN TODO body of TGame.Finished
{ VERVANG DIT DOOR EIGEN CODE }
// ret: (forall S in TSuit: SUitPile(S).IsComplete

result := (FSuitPiles[suHeart].IsComplete and FSuitPiles[suDiamond].IsComplete and FSuitPiles[suSpade].IsComplete and FSuitPiles[suClub].IsComplete);

{ FSuitPiles[suHeart].IsComplete }

//# END TODO
end;

procedure TGame.FlipTop(APile: TTableauPile);
  var VCard:TCard;
begin
//# BEGIN TODO body of TGame.FlipTop
{ VERVANG DIT DOOR EIGEN CODE }

Assert(APile.CanFlipTop,'FFlipTop failed: illegal flip' );

  //VCard := TCard.Create;
  //APile.Remove( VCard );

  //VCard.Flip;

  //APile.Put( VCard );
   APile.FlipTop;
  {APile.Top.Flip;}


{iCard:= APile[FCount -1] 
 iCard.FaceUp := True;}

//# END TODO
end;

procedure TGame.MoveCard(AFrom, ATo: TPile);
var
  VCard: TCard;
begin
//# BEGIN TODO body of TGame.MoveCard
{ VERVANG DIT DOOR EIGEN CODE }

Assert( CanMoveCard(AFrom, ATo), 'TGame.MoveCard.pre failed: Illegal move');

VCard := AFrom.Top;
AFrom.Remove(VCard);
ATo.Put(VCard);

//# END TODO
end;

function TGame.MovesCount: Integer;
begin
  Result := FMovesCount;
end;

procedure TGame.MoveSubPile(I: Integer; AFrom, ATo: TTableauPile);
var
  VPile: TPile;
  VCard: TCard;
  X,J: Integer;
begin
//# BEGIN TODO body of TGame.MoveSubPile
{ VERVANG DIT DOOR EIGEN CODE }
    // pre: CanMoveSubPile(I, AFrom, ATo)

Assert( CanMoveSubPile(I, AFrom, ATo), 'TGame.MoveSubPile.pre failed: Illegal move');

X := AFrom.Count - (AFrom.Count - I);          // het aantal te verplaatsen kaarten

VPile := TPile.Create(X);                      // Init hulp Pile

// stop kaarten in hulp pile, boveste kaart onderop
  for J := (AFrom.Count - 1) downto (I) do begin
    AFrom.Remove( VCard );
    VPile.Put( VCard );
  end; //for


// stop kaarten in ATo, laatste kaart die op Ato komt is de onderste van VPile
  while not VPile.IsEmpty do
  begin
    VPile.Remove( VCard );
    ATo.Put( VCard );
  end;

//# END TODO
end;

procedure TGame.NewCard;
var
  VCard: TCard;
begin
//# BEGIN TODO body of TGame.NewCard
{ VERVANG DIT DOOR EIGEN CODE }

// pre: not DeckPile.IsEmpty
// effect: take card from DeckPile and put it faceup on DiscardPile


Assert( not FDeckPile.IsEmpty,
  'FMoveCard failed: Illegal move');

    VCard := FDeckPile.Top;
    FDeckPile.Remove(VCard);
    VCard.Flip;
    FDiscardPile.Put(VCard);

   // MoveCard(FDeckpile, FDiscardPile);

//# END TODO
end;

procedure TGame.NewGame;
begin
//# BEGIN TODO body of TGame.NewGame
{ VERVANG DIT DOOR EIGEN CODE }

{ Collect; Shuffle; Deal; }


Collect;

Shuffle;

Deal;

//# END TODO
end;

procedure TGame.Recycle;
var
  VCard: TCard;
  i, j: Integer;
begin
//# BEGIN TODO body of TGame.Recycle
{ VERVANG DIT DOOR EIGEN CODE }

// pre: true
// effect: take all cards from DiscardPile and put them facedown on DeckPile

  //VCard := TCard.Create;
  
  i := FDiscardPile.Count -1;

  for j := 0 to I do begin
    VCard := FDiscardPile.Top;               // Pak boveste kaart
    FDiscardPile.Remove(VCard);
    
    VCard.Flip;                          // Draai kaart om
    
    FDeckPile.Put(VCard);                    // Plaats kaart
    
  
    
  end; //for

//# END TODO
end;

procedure TGame.Shuffle;
begin
//# BEGIN TODO body of TGame.Shuffle
  
{ VERVANG DIT DOOR EIGEN CODE }
// pre: true
// effect: shuffle FDeckPile

FDeckPile.Shuffle;

//# END TODO
end;

function TGame.SuitPile(ASuit: TSuit): TSuitPile;
begin
  Result := FSuitPiles[ASuit];
end;

function TGame.TableauPile(AIndex: Integer): TTableauPile;
begin
  // check precondition
  Assert( (0 <= AIndex) and (AIndex <= 7),
    Format('FTableauPiles.pre failed; AIndex = %d', [AIndex] ));

  Result := FTableauPiles[AIndex];
end;

end.
