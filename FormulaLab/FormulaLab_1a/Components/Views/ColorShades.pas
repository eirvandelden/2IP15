unit ColorShades;

interface

uses
  Classes, Graphics;

type

  TNrOfLevels = 2..16;
  TLevelIndex = 1..16;

  TColorShades =
  class(TObject)
    private
      FLeftBlue  : Byte;
      FRightBlue : Byte;
      FDeltaBlue : Byte;
      FLeftGreen : Byte;
      FRightGreen: Byte;
      FDeltaGreen: Byte;
      FLeftRed   : Byte;
      FRightRed  : Byte;
      FDeltaRed  : Byte;
      FNrOfLevels: TNrOflevels;
      procedure Update;
      procedure SetLeftBlue  (const Value: Byte);
      procedure SetRightBlue (const Value: Byte);
      procedure SetLeftGreen (const Value: Byte);
      procedure SetRightGreen(const Value: Byte);
      procedure SetLeftRed   (const Value: Byte);
      procedure SetRightRed  (const Value: Byte);
      procedure SetNrOfLevels(const Value: TNrOfLevels);
      procedure SetStandard(AShades: Integer);
    public
      procedure SetProperties(
                  ALeftBlue , ARightBlue ,
                  ALeftGreen, ARightGreen,
                  ALeftRed  , ARightRed: Byte;
                  ANrOfLevels: TNrOfLevels);
      function  Level(I: TLevelIndex): TColor;
      property  LeftBlue  : Byte read FLeftBlue   write SetLeftBlue  ;
      property  RightBlue : Byte read FRightBlue  write SetRightBlue ;
      property  DeltaBlue : Byte read FDeltaBlue;
      property  LeftGreen : Byte read FLeftGreen  write SetLeftGreen ;
      property  RightGreen: Byte read FRightGreen write SetRightGreen;
      property  DeltaGreen: Byte read FDeltaGreen;
      property  LeftRed   : Byte read FLeftRed    write SetLeftRed   ;
      property  RightRed  : Byte read FRightRed   write SetRightRed  ;
      property  DeltaRed  : Byte read FDeltaRed;
      property  NrOfLevels: TNrOfLevels read FNrOfLevels  write SetNrOfLevels;
      property  Standard  : Integer write SetStandard;
    end;


const
  sh4LightGray   =  0;
  sh4LightBlue   =  1;
  sh4LightGreen  =  2;
  sh4LightRed    =  3;
  sh4LightYellow =  4;
  sh4LightViolet =  5;
  sh4LightOrange =  6;

var
  StandardShadesList: TStrings;


implementation

//{$R *.DFM}

type
  TStandardShades =
  record
    LB, RB, LG, RG, LR, RR: Byte;
    NL: TNrOfLevels;
  end;

const
  StandardShades: array[sh4LightGray..sh4LightOrange] of TStandardShades =
  (
    (LB: 200; RB: 240; LG: 200; RG:240; LR:200; RR:240; NL:4 ), {sh4LightGray}
    (LB: 255; RB: 255; LG: 180; RG:240; LR:180; RR:240; NL:4 ), {sh4LightBlue}
    (LB: 180; RB: 240; LG: 255; RG:255; LR:180; RR:240; NL:4 ), {shLightGreen}
    (LB: 180; RB: 240; LG: 180; RG:240; LR:255; RR:255; NL:4 ), {sh4LightRed}
    (LB: 150; RB: 240; LG: 255; RG:255; LR:255; RR:255; NL:4 ), {sh4LightYellow}
    (LB: 255; RB: 255; LG: 180; RG:240; LR:240; RR:240; NL:4 ), {sh4LightViolet}
    (LB: 155; RB: 240; LG: 200; RG:240; LR:240; RR:240; NL:4 )  {sh4LightOrange}
  );

const
  clGrayUnit  = $00010101;
  clBlueUnit  = $00010000;
  clGreenUnit = $00000100;
  clRedUnit   = $00000001;

{ TColorShades }

procedure TColorShades.SetLeftBlue(const Value: Byte);
begin
  FLeftBlue := Value;
  Update;
end;

procedure TColorShades.SetLeftGreen(const Value: Byte);
begin
  FLeftGreen := Value;
  Update;
end;

procedure TColorShades.SetLeftRed(const Value: Byte);
begin
  FLeftRed := Value;
  Update;
end;

procedure TColorShades.SetNrOfLevels(const Value: TNrOfLevels);
begin
  FNrOfLevels := Value;
  Update;
end;

procedure TColorShades.SetStandard(AShades: Integer);
var
  VI: Integer;
begin
  if (sh4LightGray <= AShades) and (AShades <= sh4LightOrange)
  then VI := AShades
  else VI := sh4LightGray;
  with StandardShades[VI] do
    SetProperties(LB, RB, LG, RG, LR, RR, NL);
end;


procedure TColorShades.SetRightBlue(const Value: Byte);
begin
  FRightBlue := Value;
  Update;
end;

procedure TColorShades.SetRightGreen(const Value: Byte);
begin
  FRightGreen := Value;
  Update;
end;

procedure TColorShades.SetRightRed(const Value: Byte);
begin
  FRightRed := Value;
  Update;
end;

procedure TColorShades.Update;
begin
  FDeltaBlue  := (FRightBlue  - FLeftBlue ) div (FNrOfLevels - 1);
  FDeltaGreen := (FRightGreen - FLeftGreen) div (FNrOfLevels - 1);
  FDeltaRed   := (FRightRed   - FLeftRed  ) div (FNrOfLevels - 1);
end;

procedure TColorShades.SetProperties(
            ALeftBlue , ARightBlue ,
            ALeftGreen, ARightGreen,
            ALeftRed  , ARightRed: Byte;
            ANrOfLevels: TNrOfLevels);
begin
  FLeftBlue   := ALeftBlue;
  FRightBlue  := ARightBlue;
  FLeftGreen  := ALeftGreen;
  FRightGreen := ARightGreen;
  FLeftRed    := ALeftRed;
  FRightRed   := ARightRed;
  FNrOfLevels := ANrOfLevels;
  Update;
end;

function TColorShades.Level(I: TLevelIndex): TColor;
begin
  Result :=
    (FLeftBlue  + (I-1) * FDeltaBlue)  * clBlueUnit  +
    (FLeftGreen + (I-1) * FDeltaGreen) * clGreenUnit +
    (FLeftRed   + (I-1) * FDeltaRed)   * clRedUnit;
end;


initialization
  StandardShadesList := TStringList.Create;
  with StandardShadesList do
  begin
    Add('sh4LightGray  ');
    Add('sh4LightBlue  ');
    Add('sh4LightGreen ');
    Add('sh4LightRed   ');
    Add('sh4LightYellow');
    Add('sh4LightViolet');
    Add('sh4LightOrange');
  end;


end.
 