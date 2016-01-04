unit CardDeck;

{ Author: Kees Hemerik
  Version history:
  0.1 d.d. 20080316
}

interface

uses
  Graphics,
  CardPiles;

type
  //----------------------------------------------------------------------------
  // TCardDeck provides data needed for textual and graphical representation of
  // the various elements of a deck of cards.
  // Short decription of operations:
  // - LongSuitName(ASuit)  yields the long name of a TSuit value, e.g. 'Hearts'
  // - ShortSuitName(ASuit) yields the short name of a TSuit value, e.g. 'H'
  // - CardText(ACard)      yields a text representation of a card, e.g. '07H'
  // - CardBitmap(ACard)    yields a bitmap representing the face of ACard
  // - CardBitmap2(AValue, ASuit) yields a bitmap representing the card with
  //     value AValue and suit ASuit
  // - BottomSuit(ASuit)   yields bitmap representing empty suitpile for ASuit
  // - Bottom              yields bitmap representing other empty piles
  // - Back                yields bitmap representing back of cards
  //
  // - LoadFromFiles(APath) loads all data for a TCardDeck object from set of
  //     .bmp files in directory with path APath.
  //   It is assumed that the filename for card ACard is nnn.bmp ,
  //     where nnn is CardText(ACard)
  //----------------------------------------------------------------------------
  TCardDeck =
  class(TObject)
  protected
    FCardBitmaps: array[TValue, TSuit] of TBitmap;
    FBottomSuit: array [TSuit] of TBitmap;
    FBottom: TBitmap;
    FBack: TBitmap;
  public
    // construction/destruction
    constructor Create;
    destructor Destroy; override;
    
    // queries
    function LongSuitName(ASuit: TSuit): String;
    function ShortSuitName(ASuit: TSuit): String;
    function CardText(ACard: TCard): String;
    function Cardtext2(AValue: TValue; ASuit: TSuit): String;
    function CardBitmap(ACard: TCard): TBitmap;
    function CardBitmap2(AValue: TValue; ASuit: TSuit): TBitmap;
    function BottomSuit(ASuit: TSuit): TBitmap;
    function Bottom: TBitmap;
    function Back: TBitmap;

    // commands
    procedure LoadFromFiles(APath: String);
  end;

implementation //===============================================================

uses
  SysUtils;

{ TCardDeck }

function TCardDeck.Back: TBitmap;
begin
  Result := FBack;
end;

function TCardDeck.Bottom: TBitmap;
begin
  Result := FBottom;
end;

function TCardDeck.BottomSuit(ASuit: TSuit): TBitmap;
begin
  Result := FBottomSuit[ASuit];
end;

function TCardDeck.CardBitmap(ACard: TCard): TBitmap;
begin
  Result := CardBitmap2(ACard.Value, ACard.Suit);
end;

function TCardDeck.CardBitmap2(AValue: TValue; ASuit: TSuit): TBitmap;
begin
  Result := FCardBitmaps[AValue, ASuit];
end;

function TCardDeck.CardText(ACard: TCard): String;
begin
  with ACard do
    if FaceUp
    then Result := CardText2(Value, Suit)
    else Result := 'X';
end;

function TCardDeck.CardText2(AValue: TValue; ASuit: TSuit): String;
begin
  Result := Format('%.2d%s', [AValue, ShortSuitName(ASuit)] )
end;

constructor TCardDeck.Create;
var
  VSuit: TSuit;
  VValue: TValue;
begin
  inherited Create;

  // create bitmaps for all cards
  for VValue := Low(TValue) to High(TValue) do
    for VSuit := Low(TSuit) to High(TSuit) do
      FCardBitmaps[VValue, VSuit] := TBitmap.Create;

  // create bitmaps for all suits
  for VSuit := Low(TSuit) to High(TSuit)
  do FBottomSuit[VSuit] := TBitmap.Create;

  // create bitmaps for bottom and back
  FBottom := TBitmap.Create;
  FBack := TBitmap.Create;
end;

destructor TCardDeck.Destroy;
var
  VSuit: TSuit;
  VValue: TValue;
begin
  // free bitmaps for all cards
  for VValue := Low(TValue) to High(TValue) do
    for VSuit := Low(TSuit) to High(TSuit) do
      FCardBitmaps[VValue, VSuit].Free;

  // free bitmaps for suits
  for VSuit := Low(TSuit) to High(TSuit)
  do FBottomSuit[VSuit].Free;

  // free bitmaps for bottom and back
  FBottom.Free;
  FBack.Free;

  inherited;
end;

procedure TCardDeck.LoadFromFiles(APath: String);
var
  VValue: TValue;
  VSuit: TSuit;
  VFileName: String;
begin
  // load bitmaps for faces of all cards
  for VValue := Low(TValue) to High(TValue) do
    for VSuit := Low(TSuit) to High(TSuit) do
    begin
      // compose filename from APath, VValue and VSuit
      VFileName :=
        Format('%s%s.bmp', [APath, CardText2(VValue, VSuit)] );
      // load bitmap from file
      FCardBitmaps[VValue, VSuit].LoadFromFile(VFileName);
    end;

  // load bitmaps for bottoms of suits
  FBottomSuit[suHeart].LoadFromFile(APath + 'bottom06.bmp');
  FBottomSuit[suClub].LoadFromFile(APath + 'bottom04.bmp');
  FBottomSuit[suDiamond].LoadFromFile(APath + 'bottom07.bmp');
  FBottomSuit[suSpade].LoadFromFile(APath + 'bottom05.bmp');

  // load bitmaps for bottom and back
  FBottom.LoadFromFile(APath + 'bottom02.bmp');
  FBack.LoadFromFile(APath + 'back111.bmp');
end;

function TCardDeck.LongSuitName(ASuit: TSuit): String;
const
  Names: array[TSuit] of String = ('Hearts', 'Clubs', 'Diamonds', 'Spades');
begin
  Result := Names[ASuit];
end;

function TCardDeck.ShortSuitName(ASuit: TSuit): String;
const
  Names: array[TSuit] of String = ('H', 'C', 'D', 'S');
begin
  Result := Names[ASuit];
end;

end.
