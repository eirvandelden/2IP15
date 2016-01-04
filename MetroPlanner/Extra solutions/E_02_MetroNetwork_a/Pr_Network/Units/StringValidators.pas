unit StringValidators;

interface

// String validators -----------------------------------------------------------
const
  csSpecial = ['-', ' ', '''', '.'];
  csDigit   = ['0'..'9'];
  csLetterU = ['A'..'Z'];
  csLetterL = ['a'..'z'];
  csAccentedL = ['á', 'à', 'â', 'ä', 'é', 'è', 'ê', 'ë', 'í', 'ì', 'î', 'ï',
                 'ó', 'ò', 'ô', 'ö', 'ú', 'ù', 'û', 'ü', 'ç'];
  csAccentedU = ['Á', 'À', 'Â', 'Ä', 'É', 'È', 'Ê', 'Ë', 'Í', 'Ì', 'Î', 'Ï',
                 'Ó', 'Ò', 'Ô', 'Ö', 'Ú', 'Ù', 'Û', 'Ü', 'Ç'];
  csLetter  = csLetterU + csLetterL + csAccentedU + csAccentedL;
  csCodeSet = csLetter + csDigit;
  csNameSet = csLetter + csDigit + csSpecial;

function ValidStationCode(AString: String): Boolean;
// pre: True
// ret: AString in csCodeSet+
function ValidStationName(AString: String): Boolean;
// pre: True
// ret: AString in csNameSet+
function ValidLineCode(AString: String): Boolean;
// pre: True
// ret: AString in csCodeSet+
function ValidLineName(AString: String): Boolean;
// pre: True
// ret: AString in csNameSet+
function ValidMapName(AString: String): Boolean;
// pre: True
// post: AString in csNameSet+
function ValidNetworkName(AString: String): Boolean;
// pre: True
// ret: Astring in csNameSet+
function ValidLandmarkCode(AString: String): Boolean;
// pre: True
// ret: Astring in csCodeSet+
function ValidTextCode(AString: String): Boolean;
// pre: True
// ret: Astring in csCodeSet+

implementation

type
  TCharSet = set of Char;

function AuxValid(AString: String; ACharSet: TCharSet): Boolean;
// ret: AString in ACharSet+
var
  I: Integer;
begin
  Result := Length(AString) > 0;
  for I := 1 to Length(AString) do
    if not (AString[I] in ACharSet)
    then Result := False;
end;

function ValidStationCode(AString: String): Boolean;
// ret: AString in csCodeSet+
begin
  Result := AuxValid(AString, csCodeSet);
end;

function ValidStationName(AString: String): Boolean;
// ret: AString in csNameSet+
begin
  Result := AuxValid(AString, csNameSet);
end;

function ValidLineCode(AString: String): Boolean;
// ret: AString in csCodeSet+
begin
  Result := AuxValid(AString, csCodeSet);
end;

function ValidLineName(AString: String): Boolean;
// ret: AString in csNameSet+
begin
  Result := AuxValid(AString, csNameSet);
end;

function ValidMapName(AString: String): Boolean;
// ret: AString in csNameSet+
begin
  Result := AuxValid(AString, csNameSet);
end;

function ValidNetworkName(AString: String): Boolean;
// ret: AString in csNameSet+
begin
  Result := AuxValid(AString, csNameSet);
end;

function ValidLandmarkCode(AString: String): Boolean;
// ret: AString in csCodeSet+
begin
  Result := AuxValid(AString, csCodeSet);
end;

function ValidTextCode(AString: String): Boolean;
// ret: AString in csCodeSet+
begin
  Result := AuxValid(AString, csCodeSet);
end;
  
end.
 