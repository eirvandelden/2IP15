unit Auxiliary;

interface
uses
  Graphics;

function ColorNameToColor(AString: String): TColor;
function ColorToColorName(AColor: TColor): String;

implementation

type
  TPair =
  record
    N: String;
    C: TColor;
  end;

const
  ColorTable: array[0..15] of TPair =
   ( (N: 'clAqua'      ; C: clAqua)
   , (N: 'clBlack'     ; C: clBlack)
   , (N: 'clBlue'      ; C: clBlue)
   , (N: 'clCream'     ; C: clCream)
   , (N: 'clFuchsia'   ; C: clFuchsia)
   , (N: 'clGreen'     ; C: clGreen)
   , (N: 'clLime'      ; C: clLime)
   , (N: 'clMaroon'    ; C: clMaroon)
   , (N: 'clMoneyGreen'; C: clMoneyGreen)
   , (N: 'clNavy'      ; C: clNavy)
   , (N: 'clOlive'     ; C: clOlive)
   , (N: 'clPurple'    ; C: clPurple)
   , (N: 'clRed'       ; C: clRed)
   , (N: 'clTeal'      ; C: clTeal)
   , (N: 'clYellow'    ; C: clYellow)
   , (N: 'clWhite'     ; C: clWhite)
   );

  clDefaultColor = clBlack;
  clDefaultName  = 'clBlack';

function ColorNameToColor(AString: String): TColor;
var
  I: Integer;
begin
  Result := clDefaultColor;
  for I := 0 to 15 do
    if ColorTable[I].N = AString
    then Result := ColorTable[I].C;
end;

function ColorToColorName(AColor: TColor): String;
var
  I: Integer;
begin
  Result := clDefaultName;
  for I := 0 to 15 do
    if ColorTable[I].C = AColor
    then Result := ColorTable[I].N;
end;





end.
