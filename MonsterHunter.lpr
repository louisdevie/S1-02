//Programme principal du jeu Monster Hunter : New World
program MonsterHunter;

uses
    UnitLieu,
    unitIHM,
    unitPersonnage,
    unitObjet,
    unitChambre,
    unitEquipement,
    unitVille,
    unitMarchand,
    unitMonstre,
    unitChasse,
    unitCantine,
    unitForge,
    unitChargementRecettes,
    GestionEcran, unitjournalisation;

var lieuEnCours : typeLieu;  //Lieu où se trouve le "joueur"

begin
  initJournal;
  //Randomize
  Randomize;
  //Charger les recettes
  chargerLesRecettes;    
  //On redimensionne la console
  changerTailleConsole(200,40);
  //Le programme commence au niveau du menu principal
  LieuEnCours := cantine;
  //Tant que l'utilisateur ne souhaite pas quitter
  while LieuEnCours <> quitter do
  begin
    //On se rend au lieu en cours (dans lequel l'utilisateur spécifira un nouveau lieu en cours)
    LieuEnCours := seRendre(LieuEnCours);
  end;
end.

