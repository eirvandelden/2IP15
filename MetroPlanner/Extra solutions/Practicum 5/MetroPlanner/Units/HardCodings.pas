unit HardCodings;

interface
uses
  Classes;

function HardCodedMap(AOwner: TComponent): TMetroMap;


implementation //===============================================================

function HardCodedMap(AOwner: TComponent): TMetroMap;
var
  VMetroMap: TmetroMap;
  VLine: TVisLine;
  VBitmap: TBitmap;
begin

  VMetroMap := TMetroMap.Create(AOwner);

  // add some stations ---------------------------------------------------------
  with VMetroMap do
  begin
    Add(TVisStationTransfer.Create('GAD', nil, 157, 388)); //Grande Arche de La Défense
    Add(TVisStationStop    .Create('ESP', nil, 181, 411)); //Esplanade de La Défense
    Add(TVisStationStop    .Create('PON', nil, 206, 436)); //Pont de Neuilly
    Add(TVisStationStop    .Create('LSA', nil, 231, 461)); //Les Sablons
    Add(TVisStationTransfer.Create('PTT', nil, 259, 490)); //Porte Maillot
    Add(TVisStationStop    .Create('ARG', nil, 299, 530)); //Argentine
    Add(TVisStationTransfer.Create('CDG', nil, 331, 562)); //Charles de Gaulle - Étoile
    Add(TVisStationStop    .Create('GEO', nil, 369, 600)); //George V
    Add(TVisStationTransfer.Create('FRA', nil, 407, 638)); //Franklin D. Roosevelt
    Add(TVisStationTransfer.Create('CEC', nil, 433, 664)); //Champs Élysées - Clémenceau
    Add(TVisStationTransfer.Create('CON', nil, 457, 688)); //Concorde
    Add(TVisStationStop    .Create('TUI', nil, 514, 705)); //Tuileries
    Add(TVisStationStop    .Create('LOU', nil, 569, 705)); //Louvre
    Add(TVisStationStop    .Create('LOR', nil, 613, 705)); //Louvre - Rivoli
    Add(TVisStationTransfer.Create('CHA', nil, 709, 705)); //Châtelet
    Add(TVisStationTransfer.Create('HOT', nil, 763, 705)); //Hôtel de Ville
    Add(TVisStationStop    .Create('SAP', nil, 809, 751)); //Saint-Paul
    Add(TVisStationTransfer.Create('BAS', nil, 866, 766)); //Bastille
    Add(TVisStationTransfer.Create('GLY', nil, 907, 866)); //Gare de Lyon
    Add(TVisStationTransfer.Create('REU', nil, 986, 844)); //Reuilly - Diderot
    Add(TVisStationTransfer.Create('NAT', nil,1066, 800)); //Nation
    Add(TVisStationStop    .Create('PTZ', nil,1118, 816)); //Porte de Vincennes
    Add(TVisStationStop    .Create('SAM', nil,1158, 838)); //Saint-Mandé - Tourelle
    Add(TVisStationStop    .Create('BER', nil,1179, 859)); //Bérault
    Add(TVisStationStop    .Create('CHV', nil,1198, 878)); //Château de Vincennes
  end;

  // add some lines ------------------------------------------------------------

  VLine := TVisLine.Create('L01', nil, clRed);
  with VLine do
  begin
    Add(VMetroMap.GetStation('GAD'));
    Add(VMetroMap.GetStation('ESP'));
    Add(VMetroMap.GetStation('PON'));
    Add(VMetroMap.GetStation('LSA'));
    Add(VMetroMap.GetStation('PTT'));
    Add(VMetroMap.GetStation('ARG'));
    Add(VMetroMap.GetStation('CDG'));
    Add(VMetroMap.GetStation('GEO'));
    Add(VMetroMap.GetStation('FRA'));
    Add(VMetroMap.GetStation('CEC'));
    Add(VMetroMap.GetStation('CON'));
    Add(TVisStationDummy.Create( 474, 705));
    Add(VMetroMap.GetStation('TUI'));
    Add(VMetroMap.GetStation('LOU'));
    Add(VMetroMap.GetStation('LOR'));
    Add(VMetroMap.GetStation('CHA'));
    Add(VMetroMap.GetStation('HOT'));
    Add(VMetroMap.GetStation('SAP'));
    Add(TVisStationDummy.Create( 814, 757));
    Add(TVisStationDummy.Create( 854, 757));
    Add(TVisStationDummy.Create( 867, 769));
    Add(VMetroMap.GetStation('BAS'));
    Add(TVisStationDummy.Create( 867, 769));
    Add(TVisStationDummy.Create( 904, 806));
    Add(TVisStationDummy.Create( 904, 846));
    Add(TVisStationDummy.Create( 916, 858));
    Add(VMetroMap.GetStation('GLY'));
    Add(TVisStationDummy.Create( 916, 858));
    Add(TVisStationDummy.Create( 944, 886));
    Add(VMetroMap.GetStation('REU'));
    Add(TVisStationDummy.Create(1042, 788));
    Add(TVisStationDummy.Create(1061, 805));
    Add(VMetroMap.GetStation('NAT'));
    Add(TVisStationDummy.Create(1061, 805));
    Add(TVisStationDummy.Create(1071, 816));
    Add(VMetroMap.GetStation('PTZ'));
    Add(TVisStationDummy.Create(1136, 816));
    Add(VMetroMap.GetStation('SAM'));
    Add(VMetroMap.GetStation('BER'));
    Add(VMetroMap.GetStation('CHV'));
  end;
  VMetroMap.Add(VLine);

  // add some landmarks ----------------------------------------------------------
  VBitmap := TBitmap.Create;
  VBitmap.LoadFromFile('../Images/Landmarks/eiffel.bmp');
  VMetroMap.Add(TVisLandmark.Create('eif', nil, 300, 738, VBitMap));

  VBitmap := TBitmap.Create;
  VBitmap.LoadFromFile('../Images/Landmarks/arcdetriomphe.bmp');
  VMetroMap.Add(TVisLandmark.Create('arc', nil, 306, 490, VBitMap));

  VBitmap := TBitmap.Create;
  VBitmap.LoadFromFile('../Images/Landmarks/notredame.bmp');
  VMetroMap.Add(TVisLandmark.Create('nod', nil, 704, 734, VBitMap));

  VBitmap := TBitmap.Create;
  VBitmap.LoadFromFile('../Images/Landmarks/defense.bmp');
  VMetroMap.Add(TVisLandmark.Create('def', nil, 143, 319, VBitMap));

  VBitmap := TBitmap.Create;
  VBitmap.LoadFromFile('../Images/Landmarks/madeleine.bmp');
  VMetroMap.Add(TVisLandmark.Create('mad', nil, 467, 590, VBitMap));

  VBitmap := TBitmap.Create;
  VBitmap.LoadFromFile('../Images/Landmarks/sacrecoeur.bmp');
  VMetroMap.Add(TVisLandmark.Create('sac', nil, 675, 338, VBitMap));

  VBitmap := TBitmap.Create;
  VBitmap.LoadFromFile('../Images/Landmarks/invalides.bmp');
  VMetroMap.Add(TVisLandmark.Create('inv', nil, 400, 745, VBitMap));

  // add some text -------------------------------------------------------------
  with VMetroMap do
  begin
    Add(TVisText.Create('PON', nil, 206, 436, 'Pont de Neuilly', tpNorthEast));
    Add(TVisText.Create('ARG', nil, 299, 530, 'Argentine'      , tpNorthEast));
    Add(TVisText.Create('CON', nil, 457, 688, 'Concorde'       , tpWest     ));
    Add(TVisText.Create('TUI', nil, 514, 705, 'Tuileries'      , tpNorth    ));
    Add(TVisText.Create('SAP', nil, 809, 751, 'St-Paul'        , tpSouthWest));
  end;

  Result := VMetroMap;
end;






end.
