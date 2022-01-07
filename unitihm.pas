//Unit en charge de l'IHM
unit unitIHM;
{$codepage utf8}
{$mode objfpc}{$H+}


interface  
//Affiche l'interface principale (les cadres principaux)
procedure afficherInterfacePrincipale();  
//Affiche l'interface principale (les cadres principaux pour écran non split)
procedure afficherInterfaceSimple();  
//Affichage du cadre d'action
procedure afficherCadreAction();
//Affiche le nom du lieu au centre de la boite associée
procedure afficherLieu(nomLieu : string); 
//Affiche le nom du lieu au centre de la boite associée (écran simple)
procedure afficherLieuSimple(nomLieu : string);
//Positionne le curseur à la n-ième ligne de la zone d'action
procedure deplacerCurseurZoneAction(numLigne : integer); 
//Positionne le curseur à la n-ième ligne de la zone d'action
procedure deplacerCurseurZoneResponse();










implementation

uses
    unitMonstre,unitObjet,unitPersonnage,unitEquipement,GestionEcran,sysutils;

//Positionne le curseur dans la zone de réponse
procedure deplacerCurseurZoneResponse();
begin
  deplacerCurseurXY(142,37);
end;

//Positionne le curseur à la n-ième ligne de la zone d'action
procedure deplacerCurseurZoneAction(numLigne : integer);
begin                
  deplacerCurseurXY(5,30+numLigne);
end;

//Affiche le nom du lieu au centre de la boite associée (écran split)
procedure afficherLieu(nomLieu : string);
begin
   deplacerCurseurXY(74-(length(nomLieu)div 2),2);
   write(nomLieu);
end;

//Affiche le nom du lieu au centre de la boite associée (écran simple)
procedure afficherLieuSimple(nomLieu : string);
begin
   deplacerCurseurXY(99-(length(nomLieu)div 2),2);
   write(nomLieu);
end;

//Affichage du cadre extérieur de l'IHM
procedure afficherCadreExterieur();
begin 
  dessinerCadreXY(1,0,198,39,simple,white,black);
end;

//Affichage du cadre d'action
procedure afficherCadreAction();
begin
  dessinerCadreXY(1,29,198,39,simple,white,black);
end;

//Affichage du cadre de réponse
procedure afficherCadreResponse();
begin
  dessinerCadreXY(139,36,145,38,simple,white,black);
end;

//Affichage le cadre latéral du personnage
procedure afficherMenuLateralPersonnage();
var
  i:integer;
  perso:Personnage;
begin
  dessinerCadreXY(157,0,198,39,simple,white,black);
  dessinerCadreXY(160,0,195,2,simple,white,black);
  dessinerCadreXY(162,1,193,3,simple,white,black);
  deplacerCurseurXY(168,2);Write('FICHE DU PERSONNAGE');

  if(getPersonnage().Nom <> '') then
  begin
    deplacerCurseurXY(159,5); write('       Nom : ',getPersonnage().nom);
    deplacerCurseurXY(159,6); write('     Genre : ',genreToString(getPersonnage().sexe));
    deplacerCurseurXY(159,7); write('    Taille : ',getPersonnage().taille);

    deplacerCurseurXY(159,9); write('     Santé : ',getPersonnage().sante);
    deplacerCurseurXY(159,10); write('    Argent : ',getPersonnage().argent);


    deplacerCurseurXY(169,12);Write('   -------------   ');

    deplacerCurseurXY(159,14); write('      Arme : ',armeToString(getPersonnage().arme));
    deplacerCurseurXY(159,15); write('    Casque : ',armureToString(Casque,getPersonnage().armures[0]));
    deplacerCurseurXY(159,16); write('     Torse : ',armureToString(Torse,getPersonnage().armures[1]));
    deplacerCurseurXY(159,17); write('     Gants : ',armureToString(Gants,getPersonnage().armures[2]));
    deplacerCurseurXY(159,18); write(' Jambières : ',armureToString(Jambieres,getPersonnage().armures[3]));
    deplacerCurseurXY(159,19); write('    Bottes : ',armureToString(Bottes,getPersonnage().armures[4]));

    deplacerCurseurXY(169,21);Write('   -------------   ');
    for i:=0 to ord(high(TypeMonstre)) do
    begin
        deplacerCurseurXY(185-length(partieToString(TypeMonstre(i))),23+i);
        write(partieToString(TypeMonstre(i)),' : ',getPersonnage().parties[i]);
    end; 
    deplacerCurseurXY(169,26);Write('   -------------   ');
    deplacerCurseurXY(159,28);Write('      Buff : ',bonusToString(getPersonnage().buff));

    deplacerCurseurXY(169,30);Write('   -------------   ');
     //////////////////////////////////////////////////////////////////////////////////////
    deplacerCurseurXY(159,32); write('    Niveau  : ',getPersonnage().lv.niveau);
    deplacerCurseurXY(159,33); write('Experience  : ',getPersonnage().xp, '/' , getPersonnage().lv.experienceRequise);
    deplacerCurseurXY(159,34); write('Competence1 : ',getPersonnage().competence.competence1.nomCompetence);
    deplacerCurseurXY(159,35); write('Competence2 : ',getPersonnage().competence.competence2.nomCompetence);
    deplacerCurseurXY(159,36); write('Attaque base: ',getPersonnage().attaqueBase);
    deplacerCurseurXY(159,37); write('Armure base : ',getPersonnage().armureBase);
    niveauSuivant();

  end;

end;

//Affichage le cadre du lieu dans le cas d'un écran simple
procedure afficherCadreLieuEcranSimple();
begin   
  dessinerCadreXY(48,0,151,2,simple,white,black);
  dessinerCadreXY(54,1,146,3,simple,white,black);
end;

//Affichage le cadre du lieu dans le cas d'un écran split
procedure afficherCadreLieuEcranSplit();
begin
  dessinerCadreXY(23,0,125,2,simple,white,black);
  dessinerCadreXY(29,1,119,3,simple,white,black);
end;

//Affiche l'interface principale (les cadres principaux pour écran split)
procedure afficherInterfacePrincipale();
begin
  effacerEcran;  
  //Cadre extérieur
  afficherCadreExterieur();
  //Cadre action
  afficherCadreAction();
  //Cadre réponse
  afficherCadreResponse();
  //Cadre latéral droit
  afficherMenuLateralPersonnage();
  //Cadre Lieu
  afficherCadreLieuEcranSplit();
end;
                    
//Affiche l'interface principale (les cadres principaux pour écran non split)
procedure afficherInterfaceSimple();
begin
  effacerEcran;
  //Cadre extérieur
  afficherCadreExterieur();
  //Cadre action
  afficherCadreAction(); 
  //Cadre Lieu
  afficherCadreLieuEcranSimple();
end;

end.

