//Unit en charge de la gestion du personnage
unit unitPersonnage;
{$codepage utf8}
{$mode objfpc}{$H+}

interface
uses
    unitObjet,unitEquipement;
//----- TYPES -----
type
  bonus = (AucunB,Force,Regeneration);       //Bonus de la cantinue
  genre = (Masculin,Feminin,Autre);         //Genre du personnage

  level = record                       //un enregistrement d'un level qui contient
    niveau : integer;                  //le niveau du personnage et
    experienceRequise : integer;       //l'experience requise
  end;

  typeCompetence = record
    nomCompetence : string;             //Nom de la competence
    degatCompetence : integer;          //Dégat de la competence
  end;

  TCompetence = record
    competence1 : typeCompetence;       //La competence 1
    competence2 : typeCompetence;       //La competence 2
  end;

  //Type représentant le personnage
  Personnage = record
    nom : String;                           //Nom du personnage
    sexe : genre;                           //Genre du personnage
    taille : integer;                       //taille du personnage
    inventaire : Tinventaire;               //Inventaire
    parties : TinventairePartie;            //Inventaire des parties de monstres
    arme : materiaux;                       //Arme utilisée
    armures : TArmures;                     //Armures
    sante : integer;                        //Vie du personnage
    santeMax : integer;                     //VieMax du personnage
    argent : integer;                       //Argent du personnage
    buff : bonus;                           //Buff du joueur

    xp : integer;//l'experience du personnage
    lv : level;//le niveau du personnage
    attaqueBase : integer;//attaque base du personnage
    armureBase  : integer;//armure base de personnage
    competence  : TCompetence; //la competence du personnage


  end;

  //Type représentant un coffre d'équipement
  TCoffre = record
    armures : TCoffreArmures;               //Armures présentes dans le coffre
    armes : TCoffreArmes;                   //Armes présentes dans le coffre
   // competence : TCoffreCompetence //Competence presente dans coffre
  end;

   
//----- FONCTIONS ET PROCEDURES -----  
//Initialisation du joueur
procedure initialisationJoueur(); 
//Initialisation du coffre de la chambre
procedure initialisationCoffre();
//Renvoie le personnage (lecture seul)
function getPersonnage() : Personnage;
//Renvoie le coffre (lecture seul)
function getCoffre() : TCoffre;
//Transforme un Genre en chaine de caractères
function genreToString(sexe : genre) : string;
//Change le nom du joueur
procedure setNomPersonnage(nom : string);
//Change la taille du joueur
procedure setTaillePersonnage(taille : integer);  
//Change le genre du joueur
procedure setGenrePersonnage(sexe : genre);
//Ajoute (ou retire) une quantité QTE de l'objet ID dans l'inventaire du joueur
procedure ajoutObjet(id : integer; qte : integer);    
//Dormir dans son lit
procedure dormir(); 
//Change l'arme du joueur
procedure changerArme(mat : integer); 
//Change l'armure du joueur
procedure changerArmure(slot,mat : integer); 
//Achete un objet du type i
procedure acheterObjet(i : integer);  
//Vendre un objet du type i
procedure vendreObjet(i : integer); 
//Renvoie le montant de dégats d'une attaque
function degatsAttaque() : integer;  
//Renvoie le montant de dégats recu
function degatsRecu() : integer; 
//Ajoute une partie de monstre
procedure ajouterPartie(i : integer); 
//Soigne le personnage de 50pv
procedure soigner();        
//Soigne le personnage de 1pv
procedure regen();
//Supprime 1 objet
procedure utiliserObjet(i : integer); 
//Récupère une prime pour avoir tué un monstre
procedure recupererPrime(qte : integer); 
//Renvoie si le joueur possède les ingrédients (et l'or) pour crafter l'objet
function peuxForger(mat : materiaux) : boolean;
//Forge une arme du matériaux donné
procedure forgerArme(mat : materiaux);
//Forge une armure du matériaux donné
procedure forgerArmure(slot : integer; mat : materiaux); 
//Converti un bonus en chaine de caractères
function bonusToString(buff : bonus) : String;
//Change le buff du joueur
procedure setBuff(buff : bonus);


//Ajouter l'experience apres tuer le monstre
procedure getExperience(qte : integer);
//Niveau Suivant
procedure niveauSuivant();
//Compétence 1 du personnage
procedure competence1();
//Compétence 2 du personnage
procedure competence2();
//Renvoie le montant de dégats d'une attaque de competence 1
function degatCompetence1() : integer;
//Renvoie le montant de dégats d'une attaque de competence 2
function degatCompetence2() : integer;
//initialisation des compétences
procedure initialisationCompetence();
{
//Renvoie si le joueur possède un niveau requis (et l'or) pour apprendre la competence
function peuxApprendre(mat : competence) : boolean;
//apprendre la competence1
procedure apprendreCompetence1(mat : competence);
//apprendre la competence2
procedure apprendreCompetence2(mat : competence);
 }












implementation
uses
    unitMonstre;
var
   perso : Personnage;                      //Le personnage
   coffre : TCoffre;                        //Le coffre de la chambre

   
//Initialisation du coffre de la chambre
procedure initialisationCoffre();
var
   mat,slot : integer;
begin
  //Armures (vide)
  for slot:=0 to 4 do
    for mat:=1 to ord(high(materiaux)) do
      coffre.armures[slot,mat] := false;
  //Armes (vide)
  for mat:=1 to ord(high(materiaux)) do
    coffre.armes[mat] := false;

  //Ajoute une épée de fer
  coffre.armes[1] := true;

end;

//Initialisation du joueur
procedure initialisationJoueur();
var
   i:integer;
begin
  //Inventaire vide
  for i:=1 to nbObjets do perso.inventaire[i] := 0;
  //Inventaire de partie vide
  for i := 0 to ord(high(TypeMonstre)) do perso.parties[i] := 0;
  //En Max forme
  perso.santeMax:=150;
  //En pleine forme
  perso.sante:=perso.santeMax;
  //Pas d'arme
  perso.arme := aucun;
  //Pas d'armure
  for i := 0 to 4 do perso.armures[i] := aucun; 
  //Ajouter 200 PO
  perso.argent:=200;

  //Attaque de base du personnage
  perso.attaqueBase:=1 ;
  //Armure de base du personnage
  perso.armureBase:=1;
  //Experience au debut
  perso.xp:=0;
  perso.lv.experienceRequise:=100;
end;

//initialisation des compétences
procedure initialisationCompetence();
begin
  perso.competence.competence1.nomCompetence:='Boule de neige';
  perso.competence.competence1.degatCompetence:=100;
  perso.competence.competence2.nomCompetence:='Boule de feu';
  perso.competence.competence2.degatCompetence:=200;
end;

//Renvoie le personnage (lecture seul)
function getPersonnage() : Personnage;
begin
  getPersonnage := perso;
  if perso.nom='Alice' then
  begin
    perso.argent:=5000;
    coffre.armes[ord(Obsidienne)]:=true;
    changerArmure(ord(Torse),ord(Obsidienne));    //on peut changer de cette maniere
    // perso.armures[ord(Torse)]:= Obsidienne;    //ou cette maniere
    perso.lv.niveau:=9;
    perso.xp:=1001;
    perso.lv.experienceRequise:=1000;
    perso.competence.competence1.nomCompetence:='haha';
    perso.competence.competence2.nomCompetence:='hoho';
    perso.attaqueBase:=100;
    perso.armureBase :=100;
  end;
end;

//Renvoie le coffre (lecture seul)
function getCoffre() : TCoffre;
begin
  getCoffre := coffre;
end;

//Transforme un Genre en chaine de caractères
function genreToString(sexe : genre) : string;
begin
  case sexe of
       Masculin : genreToString := 'Masculin';
       Feminin : genreToString := 'Féminin';
       Autre : genreToString := 'Autre';
  end;
end;

//Change le nom du joueur
procedure setNomPersonnage(nom : string);
begin
  perso.nom:=nom;
end;

//Change le genre du joueur
procedure setGenrePersonnage(sexe : genre);
begin
  perso.sexe:=sexe;
end;

//Change la taille du joueur
procedure setTaillePersonnage(taille : integer);
begin
  perso.taille:=taille;
end;

//Ajoute (ou retire) une quantité QTE de l'objet ID dans l'inventaire du joueur
procedure ajoutObjet(id : integer; qte : integer);
begin
     perso.inventaire[id] += qte;
     if(perso.inventaire[id] < 0) then perso.inventaire[id] := 0;
end;

//Dormir dans son lit
procedure dormir();
begin
  perso.sante:=perso.santeMax;
end;

//Change l'arme du joueur
procedure changerArme(mat : integer);
begin
  //Enlève l'arme du coffre
  coffre.armes[mat] := false;
  //Range l'arme dans le coffre (si le joueur en a une)
  if(ord(perso.arme) <> 0) then coffre.armes[ord(perso.arme)] := true;
  //Equipe la nouvelle arme
  perso.arme := materiaux(mat);
end;


//Change l'armure du joueur
procedure changerArmure(slot,mat : integer);
begin
  //Enlève l'armure du coffre
  coffre.armures[slot,mat] := false;
  //Range l'armure dans le coffre (si le joueur en a une)
  if(ord(perso.armures[slot]) <> 0) then coffre.armures[slot,ord(perso.armures[slot])] := true;
  //Equipe la nouvelle armure
  perso.armures[slot] := materiaux(mat);
end;

//Achete un objet du type i
procedure acheterObjet(i : integer);
begin
  perso.argent -= getObjet(i).prixAchat;
  perso.inventaire[i] += 1;
end;

//Vendre un objet du type i
procedure vendreObjet(i : integer);
begin
  perso.argent += getObjet(i).prixVente;
  perso.inventaire[i] -= 1;
end;

//Renvoie le montant de dégats d'une attaque
function degatsAttaque() : integer;
begin
  degatsAttaque := (4+Random(5))*multiplicateurDegatsArme(perso.arme);
end;

//Renvoie le montant de dégats recu
function degatsRecu() : integer;
begin
  degatsRecu := (2+Random(10))-encaissement(perso.armures);
  if degatsRecu < 0 then degatsRecu := 0;
  perso.sante -= degatsRecu;
  if perso.sante < 0 then perso.sante := 0;
end;

//Ajoute une partie de monstre
procedure ajouterPartie(i : integer);
begin
  perso.parties[i] += 1;
end;

//Soigne le personnage de 50pv
procedure soigner();
begin
  perso.sante += 50;
  if(perso.sante > perso.santeMax) then perso.sante := perso.santeMax;
end;

//Soigne le personnage de 1pv
procedure regen();
begin
  perso.sante += 1;
  if(perso.sante > perso.santeMax) then perso.sante := perso.santeMax;
end;

//Supprime 1 objet
procedure utiliserObjet(i : integer);
begin
  perso.inventaire[i] -= 1;
end;

//Récupère une prime pour avoir tué un monstre
procedure recupererPrime(qte : integer);
begin
  perso.argent += qte;
end;

//Renvoie si le joueur possède les ingrédients (et l'or) pour crafter l'objet
function peuxForger(mat : materiaux) : boolean;
begin
     //Test de l'argent
     peuxForger := (perso.argent >= 500);
     //Test des matériaux et le niveau
     case mat of
          os : peuxForger := peuxForger AND (perso.parties[0]>4) AND (perso.lv.niveau>=1);
          Ecaille : peuxForger := peuxForger AND (perso.parties[1]>4) AND (perso.lv.niveau>=5);
          Obsidienne : peuxForger:= peuxForger AND (perso.parties[0]>4) AND (perso.lv.niveau>=8);
     end;
end;

//Forge une arme du matériaux donné
procedure forgerArme(mat : materiaux);
begin
     //retire l'or
     perso.argent -= 500;
     
     //Retire les matériaux
     case mat of
          os : perso.parties[0] -= 5;
          Ecaille : perso.parties[1] -= 5;
          Obsidienne: perso.parties[1] -= 50;
     end;
     //Ajoute l'arme dans le coffre
     coffre.armes[ord(mat)] := true;
end;

//Forge une armure du matériaux donné
procedure forgerArmure(slot : integer; mat : materiaux);
begin
     //retire l'or
     perso.argent -= 500;

     //Retire les matériaux
     case mat of
          os : perso.parties[0] -= 5;
          Ecaille : perso.parties[1] -= 5;
          Obsidienne: perso.parties[1] -= 50;

     end;

     //Ajoute l'armure dans le coffre
     coffre.armures[slot,ord(mat)] := true;
end;

//Converti un bonus en chaine de caractères
function bonusToString(buff : bonus) : String;
begin
  case buff of
       AucunB:bonusToString:='Aucun';
       Force:bonusToString:='Force';
       Regeneration:bonusToString:='Regénération';
  end;
end;

//Change le buff du joueur
procedure setBuff(buff : bonus);
begin
  perso.buff := buff;
end;

//Ajouter l'experience apres tuer le monstre
procedure getExperience(qte : integer);
begin
  perso.xp += qte;
end;

//Niveau Suivant
procedure niveauSuivant();
begin
  if (perso.xp)>=(perso.lv.experienceRequise) then
    begin
      perso.lv.niveau+=1;
      perso.xp-=perso.lv.experienceRequise;
      perso.lv.experienceRequise+=100;
      if perso.xp <=0 then perso.xp:=0;
      perso.santeMax+=50;
      perso.attaqueBase+=5;
      perso.armureBase+=3;
      perso.sante:=perso.santeMax;
    end;

end;

//Compétence 1 du personnage
procedure competence1();
begin
  //verifier si il a assez d'argent pour apprendre cette competence
  if (getPersonnage().argent>=100) then
  begin
    perso.competence.competence1.nomCompetence:='boule de neige';
    perso.argent:=perso.argent-100;
  end;
  //entrainementHUB();
end;

//Compétence 2 du personnage
procedure competence2();
begin
  //verifier si il a assez d'argent pour apprendre cette competence
  if (getPersonnage().argent>=500) then
  begin
    perso.competence.competence2.nomCompetence:='boule de feu';
    perso.argent:=perso.argent-500;
  end;
  //entrainementHUB();
end;

    {
//Renvoie si le joueur possède un niveau requis (et l'or) pour apprendre la competence
function peuxApprendre(mat : competence) : boolean;
begin
     //Test de l'argent
     peuxApprendre := (perso.argent >= 50);
     //Test niveau
     case mat of
          competence1 : peuxApprendre := peuxApprendre AND (perso.lv>2);
          competence2 : peuxApprendre := peuxApprendre AND (perso.lv>10);
     end;
end;

//apprendre la competence1
procedure apprendreCompetence1(mat : competence);
begin
     //retire l'or
     perso.argent -= 50;
     //Ajoute la competance1 dans le coffre
     coffre.competence[ord(mat)] := true;
end;

//apprendre la competence2
procedure apprendreCompetence2(mat : competence);
begin
     //retire l'or
     perso.argent -= 500;
     //Ajoute la competence2 dans le coffre
     coffre.competence[ord(mat)] := true;
end;
end;






   }

//Renvoie le montant de dégats d'une attaque de competence 1
function degatCompetence1() : integer;
begin
 degatCompetence1 := ((perso.attaqueBase)+(perso.competence.competence1.degatCompetence));
end;



//Renvoie le montant de dégats d'une attaque de competence 2
function degatCompetence2() : integer;
begin
 degatCompetence2 := ((perso.attaqueBase)+(perso.competence.competence2.degatCompetence));
end;


end.

