unit unitChargementRecettes;

interface

    procedure chargerLesRecettes;

implementation

    uses
      unitListeRecettes,
      unitPersonnage; // pour les types de bonus

    function bonusFromString(bonus: string): Bonus;
    begin
        if bonus = '(Regeneration)' then
            bonusFromString := REGENERATION
        else if bonus = '(Critique)' then
            bonusFromString := CRITIQUE
        else if bonus = '(Force)' then
            bonusFromString := FORCE
        else
            bonusFromString := AUCUNB;
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

    procedure chargerLesRecettes;
    var
        fichier: Text;
        ligne, nom, effet: string;
        recette: TypeRecette;
    begin
        AssignFile(fichier, 'Recettes.txt');

        reset(fichier);

        initRecettes;

        while not eof(fichier) do
        begin
            readln(fichier, ligne);
            separer(ligne, nom, effet);
            recette.nom := nom;
            recette.effet := bonusFromString(effet);
            insererRecette(recette);
        end;

        closeFile(fichier);
        recettesChargees;
    end;
end.

