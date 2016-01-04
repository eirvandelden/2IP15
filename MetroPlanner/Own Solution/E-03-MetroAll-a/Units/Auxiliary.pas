unit Auxiliary;

interface
uses
  Graphics, MetroVisCom;

function ColorNameToColor(AString: String): TColor;
// pre: True
// ret: The color named AString, if AString represents a color contained in the
//                               standard colors or the extended colors
//      clDefaultColor, otherwise
function ColorToColorName(AColor: TColor): String;
// pre: True
// ret: The name of the color AColor, if AColor is contained in the
//                                    standard colors or the extended colors
//      DefaultColorName, otherwise

function StringToTextPos(AString: String): TTextPos;
// pre: True
// ret: The direction of the wind named AString
function TextPosToString(ATextPos: TTextPos): String;
// pre: True
// ret: The name of the direction of the wind ATextPos

implementation

type
  TColorPair =
  record
    N: String;
    C: TColor;
  end;

  TPosPair =
  record
    S: String;
    P: TTextPos;
  end;

const
  ColorTable: array[0..19] of TColorPair =
   ( (N: 'clAqua'      ; C: clAqua)
   , (N: 'clBlack'     ; C: clBlack)
   , (N: 'clBlue'      ; C: clBlue)
   , (N: 'clCream'     ; C: clCream)
   , (N: 'clFuchsia'   ; C: clFuchsia)
   , (N: 'clGreen'     ; C: clGreen)
   , (N: 'clGray'      ; C: clGray)
   , (N: 'clLime'      ; C: clLime)
   , (N: 'clMaroon'    ; C: clMaroon)
   , (N: 'clMedGray'   ; C: clMedGray)
   , (N: 'clMoneyGreen'; C: clMoneyGreen)
   , (N: 'clNavy'      ; C: clNavy)
   , (N: 'clOlive'     ; C: clOlive)
   , (N: 'clPurple'    ; C: clPurple)
   , (N: 'clRed'       ; C: clRed)
   , (N: 'clSilver'    ; C: clSilver)
   , (N: 'clSkyBlue'   ; C: clSkyBlue)
   , (N: 'clTeal'      ; C: clTeal)
   , (N: 'clYellow'    ; C: clYellow)
   , (N: 'clWhite'     ; C: clWhite)
   );

  PosTable: array[0..7] of TPosPair =
   ( (S: 'N' ; P: tpNorth)
   , (S: 'NE'; P: tpNorthEast)
   , (S: 'E' ; P: tpEast)
   , (S: 'SE'; P: tpSouthEast)
   , (S: 'S' ; P: tpSouth)
   , (S: 'SW'; P: tpSouthWest)
   , (S: 'W' ; P: tpWest)
   , (S: 'NW'; P: tpNorthWest)
   );

  clDefaultColor = clBlack;
  DefaultColorName  = 'clBlack';

function ColorNameToColor(AString: String): TColor;
var
  I: Integer;
begin
  Result := clDefaultColor;
  for I := 0 to 19 do
    if ColorTable[I].N = AString
    then Result := ColorTable[I].C;
end;

function ColorToColorName(AColor: TColor): String;
var
  I: Integer;
begin
  Result := DefaultColorName;
  for I := 0 to 19 do
    if ColorTable[I].C = AColor
    then Result := ColorTable[I].N;
end;

function StringToTextPos(AString: String): TTextPos;
var
  I: Integer;
begin
  Result := tpNorth;
  for I := 0 to 7 do
    if PosTable[I].S = AString
    then Result := PosTable[I].P;
end;

function TextPosToString(ATextPos: TTextPos): String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to 7 do
    if PosTable[I].P = ATextPos
    then Result := PosTable[I].S;
end;

end.
