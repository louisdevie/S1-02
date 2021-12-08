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


    procedure effacerRecettes;


    procedure premierePageRecettes;

    procedure pageSuivanteRecettes;

    procedure pagePrecedenteRecettes;

    function pageCourante: Integer;


    function lireRecette(n: Integer): TypeRecette;


implementation

    type
        PtrCelluleRecette = ^CelluleRecette;

        CelluleRecette = record
            valeur: TypeRecette;
            precedantOrdreAlpha: PtrCelluleRecette;
            suivantOrdreAlpha: PtrCelluleRecette;
            precedantOrdreBonus: PtrCelluleRecette;
            suivantOrdreBonus: PtrCelluleRecette;
        end;

    var
        _pointeurPage: PtrCelluleRecette;
        _pointeurRecette: PtrCelluleRecette;
        _pageCourante: Integer;

    procedure initRecettes;
    begin
        // À FAIRE
    end;


    procedure insererRecette(recette: TypeRecette);
    begin
        // À FAIRE
    end;


    procedure effacerRecettes;
    begin
        // À FAIRE
    end;


    procedure premierePageRecettes;
    begin
        // À FAIRE
    end;

    procedure pageSuivanteRecettes;
    begin
        // À FAIRE
    end;

    procedure pagePrecedenteRecettes;
    begin
        // À FAIRE
    end;

    function pageCourante: Integer;
    begin
        // À FAIRE
    end;


    function lireRecette(n: Integer): TypeRecette;
    begin
        // À FAIRE
    end;

end.

