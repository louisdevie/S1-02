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
    argent : integer;                       //Argent du personnage
    buff : bonus;                           //Buff du joueur
    santeMax : integer                      //Santé maximale                    {2.2}
  end;

  //Type représentant un coffre d'équipement
  TCoffre = record
    armures : TCoffreArmures;               //Armures présentes dans le coffre
    armes : TCoffreArmes;                   //Armes présentes dans le coffre
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
  for i := 0 to ord(high(TypeMonstre)) do perso.parties[i] := 50;
  //En pleine forme
  perso.santeMax:=150;
  perso.sante:=perso.santeMax;                                                  {2.2}
  //Pas d'arme
  perso.arme := aucun;
  //Pas d'armure
  for i := 0 to 4 do perso.armures[i] := aucun;
  //Ajouter 200 PO
  perso.argent:=200;

end;

//Renvoie le personnage (lecture seul)
function getPersonnage() : Personnage;
begin
  getPersonnage := perso;
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
var
   i : integer;

begin
  perso.nom:=nom;
  //Cheat code
  if perso.nom='Alice' then
     begin
       perso.argent:=5000;                                                      {2.1}
       perso.armures[ord(Torse)]:=Obsidienne;                                   {4.10}
       //perso.arme := Obsidienne;
       coffre.armes[ord(Obsidienne)]:=true;                                     {4.10}
     end;
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
  perso.sante:=150;                                                             {2.3}
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
  if (degatsRecu < 0) then degatsRecu := 0;
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
  if(perso.sante > 150) then perso.sante := 150;                                {2.3}
end;

//Soigne le personnage de 1pv
procedure regen();
begin
  perso.sante += 1;
  if(perso.sante > 150) then perso.sante := 150;                                {2.3}
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
     //Test des matériaux
     case mat of
          os : peuxForger := peuxForger AND (perso.parties[0]>4);
          Ecaille : peuxForger := peuxForger AND (perso.parties[1]>4);
          Obsidienne : peuxForger := peuxForger AND (perso.parties[1]>49)       {4.13}
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
          Obsidienne : perso.parties[1] -= 50;                                  {4.13}
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
          Obsidienne : perso.parties[1] -= 50;                                  {4.13}
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

end.

