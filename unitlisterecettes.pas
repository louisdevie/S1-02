unit unitListeRecettes;

interface

    type
        EnumBonus = (AUCUN, REGENERATION, CRITIQUE, FORCE);

        TypeRecette = record
            nom: string;
            effet: EnumBonus;
        end;


    procedure initRecettes;


    procedure insererRecette(recette: TypeRecette);


    procedure premierePageRecettes;

    procedure pageSuivanteRecettes;

    procedure pagePrecedenteRecettes;

    function pageCourante: Integer;


    function lireRecette(n: Integer): TypeRecette;


implementation

end.

