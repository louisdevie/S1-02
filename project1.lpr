program project1;

uses SysUtils, unitListeRecettes;

function bonusFromString(bonus: string): EnumBonus;
begin
    if bonus = '(Regeneration)' then
        bonusFromString := REGENERATION
    else if bonus = '(Critique)' then
        bonusFromString := CRITIQUE
    else if bonus = '(Force)' then
        bonusFromString := FORCE
    else
        bonusFromString := AUCUN;
end;

// sépare une chaine de caractères au niveau du dernier "/" trouvé
procedure separer(ligne: string; var avant, apres: string);
var
    i: Integer; // indice pour parcourir la ligne
begin
    i := length(ligne); // on part de la fin
    avant := '';
    apres := '';
    // `apres` contient tout ce qu'il y a après le dernier "/"
    while (ligne[i] <> '/') and (i > 0) do begin
        apres := ligne[i] + apres;
        i -= 1;
    end;
    // on saute le "/"
    i -= 1;
    // `avant` contient ce qu'il reste
    while (i > 0) do begin
        avant := ligne[i] + avant;
        i -= 1;
    end;
end;

var
    FD: Text;
    ligne, nom, effet: string;
    recette: TypeRecette;
    i: Integer;
begin
    AssignFile(FD, 'Recettes.txt');

    reset(FD);

    initRecettes;

    while not eof(FD) do
    begin
        readln(FD, ligne);
        separer(ligne, nom, effet);
        recette.nom := nom;
        recette.effet := bonusFromString(effet);
        insererRecette(recette);
    end;

    closeFile(FD);

    afficherRecettes;

   { triAlphaRecettes;
    premierePageRecettes;
    while pageCouranteRecettes < 123 do pageSuivanteRecettes;

    for i := 1 to TAILLE_PAGE_RECETTES do begin
        recette := lireRecette;
        writeln(recette.nom, recette.effet);
    end;
   }


    effacerRecettes;

    readln;
end.

