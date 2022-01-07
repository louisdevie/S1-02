//unit charge le camp d'entrainement
unit unitEntrainement;

{$mode objfpc}{$H+}


interface
uses
    ;
type
  competence = (aucune,neige, feu); //les 2 compétence du personnage
  emplacementCompetence= (competence1, competence2);            //liste des emplacements des competences
  TCompetence = array[0..2] of competence;                          //2slots competence
  TCoffreCompetence = array[1..ord(high(competence))] of boolean;  //Coffre competence

//----- FONCTIONS ET PROCEDURES -----
//Fonction exécutée à l'arrivée dans camp d'entrainement
//Renvoie le prochain lieu à visiter
function entrainementHUB() : typeLieu;





implementation
uses
    unitPersonnage,unitEquipement,unitIHM,GestionEcran;

//Gestion de l'affichage (chaine de caractères) d'une competence
function competenceToString(piece : emplacementCompetence; mat : competence) : String;
begin
  if(mat = aucune) then competenceToString := 'Aucune'
  else
  begin
     case piece of
        competence1 : competenceToString += ' competence1';
        competence2  : competenceToString += ' competence2';
    end;
    case mat of
        neige : competenceToString := 'Neige';
        feu : competenceToString := 'Feu';
    end;

  end;
end;

//Fonction exécutée quand le joueur souhaite apprendre une competence
//Renvoie le prochain lieu à visiter
function fabricationEquipement() : typeLieu;
var
  ligne,mat,slot,nbchoix,choix,i : integer;
begin
     choix := -1;
     while(choix <> 0) do
     begin
        afficherInterfacePrincipale();
        afficherLieu('Camp d''entrainement');
        deplacerCurseurXY(63,5);write('Les competences vous proposent :');

        deplacerCurseurXY(4,7);write('--- COMPETENCE1 ---');
        deplacerCurseurXY(80,7);write('--- COMPETENCE 2 ---');

        //Apprendre des COMPETENCES
        for mat := 1 to ord(high(competence)) do
        begin
           //Compétence déja possédée
           if(getCoffre().competence[mat]) or (ord(getPersonnage().competence1) = mat) then
           begin
                couleurTexte(green);
                deplacerCurseurXY(34,8+mat);write('(Déjà appris cette compétence');
           end
           else
           begin
              //Compétence non appris
              if not(peuxForger(competence(mat))) then couleurTexte(lightred);
              //Affichage les compétences
              deplacerCurseurXY(34,8+mat);writeln(listeCompetenceToString(competence(mat)));
           end;
           deplacerCurseurXY(4,8+mat);writeln(mat,'/ ',listeCompetenceToString(competence(mat)));
           couleurTexte(white);
        end;

        //Fabrication des ARMURES
        ligne := 9;
        nbchoix := 10;
        for mat := 1 to ord(high(competence)) do
        begin
            for slot := 0 to 2 do
            begin
                //Competence déja appris
                if(getCoffre().competence[slot,mat]) or (ord(getPersonnage().competence2[slot]) = mat) then
                begin
                     couleurTexte(green);
                     deplacerCurseurXY(110,ligne);write('(Déjà appris cette compétence');
                end
                //Competence non appris
                else
                begin
                    if not(peuxForger(competence(mat))) then couleurTexte(lightred);
                    deplacerCurseurXY(110,ligne);writeln(listeCompetenceToString(competence(mat)));
                end;
                deplacerCurseurXY(80,ligne);write(nbchoix,'/ ',competenceToString(emplacementCompetence(slot),competence(mat)));
                nbchoix += 1;
                ligne += 1;
                couleurTexte(white);
            end;
            ligne +=1;
        end;

        deplacerCurseurZoneAction(1);write('Que souhaitez-vous apprendre ?');
        deplacerCurseurZoneAction(3);write('     ?/ Apprendre la competence 1 (entrer son numéro)');
        deplacerCurseurZoneAction(4);write('     ?/ Apprendre la competence 2(entrer son numéro)');
        deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');


        deplacerCurseurZoneResponse();
        readln(choix);

        //Demande de apprendre une competence
        if(choix < 2) and (choix > 0) then
        begin
             //Si on peu la apprendre et si on ne la appris pas déjà
             if(peuxForger(competence(choix))) and (not (getCoffre().competence[choix])) and (not (ord(getPersonnage().competence1) = choix)) then
                forgerArme(competence(choix));
        end;
        //Demande de fabrication d'une armure
        if(choix < 25) and (choix > 9) then
        begin
             mat := ((choix-10) div 5)+1;
             slot := (choix-10) mod 5;
             //Si on peu la faire et si on ne la possède pas déjà
             if(peuxForger(materiaux(mat))) and (not (getCoffre().armures[slot,mat])) and (not (ord(getPersonnage().armures[slot]) = mat)) then
                forgerArmure(slot,materiaux(mat));
        end;

     end;

    fabricationEquipement:=ville;
end;


//Fonction exécutée à l'arrivée dans la forge
//Renvoie le prochain lieu à visiter
function ForgeHUB() : typeLieu;
var choix : string;
begin
  choix := '';
  while (choix <> '0') and (choix <> '1') do
  begin
    afficherInterfacePrincipale();
    afficherLieu('Forge de la ville de Brightwood');

    deplacerCurseurXY(30,7);write('Vous vous faites un chemin à travers l''épaisse fumée qui s''échappe de la forge de la ville.');
    deplacerCurseurXY(30,8);write('L''air est lourd et il se dégage une forte odeur, mélange de souffre et de fer fondu. A l''o');
    deplacerCurseurXY(30,9);write('deur se rajoutent la chaleur intense des fourneaux et le bruit incessant des marteaux frap');
    deplacerCurseurXY(30,10);write('pant le métal.');

    deplacerCurseurXY(30,12);write('C''est ici que la plupart des armures et des armes des chasseurs voient le jour. Les maitres');
    deplacerCurseurXY(30,13);write('forgerons peuvent fabriquer l''équipement de votre choix en échange de partie de monstres et');
    deplacerCurseurXY(30,14);write('de quelques pièces.');

    deplacerCurseurXY(30,16);write('A votre arrivée, un homme a la musculature impressionnante se tourne vers vous afin de pren');
    deplacerCurseurXY(30,17);write('dre votre commande.');

    couleurTexte(White);
    deplacerCurseurZoneAction(1);write('Que souhaitez-vous faire ?');
    deplacerCurseurZoneAction(3);write('     1/ Commander une pièce d''équipement');

    deplacerCurseurZoneAction(6);write('     0/ Retourner sur la place principale');

    deplacerCurseurZoneResponse();
    readln(choix);
  end;

  case choix of
       '0' : ForgeHUB := ville;
       '1' : ForgeHUB := fabricationEquipement();
  end;

end;

//Renvoie la liste des competences pour affichage
function listeCompetenceToString(mat : competence) : string;
begin
  case mat of
      competence1 : listeCompetenceToString:='(50 PO , lv 2 requis)';
      competence1 : listeCompetenceToString:='(500 PO , lv 10 requis)';
  end;
end;




end.

