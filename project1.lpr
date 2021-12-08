program project1;

uses SysUtils;

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
begin
    AssignFile(FD, 'Recettes.txt');

    reset(FD);

    while not eof(FD) do
    begin
        readln(FD, ligne);
        separer(ligne, nom, effet);
        writeln(nom, ' - ', effet);
    end;

    closeFile(FD);
    readln;
end.

