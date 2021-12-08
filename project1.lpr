program project1;

uses SysUtils;

procedure separer(inp: string; var out1, out2: string);
var
    i: Integer;
begin
    i := 0;
    out1 := '';
    out2 := '';
    while (inp[i] <> '/') and (i <= length(inp)) do begin
        out1 += inp[i];
        i += 1;
    end;
    while (i <= length(inp)) do begin
        out2 += out2;
        i += 1;
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
        writeln(nom);
    end;

    closeFile(FD);
    readln;
end.

