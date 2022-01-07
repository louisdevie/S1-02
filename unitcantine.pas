//Unit en charge de la cantine
unit unitCantine;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
//----- FONCTIONS ET PROCEDURES -----
uses
  unitLieu;
//Fonction exécutée à l'arrivée dans la cantine
//Renvoie le prochain lieu à visiter
function cantineHUB() : typeLieu;












implementation

uses
    sysutils,
    unitPersonnage,
    unitIHM,
    GestionEcran,
    unitListeRecettes,
    unitJournalisation;

//Mange le plat et applique le bonus
procedure manger(nbPlat : integer);
begin
    setBuff(lireRecette(nbPlat).effet);
end;
       
//Fonction exécutée pour afficher l'écran d'affichage des recettes
//Renvoie le prochain lieu à visiter
function choixRecette() : typeLieu;
var
  choix : string;
  choixNumber, i, bonusX : integer;
  recette: TypeRecette;
begin
  choix := '';
  while (choix <> '0') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Cantine de la ville de Brightwood');
                                                        
    deplacerCurseurXY(63,5); write('Le cuisinier vous propose :');
    couleurTexte(Cyan);
    deplacerCurseurXY(29,7); write('Plat');
    bonusX := 27 + longueurMaxNomRecette;
    deplacerCurseurXY(bonusX,7); write('Bonus');
    couleurTexte(White);

    for i := 0 to taillePageRecettes-1 do begin
        recette := lireRecette(i);
        deplacerCurseurXY(25, 9+i); write(i+1:2, '/ ', recette.nom);
        deplacerCurseurXY(bonusX, 9+i); write(bonusToString(recette.effet));
    end;

    deplacerCurseurXY(63, 28); write('Page ', pageCouranteRecettes, ' sur ', nombrePagesRecettes);

    deplacerCurseurZoneAction(1); write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3); write('     ?/ Commander un plat (entrer son numéro)');

    deplacerCurseurZoneAction(5); write('     0/ Revenir en arrière');   
    deplacerCurseurZoneAction(6); write('     S/ Page suivante');
    deplacerCurseurZoneAction(7); write('     P/ Page précédante');

    deplacerCurseurZoneResponse();
    readln(choix);

    //Si l'utilisateur saisit 0 => revenir au premier menu
    if(choix = '0') then choixRecette := cantine
    else if (choix = 'S') or (choix = 's') then pageSuivanteRecettes 
    else if (choix = 'P') or (choix = 'p') then pagePrecedenteRecettes
    //Si l'utilisateur saisit un nombre, convertir choix (string) en choixNumber (integer)
    else if(TryStrToInt(choix,choixNumber)) then
    begin
         //Si la recette existe, la manger
         if(choixNumber > 0) and (choixNumber < taillePageRecettes) then manger(choixNumber-1);
    end;
  end;
end;

//Fonction exécutée pour afficher l'écran de choix de filtre
//Renvoie le prochain lieu à visiter
function choixTri() : typeLieu;
var choix : string;
begin
  choix := '';
  while (choix <> '0') and (choix <> '1') and (choix <> '2') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Cantine de la ville de Brightwood');

    deplacerCurseurXY(30,7);write('Alors que vous approchez de la cantine, l''air s''emplit d''un épais fumet. Viandes, poissons,');
    deplacerCurseurXY(30,8);write('fruits et légumes dont certains vous sont inconnus sont exposés sur les nombreuses tables');
    deplacerCurseurXY(30,9);write('qui entourent une cuisine de fortune où des palicos s''affairent à préparer des mets aussi');
    deplacerCurseurXY(30,10);write('généreux qu''appétissants.');

    deplacerCurseurXY(30,12);write('Vous apercevez de nombreux chasseurs assis aux différentes tables de la cantine. Les rires');
    deplacerCurseurXY(30,13);write('et les chants résonnent créant en ce lieu, une ambiance chaleureuse et rassurante.');

    deplacerCurseurXY(30,15);write('Alors que vous vous asseyez à une table, un palico vous rejoint posant devant vous une');
    deplacerCurseurXY(30,16);write('chope et attendant votre commande.');

    couleurTexte(White);
    deplacerCurseurZoneAction(1);write('Trier les plats par :');
    deplacerCurseurZoneAction(3);write('     1/ Ordre alphabétique');
    deplacerCurseurZoneAction(4);write('     2/ Effet');

    deplacerCurseurZoneAction(6);write('     0/ Revenir en arrière');

    deplacerCurseurZoneResponse();
    readln(choix);

    case choix of
       '0' : choixTri := cantine;
       '1' : begin
           triAlphaRecettes;
           premierePageRecettes;
           choixTri := choixRecette();
       end;
       '2' : begin
           triBonusRecettes;    
           premierePageRecettes;
           choixTri := choixRecette();
       end;
    end;
  end;
end;

//Fonction exécutée à l'arrivée dans la cantine
//Renvoie le prochain lieu à visiter
function cantineHUB() : typeLieu;
var
    choix : string;
begin
    choix := '';
    while (choix <> '0') and (choix <> '1') do begin
        afficherInterfacePrincipale();
        afficherLieu('Cantine de la ville de Brightwood');

        deplacerCurseurXY(30,7);write('Alors que vous approchez de la cantine, l''air s''emplit d''un épais fumet. Viandes, poissons,');
        deplacerCurseurXY(30,8);write('fruits et légumes dont certains vous sont inconnus sont exposés sur les nombreuses tables');
        deplacerCurseurXY(30,9);write('qui entourent une cuisine de fortune où des palicos s''affairent à préparer des mets aussi');
        deplacerCurseurXY(30,10);write('généreux qu''appétissants.');

        deplacerCurseurXY(30,12);write('Vous apercevez de nombreux chasseurs assis aux différentes tables de la cantine. Les rires');
        deplacerCurseurXY(30,13);write('et les chants résonnent créant en ce lieu, une ambiance chaleureuse et rassurante.');

        deplacerCurseurXY(30,15);write('Alors que vous vous asseyez à une table, un palico vous rejoint posant devant vous une');
        deplacerCurseurXY(30,16);write('chope et attendant votre commande.');

        couleurTexte(White);
        deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
        deplacerCurseurZoneAction(3);write('     1/ Commander un plat');

        deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');

        deplacerCurseurZoneResponse();
        readln(choix);
    end;

    case choix of
       '0' : cantineHUB := ville;
       '1' : cantineHUB := choixTri();
    end;
end;
end.

